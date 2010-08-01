Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab0HAKHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 06:07:54 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41785 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753963Ab0HAKHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 06:07:52 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: [PATCH 3/3 v3] cyber2000fb: add I2C support
Date: Sun, 1 Aug 2010 12:07:42 +0200
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201007312255.51139.linux@rainbow-software.org> <201008010013.39287.linux@rainbow-software.org> <20100801084415.GA10608@n2100.arm.linux.org.uk>
In-Reply-To: <20100801084415.GA10608@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008011207.44069.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C support for the DDC bus to cyber2000fb driver. This is only bus
support, driver does not use EDID.
Tested on two different CyberPro 2000 cards with i2cdetect and decode-edid.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
This is v3 with spinlock instead of mutex (I don't know what's better here -
but both mode switch and DDC are not performance critical so it probably does
not matter) and all new things properly named ddc.

diff -urp linux-2.6.35-rc3-/drivers/video/cyber2000fb.c linux-2.6.35-rc3/drivers/video/cyber2000fb.c
--- linux-2.6.35-rc3-/drivers/video/cyber2000fb.c	2010-07-31 21:58:35.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-08-01 11:53:32.000000000 +0200
@@ -48,6 +48,10 @@
 #include <linux/init.h>
 #include <linux/io.h>
 
+#include <linux/i2c.h>
+#include <linux/i2c-id.h>
+#include <linux/i2c-algo-bit.h>
+
 #include <asm/pgtable.h>
 #include <asm/system.h>
 
@@ -88,6 +92,12 @@ struct cfb_info {
 	u_char			ramdac_powerdown;
 
 	u32			pseudo_palette[16];
+#ifdef CONFIG_FB_CYBER2000_DDC
+	bool			ddc_registered;
+	struct i2c_adapter	ddc_adapter;
+	struct i2c_algo_bit_data	ddc_algo;
+	spinlock_t		reg_b0_lock;
+#endif
 };
 
 static char *default_font = "Acorn8x8";
