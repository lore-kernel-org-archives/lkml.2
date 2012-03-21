Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab2CUJy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:54:59 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:48795 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818Ab2CUJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:52:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 03/11] m68k/amiga: Add error checks when registering platform devices
Date: Wed, 21 Mar 2012 10:51:47 +0100
Message-Id: <1332323515-7314-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c |  122 ++++++++++++++++++++++++++++++++------------
 1 files changed, 90 insertions(+), 32 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 1b8db5c..2872891 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -6,6 +6,7 @@
  * for more details.
  */
 
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/zorro.h>
@@ -46,11 +47,18 @@ static const struct resource zorro_resources[] __initconst = {
 
 static int __init amiga_init_bus(void)
 {
+	struct platform_device *pdev;
+	unsigned int n;
+
 	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(ZORRO))
 		return -ENODEV;
 
-	platform_device_register_simple("amiga-zorro", -1, zorro_resources,
-					AMIGAHW_PRESENT(ZORRO3) ? 4 : 2);
+	n = AMIGAHW_PRESENT(ZORRO3) ? 4 : 2;
+	pdev = platform_device_register_simple("amiga-zorro", -1,
+					       zorro_resources, n);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
 	return 0;
 }
 
@@ -126,70 +134,120 @@ static const struct resource amiga_rtc_resource __initconst = {
 static int __init amiga_init_devices(void)
 {
 	struct platform_device *pdev;
+	int error;
 
 	if (!MACH_IS_AMIGA)
 		return -ENODEV;
 
 	/* video hardware */
-	if (AMIGAHW_PRESENT(AMI_VIDEO))
-		platform_device_register_simple("amiga-video", -1, NULL, 0);
+	if (AMIGAHW_PRESENT(AMI_VIDEO)) {
+		pdev = platform_device_register_simple("amiga-video", -1, NULL,
+						       0);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
 
 	/* sound hardware */
-	if (AMIGAHW_PRESENT(AMI_AUDIO))
-		platform_device_register_simple("amiga-audio", -1, NULL, 0);
+	if (AMIGAHW_PRESENT(AMI_AUDIO)) {
+		pdev = platform_device_register_simple("amiga-audio", -1, NULL,
+						       0);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
 
 	/* storage interfaces */
-	if (AMIGAHW_PRESENT(AMI_FLOPPY))
-		platform_device_register_simple("amiga-floppy", -1, NULL, 0);
+	if (AMIGAHW_PRESENT(AMI_FLOPPY)) {
+		pdev = platform_device_register_simple("amiga-floppy", -1,
+						       NULL, 0);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
-	if (AMIGAHW_PRESENT(A3000_SCSI))
-		platform_device_register_simple("amiga-a3000-scsi", -1,
-						&a3000_scsi_resource, 1);
+	if (AMIGAHW_PRESENT(A3000_SCSI)) {
+		pdev = platform_device_register_simple("amiga-a3000-scsi", -1,
+						       &a3000_scsi_resource, 1);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
-	if (AMIGAHW_PRESENT(A4000_SCSI))
-		platform_device_register_simple("amiga-a4000t-scsi", -1,
-						&a4000t_scsi_resource, 1);
+	if (AMIGAHW_PRESENT(A4000_SCSI)) {
+		pdev = platform_device_register_simple("amiga-a4000t-scsi", -1,
+						       &a4000t_scsi_resource,
+						       1);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
 	if (AMIGAHW_PRESENT(A1200_IDE) ||
 	    z_dev_present(ZORRO_PROD_MTEC_VIPER_MK_V_E_MATRIX_530_SCSI_IDE)) {
 		pdev = platform_device_register_simple("amiga-gayle-ide", -1,
 						       &a1200_ide_resource, 1);
-		platform_device_add_data(pdev, &a1200_ide_pdata,
-					 sizeof(a1200_ide_pdata));
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+		error = platform_device_add_data(pdev, &a1200_ide_pdata,
+						 sizeof(a1200_ide_pdata));
+		if (error)
+			return error;
 	}
 
 	if (AMIGAHW_PRESENT(A4000_IDE)) {
 		pdev = platform_device_register_simple("amiga-gayle-ide", -1,
 						       &a4000_ide_resource, 1);
-		platform_device_add_data(pdev, &a4000_ide_pdata,
-					 sizeof(a4000_ide_pdata));
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+		error = platform_device_add_data(pdev, &a4000_ide_pdata,
+						 sizeof(a4000_ide_pdata));
+		if (error)
+			return error;
 	}
 
 
 	/* other I/O hardware */
-	if (AMIGAHW_PRESENT(AMI_KEYBOARD))
-		platform_device_register_simple("amiga-keyboard", -1, NULL, 0);
+	if (AMIGAHW_PRESENT(AMI_KEYBOARD)) {
+		pdev = platform_device_register_simple("amiga-keyboard", -1,
+						       NULL, 0);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
-	if (AMIGAHW_PRESENT(AMI_MOUSE))
-		platform_device_register_simple("amiga-mouse", -1, NULL, 0);
+	if (AMIGAHW_PRESENT(AMI_MOUSE)) {
+		pdev = platform_device_register_simple("amiga-mouse", -1, NULL,
+						       0);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
-	if (AMIGAHW_PRESENT(AMI_SERIAL))
-		platform_device_register_simple("amiga-serial", -1, NULL, 0);
+	if (AMIGAHW_PRESENT(AMI_SERIAL)) {
+		pdev = platform_device_register_simple("amiga-serial", -1,
+						       NULL, 0);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
-	if (AMIGAHW_PRESENT(AMI_PARALLEL))
-		platform_device_register_simple("amiga-parallel", -1, NULL, 0);
+	if (AMIGAHW_PRESENT(AMI_PARALLEL)) {
+		pdev = platform_device_register_simple("amiga-parallel", -1,
+						       NULL, 0);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
 
 	/* real time clocks */
-	if (AMIGAHW_PRESENT(A2000_CLK))
-		platform_device_register_simple("rtc-msm6242", -1,
-						&amiga_rtc_resource, 1);
+	if (AMIGAHW_PRESENT(A2000_CLK)) {
+		pdev = platform_device_register_simple("rtc-msm6242", -1,
+						       &amiga_rtc_resource, 1);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
-	if (AMIGAHW_PRESENT(A3000_CLK))
-		platform_device_register_simple("rtc-rp5c01", -1,
-						&amiga_rtc_resource, 1);
+	if (AMIGAHW_PRESENT(A3000_CLK)) {
+		pdev = platform_device_register_simple("rtc-rp5c01", -1,
+						       &amiga_rtc_resource, 1);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
 
 	return 0;
 }
-- 
1.7.0.4

