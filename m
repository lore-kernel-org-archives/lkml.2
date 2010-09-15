Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0IOFPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 01:15:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42001 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab0IOFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 01:15:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH] After swapout/swapin private dirty mappings become clean
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        balbir@linux.vnet.ibm.com, rguenther@novell.com, matz@novell.com
In-Reply-To: <201009151030.36012.knikanth@suse.de>
References: <20100915134347.C9EB.A69D9226@jp.fujitsu.com> <201009151030.36012.knikanth@suse.de>
Message-Id: <20100915140343.C9F4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 15 Sep 2010 14:15:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 15 September 2010 10:16:36 KOSAKI Motohiro wrote:
> > > On Wednesday 15 September 2010 05:54:31 KOSAKI Motohiro wrote:
> > > > > /proc/$pid/smaps broken: After swapout/swapin private dirty mappings
> > > > > become clean.
> > > > >
> > > > > When a page with private file mapping becomes dirty, the vma will be
> > > > > in both i_mmap tree and anon_vma list. The /proc/$pid/smaps will
> > > > > account these pages as dirty and backed by the file.
> > > > >
> > > > > But when those dirty pages gets swapped out, and when they are read
> > > > > back from swap, they would be marked as clean, as it should be, as
> > > > > they are part of swap cache now.
> > > > >
> > > > > But the /proc/$pid/smaps would report the vma as a mapping of a file
> > > > > and it is clean. The pages are actually in same state i.e., dirty
> > > > > with respect to file still, but which was once reported as dirty is
> > > > > now being reported as clean to user-space.
> > > > >
> > > > > This confuses tools like gdb which uses this information. Those tools
> > > > > think that those pages were never modified and it creates problem
> > > > > when they create dumps.
> > > > >
> > > > > The file mapping of the vma also cannot be broken as pages never read
> > > > > earlier, will still have to come from the file. Just that those dirty
> > > > > pages have become clean anonymous pages.
> > > > >
> > > > > During swaping in, restoring the exact state as dirty file-backed
> > > > > pages before swapout would be useless, as there in no real bug.
> > > > > Breaking the vma with only anonymous pages as seperate vmas
> > > > > unnecessary may not be a good thing as well. So let us just export
> > > > > the information that a file-backed vma has anonymous dirty pages.
> > > >
> > > > Why can't gdb check Swap: field in smaps? I think Swap!=0 mean we need
> > > > dump out.
> > >
> > > Yes. When the page is swapped out it is accounted in "Swap:".
> > >
> > > > Am I missing anything?
> > >
> > > But when it gets swapped in back to memory, it is removed from "Swap:"
> > > and added to "Private_Clean:" instead of "Private_Dirty:".
> > 
> > Here is the code.
> > I think the page will become dirty, again.
> > 
> > --------------------------------------------------------------
> > int try_to_free_swap(struct page *page)
> > {
> >         VM_BUG_ON(!PageLocked(page));
> > 
> >         if (!PageSwapCache(page))
> >                 return 0;
> >         if (PageWriteback(page))
> >                 return 0;
> >         if (page_swapcount(page))
> >                 return 0;
> > 
> >         delete_from_swap_cache(page);
> >         SetPageDirty(page);
> >         return 1;
> > }
> > 
> 
> I think this gets called only when the swap space gets freed. 

this is try-to-free-swap-space.
delete_from_swap_cache() does actual free.


> But when the 
> page is just swapped out and swapped in, and the page is still part of 
> SwapCache, it will be marked as clean, when the I/O read from swap completes.

Because in this case, the swap entry is not freed yet. Then the page is still clean
and swap field is still !0.

PageSwapCache == the page has backend swap entry == the page may be clean.
But, When the swap entry is removed, page will become dirty again.

As I said, following is incorrect.  In almost case, swap entry is not removed at
swap-in. Please grep try_to_free_swap() callers and 

> > > But when it gets swapped in back to memory, it is removed from "Swap:"