@@ -498,6 +508,9 @@ static void cyber2000fb_set_timing(struc
 	cyber2000_attrw(0x14, 0x00, cfb);
 
 	/* PLL registers */
+#ifdef CONFIG_FB_CYBER2000_DDC
+	spin_lock(&cfb->reg_b0_lock);
+#endif
 	cyber2000_grphw(EXT_DCLK_MULT, hw->clock_mult, cfb);
 	cyber2000_grphw(EXT_DCLK_DIV, hw->clock_div, cfb);
 	cyber2000_grphw(EXT_MCLK_MULT, cfb->mclk_mult, cfb);
@@ -505,6 +518,9 @@ static void cyber2000fb_set_timing(struc
 	cyber2000_grphw(0x90, 0x01, cfb);
 	cyber2000_grphw(0xb9, 0x80, cfb);
 	cyber2000_grphw(0xb9, 0x00, cfb);
+#ifdef CONFIG_FB_CYBER2000_DDC
+	spin_unlock(&cfb->reg_b0_lock);
+#endif
 
 	cfb->ramdac_ctrl = hw->ramdac;
 	cyber2000fb_write_ramdac_ctrl(cfb);
@@ -1145,6 +1161,105 @@ void cyber2000fb_detach(int idx)
 }
 EXPORT_SYMBOL(cyber2000fb_detach);
 
+#ifdef CONFIG_FB_CYBER2000_DDC
+
+#define DDC_REG		0xb0
+#define DDC_SCL_OUT	(1 << 0)
+#define DDC_SDA_OUT	(1 << 4)
+#define DDC_SCL_IN	(1 << 2)
+#define DDC_SDA_IN	(1 << 6)
+
+static void cyber2000fb_enable_ddc(struct cfb_info *cfb)
+{
+	spin_lock(&cfb->reg_b0_lock);
+	cyber2000fb_writew(0x1bf, 0x3ce, cfb);
+}
+
+static void cyber2000fb_disable_ddc(struct cfb_info *cfb)
+{
+	cyber2000fb_writew(0x0bf, 0x3ce, cfb);
+	spin_unlock(&cfb->reg_b0_lock);
+}
+
+
+static void cyber2000fb_ddc_setscl(void *data, int val)
+{
+	struct cfb_info *cfb = data;
+	unsigned char reg;
+
+	cyber2000fb_enable_ddc(cfb);
+	reg = cyber2000_grphr(DDC_REG, cfb);
+	if (!val)	/* bit is inverted */
+		reg |= DDC_SCL_OUT;
+	else
+		reg &= ~DDC_SCL_OUT;
+	cyber2000_grphw(DDC_REG, reg, cfb);
+	cyber2000fb_disable_ddc(cfb);
+}
+
+static void cyber2000fb_ddc_setsda(void *data, int val)
+{
+	struct cfb_info *cfb = data;
+	unsigned char reg;
+
+	cyber2000fb_enable_ddc(cfb);
+	reg = cyber2000_grphr(DDC_REG, cfb);
+	if (!val)	/* bit is inverted */
+		reg |= DDC_SDA_OUT;
+	else
+		reg &= ~DDC_SDA_OUT;
+	cyber2000_grphw(DDC_REG, reg, cfb);
+	cyber2000fb_disable_ddc(cfb);
+}
+
+static int cyber2000fb_ddc_getscl(void *data)
+{
+	struct cfb_info *cfb = data;
+	int retval;
+
+	cyber2000fb_enable_ddc(cfb);
+	retval = !!(cyber2000_grphr(DDC_REG, cfb) & DDC_SCL_IN);
+	cyber2000fb_disable_ddc(cfb);
+
+	return retval;
+}
+
+static int cyber2000fb_ddc_getsda(void *data)
+{
+	struct cfb_info *cfb = data;
+	int retval;
+
+	cyber2000fb_enable_ddc(cfb);
+	retval = !!(cyber2000_grphr(DDC_REG, cfb) & DDC_SDA_IN);
+	cyber2000fb_disable_ddc(cfb);
+
+	return retval;
+}
+
+static int __devinit cyber2000fb_setup_ddc_bus(struct cfb_info *cfb)
+{
+	spin_lock_init(&cfb->reg_b0_lock);
+
+	strlcpy(cfb->ddc_adapter.name, cfb->fb.fix.id,
+		sizeof(cfb->ddc_adapter.name));
+	cfb->ddc_adapter.owner		= THIS_MODULE;
+	cfb->ddc_adapter.class		= I2C_CLASS_DDC;
+	cfb->ddc_adapter.algo_data	= &cfb->ddc_algo;
+	cfb->ddc_adapter.dev.parent	= &cfb->dev->dev;
+	cfb->ddc_algo.setsda		= cyber2000fb_ddc_setsda;
+	cfb->ddc_algo.setscl		= cyber2000fb_ddc_setscl;
+	cfb->ddc_algo.getsda		= cyber2000fb_ddc_getsda;
+	cfb->ddc_algo.getscl		= cyber2000fb_ddc_getscl;
+	cfb->ddc_algo.udelay		= 10;
+	cfb->ddc_algo.timeout		= 20;
+	cfb->ddc_algo.data		= cfb;
+
+	i2c_set_adapdata(&cfb->ddc_adapter, cfb);
+
+	return i2c_bit_add_bus(&cfb->ddc_adapter);
+}
+#endif /* CONFIG_FB_CYBER2000_DDC */
+
 /*
  * These parameters give
  * 640x480, hsync 31.5kHz, vsync 60Hz
@@ -1373,6 +1488,11 @@ static int __devinit cyberpro_common_pro
 	cfb->fb.fix.mmio_len   = MMIO_SIZE;
 	cfb->fb.screen_base    = cfb->region;
 
+#ifdef CONFIG_FB_CYBER2000_DDC
+	if (cyber2000fb_setup_ddc_bus(cfb) == 0)
+		cfb->ddc_registered = true;
+#endif
+
 	err = -EINVAL;
 	if (!fb_find_mode(&cfb->fb.var, &cfb->fb, mode_option, NULL, 0,
 			  &cyber2000fb_default_mode, 8)) {
@@ -1410,6 +1530,10 @@ static int __devinit cyberpro_common_pro
 	err = register_framebuffer(&cfb->fb);
 
 failed:
+#ifdef CONFIG_FB_CYBER2000_DDC
+	if (err && cfb->ddc_registered)
+		i2c_del_adapter(&cfb->ddc_adapter);
+#endif
 	return err;
 }
 
@@ -1661,6 +1785,10 @@ static void __devexit cyberpro_pci_remov
 			printk(KERN_WARNING "%s: danger Will Robinson, "
 				"danger danger!  Oopsen imminent!\n",
 				cfb->fb.fix.id);
+#ifdef CONFIG_FB_CYBER2000_DDC
+		if (cfb->ddc_registered)
+			i2c_del_adapter(&cfb->ddc_adapter);
+#endif
 		iounmap(cfb->region);
 		cyberpro_free_fb_info(cfb);
 
diff -urp linux-2.6.35-rc3-/drivers/video/Kconfig linux-2.6.35-rc3/drivers/video/Kconfig
--- linux-2.6.35-rc3-/drivers/video/Kconfig	2010-07-31 22:00:23.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/Kconfig	2010-08-01 11:48:32.000000000 +0200
@@ -422,6 +422,15 @@ config FB_CYBER2000
 	  Say Y if you have a NetWinder or a graphics card containing this
 	  device, otherwise say N.
 
+config FB_CYBER2000_DDC
+	bool "DDC for CyberPro support"
+	depends on FB_CYBER2000
+	select FB_DDC
+	default y
+	help
+	  Say Y here if you want DDC support for your CyberPro graphics
+	  card. This is only I2C bus support, driver does not use EDID.
+
 config FB_APOLLO
 	bool
 	depends on (FB = y) && APOLLO


-- 
Ondrej Zary
