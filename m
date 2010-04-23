Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab0DWIAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:00:44 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:41833 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab0DWIAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:00:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 05/14] m68k: amiga - Sound platform device conversion
Date: Fri, 23 Apr 2010 10:00:26 +0200
Message-Id: <1272009635-6504-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-5-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-4-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-5-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c          |    5 +++
 sound/oss/dmasound/dmasound_paula.c |   51 +++++++++++++++++++++-------------
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 7fa929c..2e308e7 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -67,6 +67,11 @@ static int __init amiga_init_devices(void)
 	if (AMIGAHW_PRESENT(AMI_VIDEO))
 		platform_device_register_simple("amiga-video", -1, NULL, 0);
 
+
+	/* sound hardware */
+	if (AMIGAHW_PRESENT(AMI_AUDIO))
+		platform_device_register_simple("amiga-audio", -1, NULL, 0);
+
 	return 0;
 }
 
diff --git a/sound/oss/dmasound/dmasound_paula.c b/sound/oss/dmasound/dmasound_paula.c
index bb14e4c..87910e9 100644
--- a/sound/oss/dmasound/dmasound_paula.c
+++ b/sound/oss/dmasound/dmasound_paula.c
@@ -21,6 +21,7 @@
 #include <linux/ioport.h>
 #include <linux/soundcard.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
 
 #include <asm/uaccess.h>
 #include <asm/setup.h>
@@ -710,31 +711,41 @@ static MACHINE machAmiga = {
 /*** Config & Setup **********************************************************/
 
 
-static int __init dmasound_paula_init(void)
+static int __init amiga_audio_probe(struct platform_device *pdev)
 {
-	int err;
-
-	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(AMI_AUDIO)) {
-	    if (!request_mem_region(CUSTOM_PHYSADDR+0xa0, 0x40,
-				    "dmasound [Paula]"))
-		return -EBUSY;
-	    dmasound.mach = machAmiga;
-	    dmasound.mach.default_hard = def_hard ;
-	    dmasound.mach.default_soft = def_soft ;
-	    err = dmasound_init();
-	    if (err)
-		release_mem_region(CUSTOM_PHYSADDR+0xa0, 0x40);
-	    return err;
-	} else
-	    return -ENODEV;
+	dmasound.mach = machAmiga;
+	dmasound.mach.default_hard = def_hard ;
+	dmasound.mach.default_soft = def_soft ;
+	return dmasound_init();
 }
 
-static void __exit dmasound_paula_cleanup(void)
+static int __exit amiga_audio_remove(struct platform_device *pdev)
 {
 	dmasound_deinit();
-	release_mem_region(CUSTOM_PHYSADDR+0xa0, 0x40);
+	return 0;
+}
+
+static struct platform_driver amiga_audio_driver = {
+	.remove = __exit_p(amiga_audio_remove),
+	.driver   = {
+		.name	= "amiga-audio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init amiga_audio_init(void)
+{
+	return platform_driver_probe(&amiga_audio_driver, amiga_audio_probe);
 }
 
-module_init(dmasound_paula_init);
-module_exit(dmasound_paula_cleanup);
+module_init(amiga_audio_init);
+
+static void __exit amiga_audio_exit(void)
+{
+	platform_driver_unregister(&amiga_audio_driver);
+}
+
+module_exit(amiga_audio_exit);
+
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:amiga-audio");
-- 
1.6.0.4

