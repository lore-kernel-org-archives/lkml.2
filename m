Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0EENth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:49:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44502 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760115Ab0EENtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:49:31 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Send callback when a swap slot is freed
Date: Wed,  5 May 2010 19:15:55 +0530
Message-Id: <1273067156-2574-3-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1273067156-2574-1-git-send-email-ngupta@vflare.org>
References: <1273067156-2574-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This callback is required when RAM based devices are used as swap disks.
One such device is ramzswap[1] which is used as compressed in-memory swap
disk. For such devices, we need a callback as soon as a swap slot is no
longer used to allow freeing memory allocated for this slot. Without this
callback, stale data can quickly accumulate in memory defeating the whole
purpose of such devices.

Signed-off-by: Nitin Gupta <ngupta@vvflare.org>
---
 include/linux/swap.h |    6 ++++++
 mm/swapfile.c        |   19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index f3c7378..ffe0063 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -8,6 +8,7 @@
 #include <linux/memcontrol.h>
 #include <linux/sched.h>
 #include <linux/node.h>
+#include <linux/blkdev.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>
@@ -20,6 +21,9 @@ struct bio;
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_PRIO_SHIFT	0
 
+typedef void (ramzswap_slot_free_notify_fn)(struct block_device *,
+						unsigned long);
+
 static inline int current_is_kswapd(void)
 {
 	return current->flags & PF_KSWAPD;
@@ -185,6 +189,7 @@ struct swap_info_struct {
 	struct swap_extent *curr_swap_extent;
 	struct swap_extent first_swap_extent;
 	struct block_device *bdev;	/* swap device or bdev of swap file */
+	ramzswap_slot_free_notify_fn *ramzswap_slot_free_notify_fn;
 	struct file *swap_file;		/* seldom referenced */
 	unsigned int old_block_size;	/* seldom referenced */
 };
@@ -338,6 +343,7 @@ extern int register_swap_event_notifier(struct notifier_block *nb,
 				enum swap_event event);
 extern int unregister_swap_event_notifier(struct notifier_block *nb,
 				enum swap_event event);
+extern void set_ramzswap_slot_free_notify(int, ramzswap_slot_free_notify_fn *);
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index aa474f3..aaea63d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -586,6 +586,8 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
 			swap_list.next = p->type;
 		nr_swap_pages++;
 		p->inuse_pages--;
+		if (p->ramzswap_slot_free_notify_fn)
+			p->ramzswap_slot_free_notify_fn(p->bdev, offset);
 	}
 
 	return usage;
@@ -2538,3 +2540,20 @@ int unregister_swap_event_notifier(struct notifier_block *nb,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(unregister_swap_event_notifier);
+
+/*
+ * Called from ramzswap driver. Sets swap slot free callback for
+ * the given ramzswap device. This callback will be given a more
+ * generic name if it finds more users.
+ */
+void set_ramzswap_slot_free_notify(int type, ramzswap_slot_free_notify_fn *fn)
+{
+	struct swap_info_struct *sis;
+
+	spin_lock(&swap_lock);
+	sis = swap_info[type];
+	sis->ramzswap_slot_free_notify_fn = fn;
+	spin_unlock(&swap_lock);
+}
+EXPORT_SYMBOL_GPL(set_ramzswap_slot_free_notify);
+
-- 
1.6.6.1

