Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0D1WSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:18:51 -0400
Received: from tex.lwn.net ([70.33.254.29]:48897 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287Ab0D1WSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:18:30 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 30/30] viafb: make procfs entries optional
Date: Wed, 28 Apr 2010 16:17:31 -0600
Message-Id: <1272493051-25380-31-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

viafb: make procfs entries optional

This patch adds a config option to enable procfs entries for direct
hardware access. This was the old behaviour but the option defaults
to no as this is really ugly and should not be needed if the driver
works correct (and if it doesn't, it needs to be fixed).
That stuff is really something that should
- not be needed at all (the driver should be capable of doing it)
- not be there (debugfs would be better for such things)
So add this option just for backwards compatiblity.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/Kconfig        |   14 ++++++++++++++
 drivers/video/via/viafbdev.c |    8 ++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index a969f76..f263564 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1531,6 +1531,20 @@ config FB_VIA_CAMERA
 	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
 	   with ov7670 sensors.
 
+if FB_VIA
+
+config FB_VIA_DIRECT_PROCFS
+	bool "direct hardware access via procfs (DEPRECATED)(DANGEROUS)"
+	depends on FB_VIA
+	default n
+	help
+	  Allow direct hardware access to some output registers via procfs.
+	  This is dangerous but may provide the only chance to get the
+	  correct output device configuration.
+	  Its use is strongly discouraged.
+
+endif
+
 config FB_NEOMAGIC
 	tristate "NeoMagic display support"
 	depends on FB && PCI
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 51e9106..3d03318 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1326,6 +1326,8 @@ static void parse_dvi_port(void)
 		  output_interface);
 }
 
+#ifdef CONFIG_FB_VIA_DIRECT_PROCFS
+
 /*
  * The proc filesystem read/write function, a simple proc implement to
  * get/set the value of DPA  DVP0,   DVP0DataDriving,  DVP0ClockDriving, DVP1,
@@ -1715,6 +1717,8 @@ static void viafb_remove_proc(struct proc_dir_entry *viafb_entry)
 	remove_proc_entry("viafb", NULL);
 }
 
+#endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
+
 static int parse_mode(const char *str, u32 *xres, u32 *yres)
 {
 	char *ptr;
@@ -1943,7 +1947,9 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 		  viafbinfo->node, viafbinfo->fix.id, default_var.xres,
 		  default_var.yres, default_var.bits_per_pixel);
 
+#ifdef CONFIG_FB_VIA_DIRECT_PROCFS
 	viafb_init_proc(&viaparinfo->shared->proc_entry);
+#endif
 	viafb_init_dac(IGA2);
 	return 0;
 
@@ -1970,7 +1976,9 @@ void __devexit via_fb_pci_remove(struct pci_dev *pdev)
 	unregister_framebuffer(viafbinfo);
 	if (viafb_dual_fb)
 		unregister_framebuffer(viafbinfo1);
+#ifdef CONFIG_FB_VIA_DIRECT_PROCFS
 	viafb_remove_proc(viaparinfo->shared->proc_entry);
+#endif
 	framebuffer_release(viafbinfo);
 	if (viafb_dual_fb)
 		framebuffer_release(viafbinfo1);
-- 
1.7.0.1

