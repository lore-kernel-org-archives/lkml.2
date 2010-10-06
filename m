Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab0JFBsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:48:18 -0400
Received: from ns2.cypress.com ([157.95.67.5]:52984 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab0JFBsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:48:17 -0400
Subject: [PATCH] west bridge, addition of common lock on cyasdevice
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1285287600.17888.2.camel@odc-laptop>
References: <1285287600.17888.2.camel@odc-laptop>
Content-Type: text/plain
Organization: Cypress
Date: Tue, 05 Oct 2010 18:48:08 -0700
Message-Id: <1286329688.9470.11.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds and initializes a common lock to
cyasdevice module. This is meant to be used in order
to avoid error scenarios where the device module
could be called by both the block and gadget modules
at the same time.

Signed-off-by: David Cross <david.cross@cypress.com>
---
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c linux-next-incremen/drivers/staging/westbridge/astoria/device/cyasdevice.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c	2010-10-04 21:56:31.000000000 -0700
+++ linux-next-incremen/drivers/staging/westbridge/astoria/device/cyasdevice.c	2010-10-05 16:25:18.000000000 -0700
@@ -48,6 +48,8 @@ typedef struct cyasdevice {
 		cy_as_device_handle			dev_handle;
 		/* Handle to the HAL */
 		cy_as_hal_device_tag			hal_tag;
+		spinlock_t	  common_lock;
+		unsigned long flags;
 } cyasdevice;
 
 /* global ptr to astoria device */
@@ -126,6 +128,20 @@ static void cy_misc_callback(cy_as_devic
 	}
 }
 
+void cy_as_acquire_common_lock()
+{
+	spin_lock_irqsave(&cy_as_device_controller->common_lock,
+		cy_as_device_controller->flags);
+}
+EXPORT_SYMBOL(cy_as_acquire_common_lock);
+
+void cy_as_release_common_lock()
+{
+	spin_unlock_irqrestore(&cy_as_device_controller->common_lock,
+		cy_as_device_controller->flags);
+}
+EXPORT_SYMBOL(cy_as_release_common_lock);
+
 /* reset astoria and reinit all regs */
  #define PNAND_REG_CFG_INIT_VAL 0x0000
 void  hal_reset(cy_as_hal_device_tag tag)
@@ -331,6 +347,8 @@ static int cyasdevice_initialize(void)
 		((ver_data.is_debug_mode) ? "debug" : "release"),
 		ver_data.major, ver_data.minor, ver_data.build, str);
 
+	spin_lock_init(&cy_as_dev->common_lock);
+
 	/* done now */
 	cy_as_device_controller = cy_as_dev;
 


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

