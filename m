Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0DWV3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:29:06 -0400
Received: from tex.lwn.net ([70.33.254.29]:50559 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0DWV2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:28:37 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 05/13] viafb: Convert GPIO and i2c to the new indexed port ops
Date: Fri, 23 Apr 2010 15:28:05 -0600
Message-Id: <1272058093-20914-6-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272058093-20914-1-git-send-email-corbet@lwn.net>
References: <1272058093-20914-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add low-level locking to the i2c driver.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-core.c |    2 +-
 drivers/video/via/via-gpio.c |   14 ++++++------
 drivers/video/via/via_i2c.c  |   46 ++++++++++++++++++++++++++---------------
 drivers/video/via/via_i2c.h  |    2 +-
 4 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 00b9021..68f5756 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -219,7 +219,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	 * Create the I2C busses.  Bailing out on failure seems extreme,
 	 * but that's what the code did before.
 	 */
-	ret = viafb_create_i2c_busses(adap_configs);
+	ret = viafb_create_i2c_busses(&global_dev, adap_configs);
 	if (ret) {
 		via_fb_pci_remove(pdev);
 		return ret;
diff --git a/drivers/video/via/via-gpio.c b/drivers/video/via/via-gpio.c
index e119d21..6b36117 100644
--- a/drivers/video/via/via-gpio.c
+++ b/drivers/video/via/via-gpio.c
@@ -91,13 +91,13 @@ static void via_gpio_set(struct gpio_chip *chip, unsigned int nr,
 
 	spin_lock_irqsave(&cfg->vdev->reg_lock, flags);
 	gpio = cfg->active_gpios[nr];
-	reg = viafb_read_reg(VIASR, gpio->vg_port_index);
+	reg = via_read_reg(VIASR, gpio->vg_port_index);
 	reg |= 0x40 << gpio->vg_mask_shift;  /* output enable */
 	if (value)
 		reg |= 0x10 << gpio->vg_mask_shift;
 	else
 		reg &= ~(0x10 << gpio->vg_mask_shift);
-	viafb_write_reg(gpio->vg_port_index, VIASR, reg);
+	via_write_reg(VIASR, gpio->vg_port_index, reg);
 	spin_unlock_irqrestore(&cfg->vdev->reg_lock, flags);
 }
 
@@ -122,8 +122,8 @@ static int via_gpio_dir_input(struct gpio_chip *chip, unsigned int nr)
 
 	spin_lock_irqsave(&cfg->vdev->reg_lock, flags);
 	gpio = cfg->active_gpios[nr];
-	viafb_write_reg_mask(gpio->vg_port_index, VIASR, 0,
-			     0x40 << gpio->vg_mask_shift);
+	via_write_reg_mask(VIASR, gpio->vg_port_index, 0,
+			0x40 << gpio->vg_mask_shift);
 	spin_unlock_irqrestore(&cfg->vdev->reg_lock, flags);
 	return 0;
 }
@@ -139,7 +139,7 @@ static int via_gpio_get(struct gpio_chip *chip, unsigned int nr)
 
 	spin_lock_irqsave(&cfg->vdev->reg_lock, flags);
 	gpio = cfg->active_gpios[nr];
-	reg = viafb_read_reg(VIASR, gpio->vg_port_index);
+	reg = via_read_reg(VIASR, gpio->vg_port_index);
 	spin_unlock_irqrestore(&cfg->vdev->reg_lock, flags);
 	return reg & (0x04 << gpio->vg_mask_shift);
 }
