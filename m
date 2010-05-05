Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0EEQ6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:58:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47161 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0EEQ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:58:52 -0400
Message-ID: <4BE1A307.709@vflare.org>
Date: Wed, 05 May 2010 22:25:35 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, Minchan Kim <minchan.kim@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data in compressed memory
References: <1273067156-2574-1-git-send-email-ngupta@vflare.org> <alpine.LFD.2.00.1005050809490.5478@i5.linux-foundation.org> <4BE1973D.5040206@vflare.org> <alpine.LFD.2.00.1005050912310.5478@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005050912310.5478@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 09:52 PM, Linus Torvalds wrote:
> 
> 
> On Wed, 5 May 2010, Nitin Gupta wrote:
>>
>> I think such 'swap_operations' structure will be have to be part of
>> block_device_operations, so we may access it from swap_entry_free()
>> where a swap slot is freed. This will also get rid of all this notifier
>> stuff.
> 
> Yes, I think adding it to block_device_operations would be fine. That 
> sounds like a sane layering, and would make it easy for a block device 
> driver to say "I want to know about swap events".
> 
> In fact, for regular block devices, a swap block free might well translate 
> into a TRIM command some day (where "some day" means when the SSD's 
> actually get their stuff together and there is real upside and not just 
> "most cases will be very slow and the upside is debatable").
> 

Its great if adding such a callback to block_device_operations is okay. Hugh
suggested this approach and I'm distributing it with compcache for quite some
time now:
http://code.google.com/p/compcache/source/browse/patches/patch_swap_notify_core_support_2.6.33.diff

Can you please have a lot at patch above and see if its acceptable? Then I will
post it to lkml again.


>> The patch you nacked did something similar: it add 'swap_slot_free_callback'
>> directly to block_device_operations. Without such change, I could not think
>> of any way to do away with notifiers.
> 
> Umm. No. IIRC, the patch I NAK'ed aded it to the 'swap_info_struct', which 
> I said was the wrong level. The block device driver level would seem to be 
> the _right_ level, since that's what ramzswap is. No?
> 
> Also, the patch I NAK'ed also used those nasty notifier chains, making it 
> even uglier.

Please see the original mail below (patch you nacked). Maybe, at that time, I didn't
make it clear that ramzswap is really a *block device* :)



-------- Original Message --------
Subject: [nacked] mm-add-swap-slot-free-callback-to-block_device_operations.patch removed from -mm tree
Date: Tue, 09 Mar 2010 14:30:27 -0800
From: akpm@linux-foundation.org
To: <snip/>

The patch titled
     mm: add swap slot free callback to block_device_operations
has been removed from the -mm tree.  Its filename was
     mm-add-swap-slot-free-callback-to-block_device_operations.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add swap slot free callback to block_device_operations
From: Nitin Gupta <ngupta@vflare.org>

This callback is required when RAM based devices are used as swap disks. 
One such device is ramzswap[1] which is used as compressed in-memory swap
disk.  For such devices, we need a callback as soon as a swap slot is no
longer used to allow freeing memory allocated for this slot.  Without this
callback, stale data can quickly accumulate in memory defeating the whole
purpose of such devices.

Another user of this callback will be "preswap" as introduced by
"Transcendent Memory" patches: http://lwn.net/Articles/367286/ (I intend
to integrade preswap with ramzswap).

[1] ramzswap: http://code.google.com/p/compcache/

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    2 ++
 mm/swapfile.c          |    3 +++
 2 files changed, 5 insertions(+)

diff -puN include/linux/blkdev.h~mm-add-swap-slot-free-callback-to-block_device_operations include/linux/blkdev.h
--- a/include/linux/blkdev.h~mm-add-swap-slot-free-callback-to-block_device_operations
+++ a/include/linux/blkdev.h
@@ -1310,6 +1310,8 @@ struct block_device_operations {
 						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
+	/* this callback is with swap_lock and sometimes page table lock held */
+	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 };
 
diff -puN mm/swapfile.c~mm-add-swap-slot-free-callback-to-block_device_operations mm/swapfile.c
--- a/mm/swapfile.c~mm-add-swap-slot-free-callback-to-block_device_operations
+++ a/mm/swapfile.c
@@ -574,6 +574,7 @@ static unsigned char swap_entry_free(str
 
 	/* free if no reference */
 	if (!usage) {
+		struct gendisk *disk = p->bdev->bd_disk;
 		if (offset < p->lowest_bit)
 			p->lowest_bit = offset;
 		if (offset > p->highest_bit)
@@ -583,6 +584,8 @@ static unsigned char swap_entry_free(str
 			swap_list.next = p->type;
 		nr_swap_pages++;
 		p->inuse_pages--;
+		if (disk->fops->swap_slot_free_notify)
+			disk->fops->swap_slot_free_notify(p->bdev, offset);
 	}
 
 	return usage;
_

Patches currently in -mm which might be from ngupta@vflare.org are

linux-next.patch
mm-add-swap-slot-free-callback-to-block_device_operations.patch


