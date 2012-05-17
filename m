Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030396Ab2EQTKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 15:10:37 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:23330
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967643Ab2EQTKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 15:10:35 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <linuxppc-dev@linux.freescale.net>, Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Anatolij Gustschin <agust@denx.de>, <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] [for 3.4] powerpc/512x: don't compile any platform DIU code if the DIU is not enabled
Date: Thu, 17 May 2012 14:10:28 -0500
Message-ID: <1337281828-31120-2-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1337281828-31120-1-git-send-email-timur@freescale.com>
References: <1337281828-31120-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the DIU framebuffer driver is not enabled, then there's no point in
compiling any platform DIU code, because it will never be used.  Most of
the platform code was protected in the appropriate #ifdef, but not all.
This caused a break in some randconfig builds.

This is only a problem on the 512x platforms.  The P1022DS and MPC8610HPCD
platforms are already correct.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 arch/powerpc/platforms/512x/mpc5121_ads.c     |    5 +++++
 arch/powerpc/platforms/512x/mpc5121_generic.c |    2 ++
 arch/powerpc/platforms/512x/mpc512x.h         |    8 ++++++--
 arch/powerpc/platforms/512x/mpc512x_shared.c  |    7 ++++---
 arch/powerpc/platforms/512x/pdm360ng.c        |    4 +++-
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/512x/mpc5121_ads.c b/arch/powerpc/platforms/512x/mpc5121_ads.c
index dcef6ad..bd6b28a 100644
--- a/arch/powerpc/platforms/512x/mpc5121_ads.c
+++ b/arch/powerpc/platforms/512x/mpc5121_ads.c
@@ -42,7 +42,10 @@ static void __init mpc5121_ads_setup_arch(void)
 	for_each_compatible_node(np, "pci", "fsl,mpc5121-pci")
 		mpc83xx_add_bridge(np);
 #endif
+
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
 	mpc512x_setup_diu();
+#endif
 }
 
 static void __init mpc5121_ads_init_IRQ(void)
@@ -66,7 +69,9 @@ define_machine(mpc5121_ads) {
 	.probe			= mpc5121_ads_probe,
 	.setup_arch		= mpc5121_ads_setup_arch,
 	.init			= mpc512x_init,
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
 	.init_early		= mpc512x_init_diu,
+#endif
 	.init_IRQ		= mpc5121_ads_init_IRQ,
 	.get_irq		= ipic_get_irq,
 	.calibrate_decr		= generic_calibrate_decr,
diff --git a/arch/powerpc/platforms/512x/mpc5121_generic.c b/arch/powerpc/platforms/512x/mpc5121_generic.c
index 926731f..e4aa298 100644
--- a/arch/powerpc/platforms/512x/mpc5121_generic.c
+++ b/arch/powerpc/platforms/512x/mpc5121_generic.c
@@ -43,8 +43,10 @@ define_machine(mpc5121_generic) {
 	.name			= "MPC5121 generic",
 	.probe			= mpc5121_generic_probe,
 	.init			= mpc512x_init,
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
 	.init_early		= mpc512x_init_diu,
 	.setup_arch		= mpc512x_setup_diu,
+#endif
 	.init_IRQ		= mpc512x_init_IRQ,
 	.get_irq		= ipic_get_irq,
 	.calibrate_decr		= generic_calibrate_decr,
diff --git a/arch/powerpc/platforms/512x/mpc512x.h b/arch/powerpc/platforms/512x/mpc512x.h
index 1ab6d11..240061a 100644
--- a/arch/powerpc/platforms/512x/mpc512x.h
+++ b/arch/powerpc/platforms/512x/mpc512x.h
@@ -16,6 +16,10 @@ extern void __init mpc512x_init(void);
 extern int __init mpc5121_clk_init(void);
 void __init mpc512x_declare_of_platform_devices(void);
 extern void mpc512x_restart(char *cmd);
-extern void mpc512x_init_diu(void);
-extern void mpc512x_setup_diu(void);
+
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
+void mpc512x_init_diu(void);
+void mpc512x_setup_diu(void);
+#endif
+
 #endif				/* __MPC512X_H__ */
diff --git a/arch/powerpc/platforms/512x/mpc512x_shared.c b/arch/powerpc/platforms/512x/mpc512x_shared.c
index cfe958e..4c65f64 100644
--- a/arch/powerpc/platforms/512x/mpc512x_shared.c
+++ b/arch/powerpc/platforms/512x/mpc512x_shared.c
@@ -58,6 +58,8 @@ void mpc512x_restart(char *cmd)
 		;
 }
 
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
+
 struct fsl_diu_shared_fb {
 	u8		gamma[0x300];	/* 32-bit aligned! */
 	struct diu_ad	ad0;		/* 32-bit aligned! */
@@ -191,8 +193,6 @@ mpc512x_valid_monitor_port(enum fsl_diu_monitor_port port)
 
 static struct fsl_diu_shared_fb __attribute__ ((__aligned__(8))) diu_shared_fb;
 
-#if defined(CONFIG_FB_FSL_DIU) || \
-    defined(CONFIG_FB_FSL_DIU_MODULE)
 static inline void mpc512x_free_bootmem(struct page *page)
 {
 	__ClearPageReserved(page);
@@ -220,7 +220,6 @@ void mpc512x_release_bootmem(void)
 	}
 	diu_ops.release_bootmem	= NULL;
 }
-#endif
 
 /*
  * Check if DIU was pre-initialized. If so, perform steps
@@ -334,6 +333,8 @@ void __init mpc512x_setup_diu(void)
 #endif
 }
 
+#endif
+
 void __init mpc512x_init_IRQ(void)
 {
 	struct device_node *np;
diff --git a/arch/powerpc/platforms/512x/pdm360ng.c b/arch/powerpc/platforms/512x/pdm360ng.c
index 0575e85..2fd937c 100644
--- a/arch/powerpc/platforms/512x/pdm360ng.c
+++ b/arch/powerpc/platforms/512x/pdm360ng.c
@@ -119,9 +119,11 @@ static int __init pdm360ng_probe(void)
 define_machine(pdm360ng) {
 	.name			= "PDM360NG",
 	.probe			= pdm360ng_probe,
-	.setup_arch		= mpc512x_setup_diu,
 	.init			= pdm360ng_init,
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
 	.init_early		= mpc512x_init_diu,
+	.setup_arch		= mpc512x_setup_diu,
+#endif
 	.init_IRQ		= mpc512x_init_IRQ,
 	.get_irq		= ipic_get_irq,
 	.calibrate_decr		= generic_calibrate_decr,
-- 
1.7.3.4