@@ -164,12 +164,12 @@ static struct viafb_gpio_cfg gpio_config = {
  */
 static void viafb_gpio_enable(struct viafb_gpio *gpio)
 {
-	viafb_write_reg_mask(gpio->vg_port_index, VIASR, 0x02, 0x02);
+	via_write_reg_mask(VIASR, gpio->vg_port_index, 0x02, 0x02);
 }
 
 static void viafb_gpio_disable(struct viafb_gpio *gpio)
 {
-	viafb_write_reg_mask(gpio->vg_port_index, VIASR, 0, 0x02);
+	via_write_reg_mask(VIASR, gpio->vg_port_index, 0, 0x02);
 }
 
 
diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 6cb94a8..195110a 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -29,16 +29,18 @@
  */
 #define VIAFB_NUM_I2C		5
 static struct via_i2c_stuff via_i2c_par[VIAFB_NUM_I2C];
+struct viafb_dev *i2c_vdev;  /* Passed in from core */
 
 static void via_i2c_setscl(void *data, int state)
 {
 	u8 val;
 	struct via_port_cfg *adap_data = data;
+	unsigned long flags;
 
 	DEBUG_MSG(KERN_DEBUG "reading index 0x%02x from IO 0x%x\n",
 		adap_data->ioport_index, adap_data->io_port);
-	val = viafb_read_reg(adap_data->io_port,
-			     adap_data->ioport_index) & 0xF0;
+	spin_lock_irqsave(&i2c_vdev->reg_lock, flags);
+	val = via_read_reg(adap_data->io_port, adap_data->ioport_index) & 0xF0;
 	if (state)
 		val |= 0x20;
 	else
@@ -53,35 +55,44 @@ static void via_i2c_setscl(void *data, int state)
 	default:
 		DEBUG_MSG("viafb_i2c: specify wrong i2c type.\n");
 	}
-	viafb_write_reg(adap_data->ioport_index,
-			adap_data->io_port, val);
+	via_write_reg(adap_data->io_port, adap_data->ioport_index, val);
+	spin_unlock_irqrestore(&i2c_vdev->reg_lock, flags);
 }
 
 static int via_i2c_getscl(void *data)
 {
 	struct via_port_cfg *adap_data = data;
-
-	if (viafb_read_reg(adap_data->io_port, adap_data->ioport_index) & 0x08)
-		return 1;
-	return 0;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&i2c_vdev->reg_lock, flags);
+	if (via_read_reg(adap_data->io_port, adap_data->ioport_index) & 0x08)
+		ret = 1;
+	spin_unlock_irqrestore(&i2c_vdev->reg_lock, flags);
+	return ret;
 }
 
 static int via_i2c_getsda(void *data)
 {
 	struct via_port_cfg *adap_data = data;
-
-	if (viafb_read_reg(adap_data->io_port, adap_data->ioport_index) & 0x04)
-		return 1;
-	return 0;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&i2c_vdev->reg_lock, flags);
+	if (via_read_reg(adap_data->io_port, adap_data->ioport_index) & 0x04)
+		ret = 1;
+	spin_unlock_irqrestore(&i2c_vdev->reg_lock, flags);
+	return ret;
 }
 
 static void via_i2c_setsda(void *data, int state)
 {
 	u8 val;
 	struct via_port_cfg *adap_data = data;
+	unsigned long flags;
 
-	val = viafb_read_reg(adap_data->io_port,
-			     adap_data->ioport_index) & 0xF0;
+	spin_lock_irqsave(&i2c_vdev->reg_lock, flags);
+	val = via_read_reg(adap_data->io_port, adap_data->ioport_index) & 0xF0;
 	if (state)
 		val |= 0x10;
 	else
@@ -96,8 +107,8 @@ static void via_i2c_setsda(void *data, int state)
 	default:
 		DEBUG_MSG("viafb_i2c: specify wrong i2c type.\n");
 	}
-	viafb_write_reg(adap_data->ioport_index,
-			adap_data->io_port, val);
+	via_write_reg(adap_data->io_port, adap_data->ioport_index, val);
+	spin_unlock_irqrestore(&i2c_vdev->reg_lock, flags);
 }
 
 int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata)
@@ -176,10 +187,11 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
 	return i2c_bit_add_bus(adapter);
 }
 
-int viafb_create_i2c_busses(struct via_port_cfg *configs)
+int viafb_create_i2c_busses(struct viafb_dev *dev, struct via_port_cfg *configs)
 {
 	int i, ret;
 
+	i2c_vdev = dev;
 	for (i = 0; i < VIAFB_NUM_PORTS; i++) {
 		struct via_port_cfg *adap_cfg = configs++;
 		struct via_i2c_stuff *i2c_stuff = &via_i2c_par[i];
diff --git a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
index 0093291..0685de9 100644
--- a/drivers/video/via/via_i2c.h
+++ b/drivers/video/via/via_i2c.h
@@ -36,7 +36,7 @@ int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data);
 int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len);
 
 struct viafb_par;
-int viafb_create_i2c_busses(struct via_port_cfg *cfg);
+int viafb_create_i2c_busses(struct viafb_dev *vdev, struct via_port_cfg *cfg);
 void viafb_delete_i2c_busses(void);
 struct i2c_adapter *viafb_find_adapter(enum viafb_i2c_adap which);
 #endif /* __VIA_I2C_H__ */
-- 
1.7.0.1

