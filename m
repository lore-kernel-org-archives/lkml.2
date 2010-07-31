Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0GaUz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 16:55:58 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:46380 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756653Ab0GaUz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 16:55:56 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: [PATCH 3/3] cyber2000fb: add I2C support
Date: Sat, 31 Jul 2010 22:55:49 +0200
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007312255.51139.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C support for the DDC bus to cyber2000fb driver. This is only bus
support, driver does not use EDID.
Tested on two different CyberPro 2000 cards with i2cdetect and decode-edid.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff -urp linux-2.6.35-rc3-/drivers/video/cyber2000fb.c linux-2.6.35-rc3/drivers/video/cyber2000fb.c
--- linux-2.6.35-rc3-/drivers/video/cyber2000fb.c	2010-07-31 21:58:35.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-07-31 22:49:55.000000000 +0200
@@ -48,6 +48,10 @@
 #include <linux/init.h>
 #include <linux/io.h>
 
+#include <linux/i2c.h>
+#include <linux/i2c-id.h>
+#include <linux/i2c-algo-bit.h>
+
 #include <asm/pgtable.h>
 #include <asm/system.h>
 
@@ -88,6 +92,11 @@ struct cfb_info {
 	u_char			ramdac_powerdown;
 
 	u32			pseudo_palette[16];
+#ifdef CONFIG_FB_CYBER2000_I2C
+	bool			i2c_registered;
+	struct i2c_adapter	i2c_adapter;
+	struct i2c_algo_bit_data	i2c_algo;
+#endif
 };
 
 static char *default_font = "Acorn8x8";
@@ -1145,6 +1154,95 @@ void cyber2000fb_detach(int idx)
 }
 EXPORT_SYMBOL(cyber2000fb_detach);
 
+#ifdef CONFIG_FB_CYBER2000_I2C
+
+#define DDC_REG		0xb0
+#define DDC_SCL_OUT	(1 << 0)
+#define DDC_SDA_OUT	(1 << 4)
+#define DDC_SCL_IN	(1 << 2)
+#define DDC_SDA_IN	(1 << 6)
+
+static void cyber2000fb_enable_ddc(char enable, struct cfb_info *cfb)
+{
+	cyber2000fb_writew(((enable & 0x01) << 8) | 0xbf, 0x3ce, cfb);
+}
+
+static void cyber2000fb_setscl(void *data, int val)
+{
+	struct cfb_info *cfb = data;
+	unsigned char reg;
+
+	cyber2000fb_enable_ddc(1, cfb);
+	reg = cyber2000_grphr(DDC_REG, cfb);
+	if (!val)	/* bit is inverted */
+		reg |= DDC_SCL_OUT;
+	else
+		reg &= ~DDC_SCL_OUT;
+	cyber2000_grphw(DDC_REG, reg, cfb);
+	cyber2000fb_enable_ddc(0, cfb);
+}
+
+static void cyber2000fb_setsda(void *data, int val)
+{
+	struct cfb_info *cfb = data;
+	unsigned char reg;
+
+	cyber2000fb_enable_ddc(1, cfb);
+	reg = cyber2000_grphr(DDC_REG, cfb);
+	if (!val)	/* bit is inverted */
+		reg |= DDC_SDA_OUT;
+	else
+		reg &= ~DDC_SDA_OUT;
+	cyber2000_grphw(DDC_REG, reg, cfb);
+	cyber2000fb_enable_ddc(0, cfb);
+}
+
+static int cyber2000fb_getscl(void *data)
+{
+	struct cfb_info *cfb = data;
+	int retval;
+
+	cyber2000fb_enable_ddc(1, cfb);
+	retval = !!(cyber2000_grphr(DDC_REG, cfb) & DDC_SCL_IN);
+	cyber2000fb_enable_ddc(0, cfb);
+
+	return retval;
+}
+
+static int cyber2000fb_getsda(void *data)
+{
+	struct cfb_info *cfb = data;
+	int retval;
+
+	cyber2000fb_enable_ddc(1, cfb);
+	retval = !!(cyber2000_grphr(DDC_REG, cfb) & DDC_SDA_IN);
+	cyber2000fb_enable_ddc(0, cfb);
+
+	return retval;
+}
+
+static int __devinit cyber2000fb_setup_ddc_bus(struct cfb_info *cfb)
+{
+	strlcpy(cfb->i2c_adapter.name, cfb->fb.fix.id,
+		sizeof(cfb->i2c_adapter.name));
+	cfb->i2c_adapter.owner		= THIS_MODULE;
+	cfb->i2c_adapter.class		= I2C_CLASS_DDC;
+	cfb->i2c_adapter.algo_data	= &cfb->i2c_algo;
+	cfb->i2c_adapter.dev.parent	= &cfb->dev->dev;
+	cfb->i2c_algo.setsda		= cyber2000fb_setsda;
+	cfb->i2c_algo.setscl		= cyber2000fb_setscl;
+	cfb->i2c_algo.getsda		= cyber2000fb_getsda;
+	cfb->i2c_algo.getscl		= cyber2000fb_getscl;
+	cfb->i2c_algo.udelay		= 10;
+	cfb->i2c_algo.timeout		= 20;
+	cfb->i2c_algo.data		= cfb;
+
+	i2c_set_adapdata(&cfb->i2c_adapter, cfb);
+
+	return i2c_bit_add_bus(&cfb->i2c_adapter);
+}
+#endif /* CONFIG_FB_CYBER2000_I2C */
+
 /*
  * These parameters give
  * 640x480, hsync 31.5kHz, vsync 60Hz
@@ -1373,6 +1471,11 @@ static int __devinit cyberpro_common_pro
 	cfb->fb.fix.mmio_len   = MMIO_SIZE;
 	cfb->fb.screen_base    = cfb->region;
 
+#ifdef CONFIG_FB_CYBER2000_I2C
+	if (cyber2000fb_setup_ddc_bus(cfb) == 0)
+		cfb->i2c_registered = true;
+#endif
+
 	err = -EINVAL;
 	if (!fb_find_mode(&cfb->fb.var, &cfb->fb, mode_option, NULL, 0,
 			  &cyber2000fb_default_mode, 8)) {
@@ -1410,6 +1513,10 @@ static int __devinit cyberpro_common_pro
 	err = register_framebuffer(&cfb->fb);
 
 failed:
+#ifdef CONFIG_FB_CYBER2000_I2C
+	if (err && cfb->i2c_registered)
+		i2c_del_adapter(&cfb->i2c_adapter);
+#endif
 	return err;
 }
 
@@ -1661,6 +1768,10 @@ static void __devexit cyberpro_pci_remov
 			printk(KERN_WARNING "%s: danger Will Robinson, "
 				"danger danger!  Oopsen imminent!\n",
 				cfb->fb.fix.id);
+#ifdef CONFIG_FB_CYBER2000_I2C
+		if (cfb->i2c_registered)
+			i2c_del_adapter(&cfb->i2c_adapter);
+#endif
 		iounmap(cfb->region);
 		cyberpro_free_fb_info(cfb);
 
diff -urp linux-2.6.35-rc3-/drivers/video/Kconfig linux-2.6.35-rc3/drivers/video/Kconfig
--- linux-2.6.35-rc3-/drivers/video/Kconfig	2010-07-31 22:00:23.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/Kconfig	2010-07-31 22:52:11.000000000 +0200
@@ -422,6 +422,15 @@ config FB_CYBER2000
 	  Say Y if you have a NetWinder or a graphics card containing this
 	  device, otherwise say N.
 
+config FB_CYBER2000_I2C
+	bool "DDC/I2C for CyberPro support"
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
