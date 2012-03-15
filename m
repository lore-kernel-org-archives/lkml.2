Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161340Ab2COTuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:50:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16642 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161312Ab2COTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:50:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6650"; a="170561628"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Linux PM mailing list <linux-pm@vger.kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] firmware_class: Move request_firmware_nowait() to workqueues
Date: Thu, 15 Mar 2012 12:50:15 -0700
Message-Id: <1331841015-26684-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <201203150111.05724.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oddly enough a work_struct was already part of the firmware_work
structure but nobody was using it. Instead of creating a new
kthread for each request_firmware_nowait() just schedule the work
on the system workqueue. This should avoid some overhead in
forking new threads when they're not strictly necessary if
workqueues are available.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---

I saw this while looking at this problem we're having.

 drivers/base/firmware_class.c |   29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6c9387d..1010c06 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -16,7 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
-#include <linux/kthread.h>
+#include <linux/workqueue.h>
 #include <linux/highmem.h>
 #include <linux/firmware.h>
 #include <linux/slab.h>
@@ -629,25 +629,18 @@ struct firmware_work {
 	bool uevent;
 };
 
-static int request_firmware_work_func(void *arg)
+static void request_firmware_work_func(struct work_struct *work)
 {
-	struct firmware_work *fw_work = arg;
+	struct firmware_work *fw_work;
 	const struct firmware *fw;
-	int ret;
-
-	if (!arg) {
-		WARN_ON(1);
-		return 0;
-	}
+	fw_work = container_of(work, struct firmware_work, work);
 
-	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
+	_request_firmware(&fw, fw_work->name, fw_work->device,
 				fw_work->uevent, true);
 	fw_work->cont(fw, fw_work->context);
 
 	module_put(fw_work->module);
 	kfree(fw_work);
-
-	return ret;
 }
 
 /**
@@ -673,7 +666,6 @@ request_firmware_nowait(
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
-	struct task_struct *task;
 	struct firmware_work *fw_work;
 
 	fw_work = kzalloc(sizeof (struct firmware_work), gfp);
@@ -692,15 +684,8 @@ request_firmware_nowait(
 		return -EFAULT;
 	}
 
-	task = kthread_run(request_firmware_work_func, fw_work,
-			    "firmware/%s", name);
-	if (IS_ERR(task)) {
-		fw_work->cont(NULL, fw_work->context);
-		module_put(fw_work->module);
-		kfree(fw_work);
-		return PTR_ERR(task);
-	}
-
+	INIT_WORK(&fw_work->work, request_firmware_work_func);
+	schedule_work(&fw_work->work);
 	return 0;
 }
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

