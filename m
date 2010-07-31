Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0GaRiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 13:38:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64898 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0GaRio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 13:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZHaZA8mDi4ndOoJFrqsVK3BW9k4/v32VX0AVkrz3jayHCR8TTbqauS0mxNslz6z/HV
         EjNjPqfh/TCmDyGaQUSe2VCVDt3NFVvanFun1HtWkEPm5lJnwcsyhwkrMTDfM7cRMr8V
         dyM/tXDMbOvyhd5O4TJDVfZqT9wnMP+y9HWiY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Li Yang <leoli@freescale.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>, linux-usb@vger.kernel.org,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] usb: fsl_udc_core: check return value of create_proc_read_entry()
Date: Sat, 31 Jul 2010 21:38:20 +0400
Message-Id: <1280597900-8405-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_proc_read_entry() may fail, if so return -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/usb/gadget/fsl_udc_core.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 08a9a62..c3d1545 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2128,7 +2128,7 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 
 #else				/* !CONFIG_USB_GADGET_DEBUG_FILES */
 
-#define create_proc_file()	do {} while (0)
+#define create_proc_file()	({ (void *)1; })
 #define remove_proc_file()	do {} while (0)
 
 #endif				/* CONFIG_USB_GADGET_DEBUG_FILES */
@@ -2373,9 +2373,14 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err_unregister;
 	}
-	create_proc_file();
+	if (create_proc_file() == 0) {
+		ret = -ENOMEM;
+		goto err_pool;
+	}
 	return 0;
 
+err_pool:
+	dma_pool_destroy(udc_controller->td_pool);
 err_unregister:
 	device_unregister(&udc_controller->gadget.dev);
 err_free_irq:
-- 
1.7.0.4

