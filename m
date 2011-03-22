Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1CVBBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 21:01:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47396 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1CVBA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 21:00:56 -0400
Date: Tue, 22 Mar 2011 12:00:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergio Aguirre <saaguirre@ti.com>, sricharan <r.sricharan@ti.com>
Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20110322120047.109ced69.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
arch/arm/mach-omap2/devices.c between commit 0abcf6185eb8 ("OMAP3:
devices: Initialise the l3 device with the hwmod data") from Linus' tree
and commit 5e1118fa89c7 ("[media] omap3: Add function to register
omap3isp platform device structure") from the v4l-dvb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/devices.c
index d478f53,145c8f0..0000000
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@@ -35,74 -33,12 +35,75 @@@
  
  #include "mux.h"
  #include "control.h"
 -
+ #include "devices.h"
  
 +#define L3_MODULES_MAX_LEN 12
 +#define L3_MODULES 3
 +
 +static int __init omap3_l3_init(void)
 +{
 +	int l;
 +	struct omap_hwmod *oh;
 +	struct omap_device *od;
 +	char oh_name[L3_MODULES_MAX_LEN];
 +
 +	/*
 +	 * To avoid code running on other OMAPs in
 +	 * multi-omap builds
 +	 */
 +	if (!(cpu_is_omap34xx()))
 +		return -ENODEV;
 +
 +	l = snprintf(oh_name, L3_MODULES_MAX_LEN, "l3_main");
 +
 +	oh = omap_hwmod_lookup(oh_name);
 +
 +	if (!oh)
 +		pr_err("could not look up %s\n", oh_name);
 +
 +	od = omap_device_build("omap_l3_smx", 0, oh, NULL, 0,
 +							   NULL, 0, 0);
 +
 +	WARN(IS_ERR(od), "could not build omap_device for %s\n", oh_name);
 +
 +	return IS_ERR(od) ? PTR_ERR(od) : 0;
 +}
 +postcore_initcall(omap3_l3_init);
 +
 +static int __init omap4_l3_init(void)
 +{
 +	int l, i;
 +	struct omap_hwmod *oh[3];
 +	struct omap_device *od;
 +	char oh_name[L3_MODULES_MAX_LEN];
 +
 +	/*
 +	 * To avoid code running on other OMAPs in
 +	 * multi-omap builds
 +	 */
 +	if (!(cpu_is_omap44xx()))
 +		return -ENODEV;
 +
 +	for (i = 0; i < L3_MODULES; i++) {
 +		l = snprintf(oh_name, L3_MODULES_MAX_LEN, "l3_main_%d", i+1);
 +
 +		oh[i] = omap_hwmod_lookup(oh_name);
 +		if (!(oh[i]))
 +			pr_err("could not look up %s\n", oh_name);
 +	}
 +
 +	od = omap_device_build_ss("omap_l3_noc", 0, oh, 3, NULL,
 +						     0, NULL, 0, 0);
 +
 +	WARN(IS_ERR(od), "could not build omap_device for %s\n", oh_name);
 +
 +	return PTR_ERR(od);
 +}
 +postcore_initcall(omap4_l3_init);
 +
  #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
  
- static struct resource cam_resources[] = {
+ static struct resource omap2cam_resources[] = {
  	{
  		.start		= OMAP24XX_CAMERA_BASE,
  		.end		= OMAP24XX_CAMERA_BASE + 0xfff,
@@@ -197,63 -142,92 +207,67 @@@ static struct platform_device omap3isp_
  	.resource	= omap3isp_resources,
  };
  
- static inline void omap_init_camera(void)
+ int omap3_init_camera(struct isp_platform_data *pdata)
  {
- 	platform_device_register(&omap3isp_device);
+ 	omap3isp_device.dev.platform_data = pdata;
+ 	return platform_device_register(&omap3isp_device);
  }
- #else
+ 
  static inline void omap_init_camera(void)
  {
- }
+ #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
+ 	if (cpu_is_omap24xx())
+ 		platform_device_register(&omap2cam_device);
  #endif
+ }
  
 -#if defined(CONFIG_OMAP_MBOX_FWK) || defined(CONFIG_OMAP_MBOX_FWK_MODULE)
 -
 -#define MBOX_REG_SIZE   0x120
 -
 -#ifdef CONFIG_ARCH_OMAP2
 -static struct resource omap2_mbox_resources[] = {
 -	{
 -		.start		= OMAP24XX_MAILBOX_BASE,
 -		.end		= OMAP24XX_MAILBOX_BASE + MBOX_REG_SIZE - 1,
 -		.flags		= IORESOURCE_MEM,
 -	},
 +struct omap_device_pm_latency omap_keyboard_latency[] = {
  	{
 -		.start		= INT_24XX_MAIL_U0_MPU,
 -		.flags		= IORESOURCE_IRQ,
 -		.name		= "dsp",
 -	},
 -	{
 -		.start		= INT_24XX_MAIL_U3_MPU,
 -		.flags		= IORESOURCE_IRQ,
 -		.name		= "iva",
 +		.deactivate_func = omap_device_idle_hwmods,
 +		.activate_func   = omap_device_enable_hwmods,
 +		.flags = OMAP_DEVICE_LATENCY_AUTO_ADJUST,
  	},
  };
 -static int omap2_mbox_resources_sz = ARRAY_SIZE(omap2_mbox_resources);
 -#else
 -#define omap2_mbox_resources		NULL
 -#define omap2_mbox_resources_sz		0
 -#endif
  
 -#ifdef CONFIG_ARCH_OMAP3
 -static struct resource omap3_mbox_resources[] = {
 -	{
 -		.start		= OMAP34XX_MAILBOX_BASE,
 -		.end		= OMAP34XX_MAILBOX_BASE + MBOX_REG_SIZE - 1,
 -		.flags		= IORESOURCE_MEM,
 -	},
 -	{
 -		.start		= INT_24XX_MAIL_U0_MPU,
 -		.flags		= IORESOURCE_IRQ,
 -		.name		= "dsp",
 -	},
 -};
 -static int omap3_mbox_resources_sz = ARRAY_SIZE(omap3_mbox_resources);
 -#else
 -#define omap3_mbox_resources		NULL
 -#define omap3_mbox_resources_sz		0
 -#endif
 +int __init omap4_keyboard_init(struct omap4_keypad_platform_data
 +						*sdp4430_keypad_data)
 +{
 +	struct omap_device *od;
 +	struct omap_hwmod *oh;
 +	struct omap4_keypad_platform_data *keypad_data;
 +	unsigned int id = -1;
 +	char *oh_name = "kbd";
 +	char *name = "omap4-keypad";
 +
 +	oh = omap_hwmod_lookup(oh_name);
 +	if (!oh) {
 +		pr_err("Could not look up %s\n", oh_name);
 +		return -ENODEV;
 +	}
  
 -#ifdef CONFIG_ARCH_OMAP4
 +	keypad_data = sdp4430_keypad_data;
  
 -#define OMAP4_MBOX_REG_SIZE	0x130
 -static struct resource omap4_mbox_resources[] = {
 -	{
 -		.start          = OMAP44XX_MAILBOX_BASE,
 -		.end            = OMAP44XX_MAILBOX_BASE +
 -					OMAP4_MBOX_REG_SIZE - 1,
 -		.flags          = IORESOURCE_MEM,
 -	},
 -	{
 -		.start          = OMAP44XX_IRQ_MAIL_U0,
 -		.flags          = IORESOURCE_IRQ,
 -		.name		= "mbox",
 -	},
 -};
 -static int omap4_mbox_resources_sz = ARRAY_SIZE(omap4_mbox_resources);
 -#else
 -#define omap4_mbox_resources		NULL
 -#define omap4_mbox_resources_sz		0
 -#endif
 +	od = omap_device_build(name, id, oh, keypad_data,
 +			sizeof(struct omap4_keypad_platform_data),
 +			omap_keyboard_latency,
 +			ARRAY_SIZE(omap_keyboard_latency), 0);
  
 -static struct platform_device mbox_device = {
 -	.name		= "omap-mailbox",
 -	.id		= -1,
 +	if (IS_ERR(od)) {
 +		WARN(1, "Cant build omap_device for %s:%s.\n",
 +						name, oh->name);
 +		return PTR_ERR(od);
 +	}
 +
 +	return 0;
 +}
 +
 +#if defined(CONFIG_OMAP_MBOX_FWK) || defined(CONFIG_OMAP_MBOX_FWK_MODULE)
 +static struct omap_device_pm_latency mbox_latencies[] = {
 +	[0] = {
 +		.activate_func = omap_device_enable_hwmods,
 +		.deactivate_func = omap_device_idle_hwmods,
 +		.flags = OMAP_DEVICE_LATENCY_AUTO_ADJUST,
 +	},
  };
  
  static inline void omap_init_mbox(void)
