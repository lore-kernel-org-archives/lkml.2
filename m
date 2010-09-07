Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab0IGTkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:40:24 -0400
Received: from ns2.cypress.com ([157.95.67.5]:41039 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217Ab0IGTkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:40:22 -0400
Subject: Re: [PATCH] west bridge, device modules fixes
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Cypress
Date: Tue, 07 Sep 2010 12:40:14 -0700
Message-Id: <1283888414.7250.24.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes minor fixes to the device module for locking issues,
as well as some changes for the HAL/Kconfig changes made in a separate
patch. Please let me know if there are issues or concerns with this
patch.
Thanks,
David

Signed-off-by: David Cross <david.cross@cypress.com>

diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/device/cyasdevice.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/device/cyasdevice.c	2010-09-07 11:32:36.000000000 -0700
@@ -48,6 +48,8 @@ typedef struct cyasdevice {
 		cy_as_device_handle			dev_handle;
 		/* Handle to the HAL */
 		cy_as_hal_device_tag			hal_tag;
+		spinlock_t	  common_lock;
+		unsigned long flags;
 } cyasdevice ;
 
 /* global ptr to astoria device */
@@ -81,13 +83,19 @@ static void cyasdevice_deinit(cyasdevice
 
 	if (cy_as_dev->hal_tag) {
 
- #ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
-		if (stop_o_m_a_p_kernel(dev_handle_name,
+	#ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
+		if (cy_as_hal_omap_pnand_stop(dev_handle_name,
 			cy_as_dev->hal_tag) != 0)
 			cy_as_hal_print_message("<1>_cy_as_device: stopping "
-				"OMAP kernel HAL failed\n");
+				"OMAP PNAND HAL failed\n");
+	#endif
 
- #endif
+	#ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_CRAM_HAL
+		if (cy_as_hal_omap_cram_stop(dev_handle_name,
+			cy_as_dev->hal_tag) != 0)
+			cy_as_hal_print_message("<1>_cy_as_device: stopping "
+				"OMAP CRAM HAL failed\n");
+	#endif
 	}
 	cy_as_hal_print_message("<1>_cy_as_device:HAL layer stopped\n") ;
 
@@ -126,6 +134,28 @@ static void cy_misc_callback(cy_as_devic
 	}
 }
 
+void cy_as_acquire_common_lock()
+{
+	/*printk("%s: lock address is 0x%x, is_locked=0x%x\n", __func__,
+		&cy_as_device_controller->common_lock,
+		spin_is_locked(&cy_as_device_controller->common_lock));*/
+	spin_lock_irqsave(&cy_as_device_controller->common_lock,
+		cy_as_device_controller->flags);/*
+		printk("%s: -- is_locked=0x%x\n", __func__,
+		spin_is_locked(&cy_as_device_controller->common_lock));*/
+}
+EXPORT_SYMBOL(cy_as_acquire_common_lock);
+
+void cy_as_release_common_lock()
+{
+	/*printk("%s: lock address is 0x%x, is_locked=0x%x\n", __func__,
+		&cy_as_device_controller->common_lock,
+		spin_is_locked(&cy_as_device_controller->common_lock));*/
+	spin_unlock_irqrestore(&cy_as_device_controller->common_lock,
+	cy_as_device_controller->flags);
+}
+EXPORT_SYMBOL(cy_as_release_common_lock);
+
 /* reset astoria and reinit all regs */
  #define PNAND_REG_CFG_INIT_VAL 0x0000
 void  hal_reset(cy_as_hal_device_tag tag)
@@ -209,17 +239,29 @@ static int cyasdevice_initialize(void)
 
 	/* Init the HAL & CyAsDeviceHandle */
 
- #ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
- /* start OMAP HAL init instsnce */
+	#ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
+	/* start OMAP HAL init instsnce */
 
-	if (!start_o_m_a_p_kernel(dev_handle_name,
+	if (!cy_as_hal_omap_pnand_start(dev_handle_name,
 		&(cy_as_dev->hal_tag), cy_false)) {
 
 		cy_as_hal_print_message(
 			"<1>_cy_as_device: start OMAP34xx HAL failed\n") ;
 		goto done;
 	}
- #endif
+	#endif
+
+	#ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_CRAM_HAL
+	/* start OMAP HAL init instsnce */
+
+	if (!cy_as_hal_omap_cram_start(dev_handle_name,
+		&(cy_as_dev->hal_tag), cy_false)) {
+
+		cy_as_hal_print_message(
+			"<1>_cy_as_device: start OMAP34xx HAL failed\n") ;
+		goto done;
+	}
+	#endif
 
 	/* Now create the device */
 	if (cy_as_misc_create_device(&(cy_as_dev->dev_handle),
@@ -331,6 +373,8 @@ static int cyasdevice_initialize(void)
 		((ver_data.is_debug_mode) ? "debug" : "release"),
 		ver_data.major, ver_data.minor, ver_data.build, str) ;
 
+	spin_lock_init(&cy_as_dev->common_lock);
+
 	/* done now */
 	cy_as_device_controller = cy_as_dev ;
 


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

