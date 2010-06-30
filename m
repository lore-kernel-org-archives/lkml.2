Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0F3P5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:57:32 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39716 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730Ab0F3P52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:57:28 -0400
Date: Wed, 30 Jun 2010 17:57:26 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Cory Maccarrone <darkstar6262@gmail.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       "Zebediah C. McClure" <zmc@lurian.net>,
       Alistair Buxton <a.j.buxton@gmail.com>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Jorge Eduardo Candelaria <x0107209@ti.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 11/33] Removing dead OMAP_DSP
Message-ID: <fc9feac62dc4eb90e8c3b7039729fa102ad0ac98.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP_DSP doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-omap1/board-nokia770.c         |  132 --------------------------
 arch/arm/mach-omap1/devices.c                |   37 -------
 arch/arm/mach-omap1/mcbsp.c                  |    3 -
 arch/arm/plat-omap/devices.c                 |   62 ------------
 arch/arm/plat-omap/include/plat/dsp_common.h |   40 --------
 5 files changed, 0 insertions(+), 274 deletions(-)
 delete mode 100644 arch/arm/plat-omap/include/plat/dsp_common.h

diff --git a/arch/arm/mach-omap1/board-nokia770.c b/arch/arm/mach-omap1/board-nokia770.c
index 71e1a3f..825b4c8 100644
--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@ -242,138 +242,6 @@ static inline void nokia770_mmc_init(void)
 }
 #endif
 
