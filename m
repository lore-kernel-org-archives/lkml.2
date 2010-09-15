Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab0IOE5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 00:57:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab0IOE5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 00:57:44 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] After swapout/swapin private dirty mappings become clean
Date: Wed, 15 Sep 2010 10:30:35 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        balbir@linux.vnet.ibm.com, rguenther@novell.com, matz@novell.com
References: <20100915092239.C9D9.A69D9226@jp.fujitsu.com> <201009151007.43232.knikanth@suse.de> <20100915134347.C9EB.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100915134347.C9EB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009151030.36012.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 September 2010 10:16:36 KOSAKI Motohiro wrote:
> > On Wednesday 15 September 2010 05:54:31 KOSAKI Motohiro wrote:
> > > > /proc/$pid/smaps broken: After swapout/swapin private dirty mappings
> > > > become clean.
> > > >
> > > > When a page with private file mapping becomes dirty, the vma will be
> > > > in both i_mmap tree and anon_vma list. The /proc/$pid/smaps will
> > > > account these pages as dirty and backed by the file.
> > > >
> > > > But when those dirty pages gets swapped out, and when they are read
> > > > back from swap, they would be marked as clean, as it should be, as
> > > > they are part of swap cache now.
> > > >
> > > > But the /proc/$pid/smaps would report the vma as a mapping of a file
> > > > and it is clean. The pages are actually in same state i.e., dirty
> > > > with respect to file still, but which was once reported as dirty is
> > > > now being reported as clean to user-space.
> > > >
> > > > This confuses tools like gdb which uses this information. Those tools
> > > > think that those pages were never modified and it creates problem
> > > > when they create dumps.
> > > >
> > > > The file mapping of the vma also cannot be broken as pages never read
> > > > earlier, will still have to come from the file. Just that those dirty
> > > > pages have become clean anonymous pages.
> > > >
> > > > During swaping in, restoring the exact state as dirty file-backed
> > > > pages before swapout would be useless, as there in no real bug.
> > > > Breaking the vma with only anonymous pages as seperate vmas
> > > > unnecessary may not be a good thing as well. So let us just export
> > > > the information that a file-backed vma has anonymous dirty pages.
> > >
> > > Why can't gdb check Swap: field in smaps? I think Swap!=0 mean we need
> > > dump out.
> >
> > Yes. When the page is swapped out it is accounted in "Swap:".
> >
> > > Am I missing anything?
> >
> > But when it gets swapped in back to memory, it is removed from "Swap:"
> > and added to "Private_Clean:" instead of "Private_Dirty:".
> 
> Here is the code.
> I think the page will become dirty, again.
> 
> --------------------------------------------------------------
> int try_to_free_swap(struct page *page)
> {
>         VM_BUG_ON(!PageLocked(page));
> 
>         if (!PageSwapCache(page))
>                 return 0;
>         if (PageWriteback(page))
>                 return 0;
>         if (page_swapcount(page))
>                 return 0;
> 
>         delete_from_swap_cache(page);
>         SetPageDirty(page);
>         return 1;
> }
> 

I think this gets called only when the swap space gets freed. But when the 
page is just swapped out and swapped in, and the page is still part of 
SwapCache, it will be marked as clean, when the I/O read from swap completes.

Thanks
Nikanth
