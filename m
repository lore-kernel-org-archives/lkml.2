Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2EHWWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:22:19 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:37377 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2EHWWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:22:18 -0400
Message-ID: <1336515735.2097.23.camel@shrek.rexursive.com>
Subject: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org
Date: Wed, 09 May 2012 08:22:15 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Here is the same thing, this time with signed off. Looks like all the
memory used for hibernation is being released before power_down(), so I
guess we should be good. The patch is against linux-next.

------------------------------
Enable suspend to both for in-kernel hibernation.

It is often useful to suspend to memory after hibernation image has been
written to disk. If the battery runs out or power is otherwise lost, the
computer will resume from the hibernated image. If not, it will resume
from memory and hibernation image will be discarded.

Signed-off-by: Bojan Smojver <bojan@rexursive.com>
---
 Documentation/power/swsusp.txt |    5 +++++
 kernel/power/hibernate.c       |   36 ++++++++++++++++++++++++++++++++++++
 kernel/power/power.h           |    3 +++
 kernel/power/swap.c            |   28 ++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.txt
index ac190cf..92341b8 100644
--- a/Documentation/power/swsusp.txt
+++ b/Documentation/power/swsusp.txt
@@ -33,6 +33,11 @@ echo shutdown > /sys/power/disk; echo disk > /sys/power/state
 
 echo platform > /sys/power/disk; echo disk > /sys/power/state
 
+. If you would like to write hibernation image to swap and then suspend
+to RAM (provided your platform supports it), you can try
+
+echo suspend > /sys/power/disk; echo disk > /sys/power/state
+
 . If you have SATA disks, you'll need recent kernels with SATA suspend
 support. For suspend and resume to work, make sure your disk drivers
 are built into kernel -- not modules. [There's way to make
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index e09dfbf..3b5726f 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2003 Open Source Development Lab
  * Copyright (c) 2004 Pavel Machek <pavel@ucw.cz>
  * Copyright (c) 2009 Rafael J. Wysocki, Novell Inc.
+ * Copyright (C) 2012 Bojan Smojver <bojan@rexursive.com>
  *
  * This file is released under the GPLv2.
  */
@@ -44,6 +45,9 @@ enum {
 	HIBERNATION_PLATFORM,
 	HIBERNATION_SHUTDOWN,
 	HIBERNATION_REBOOT,
+#ifdef CONFIG_SUSPEND
+	HIBERNATION_SUSPEND,
+#endif
 	/* keep last */
 	__HIBERNATION_AFTER_LAST
 };
@@ -572,6 +576,10 @@ int hibernation_platform_enter(void)
  */
 static void power_down(void)
 {
+#ifdef CONFIG_SUSPEND
+	int error;
+#endif
+
 	switch (hibernation_mode) {
 	case HIBERNATION_REBOOT:
 		kernel_restart(NULL);
@@ -581,6 +589,25 @@ static void power_down(void)
 	case HIBERNATION_SHUTDOWN:
 		kernel_power_off();
 		break;
+#ifdef CONFIG_SUSPEND
+	case HIBERNATION_SUSPEND:
+		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		if (error) {
+			if (hibernation_ops)
+				hibernation_mode = HIBERNATION_PLATFORM;
+			else
+				hibernation_mode = HIBERNATION_SHUTDOWN;
+			power_down();
+		}
+		/*
+		 * Restore swap signature.
+		 */
+		error = swsusp_unmark();
+		if (error)
+			printk(KERN_ERR "PM: Swap will be unusable! "
+			                "Try swapon -a.\n");
+		return;
+#endif
 	}
 	kernel_halt();
 	/*
@@ -814,6 +841,9 @@ static const char * const hibernation_modes[] = {
 	[HIBERNATION_PLATFORM]	= "platform",
 	[HIBERNATION_SHUTDOWN]	= "shutdown",
 	[HIBERNATION_REBOOT]	= "reboot",
+#ifdef CONFIG_SUSPEND
+	[HIBERNATION_SUSPEND]	= "suspend",
+#endif
 };
 
 /*
@@ -854,6 +884,9 @@ static ssize_t disk_show(struct kobject *kobj, struct kobj_attribute *attr,
 		switch (i) {
 		case HIBERNATION_SHUTDOWN:
 		case HIBERNATION_REBOOT:
+#ifdef CONFIG_SUSPEND
+		case HIBERNATION_SUSPEND:
+#endif
 			break;
 		case HIBERNATION_PLATFORM:
 			if (hibernation_ops)
@@ -894,6 +927,9 @@ static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
 		switch (mode) {
 		case HIBERNATION_SHUTDOWN:
 		case HIBERNATION_REBOOT:
+#ifdef CONFIG_SUSPEND
+		case HIBERNATION_SUSPEND:
+#endif
 			hibernation_mode = mode;
 			break;
 		case HIBERNATION_PLATFORM:
diff --git a/kernel/power/power.h b/kernel/power/power.h
index b0bd4be..7d4b7ff 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -156,6 +156,9 @@ extern void swsusp_free(void);
 extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
 extern void swsusp_close(fmode_t);
+#ifdef CONFIG_SUSPEND
+extern int swsusp_unmark(void);
+#endif
 
 /* kernel/power/block_io.c */
 extern struct block_device *hib_resume_bdev;
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 11e22c0..83d5051 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1472,6 +1472,34 @@ void swsusp_close(fmode_t mode)
 	blkdev_put(hib_resume_bdev, mode);
 }
 
+/**
+ *      swsusp_unmark - Unmark swsusp signature in the resume device
+ */
+
+#ifdef CONFIG_SUSPEND
+int swsusp_unmark(void)
+{
+	int error;
+
+	hib_bio_read_page(swsusp_resume_block, swsusp_header, NULL);
+	if (!memcmp(HIBERNATE_SIG,swsusp_header->sig, 10)) {
+		memcpy(swsusp_header->sig,swsusp_header->orig_sig, 10);
+		error = hib_bio_write_page(swsusp_resume_block,
+					swsusp_header, NULL);
+	} else {
+		printk(KERN_ERR "PM: Cannot find swsusp signature!\n");
+		error = -ENODEV;
+	}
+
+	/*
+	 * We just returned from suspend, we don't need the image any more.
+	 */
+	free_all_swap_pages(root_swap);
+
+	return error;
+}
+#endif
+
 static int swsusp_header_init(void)
 {
 	swsusp_header = (struct swsusp_header*) __get_free_page(GFP_KERNEL);
------------------------------

-- 
Bojan

