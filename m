Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab1GQX4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:56:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56717 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab1GQX4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:56:10 -0400
From: Raja Naresh <rajanaresh89@gmail.com>
To: gregkh@suse.de
Cc: martyn.welch@ge.com, tglx@linutronix.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Raja Naresh <rajanaresh89@gmail.com>
Subject: [PATCH] staging: vme_user: fix bugs in vme_user_probe
Date: Sun, 17 Jul 2011 19:55:58 -0400
Message-Id: <1310946958-13416-1-git-send-email-rajanaresh89@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Raja Naresh <rajanaresh89@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index a571173..0929c33 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -736,7 +736,7 @@ static int __devinit vme_user_probe(struct device *dev, int cur_bus,
 			image[i].pci_buf = 0;
 			vme_slave_free(image[i].resource);
 			err = -ENOMEM;
-			goto err_slave;
+			goto err_slave_alloc;
 		}
 	}
 
@@ -803,13 +803,10 @@ static int __devinit vme_user_probe(struct device *dev, int cur_bus,
 
 	return 0;
 
-	/* Ensure counter set correcty to destroy all sysfs devices */
-	i = VME_DEVS;
 err_sysfs:
-	while (i > 0) {
-		i--;
+	while (--i >= 0)
 		device_destroy(vme_user_sysfs_class, MKDEV(VME_MAJOR, i));
-	}
+
 	class_destroy(vme_user_sysfs_class);
 
 	/* Ensure counter set correcty to unalloc all master windows */
@@ -818,18 +815,17 @@ err_master_buf:
 	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++)
 		kfree(image[i].kern_buf);
 err_master:
-	while (i > MASTER_MINOR) {
-		i--;
+	while (--i >= MASTER_MINOR)
 		vme_master_free(image[i].resource);
-	}
-
-	/*
+      	/*
 	 * Ensure counter set correcty to unalloc all slave windows and buffers
 	 */
 	i = SLAVE_MAX + 1;
+err_slave_alloc:
+	if (i != (SLAVE_MAX + 1))
+		vme_slave_free(image[i].resource);
 err_slave:
-	while (i > SLAVE_MINOR) {
-		i--;
+	while (--i >= SLAVE_MINOR) {
 		buf_unalloc(i);
 		vme_slave_free(image[i].resource);
 	}
-- 
1.6.3.3

