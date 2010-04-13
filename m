Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0DMUmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:42:11 -0400
Received: from [69.28.251.93] ([69.28.251.93]:56374 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab0DMUmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:42:09 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Tue, 13 Apr 2010 13:30:12 -0700
Subject: [PATCH 2/2] UBI: Remove reboot notifier
Message-Id: <e5370484641ae54d637ece47f411bb0b0061cc54@localhost.localdomain>
In-Reply-To: <4ccec90e21edfa387822b2cb71c886217c48b4e3@localhost.localdomain>
References: <4ccec90e21edfa387822b2cb71c886217c48b4e3@localhost.localdomain>
To: <dwmw2@infradead.org>, <dedekind1@gmail.com>
Cc: <saeed.bishara@gmail.com>, <linux-mtd@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UBI reboot notifier causes problems with hibernation.  Move this
functionality into the low-level MTD driver instead.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/mtd/ubi/build.c |   35 -----------------------------------
 drivers/mtd/ubi/ubi.h   |    2 --
 2 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index fad40aa..a6a5d1a 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -42,7 +42,6 @@
 #include <linux/miscdevice.h>
 #include <linux/log2.h>
 #include <linux/kthread.h>
-#include <linux/reboot.h>
 #include <linux/kernel.h>
 #include "ubi.h"
 
@@ -831,34 +830,6 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
 }
 
 /**
- * ubi_reboot_notifier - halt UBI transactions immediately prior to a reboot.
- * @n: reboot notifier object
- * @state: SYS_RESTART, SYS_HALT, or SYS_POWER_OFF
- * @cmd: pointer to command string for RESTART2
- *
- * This function stops the UBI background thread so that the flash device
- * remains quiescent when Linux restarts the system. Any queued work will be
- * discarded, but this function will block until do_work() finishes if an
- * operation is already in progress.
- *
- * This function solves a real-life problem observed on NOR flashes when an
- * PEB erase operation starts, then the system is rebooted before the erase is
- * finishes, and the boot loader gets confused and dies. So we prefer to finish
- * the ongoing operation before rebooting.
- */
-static int ubi_reboot_notifier(struct notifier_block *n, unsigned long state,
-			       void *cmd)
-{
-	struct ubi_device *ubi;
-
-	ubi = container_of(n, struct ubi_device, reboot_notifier);
-	if (ubi->bgt_thread)
-		kthread_stop(ubi->bgt_thread);
-	ubi_sync(ubi->ubi_num);
-	return NOTIFY_DONE;
-}
-
-/**
  * ubi_attach_mtd_dev - attach an MTD device.
  * @mtd: MTD device description object
  * @ubi_num: number to assign to the new UBI device
@@ -1015,11 +986,6 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	wake_up_process(ubi->bgt_thread);
 	spin_unlock(&ubi->wl_lock);
 
-	/* Flash device priority is 0 - UBI needs to shut down first */
-	ubi->reboot_notifier.priority = 1;
-	ubi->reboot_notifier.notifier_call = ubi_reboot_notifier;
-	register_reboot_notifier(&ubi->reboot_notifier);
-
 	ubi_devices[ubi_num] = ubi;
 	ubi_notify_all(ubi, UBI_VOLUME_ADDED, NULL);
 	return ubi_num;
@@ -1090,7 +1056,6 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	 * Before freeing anything, we have to stop the background thread to
 	 * prevent it from doing anything on this device while we are freeing.
 	 */
-	unregister_reboot_notifier(&ubi->reboot_notifier);
 	if (ubi->bgt_thread)
 		kthread_stop(ubi->bgt_thread);
 
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 1af0817..797c2cb 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -349,7 +349,6 @@ struct ubi_wl_entry;
  * @bgt_thread: background thread description object
  * @thread_enabled: if the background thread is enabled
  * @bgt_name: background thread name
- * @reboot_notifier: notifier to terminate background thread before rebooting
  *
  * @flash_size: underlying MTD device size (in bytes)
  * @peb_count: count of physical eraseblocks on the MTD device
@@ -435,7 +434,6 @@ struct ubi_device {
 	struct task_struct *bgt_thread;
 	int thread_enabled;
 	char bgt_name[sizeof(UBI_BGT_NAME_PATTERN)+2];
-	struct notifier_block reboot_notifier;
 
 	/* I/O sub-system's stuff */
 	long long flash_size;
-- 
1.6.3.1

