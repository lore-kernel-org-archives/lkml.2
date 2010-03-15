Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab0COOt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:49:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965030Ab0COOtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:49:55 -0400
Date: Mon, 15 Mar 2010 10:48:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v6)
Message-ID: <20100315144803.GG21127@redhat.com>
References: <1268175636-4673-1-git-send-email-arighi@develer.com> <20100311093913.07c9ca8a.kamezawa.hiroyu@jp.fujitsu.com> <20100311101726.f58d24e9.kamezawa.hiroyu@jp.fujitsu.com> <1268298865.5279.997.camel@twins> <20100311182500.0f3ba994.kamezawa.hiroyu@jp.fujitsu.com> <20100311184244.6735076a.kamezawa.hiroyu@jp.fujitsu.com> <20100312101411.b2639128.nishimura@mxp.nes.nec.co.jp> <20100312112433.689c7294.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312112433.689c7294.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 11:24:33AM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 12 Mar 2010 10:14:11 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > On Thu, 11 Mar 2010 18:42:44 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > On Thu, 11 Mar 2010 18:25:00 +0900
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > Then, it's not problem that check pc->mem_cgroup is root cgroup or not
> > > > without spinlock.
> > > > ==
> > > > void mem_cgroup_update_stat(struct page *page, int idx, bool charge)
> > > > {
> > > > 	pc = lookup_page_cgroup(page);
> > > > 	if (unlikely(!pc) || mem_cgroup_is_root(pc->mem_cgroup))
> > > > 		return;	
> > > > 	...
> > > > }
> > > > ==
> > > > This can be handle in the same logic of "lock failure" path.
> > > > And we just do ignore accounting.
> > > > 
> > > > There are will be no spinlocks....to do more than this,
> > > > I think we have to use "struct page" rather than "struct page_cgroup".
> > > > 
> > > Hmm..like this ? The bad point of this patch is that this will corrupt FILE_MAPPED
> > > status in root cgroup. This kind of change is not very good.
> > > So, one way is to use this kind of function only for new parameters. Hmm.
> > IMHO, if we disable accounting file stats in root cgroup, it would be better
> > not to show them in memory.stat to avoid confusing users.
> agreed.
> 
> > But, hmm, I think accounting them in root cgroup isn't so meaningless.
> > Isn't making mem_cgroup_has_dirty_limit() return false in case of root cgroup enough?
> > 
> The problem is spinlock overhead.
> 
> IMHO, there are 2 excuse for "not accounting" in root cgroup
>  1. Low overhead is always appreciated.
>  2. Root's statistics can be obtained by "total - sum of children".
> 

IIUC, Total sum of children works only if user_hierarchy=1? At the same time
it does not work if there tasks in root cgroup and not in children group.

Vivek
