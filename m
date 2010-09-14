Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0INKOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 06:14:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50235 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0INKOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 06:14:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 05/10] vmscan: Synchrounous lumpy reclaim use lock_page() instead trylock_page()
Cc: kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100913091405.GB23508@csn.ul.ie>
References: <20100909182649.C94F.A69D9226@jp.fujitsu.com> <20100913091405.GB23508@csn.ul.ie>
Message-Id: <20100914191250.C9C7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 14 Sep 2010 19:14:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > example, 
> > 
> > __do_fault()
> > {
> > (snip)
> >         if (unlikely(!(ret & VM_FAULT_LOCKED)))
> >                 lock_page(vmf.page);
> >         else
> >                 VM_BUG_ON(!PageLocked(vmf.page));
> > 
> >         /*
> >          * Should we do an early C-O-W break?
> >          */
> >         page = vmf.page;
> >         if (flags & FAULT_FLAG_WRITE) {
> >                 if (!(vma->vm_flags & VM_SHARED)) {
> >                         anon = 1;
> >                         if (unlikely(anon_vma_prepare(vma))) {
> >                                 ret = VM_FAULT_OOM;
> >                                 goto out;
> >                         }
> >                         page = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
> >                                                 vma, address);
> > 
> 
> Correct, this is a problem. I already had dropped the patch but thanks for
> pointing out a deadlock because I was missing this case. Nothing stops the
> page being faulted being sent to shrink_page_list() when alloc_page_vma()
> is called. The deadlock might be hard to hit, but it's there.

Yup, unfortunatelly.



> > Afaik, detailed rule is,
> > 
> > o kswapd can call lock_page() because they never take page lock outside vmscan
> 
> lock_page_nosync as you point out in your next mail. While it can call
> it, kswapd shouldn't because normally it avoids stalls but it would not
> deadlock as a result of calling it.

Agreed.


> > o if try_lock() is successed, we can call lock_page_nosync() against its page after unlock.
> >   because the task have gurantee of no lock taken.
> > o otherwise, direct reclaimer can't call lock_page(). the task may have a lock already.
> > 
> 
> I think the safer bet is simply to say "direct reclaimers should not
> call lock_page() because the fault path could be holding a lock on that
> page already".

Yup, agreed.



