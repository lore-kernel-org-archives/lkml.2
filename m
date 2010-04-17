Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab0DQThr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:37:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:47512 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754768Ab0DQThI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:37:08 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19rZuxAqfBrZs4g8mr4GGns9YwwNm+iU1HRU4GJKK
	cwSjhdPuIVlV8f
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 7/7] viafb: make procfs entries optional
Date: Sat, 17 Apr 2010 19:44:57 +0000
Message-Id: <1271533498-3376-7-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/video/Kconfig        |   15 +++++++++++++++
 drivers/video/via/viafbdev.c |    8 ++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 6e16244..de82639 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1520,6 +1520,21 @@ config FB_VIA
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called viafb.
+
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
index 457a9b2..b1323d9 100644
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
@@ -1938,7 +1942,9 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 		  viafbinfo->node, viafbinfo->fix.id, default_var.xres,
 		  default_var.yres, default_var.bits_per_pixel);
 
+#ifdef CONFIG_FB_VIA_DIRECT_PROCFS
 	viafb_init_proc(&viaparinfo->shared->proc_entry);
+#endif
 	viafb_init_dac(IGA2);
 	return 0;
 }
@@ -1954,7 +1960,9 @@ static void __devexit via_pci_remove(struct pci_dev *pdev)
 	iounmap(viaparinfo->shared->engine_mmio);
 
 	viafb_delete_i2c_buss(viaparinfo);
+#ifdef CONFIG_FB_VIA_DIRECT_PROCFS
 	viafb_remove_proc(viaparinfo->shared->proc_entry);
+#endif
 	framebuffer_release(viafbinfo);
 	if (viafb_dual_fb)
 		framebuffer_release(viafbinfo1);
-- 
1.6.3.2

