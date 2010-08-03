Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab0HCB7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:59:14 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:50289 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0HCB7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:59:13 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1280713381.2673.2.camel@shrek.rexursive.com>
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
	 <20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280712068.2671.0.camel@shrek.rexursive.com>
	 <20100802102750.7d414819.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280713381.2673.2.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 11:59:10 +1000
Message-ID: <1280800750.3305.4.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 11:43 +1000, Bojan Smojver wrote:
> OK, get it. Will rework.

What I did today was:

1. Introduced a global variable in swap.c called swsusp_lzo_buffers. It
was declared in kernel/power/power.h as:
---------------------
extern void *swsusp_lzo_buffers;
---------------------

2. Allocation in save_image() then went like this:
--------------------- 
        swsusp_lzo_buffers = vmalloc(LZO_WRK_SIZE + LZO_UNC_SIZE + LZO_OVH_SIZE)
;       
        if (!swsusp_lzo_buffers) {
                printk(KERN_ERR "PM: Failed to allocate LZO buffers\n");
                free_page((unsigned long)page);
                return -ENOMEM;
        }
        
        wrk = swsusp_lzo_buffers;
        buf = swsusp_lzo_buffers + LZO_WRK_SIZE;
---------------------

3. Deallocation in save_image() had (this is after everything has been
written to disk):
---------------------
      vfree(swsusp_lzo_buffers);
      swsusp_lzo_buffers = NULL;
---------------------

4. swsusp_free() had (note memset(), which would crash the kernel if
this was already freed, but pointer not NULL):
---------------------
        printk (KERN_ERR "In swsusp_free().\n");
        if (swsusp_lzo_buffers) {
                printk (KERN_ERR "Freeing vmalloc() buffers.\n");
                memset(swsusp_lzo_buffers, 0, 80 * PAGE_SIZE);
                vfree(swsusp_lzo_buffers);
        }
---------------------

>From all this, I only got "In swsusp_free()" printed on resume. So, it
seems that save_image() does indeed free those vmalloc()-ed buffers and
they are not saved in the image.

I even put this in hibernate.c:
---------------------
        /* Restore control flow magically appears here */
        restore_processor_state();
        if (!in_suspend)
                platform_leave(platform_mode);

        printk(KERN_ERR "Resumed, checking swsusp_lzo_buffers.\n");
        if (swsusp_lzo_buffers) {
                printk (KERN_ERR "Setting vmalloc() buffers.\n");
                memset(swsusp_lzo_buffers, 0, 80 * PAGE_SIZE);
        }
---------------------

This printed just "Resumed, checking swsusp_lzo_buffers.", meaning it
was already set to NULL.

Any further comments on this? Nigel, what do you reckon?

PS. I also enhanced the patch to use overlapping compression in order to
save memory. Looks like that's causing it to be slower on compression
(we go down from 130 - 150 MB/s to around 105 - 110 MB/s), but still
over 3 times faster than regular swsusp code. Decompression remains
roughly the same around 100+ MB/s (this is double the speed of current
swsusp code). I will post this a bit later on.

-- 
Bojan


