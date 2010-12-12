Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0LLQtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:49:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:45373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab0LLQtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:49:00 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, Brent Casavant <bcasavan@sgi.com>
Subject: [PATCH 2/6] ioc4: use static work_struct for ioc4_load_modules()
Date: Sun, 12 Dec 2010 17:48:15 +0100
Message-Id: <1292172499-21633-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292172499-21633-1-git-send-email-tj@kernel.org>
References: <1292172499-21633-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 16:48:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to dynamically allocate work_struct for
ioc4_load_modules().  It makes the code more complex and makes it
impossible to flush the work directly.  Use static work
ioc4_load_modules_work instead and flush it directly on exit.

This removes the use of flush_scheduled_work() which is being
deprecated.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Brent Casavant <bcasavan@sgi.com>
---
This is part of a series to remove flush_scheduled_work() usage to
prepare for deprecation of flush_scheduled_work().  Patches in this
series are self contained and mostly straight-forward.

Please feel free to take it into the appropriate tree, or just ack it.
In the latter case, I'll merge the patch through the workqueue tree
during the next merge window.

Thank you.

 drivers/misc/ioc4.c |   29 +++++++++--------------------
 1 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
index 1932066..668d41e 100644
--- a/drivers/misc/ioc4.c
+++ b/drivers/misc/ioc4.c
@@ -273,13 +273,11 @@ ioc4_variant(struct ioc4_driver_data *idd)
 static void __devinit
 ioc4_load_modules(struct work_struct *work)
 {
-	/* arg just has to be freed */
-
 	request_module("sgiioc4");
-
-	kfree(work);
 }
 
+static DECLARE_WORK(ioc4_load_modules_work, ioc4_load_modules);
+
 /* Adds a new instance of an IOC4 card */
 static int __devinit
 ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
@@ -396,21 +394,12 @@ ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	 * PCI device.
 	 */
 	if (idd->idd_variant != IOC4_VARIANT_PCI_RT) {
-		struct work_struct *work;
-		work = kzalloc(sizeof(struct work_struct), GFP_KERNEL);
-		if (!work) {
-			printk(KERN_WARNING
-			       "%s: IOC4 unable to allocate memory for "
-			       "load of sub-modules.\n", __func__);
-		} else {
-			/* Request the module from a work procedure as the
-			 * modprobe goes out to a userland helper and that
-			 * will hang if done directly from ioc4_probe().
-			 */
-			printk(KERN_INFO "IOC4 loading sgiioc4 submodule\n");
-			INIT_WORK(work, ioc4_load_modules);
-			schedule_work(work);
-		}
+		/* Request the module from a work procedure as the modprobe
+		 * goes out to a userland helper and that will hang if done
+		 * directly from ioc4_probe().
+		 */
+		printk(KERN_INFO "IOC4 loading sgiioc4 submodule\n");
+		schedule_work(&ioc4_load_modules_work);
 	}
 
 	return 0;
@@ -498,7 +487,7 @@ static void __exit
 ioc4_exit(void)
 {
 	/* Ensure ioc4_load_modules() has completed before exiting */
-	flush_scheduled_work();
+	flush_work_sync(&ioc4_load_modules_work);
 	pci_unregister_driver(&ioc4_driver);
 }
 
-- 
1.7.1