-#if	defined(CONFIG_OMAP_DSP)
-/*
- * audio power control
- */
-#define	HEADPHONE_GPIO		14
-#define	AMPLIFIER_CTRL_GPIO	58
-
-static struct clk *dspxor_ck;
-static DEFINE_MUTEX(audio_pwr_lock);
-/*
- * audio_pwr_state
- * +--+-------------------------+---------------------------------------+
- * |-1|down			|power-up request -> 0			|
- * +--+-------------------------+---------------------------------------+
- * | 0|up			|power-down(1) request -> 1		|
- * |  |				|power-down(2) request -> (ignore)	|
- * +--+-------------------------+---------------------------------------+
- * | 1|up,			|power-up request -> 0			|
- * |  |received down(1) request	|power-down(2) request -> -1		|
- * +--+-------------------------+---------------------------------------+
- */
-static int audio_pwr_state = -1;
-
-static inline void aic23_power_up(void)
-{
-}
-static inline void aic23_power_down(void)
-{
-}
-
-/*
- * audio_pwr_up / down should be called under audio_pwr_lock
- */
-static void nokia770_audio_pwr_up(void)
-{
-	clk_enable(dspxor_ck);
-
-	/* Turn on codec */
-	aic23_power_up();
-
-	if (gpio_get_value(HEADPHONE_GPIO))
-		/* HP not connected, turn on amplifier */
-		gpio_set_value(AMPLIFIER_CTRL_GPIO, 1);
-	else
-		/* HP connected, do not turn on amplifier */
-		printk("HP connected\n");
-}
-
-static void codec_delayed_power_down(struct work_struct *work)
-{
-	mutex_lock(&audio_pwr_lock);
-	if (audio_pwr_state == -1)
-		aic23_power_down();
-	clk_disable(dspxor_ck);
-	mutex_unlock(&audio_pwr_lock);
-}
-
-static DECLARE_DELAYED_WORK(codec_power_down_work, codec_delayed_power_down);
-
-static void nokia770_audio_pwr_down(void)
-{
-	/* Turn off amplifier */
-	gpio_set_value(AMPLIFIER_CTRL_GPIO, 0);
-
-	/* Turn off codec: schedule delayed work */
-	schedule_delayed_work(&codec_power_down_work, HZ / 20);	/* 50ms */
-}
-
-static int
-nokia770_audio_pwr_up_request(struct dsp_kfunc_device *kdev, int stage)
-{
-	mutex_lock(&audio_pwr_lock);
-	if (audio_pwr_state == -1)
-		nokia770_audio_pwr_up();
-	/* force audio_pwr_state = 0, even if it was 1. */
-	audio_pwr_state = 0;
-	mutex_unlock(&audio_pwr_lock);
-	return 0;
-}
-
-static int
-nokia770_audio_pwr_down_request(struct dsp_kfunc_device *kdev, int stage)
-{
-	mutex_lock(&audio_pwr_lock);
-	switch (stage) {
-	case 1:
-		if (audio_pwr_state == 0)
-			audio_pwr_state = 1;
-		break;
-	case 2:
-		if (audio_pwr_state == 1) {
-			nokia770_audio_pwr_down();
-			audio_pwr_state = -1;
-		}
-		break;
-	}
-	mutex_unlock(&audio_pwr_lock);
-	return 0;
-}
-
-static struct dsp_kfunc_device nokia770_audio_device = {
-	.name	 = "audio",
-	.type	 = DSP_KFUNC_DEV_TYPE_AUDIO,
-	.enable  = nokia770_audio_pwr_up_request,
-	.disable = nokia770_audio_pwr_down_request,
-};
-
-static __init int omap_dsp_init(void)
-{
-	int ret;
-
-	dspxor_ck = clk_get(0, "dspxor_ck");
-	if (IS_ERR(dspxor_ck)) {
-		printk(KERN_ERR "couldn't acquire dspxor_ck\n");
-		return PTR_ERR(dspxor_ck);
-	}
-
-	ret = dsp_kfunc_device_register(&nokia770_audio_device);
-	if (ret) {
-		printk(KERN_ERR
-		       "KFUNC device registration faild: %s\n",
-		       nokia770_audio_device.name);
-		goto out;
-	}
-	return 0;
- out:
-	return ret;
-}
-#else
-#define omap_dsp_init()		do {} while (0)
-#endif	/* CONFIG_OMAP_DSP */
-
 static void __init omap_nokia770_init(void)
 {
 	platform_add_devices(nokia770_devices, ARRAY_SIZE(nokia770_devices));
diff --git a/arch/arm/mach-omap1/devices.c b/arch/arm/mach-omap1/devices.c
index 379100c..c00d602 100644
--- a/arch/arm/mach-omap1/devices.c
+++ b/arch/arm/mach-omap1/devices.c
@@ -63,44 +63,7 @@ static void omap_init_rtc(void)
 static inline void omap_init_rtc(void) {}
 #endif
 
-#if defined(CONFIG_OMAP_DSP) || defined(CONFIG_OMAP_DSP_MODULE)
-
-#if defined(CONFIG_ARCH_OMAP15XX)
-#  define OMAP1_MBOX_SIZE	0x23
-#  define INT_DSP_MAILBOX1	INT_1510_DSP_MAILBOX1
-#elif defined(CONFIG_ARCH_OMAP16XX)
-#  define OMAP1_MBOX_SIZE	0x2f
-#  define INT_DSP_MAILBOX1	INT_1610_DSP_MAILBOX1
-#endif
-
-#define OMAP1_MBOX_BASE		OMAP16XX_MAILBOX_BASE
-
-static struct resource mbox_resources[] = {
-	{
-		.start		= OMAP1_MBOX_BASE,
-		.end		= OMAP1_MBOX_BASE + OMAP1_MBOX_SIZE,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= INT_DSP_MAILBOX1,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mbox_device = {
-	.name		= "omap1-mailbox",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(mbox_resources),
-	.resource	= mbox_resources,
-};
-
-static inline void omap_init_mbox(void)
-{
-	platform_device_register(&mbox_device);
-}
-#else
 static inline void omap_init_mbox(void) { }
-#endif
 
 /*-------------------------------------------------------------------------*/
 
diff --git a/arch/arm/mach-omap1/mcbsp.c b/arch/arm/mach-omap1/mcbsp.c
index e9bdff1..b3a796a 100644
--- a/arch/arm/mach-omap1/mcbsp.c
+++ b/arch/arm/mach-omap1/mcbsp.c
@@ -23,7 +23,6 @@
 #include <plat/mux.h>
 #include <plat/cpu.h>
 #include <plat/mcbsp.h>
-#include <plat/dsp_common.h>
 
 #define DPS_RSTCT2_PER_EN	(1 << 0)
 #define DSP_RSTCT2_WD_PER_EN	(1 << 1)
@@ -46,7 +45,6 @@ static void omap1_mcbsp_request(unsigned int id)
 				clk_enable(api_clk);
 				clk_enable(dsp_clk);
 
-				omap_dsp_request_mem();
 				/*
 				 * DSP external peripheral reset
 				 * FIXME: This should be moved to dsp code
@@ -62,7 +60,6 @@ static void omap1_mcbsp_free(unsigned int id)
 {
 	if (id == OMAP_MCBSP1 || id == OMAP_MCBSP3) {
 		if (--dsp_use == 0) {
-			omap_dsp_release_mem();
 			if (!IS_ERR(api_clk)) {
 				clk_disable(api_clk);
 				clk_put(api_clk);
diff --git a/arch/arm/plat-omap/devices.c b/arch/arm/plat-omap/devices.c
index 95677d1..a3997ec 100644
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@ -31,67 +31,6 @@
 #include <plat/dsp_common.h>
 #include <plat/omap44xx.h>
 
-#if	defined(CONFIG_OMAP_DSP) || defined(CONFIG_OMAP_DSP_MODULE)
-
-static struct dsp_platform_data dsp_pdata = {
-	.kdev_list = LIST_HEAD_INIT(dsp_pdata.kdev_list),
-};
-
-static struct resource omap_dsp_resources[] = {
-	{
-		.name	= "dsp_mmu",
-		.start	= -1,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device omap_dsp_device = {
-	.name		= "dsp",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(omap_dsp_resources),
-	.resource	= omap_dsp_resources,
-	.dev = {
-		.platform_data = &dsp_pdata,
-	},
-};
-
-static inline void omap_init_dsp(void)
-{
-	struct resource *res;
-	int irq;
-
-	if (cpu_is_omap15xx())
-		irq = INT_1510_DSP_MMU;
-	else if (cpu_is_omap16xx())
-		irq = INT_1610_DSP_MMU;
-	else if (cpu_is_omap24xx())
-		irq = INT_24XX_DSP_MMU;
-
-	res = platform_get_resource_byname(&omap_dsp_device,
-					   IORESOURCE_IRQ, "dsp_mmu");
-	res->start = irq;
-
-	platform_device_register(&omap_dsp_device);
-}
-
-int dsp_kfunc_device_register(struct dsp_kfunc_device *kdev)
-{
-	static DEFINE_MUTEX(dsp_pdata_lock);
-
-	spin_lock_init(&kdev->lock);
-
-	mutex_lock(&dsp_pdata_lock);
-	list_add_tail(&kdev->entry, &dsp_pdata.kdev_list);
-	mutex_unlock(&dsp_pdata_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(dsp_kfunc_device_register);
-
-#else
-static inline void omap_init_dsp(void) { }
-#endif	/* CONFIG_OMAP_DSP */
-
 /*-------------------------------------------------------------------------*/
 #if	defined(CONFIG_KEYBOARD_OMAP) || defined(CONFIG_KEYBOARD_OMAP_MODULE)
 
@@ -419,7 +358,6 @@ static int __init omap_init_devices(void)
 	/* please keep these calls, and their implementations above,
 	 * in alphabetical order so they're easier to sort through.
 	 */
-	omap_init_dsp();
 	omap_init_kp();
 	omap_init_rng();
 	omap_init_mcpdm();
diff --git a/arch/arm/plat-omap/include/plat/dsp_common.h b/arch/arm/plat-omap/include/plat/dsp_common.h
deleted file mode 100644
index da97736..0000000
--- a/arch/arm/plat-omap/include/plat/dsp_common.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * This file is part of OMAP DSP driver (DSP Gateway version 3.3.1)
- *
- * Copyright (C) 2004-2006 Nokia Corporation. All rights reserved.
- *
- * Contact: Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef ASM_ARCH_DSP_COMMON_H
-#define ASM_ARCH_DSP_COMMON_H
-
-#if defined(CONFIG_ARCH_OMAP1) && defined(CONFIG_OMAP_MMU_FWK)
-extern void omap_dsp_request_mpui(void);
-extern void omap_dsp_release_mpui(void);
-extern int omap_dsp_request_mem(void);
-extern int omap_dsp_release_mem(void);
-#else
-static inline int omap_dsp_request_mem(void)
-{
-	return 0;
-}
-#define omap_dsp_release_mem()	do {} while (0)
-#endif
-
-#endif /* ASM_ARCH_DSP_COMMON_H */
-- 
1.7.0.4

