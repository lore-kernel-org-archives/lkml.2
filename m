Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab1IHJnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 05:43:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37916 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128Ab1IHJnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 05:43:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Sep 2011 18:42:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: close race between charge and putback
Message-Id: <20110908184221.feb2dab6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110908093316.GB1316@redhat.com>
References: <1315467622-9520-1-git-send-email-jweiner@redhat.com>
	<20110908173042.4a6f8ac0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110908085404.GA1316@redhat.com>
	<20110908181901.1d488d73.kamezawa.hiroyu@jp.fujitsu.com>
	<20110908093316.GB1316@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011 11:33:16 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Thu, Sep 08, 2011 at 06:19:01PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 8 Sep 2011 10:54:04 +0200
> > Johannes Weiner <jweiner@redhat.com> wrote:
> > 
> > > On Thu, Sep 08, 2011 at 05:30:42PM +0900, KAMEZAWA Hiroyuki wrote:
> > > > On Thu,  8 Sep 2011 09:40:22 +0200
> > > > Johannes Weiner <jweiner@redhat.com> wrote:
> > > > 
> > > > > There is a potential race between a thread charging a page and another
> > > > > thread putting it back to the LRU list:
> > > > > 
> > > > > charge:                         putback:
> > > > > SetPageCgroupUsed               SetPageLRU
> > > > > PageLRU && add to memcg LRU     PageCgroupUsed && add to memcg LRU
> > > > > 
> > > > 
> > > > I assumed that all pages are charged before added to LRU.
> > > > (i.e. event happens in charge->lru_lock->putback order.)
> > > > 
> > > > But hmm, this assumption may be bad for maintainance.
> > > > Do you find a code which adds pages to LRU before charge ?
> > > > 
> > > > Hmm, if there are codes which recharge the page to other memcg,
> > > > it will cause bug and my assumption may be harmful.
> > > 
> > > Swap slots are read optimistically into swapcache and put to the LRU,
> > > then charged upon fault.  
> > 
> > Yes, then swap charge removes page from LRU before charge.
> > IIUC, it needed to do so because page->mem_cgroup may be replaced.
> 
> But only from the memcg LRU.  It's still on the global per-zone LRU,
> so reclaim could isolate/putback it during the charge.  And then
> 
> > > > > charge:                         putback:
> > > > > SetPageCgroupUsed               SetPageLRU
> > > > > PageLRU && add to memcg LRU     PageCgroupUsed && add to memcg LRU
> 
> applies.
> 

Hmm, in this case, I thought memcg puts back the page to its LRU by itself
under lru_loc after charge and the race was hidden.

> And yes, it needs to fix up *pc->mem_cgroup's LRU statistics before
> the pointer get's overwritten.
> 


Thanks,
-Kame


