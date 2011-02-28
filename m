Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1B1Uwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:52:32 -0500
Received: from mxout1.idt.com ([157.165.5.25]:58636 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab1B1Uwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:52:30 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH 3/5] RapidIO: Modify subsystem and driver initialization sequence
Date: Mon, 28 Feb 2011 15:51:03 -0500
Message-Id: <1298926265-5381-4-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298926265-5381-1-git-send-email-alexandre.bounine@idt.com>
References: <1298926265-5381-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsystem initialization sequence modified to support presence of multiple
RapidIO controllers in the system. The new sequence is compatible with
initialization of PCI devices.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
---
 arch/powerpc/sysdev/fsl_rio.c |   10 +---------
 drivers/net/rionet.c          |    2 +-
 drivers/rapidio/rio.c         |    6 ++++--
 include/linux/rio.h           |    1 -
 4 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 4c28226..6995907 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1575,18 +1575,10 @@ err_ops:
 static int __devinit fsl_of_rio_rpn_probe(struct platform_device *dev,
 				     const struct of_device_id *match)
 {
-	int rc;
 	printk(KERN_INFO "Setting up RapidIO peer-to-peer network %s\n",
 			dev->dev.of_node->full_name);
 
-	rc = fsl_rio_setup(dev);
-	if (rc)
-		goto out;
-
-	/* Enumerate all registered ports */
-	rc = rio_init_mports();
-out:
-	return rc;
+	return fsl_rio_setup(dev);
 };
 
 static const struct of_device_id fsl_of_rio_rpn_ids[] = {
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 678e577..26afbaa 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -571,5 +571,5 @@ static void __exit rionet_exit(void)
 	rio_unregister_driver(&rionet_driver);
 }
 
-module_init(rionet_init);
+late_initcall(rionet_init);
 module_exit(rionet_exit);
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index d520dba..f861b72 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -1134,8 +1134,6 @@ static int __devinit rio_init(void)
 	return 0;
 }
 
-device_initcall(rio_init);
-
 int __devinit rio_init_mports(void)
 {
 	int rc = 0;
@@ -1158,10 +1156,14 @@ int __devinit rio_init_mports(void)
 			rio_disc_mport(port);
 	}
 
+	rio_init();
+
       out:
 	return rc;
 }
 
+device_initcall_sync(rio_init_mports);
+
 void rio_register_mport(struct rio_mport *port)
 {
 	list_add_tail(&port->node, &rio_mports);
diff --git a/include/linux/rio.h b/include/linux/rio.h
index efed116..b6bcb16 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -395,7 +395,6 @@ union rio_pw_msg {
 };
 
 /* Architecture and hardware-specific functions */
-extern int rio_init_mports(void);
 extern void rio_register_mport(struct rio_mport *);
 extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
 extern void rio_close_inb_mbox(struct rio_mport *, int);
-- 
1.7.3.1

