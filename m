Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1IUIop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 04:44:45 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:35657 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab1IUIoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 04:44:44 -0400
Date: Wed, 21 Sep 2011 10:44:03 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [patch 2/8] mm: memcg-aware global reclaim
Message-ID: <20110921084403.GA22516@cmpxchg.org>
References: <CALWz4iwChnacF061L9vWo7nEA7qaXNJrK=+jsEe9xBtvEBD9MA@mail.gmail.com>
 <20110811210914.GB31229@cmpxchg.org>
 <CALWz4iwJfyWRineMy+W02YBvS0Y=Pv1y8Rb=8i5R=vUCfrO+iQ@mail.gmail.com>
 <CALWz4iwRXBheXFND5zq3ze2PJDkeoxYHD1zOsTyzOe3XqY5apA@mail.gmail.com>
 <20110829190426.GC1434@cmpxchg.org>
 <CALWz4ix1X8=L0HzQpdGd=XVbjZuMCtYngzdG+hLMoeJJCUEjrg@mail.gmail.com>
 <20110829210508.GA1599@cmpxchg.org>
 <CALWz4ixH-7c-fEUAHiyf83KyO9SsRzdUm-u+wm2_Ty=xvU_NyA@mail.gmail.com>
 <20110830151449.GA28136@cmpxchg.org>
 <CALWz4iyvBd3yQK4nRybxkxe3eDrUY7ftBR+PWSNsyaUQWFjJmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALWz4iyvBd3yQK4nRybxkxe3eDrUY7ftBR+PWSNsyaUQWFjJmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ying,

On Wed, Aug 31, 2011 at 03:58:09PM -0700, Ying Han wrote:
> On Tue, Aug 30, 2011 at 8:14 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Tue, Aug 30, 2011 at 12:07:07AM -0700, Ying Han wrote:
> >> On Mon, Aug 29, 2011 at 2:05 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> >> > I have now the following comment in mem_cgroup_lru_del_list():
> >> >
> >> >        /*
> >> >         * root_mem_cgroup babysits uncharged LRU pages, but
> >> >         * PageCgroupUsed is cleared when the page is about to get
> >> >         * freed.  PageCgroupAcctLRU remembers whether the
> >> >         * LRU-accounting happened against pc->mem_cgroup or
> >> >         * root_mem_cgroup.
> >> >         */
> >> >
> >> > Does that answer your question?  If not, please tell me, so I can fix
> >> > the comment :-)
> >>
> >> Sorry, not clear to me yet :(
> >>
> >> Is this saying that we can not differentiate the page linked to root
> >> but not charged vs
> >> page linked to memcg which is about to be freed.
> >>
> >> If that is the case, isn't the page being removed from lru first
> >> before doing uncharge (ClearPageCgroupUsed) ?
> 
> Sorry for getting back to this late.
> 
> > It depends.  From the reclaim path, yes.  But it may be freed through
> > __page_cache_release() for example, which unlinks after uncharge.
> 
> That is true. And the comment start making senses to me. Thanks.
> 
> The problem here is the inconsistency of the pc->mem_cgroup and
> page->lru for uncharged pages ( !Used). And even further, that is
> caused by (only?) pages silently floating from memcg lru
> to root lru after they are uncharged (before they are freed). And I
> wonder those pages will be short lived.
> 
> Guess my question is why those pages have to travel to root and then
> freed quickly, and we just leave them in the memcg lru?

That's not what happens.  If they get reclaimed, they are first
removed from the LRU (isolated), then freed.  If they get truncated
OTOH, they get uncharged in delete_from_page_cache() and unlinked from
the LRU on the final put_page().  There is no moving around in
between.

The moving to root_mem_cgroup happens to rescue the lru-account from
pc->mem_cgroup of an LRU page before pc->mem_cgroup is overwritten, so
it is only applicable to pages that are charged while on the LRU.
PageCgroupAcctLRU indicates whether a PageLRU page is lru-accounted to
pc->mem_cgroup (set) or root_mem_cgroup (clear).
