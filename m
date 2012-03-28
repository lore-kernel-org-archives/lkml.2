Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab2C1VXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:23:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40797 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758800Ab2C1VXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:23:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] firmware_class: Move request_firmware_nowait() to workqueues
Date: Wed, 28 Mar 2012 23:26:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203260000.34377.rjw@sisk.pl> <201203282319.54708.rjw@sisk.pl>
In-Reply-To: <201203282319.54708.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203282326.00996.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Oddly enough a work_struct was already part of the firmware_work
structure but nobody was using it. Instead of creating a new
kthread for each request_firmware_nowait() call just schedule the
work on the system workqueue. This should avoid some overhead
in forking new threads when they're not strictly necessary.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/firmware_class.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

Index: linux/drivers/base/firmware_class.c
===================================================================
--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
@@ -16,10 +16,11 @@
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
-#include <linux/kthread.h>
+#include <linux/workqueue.h>
 #include <linux/highmem.h>
 #include <linux/firmware.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
 
@@ -630,19 +631,15 @@ struct firmware_work {
 	bool uevent;
 };
 
-static int request_firmware_work_func(void *arg)
+static void request_firmware_work_func(struct work_struct *work)
 {
-	struct firmware_work *fw_work = arg;
+	struct firmware_work *fw_work;
 	const struct firmware *fw;
 	struct firmware_priv *fw_priv;
 	long timeout;
 	int ret;
 
-	if (!arg) {
-		WARN_ON(1);
-		return 0;
-	}
-
+	fw_work = container_of(work, struct firmware_work, work);
 	fw_priv = _request_firmware_prepare(&fw, fw_work->name, fw_work->device,
 			fw_work->uevent, true);
 	if (IS_ERR_OR_NULL(fw_priv)) {
@@ -667,8 +664,6 @@ static int request_firmware_work_func(vo
 
 	module_put(fw_work->module);
 	kfree(fw_work);
-
-	return ret;
 }
 
 /**
@@ -694,7 +689,6 @@ request_firmware_nowait(
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
-	struct task_struct *task;
 	struct firmware_work *fw_work;
 
 	fw_work = kzalloc(sizeof (struct firmware_work), gfp);
@@ -713,15 +707,8 @@ request_firmware_nowait(
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
 

