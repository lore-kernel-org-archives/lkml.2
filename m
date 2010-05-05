Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100Ab0EENt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:49:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43866 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076Ab0EENtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:49:25 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] Add notifiers for swapon and swapoff events
Date: Wed,  5 May 2010 19:15:54 +0530
Message-Id: <1273067156-2574-2-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1273067156-2574-1-git-send-email-ngupta@vflare.org>
References: <1273067156-2574-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for ramzswap module which implements RAM based block
devices to be used as swap disks. These devices require a notification
on these events to function properly.

Currently, I'm not sure if any of these event notifiers have any other
users. However, adding ramzswap specific hooks instead of this generic
approach resulted in a bad/hacky code.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 include/linux/swap.h |    9 ++++++++
 mm/swapfile.c        |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1f59d93..f3c7378 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -150,6 +150,11 @@ enum {
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };
 
+enum swap_event {
+	SWAP_EVENT_SWAPON,
+	SWAP_EVENT_SWAPOFF,
+};
+
 #define SWAP_CLUSTER_MAX 32
 
 #define SWAP_MAP_MAX	0x3e	/* Max duplication count, in first swap_map */
@@ -329,6 +334,10 @@ extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
+extern int register_swap_event_notifier(struct notifier_block *nb,
+				enum swap_event event);
+extern int unregister_swap_event_notifier(struct notifier_block *nb,
+				enum swap_event event);
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6cd0a8f..aa474f3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -57,6 +57,9 @@ static struct swap_list_t swap_list = {-1, -1};
 static struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
 static DEFINE_MUTEX(swapon_mutex);
+static BLOCKING_NOTIFIER_HEAD(swapon_notify_list);
+static BLOCKING_NOTIFIER_HEAD(swapoff_notify_list);
+
 
 static inline unsigned char swap_count(unsigned char ent)
 {
@@ -1641,6 +1644,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_map = NULL;
 	p->flags = 0;
 	spin_unlock(&swap_lock);
+	blocking_notifier_call_chain(&swapon_notify_list, type, swap_file);
 	mutex_unlock(&swapon_mutex);
 	vfree(swap_map);
 	/* Destroy swap account informatin */
@@ -2060,6 +2064,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	else
 		swap_info[prev]->next = type;
 	spin_unlock(&swap_lock);
+	blocking_notifier_call_chain(&swapon_notify_list, type, swap_file);
 	mutex_unlock(&swapon_mutex);
 	error = 0;
 	goto out;
@@ -2487,3 +2492,49 @@ static void free_swap_count_continuations(struct swap_info_struct *si)
 		}
 	}
 }
+
+static struct blocking_notifier_head *get_swap_notifier(enum swap_event event)
+{
+	struct blocking_notifier_head *nh;
+
+	switch (event) {
+	case SWAP_EVENT_SWAPON:
+		nh = &swapon_notify_list;
+		break;
+	case SWAP_EVENT_SWAPOFF:
+		nh = &swapoff_notify_list;
+		break;
+	default:
+		nh = NULL;
+		pr_err("Invalid swap event: %d\n", event);
+	}
+	return nh;
+}
+
+int register_swap_event_notifier(struct notifier_block *nb,
+				enum swap_event event)
+{
+	int ret = -EINVAL;
+	struct blocking_notifier_head *nh;
+
+	nh = get_swap_notifier(event);
+	if (nh)
+		ret = blocking_notifier_chain_register(nh, nb);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_swap_event_notifier);
+
+int unregister_swap_event_notifier(struct notifier_block *nb,
+				enum swap_event event)
+{
+	int ret = -EINVAL;
+	struct blocking_notifier_head *nh;
+
+	nh = get_swap_notifier(event);
+	if (nh)
+		ret = blocking_notifier_chain_unregister(nh, nb);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(unregister_swap_event_notifier);
-- 
1.6.6.1

