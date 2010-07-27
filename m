Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0G0Xxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:53:32 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44610 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab0G0XwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:52:01 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 12/15] Construct status message w/ kasprintf and emit it with dev_info
Date: Tue, 27 Jul 2010 17:51:00 -0600
Message-Id: <1280274663-9160-13-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constructing the string dynamically w/ kasprintf will make it easier to
ifdef-out parts of it. Also, this is for a device, so let's use dev_info.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index f46e4f2..482785e 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -658,6 +658,7 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 					const struct pci_device_id *ent)
 {
 	int retval;
+	char *buf;
 
 	/*
 	 * Check if we can do NMI sourcing or not
@@ -741,14 +742,16 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 		goto error_misc_register;
 	}
 
-	printk(KERN_INFO
-		"hp Watchdog Timer Driver: %s"
-		", timer margin: %d seconds (nowayout=%d)"
-		", allow kernel dump: %s (default = 0/OFF)"
-		", priority: %s (default = 0/LAST).\n",
-		HPWDT_VERSION, soft_margin, nowayout,
-		(allow_kdump == 0) ? "OFF" : "ON",
-		(priority == 0) ? "LAST" : "FIRST");
+	buf = kasprintf(GFP_KERNEL, "hp Watchdog Timer Driver: %s"
+			", timer margin: %d seconds (nowayout=%d)"
+			", allow kernel dump: %s (default = 0/OFF)"
+			", priority: %s (default = 0/LAST)",
+			HPWDT_VERSION, soft_margin, nowayout,
+			(allow_kdump == 0) ? "OFF" : "ON",
+			(priority == 0) ? "LAST" : "FIRST");
+	if (!buf)
+		goto error_nomem;
+	dev_info(&dev->dev, "%s.\n", buf);
 
 	return 0;
 
@@ -761,6 +764,7 @@ error_get_cru:
 	pci_iounmap(dev, pci_mem_addr);
 error_pci_iomap:
 	pci_disable_device(dev);
+error_nomem:
 	return retval;
 }
 
-- 
1.7.1

