Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab0HBBPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:15:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37574 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0HBBPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:15:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Aug 2010 10:10:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Bojan Smojver <bojan@rexursive.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
Message-Id: <20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1280710453.2727.8.camel@shrek.rexursive.com>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	<1280486667.2608.1.camel@shrek.rexursive.com>
	<4C534C9D.8000600@tuxonice.net>
	<1280532174.2583.1.camel@shrek.rexursive.com>
	<4C5362E7.3000706@tuxonice.net>
	<1280538184.2583.11.camel@shrek.rexursive.com>
	<4C537A01.5040808@tuxonice.net>
	<1280540035.2658.5.camel@shrek.rexursive.com>
	<1280551286.3097.6.camel@shrek.rexursive.com>
	<20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>
	<1280710453.2727.8.camel@shrek.rexursive.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010 10:54:13 +1000
Bojan Smojver <bojan@rexursive.com> wrote:

> On Mon, 2010-08-02 at 09:17 +0900, KAMEZAWA Hiroyuki wrote:
> > Now, vmallc() is used here. Then, following will happen.
> > 
> > 1. vmalloc()
> >    -> vmalloc adds vmap objects and set page table entries.
> > 
> > 2. saving image
> >    -> At taking snapshot of memory to the disk, above vmalloc() area
> > is
> >       saved to disk as it is.
> > ...
> > 3. At restore
> >    Because you dont't remember which vmalloc() area was used for
> > creating
> >    snapshot, you can't free it at swsusp_free().
> > 
> > memory leak ? 
> 
> To be honest, I'm not sure.
> 
> However, I thought that by the time save_image() is called, snapshot has
> already been taken, no?
> ------------------
>         error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
>         if (error)
>                 goto Thaw;
> 
>         if (in_suspend) {
>                 unsigned int flags = 0;
> 
>                 if (hibernation_mode == HIBERNATION_PLATFORM)
>                         flags |= SF_PLATFORM_MODE;
>                 pr_debug("PM: writing image.\n");
>                 error = swsusp_write(flags);  <--- this calls save_image()
> ------------------
> 
> So, me thinks that these allocations will not be in the snapshot image.
> 
I'm a very newbie to snapshot ...(I'm now studying it because I got a report
that my patch corrupts it.) So, don't trust my words.

Looking into swsusp_write().
==
swsusp_write()
	-> save_image()
		-> 
		while () {
			snapshot_read_next()
			swap_write_page()
		}
==
This routine writes a buffer which is gotten by snapshot_read_next() to the disk.

Then, what snapshot_read_next() pass is.
==
        } else {
                struct page *page;

                page = pfn_to_page(memory_bm_next_pfn(&copy_bm));
                if (PageHighMem(page)) {
                        /* Highmem pages are copied to the buffer,
                         * because we can't return with a kmapped
                         * highmem page (we may not be called again).
                         */
                        void *kaddr;

                        kaddr = kmap_atomic(page, KM_USER0);
                        memcpy(buffer, kaddr, PAGE_SIZE);
                        kunmap_atomic(kaddr, KM_USER0);
                        handle->buffer = buffer;
                } else {
                        handle->buffer = page_address(page);
                }
        }
==
The physical memory address of a page to be saved.

So, I thought "system memory image" itself is not a snapshot but it's changing
while it runs. Why swsusp can avoid memory leak is that it records which
pages should be freed after resume in the bitmap, which will be saved to
image header(?) And, even if this snapshot saves the image of buddy-allocator,
the save routine itself uses a fixed buffer which can be freed after restore.

Thanks,
-Kame












