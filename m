Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab1IHJTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 05:19:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46671 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab1IHJTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 05:19:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Sep 2011 18:19:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: close race between charge and putback
Message-Id: <20110908181901.1d488d73.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110908085404.GA1316@redhat.com>
References: <1315467622-9520-1-git-send-email-jweiner@redhat.com>
	<20110908173042.4a6f8ac0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110908085404.GA1316@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011 10:54:04 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Thu, Sep 08, 2011 at 05:30:42PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu,  8 Sep 2011 09:40:22 +0200
> > Johannes Weiner <jweiner@redhat.com> wrote:
> > 
> > > There is a potential race between a thread charging a page and another
> > > thread putting it back to the LRU list:
> > > 
> > > charge:                         putback:
> > > SetPageCgroupUsed               SetPageLRU
> > > PageLRU && add to memcg LRU     PageCgroupUsed && add to memcg LRU
> > > 
> > 
> > I assumed that all pages are charged before added to LRU.
> > (i.e. event happens in charge->lru_lock->putback order.)
> > 
> > But hmm, this assumption may be bad for maintainance.
> > Do you find a code which adds pages to LRU before charge ?
> > 
> > Hmm, if there are codes which recharge the page to other memcg,
> > it will cause bug and my assumption may be harmful.
> 
> Swap slots are read optimistically into swapcache and put to the LRU,
> then charged upon fault.  

Yes, then swap charge removes page from LRU before charge.
IIUC, it needed to do so because page->mem_cgroup may be replaced.

> Fuse apparently recharges uncharged LRU pages.
Yes and No. IIUC, it was like page migraion and remove old page 
and add new page to radix-tree.

> That's why we have the lrucare stuff in the first place, no?
You're right.

> Or did I misunderstand your question?
> 

I just wondered whether you find a new one or possible user.

Thanks,
-Kame


