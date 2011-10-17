Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1JQXt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:49:26 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53082 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab1JQXtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:49:24 -0400
X-Sasl-enc: A59wA5tJ9pLl61Dh+UJW2gCINBxxj0b9Nd0dEyWCd1B9 1318895362
Date: Mon, 17 Oct 2011 16:49:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.0.7
Message-ID: <20111017234915.GA4693@kroah.com>
References: <20111017165654.GA5442@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+B+y8wtTXqdUj1xM"
Content-Disposition: inline
In-Reply-To: <20111017165654.GA5442@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+B+y8wtTXqdUj1xM
Content-Type: multipart/mixed; boundary="/e2eDi0V/xtL+Mc8"
Content-Disposition: inline


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Here is the 3.0.7 incremental patch, to be applied on top of 3.0.6,
signed with my stable kernel signing key.

thanks,

greg k-h


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch-3.0.6-7"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 7767a64..11c4249 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 0
-SUBLEVEL =3D 6
+SUBLEVEL =3D 7
 EXTRAVERSION =3D
 NAME =3D Sneaky Weasel
=20
diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index f8b9392..9a9706c 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -6,6 +6,7 @@ config UX500_SOC_COMMON
 	select ARM_GIC
 	select HAS_MTU
 	select ARM_ERRATA_753970
+	select ARM_ERRATA_754322
=20
 menu "Ux500 SoC"
=20
diff --git a/arch/mips/jz4740/gpio.c b/arch/mips/jz4740/gpio.c
index 73031f7..4397972 100644
--- a/arch/mips/jz4740/gpio.c
+++ b/arch/mips/jz4740/gpio.c
@@ -18,7 +18,7 @@
 #include <linux/init.h>
=20
 #include <linux/spinlock.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
@@ -86,7 +86,6 @@ struct jz_gpio_chip {
 	spinlock_t lock;
=20
 	struct gpio_chip gpio_chip;
-	struct sys_device sysdev;
 };
=20
 static struct jz_gpio_chip jz4740_gpio_chips[];
@@ -459,49 +458,47 @@ static struct jz_gpio_chip jz4740_gpio_chips[] =3D {
 	JZ4740_GPIO_CHIP(D),
 };
=20
-static inline struct jz_gpio_chip *sysdev_to_chip(struct sys_device *dev)
+static void jz4740_gpio_suspend_chip(struct jz_gpio_chip *chip)
 {
-	return container_of(dev, struct jz_gpio_chip, sysdev);
+	chip->suspend_mask =3D readl(chip->base + JZ_REG_GPIO_MASK);
+	writel(~(chip->wakeup), chip->base + JZ_REG_GPIO_MASK_SET);
+	writel(chip->wakeup, chip->base + JZ_REG_GPIO_MASK_CLEAR);
 }
=20
-static int jz4740_gpio_suspend(struct sys_device *dev, pm_message_t state)
+static int jz4740_gpio_suspend(void)
 {
-	struct jz_gpio_chip *chip =3D sysdev_to_chip(dev);
+	int i;
=20
-	chip->suspend_mask =3D readl(chip->base + JZ_REG_GPIO_MASK);
-	writel(~(chip->wakeup), chip->base + JZ_REG_GPIO_MASK_SET);
-	writel(chip->wakeup, chip->base + JZ_REG_GPIO_MASK_CLEAR);
+	for (i =3D 0; i < ARRAY_SIZE(jz4740_gpio_chips); i++)
+		jz4740_gpio_suspend_chip(&jz4740_gpio_chips[i]);
=20
 	return 0;
 }
=20
-static int jz4740_gpio_resume(struct sys_device *dev)
+static void jz4740_gpio_resume_chip(struct jz_gpio_chip *chip)
 {
-	struct jz_gpio_chip *chip =3D sysdev_to_chip(dev);
 	uint32_t mask =3D chip->suspend_mask;
=20
 	writel(~mask, chip->base + JZ_REG_GPIO_MASK_CLEAR);
 	writel(mask, chip->base + JZ_REG_GPIO_MASK_SET);
+}
=20
-	return 0;
+static void jz4740_gpio_resume(void)
+{
+	int i;
+
+	for (i =3D ARRAY_SIZE(jz4740_gpio_chips) - 1; i >=3D 0 ; i--)
+		jz4740_gpio_resume_chip(&jz4740_gpio_chips[i]);
 }
=20
-static struct sysdev_class jz4740_gpio_sysdev_class =3D {
-	.name =3D "gpio",
+static struct syscore_ops jz4740_gpio_syscore_ops =3D {
 	.suspend =3D jz4740_gpio_suspend,
 	.resume =3D jz4740_gpio_resume,
 };
=20
-static int jz4740_gpio_chip_init(struct jz_gpio_chip *chip, unsigned int i=
d)
+static void jz4740_gpio_chip_init(struct jz_gpio_chip *chip, unsigned int =
id)
 {
-	int ret, irq;
-
-	chip->sysdev.id =3D id;
-	chip->sysdev.cls =3D &jz4740_gpio_sysdev_class;
-	ret =3D sysdev_register(&chip->sysdev);
-
-	if (ret)
-		return ret;
+	int irq;
=20
 	spin_lock_init(&chip->lock);
=20
@@ -519,22 +516,17 @@ static int jz4740_gpio_chip_init(struct jz_gpio_chip =
*chip, unsigned int id)
 		irq_set_chip_and_handler(irq, &jz_gpio_irq_chip,
 					 handle_level_irq);
 	}
-
-	return 0;
 }
=20
 static int __init jz4740_gpio_init(void)
 {
 	unsigned int i;
-	int ret;
-
-	ret =3D sysdev_class_register(&jz4740_gpio_sysdev_class);
-	if (ret)
-		return ret;
=20
 	for (i =3D 0; i < ARRAY_SIZE(jz4740_gpio_chips); ++i)
 		jz4740_gpio_chip_init(&jz4740_gpio_chips[i], i);
=20
+	register_syscore_ops(&jz4740_gpio_syscore_ops);
+
 	printk(KERN_INFO "JZ4740 GPIO initialized\n");
=20
 	return 0;
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 581531d..8e073d8 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -511,6 +511,11 @@ static void __init read_obp_translations(void)
 		for (i =3D 0; i < prom_trans_ents; i++)
 			prom_trans[i].data &=3D ~0x0003fe0000000000UL;
 	}
+
+	/* Force execute bit on.  */
+	for (i =3D 0; i < prom_trans_ents; i++)
+		prom_trans[i].data |=3D (tlb_type =3D=3D hypervisor ?
+				       _PAGE_EXEC_4V : _PAGE_EXEC_4U);
 }
=20
 static void __init hypervisor_tlb_lock(unsigned long vaddr,
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 68c3c13..50b3f14 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -43,6 +43,17 @@ static const struct dmi_system_id pci_use_crs_table[] __=
initconst =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ALiveSATA2-GLAN"),
                 },
         },
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=3D30552 */
+	/* 2006 AMD HT/VIA system with two host bridges */
+	{
+		.callback =3D set_use_crs,
+		.ident =3D "ASUS M2V-MX SE",
+		.matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "M2V-MX SE"),
+			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
+		},
+	},
 	{}
 };
=20
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index cab6960..1e9ab9b 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -812,6 +812,18 @@ static bool ahci_sb600_enable_64bit(struct pci_dev *pd=
ev)
 				DMI_MATCH(DMI_BOARD_NAME, "MS-7376"),
 			},
 		},
+		/*
+		 * All BIOS versions for the Asus M3A support 64bit DMA.
+		 * (all release versions from 0301 to 1206 were tested)
+		 */
+		{
+			.ident =3D "ASUS M3A",
+			.matches =3D {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "ASUSTeK Computer INC."),
+				DMI_MATCH(DMI_BOARD_NAME, "M3A"),
+			},
+		},
 		{ }
 	};
 	const struct dmi_system_id *match;
diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/=
atombios_dp.c
index 7ad43c6..79e8ebc 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -115,6 +115,7 @@ static int radeon_dp_aux_native_write(struct radeon_con=
nector *radeon_connector,
 	u8 msg[20];
 	int msg_bytes =3D send_bytes + 4;
 	u8 ack;
+	unsigned retry;
=20
 	if (send_bytes > 16)
 		return -1;
@@ -125,20 +126,22 @@ static int radeon_dp_aux_native_write(struct radeon_c=
onnector *radeon_connector,
 	msg[3] =3D (msg_bytes << 4) | (send_bytes - 1);
 	memcpy(&msg[4], send, send_bytes);
=20
-	while (1) {
+	for (retry =3D 0; retry < 4; retry++) {
 		ret =3D radeon_process_aux_ch(dig_connector->dp_i2c_bus,
 					    msg, msg_bytes, NULL, 0, delay, &ack);
-		if (ret < 0)
+		if (ret =3D=3D -EBUSY)
+			continue;
+		else if (ret < 0)
 			return ret;
 		if ((ack & AUX_NATIVE_REPLY_MASK) =3D=3D AUX_NATIVE_REPLY_ACK)
-			break;
+			return send_bytes;
 		else if ((ack & AUX_NATIVE_REPLY_MASK) =3D=3D AUX_NATIVE_REPLY_DEFER)
 			udelay(400);
 		else
 			return -EIO;
 	}
=20
-	return send_bytes;
+	return -EIO;
 }
=20
 static int radeon_dp_aux_native_read(struct radeon_connector *radeon_conne=
ctor,
@@ -149,26 +152,31 @@ static int radeon_dp_aux_native_read(struct radeon_co=
nnector *radeon_connector,
 	int msg_bytes =3D 4;
 	u8 ack;
 	int ret;
+	unsigned retry;
=20
 	msg[0] =3D address;
 	msg[1] =3D address >> 8;
 	msg[2] =3D AUX_NATIVE_READ << 4;
 	msg[3] =3D (msg_bytes << 4) | (recv_bytes - 1);
=20
-	while (1) {
+	for (retry =3D 0; retry < 4; retry++) {
 		ret =3D radeon_process_aux_ch(dig_connector->dp_i2c_bus,
 					    msg, msg_bytes, recv, recv_bytes, delay, &ack);
-		if (ret =3D=3D 0)
-			return -EPROTO;
-		if (ret < 0)
+		if (ret =3D=3D -EBUSY)
+			continue;
+		else if (ret < 0)
 			return ret;
 		if ((ack & AUX_NATIVE_REPLY_MASK) =3D=3D AUX_NATIVE_REPLY_ACK)
 			return ret;
 		else if ((ack & AUX_NATIVE_REPLY_MASK) =3D=3D AUX_NATIVE_REPLY_DEFER)
 			udelay(400);
+		else if (ret =3D=3D 0)
+			return -EPROTO;
 		else
 			return -EIO;
 	}
+
+	return -EIO;
 }
=20
 static void radeon_write_dpcd_reg(struct radeon_connector *radeon_connecto=
r,
@@ -232,7 +240,9 @@ int radeon_dp_i2c_aux_ch(struct i2c_adapter *adapter, i=
nt mode,
 	for (retry =3D 0; retry < 4; retry++) {
 		ret =3D radeon_process_aux_ch(auxch,
 					    msg, msg_bytes, reply, reply_bytes, 0, &ack);
-		if (ret < 0) {
+		if (ret =3D=3D -EBUSY)
+			continue;
+		else if (ret < 0) {
 			DRM_DEBUG_KMS("aux_ch failed %d\n", ret);
 			return ret;
 		}
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/ev=
ergreen.c
index c975581..ea7a24e 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1593,48 +1593,6 @@ static u32 evergreen_get_tile_pipe_to_backend_map(st=
ruct radeon_device *rdev,
 	return backend_map;
 }
=20
-static void evergreen_program_channel_remap(struct radeon_device *rdev)
-{
-	u32 tcp_chan_steer_lo, tcp_chan_steer_hi, mc_shared_chremap, tmp;
-
-	tmp =3D RREG32(MC_SHARED_CHMAP);
-	switch ((tmp & NOOFCHAN_MASK) >> NOOFCHAN_SHIFT) {
-	case 0:
-	case 1:
-	case 2:
-	case 3:
-	default:
-		/* default mapping */
-		mc_shared_chremap =3D 0x00fac688;
-		break;
-	}
-
-	switch (rdev->family) {
-	case CHIP_HEMLOCK:
-	case CHIP_CYPRESS:
-	case CHIP_BARTS:
-		tcp_chan_steer_lo =3D 0x54763210;
-		tcp_chan_steer_hi =3D 0x0000ba98;
-		break;
-	case CHIP_JUNIPER:
-	case CHIP_REDWOOD:
-	case CHIP_CEDAR:
-	case CHIP_PALM:
-	case CHIP_SUMO:
-	case CHIP_SUMO2:
-	case CHIP_TURKS:
-	case CHIP_CAICOS:
-	default:
-		tcp_chan_steer_lo =3D 0x76543210;
-		tcp_chan_steer_hi =3D 0x0000ba98;
-		break;
-	}
-
-	WREG32(TCP_CHAN_STEER_LO, tcp_chan_steer_lo);
-	WREG32(TCP_CHAN_STEER_HI, tcp_chan_steer_hi);
-	WREG32(MC_SHARED_CHREMAP, mc_shared_chremap);
-}
-
 static void evergreen_gpu_init(struct radeon_device *rdev)
 {
 	u32 cc_rb_backend_disable =3D 0;
@@ -2080,8 +2038,6 @@ static void evergreen_gpu_init(struct radeon_device *=
rdev)
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
=20
-	evergreen_program_channel_remap(rdev);
-
 	num_shader_engines =3D ((RREG32(GB_ADDR_CONFIG) & NUM_SHADER_ENGINES(3)) =
>> 12) + 1;
 	grbm_gfx_index =3D INSTANCE_BROADCAST_WRITES;
=20
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 0b132a3..0c460c4 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -569,36 +569,6 @@ static u32 cayman_get_tile_pipe_to_backend_map(struct =
radeon_device *rdev,
 	return backend_map;
 }
=20
-static void cayman_program_channel_remap(struct radeon_device *rdev)
-{
-	u32 tcp_chan_steer_lo, tcp_chan_steer_hi, mc_shared_chremap, tmp;
-
-	tmp =3D RREG32(MC_SHARED_CHMAP);
-	switch ((tmp & NOOFCHAN_MASK) >> NOOFCHAN_SHIFT) {
-	case 0:
-	case 1:
-	case 2:
-	case 3:
-	default:
-		/* default mapping */
-		mc_shared_chremap =3D 0x00fac688;
-		break;
-	}
-
-	switch (rdev->family) {
-	case CHIP_CAYMAN:
-	default:
-		//tcp_chan_steer_lo =3D 0x54763210
-		tcp_chan_steer_lo =3D 0x76543210;
-		tcp_chan_steer_hi =3D 0x0000ba98;
-		break;
-	}
-
-	WREG32(TCP_CHAN_STEER_LO, tcp_chan_steer_lo);
-	WREG32(TCP_CHAN_STEER_HI, tcp_chan_steer_hi);
-	WREG32(MC_SHARED_CHREMAP, mc_shared_chremap);
-}
-
 static u32 cayman_get_disable_mask_per_asic(struct radeon_device *rdev,
 					    u32 disable_mask_per_se,
 					    u32 max_disable_mask_per_se,
@@ -841,8 +811,6 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
=20
-	cayman_program_channel_remap(rdev);
-
 	/* primary versions */
 	WREG32(CC_RB_BACKEND_DISABLE, cc_rb_backend_disable);
 	WREG32(CC_SYS_RB_BACKEND_DISABLE, cc_rb_backend_disable);
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/r=
adeon/radeon_connectors.c
index d1b36f8..05b8b2c 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -68,11 +68,11 @@ void radeon_connector_hotplug(struct drm_connector *con=
nector)
 	if (connector->connector_type =3D=3D DRM_MODE_CONNECTOR_DisplayPort) {
 		int saved_dpms =3D connector->dpms;
=20
-		if (radeon_hpd_sense(rdev, radeon_connector->hpd.hpd) &&
-		    radeon_dp_needs_link_train(radeon_connector))
-			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
-		else
+		/* Only turn off the display it it's physically disconnected */
+		if (!radeon_hpd_sense(rdev, radeon_connector->hpd.hpd))
 			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
+		else if (radeon_dp_needs_link_train(radeon_connector))
+			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
 		connector->dpms =3D saved_dpms;
 	}
 }
diff --git a/drivers/gpu/drm/radeon/radeon_cursor.c b/drivers/gpu/drm/radeo=
n/radeon_cursor.c
index 3189a7e..f59a682 100644
--- a/drivers/gpu/drm/radeon/radeon_cursor.c
+++ b/drivers/gpu/drm/radeon/radeon_cursor.c
@@ -208,6 +208,13 @@ int radeon_crtc_cursor_move(struct drm_crtc *crtc,
 	int xorigin =3D 0, yorigin =3D 0;
 	int w =3D radeon_crtc->cursor_width;
=20
+	if (ASIC_IS_AVIVO(rdev)) {
+		/* avivo cursor are offset into the total surface */
+		x +=3D crtc->x;
+		y +=3D crtc->y;
+	}
+	DRM_DEBUG("x %d y %d c->x %d c->y %d\n", x, y, crtc->x, crtc->y);
+
 	if (x < 0)
 		xorigin =3D -x + 1;
 	if (y < 0)
@@ -221,11 +228,6 @@ int radeon_crtc_cursor_move(struct drm_crtc *crtc,
 		int i =3D 0;
 		struct drm_crtc *crtc_p;
=20
-		/* avivo cursor are offset into the total surface */
-		x +=3D crtc->x;
-		y +=3D crtc->y;
-		DRM_DEBUG("x %d y %d c->x %d c->y %d\n", x, y, crtc->x, crtc->y);
-
 		/* avivo cursor image can't end on 128 pixel boundary or
 		 * go past the end of the frame if both crtcs are enabled
 		 */
diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/rad=
eon/radeon_encoders.c
index 13690f3..8a171b2 100644
--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -1755,9 +1755,12 @@ static int radeon_atom_pick_dig_encoder(struct drm_e=
ncoder *encoder)
 	/* DCE4/5 */
 	if (ASIC_IS_DCE4(rdev)) {
 		dig =3D radeon_encoder->enc_priv;
-		if (ASIC_IS_DCE41(rdev))
-			return radeon_crtc->crtc_id;
-		else {
+		if (ASIC_IS_DCE41(rdev)) {
+			if (dig->linkb)
+				return 1;
+			else
+				return 0;
+		} else {
 			switch (radeon_encoder->encoder_id) {
 			case ENCODER_OBJECT_ID_INTERNAL_UNIPHY:
 				if (dig->linkb)
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 4de5189..f2516e6 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -536,55 +536,6 @@ static u32 r700_get_tile_pipe_to_backend_map(struct ra=
deon_device *rdev,
 	return backend_map;
 }
=20
-static void rv770_program_channel_remap(struct radeon_device *rdev)
-{
-	u32 tcp_chan_steer, mc_shared_chremap, tmp;
-	bool force_no_swizzle;
-
-	switch (rdev->family) {
-	case CHIP_RV770:
-	case CHIP_RV730:
-		force_no_swizzle =3D false;
-		break;
-	case CHIP_RV710:
-	case CHIP_RV740:
-	default:
-		force_no_swizzle =3D true;
-		break;
-	}
-
-	tmp =3D RREG32(MC_SHARED_CHMAP);
-	switch ((tmp & NOOFCHAN_MASK) >> NOOFCHAN_SHIFT) {
-	case 0:
-	case 1:
-	default:
-		/* default mapping */
-		mc_shared_chremap =3D 0x00fac688;
-		break;
-	case 2:
-	case 3:
-		if (force_no_swizzle)
-			mc_shared_chremap =3D 0x00fac688;
-		else
-			mc_shared_chremap =3D 0x00bbc298;
-		break;
-	}
-
-	if (rdev->family =3D=3D CHIP_RV740)
-		tcp_chan_steer =3D 0x00ef2a60;
-	else
-		tcp_chan_steer =3D 0x00fac688;
-
-	/* RV770 CE has special chremap setup */
-	if (rdev->pdev->device =3D=3D 0x944e) {
-		tcp_chan_steer =3D 0x00b08b08;
-		mc_shared_chremap =3D 0x00b08b08;
-	}
-
-	WREG32(TCP_CHAN_STEER, tcp_chan_steer);
-	WREG32(MC_SHARED_CHREMAP, mc_shared_chremap);
-}
-
 static void rv770_gpu_init(struct radeon_device *rdev)
 {
 	int i, j, num_qd_pipes;
@@ -784,8 +735,6 @@ static void rv770_gpu_init(struct radeon_device *rdev)
 	WREG32(DCP_TILING_CONFIG, (gb_tiling_config & 0xffff));
 	WREG32(HDP_TILING_CONFIG, (gb_tiling_config & 0xffff));
=20
-	rv770_program_channel_remap(rdev);
-
 	WREG32(CC_RB_BACKEND_DISABLE,      cc_rb_backend_disable);
 	WREG32(CC_GC_SHADER_PIPE_CONFIG,   cc_gc_shader_pipe_config);
 	WREG32(GC_USER_SHADER_PIPE_CONFIG, cc_gc_shader_pipe_config);
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 2747980..16f69be 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -435,7 +435,12 @@ static int idedisk_prep_fn(struct request_queue *q, st=
ruct request *rq)
 	if (!(rq->cmd_flags & REQ_FLUSH))
 		return BLKPREP_OK;
=20
-	cmd =3D kzalloc(sizeof(*cmd), GFP_ATOMIC);
+	if (rq->special) {
+		cmd =3D rq->special;
+		memset(cmd, 0, sizeof(*cmd));
+	} else {
+		cmd =3D kzalloc(sizeof(*cmd), GFP_ATOMIC);
+	}
=20
 	/* FIXME: map struct ide_taskfile on rq->cmd[] */
 	BUG_ON(cmd =3D=3D NULL);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 451c3bb..ebdae6e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1184,14 +1184,15 @@ static void dm_table_set_integrity(struct dm_table =
*t)
 		return;
=20
 	template_disk =3D dm_table_get_integrity_disk(t, true);
-	if (!template_disk &&
-	    blk_integrity_is_initialized(dm_disk(t->md))) {
+	if (template_disk)
+		blk_integrity_register(dm_disk(t->md),
+				       blk_get_integrity(template_disk));
+	else if (blk_integrity_is_initialized(dm_disk(t->md)))
 		DMWARN("%s: device no longer has a valid integrity profile",
 		       dm_device_name(t->md));
-		return;
-	}
-	blk_integrity_register(dm_disk(t->md),
-			       blk_get_integrity(template_disk));
+	else
+		DMWARN("%s: unable to establish an integrity profile",
+		       dm_device_name(t->md));
 }
=20
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8554082..bc83428 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -61,6 +61,11 @@
 static void autostart_arrays(int part);
 #endif
=20
+/* pers_list is a list of registered personalities protected
+ * by pers_lock.
+ * pers_lock does extra service to protect accesses to
+ * mddev->thread when the mutex cannot be held.
+ */
 static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
=20
@@ -690,7 +695,12 @@ static void mddev_unlock(mddev_t * mddev)
 	} else
 		mutex_unlock(&mddev->reconfig_mutex);
=20
+	/* was we've dropped the mutex we need a spinlock to
+	 * make sur the thread doesn't disappear
+	 */
+	spin_lock(&pers_lock);
 	md_wakeup_thread(mddev->thread);
+	spin_unlock(&pers_lock);
 }
=20
 static mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
@@ -6186,11 +6196,18 @@ mdk_thread_t *md_register_thread(void (*run) (mddev=
_t *), mddev_t *mddev,
 	return thread;
 }
=20
-void md_unregister_thread(mdk_thread_t *thread)
+void md_unregister_thread(mdk_thread_t **threadp)
 {
+	mdk_thread_t *thread =3D *threadp;
 	if (!thread)
 		return;
 	dprintk("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
+	/* Locking ensures that mddev_unlock does not wake_up a
+	 * non-existent thread
+	 */
+	spin_lock(&pers_lock);
+	*threadp =3D NULL;
+	spin_unlock(&pers_lock);
=20
 	kthread_stop(thread->tsk);
 	kfree(thread);
@@ -7125,8 +7142,7 @@ static void reap_sync_thread(mddev_t *mddev)
 	mdk_rdev_t *rdev;
=20
 	/* resync has finished, collect result */
-	md_unregister_thread(mddev->sync_thread);
-	mddev->sync_thread =3D NULL;
+	md_unregister_thread(&mddev->sync_thread);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		/* success...*/
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1c26c7a..ce4e328 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -475,7 +475,7 @@ extern int register_md_personality(struct mdk_personali=
ty *p);
 extern int unregister_md_personality(struct mdk_personality *p);
 extern mdk_thread_t * md_register_thread(void (*run) (mddev_t *mddev),
 				mddev_t *mddev, const char *name);
-extern void md_unregister_thread(mdk_thread_t *thread);
+extern void md_unregister_thread(mdk_thread_t **threadp);
 extern void md_wakeup_thread(mdk_thread_t *thread);
 extern void md_check_recovery(mddev_t *mddev);
 extern void md_write_start(mddev_t *mddev, struct bio *bi);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 3535c23..d5b5fb3 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -514,8 +514,7 @@ static int multipath_stop (mddev_t *mddev)
 {
 	multipath_conf_t *conf =3D mddev->private;
=20
-	md_unregister_thread(mddev->thread);
-	mddev->thread =3D NULL;
+	md_unregister_thread(&mddev->thread);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	mempool_destroy(conf->pool);
 	kfree(conf->multipaths);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f7431b6..3a9e59f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2045,8 +2045,7 @@ static int stop(mddev_t *mddev)
 	raise_barrier(conf);
 	lower_barrier(conf);
=20
-	md_unregister_thread(mddev->thread);
-	mddev->thread =3D NULL;
+	md_unregister_thread(&mddev->thread);
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6e84668..17cb6ab 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2331,7 +2331,7 @@ static int run(mddev_t *mddev)
 	return 0;
=20
 out_free_conf:
-	md_unregister_thread(mddev->thread);
+	md_unregister_thread(&mddev->thread);
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
 	safe_put_page(conf->tmppage);
@@ -2349,8 +2349,7 @@ static int stop(mddev_t *mddev)
 	raise_barrier(conf, 0);
 	lower_barrier(conf);
=20
-	md_unregister_thread(mddev->thread);
-	mddev->thread =3D NULL;
+	md_unregister_thread(&mddev->thread);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b72edf3..2581ba1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5162,8 +5162,7 @@ static int run(mddev_t *mddev)
=20
 	return 0;
 abort:
-	md_unregister_thread(mddev->thread);
-	mddev->thread =3D NULL;
+	md_unregister_thread(&mddev->thread);
 	if (conf) {
 		print_raid5_conf(conf);
 		free_conf(conf);
@@ -5177,8 +5176,7 @@ static int stop(mddev_t *mddev)
 {
 	raid5_conf_t *conf =3D mddev->private;
=20
-	md_unregister_thread(mddev->thread);
-	mddev->thread =3D NULL;
+	md_unregister_thread(&mddev->thread);
 	if (mddev->queue)
 		mddev->queue->backing_dev_info.congested_fn =3D NULL;
 	free_conf(conf);
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/li=
s3lv02d.c
index b928bc1..8b51cd6 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -375,12 +375,14 @@ void lis3lv02d_poweron(struct lis3lv02d *lis3)
 	 *      both have been read. So the value read will always be correct.
 	 * Set BOOT bit to refresh factory tuning values.
 	 */
-	lis3->read(lis3, CTRL_REG2, &reg);
-	if (lis3->whoami =3D=3D  WAI_12B)
-		reg |=3D CTRL2_BDU | CTRL2_BOOT;
-	else
-		reg |=3D CTRL2_BOOT_8B;
-	lis3->write(lis3, CTRL_REG2, reg);
+	if (lis3->pdata) {
+		lis3->read(lis3, CTRL_REG2, &reg);
+		if (lis3->whoami =3D=3D  WAI_12B)
+			reg |=3D CTRL2_BDU | CTRL2_BOOT;
+		else
+			reg |=3D CTRL2_BOOT_8B;
+		lis3->write(lis3, CTRL_REG2, reg);
+	}
=20
 	/* LIS3 power on delay is quite long */
 	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 99d39a6..d513d47 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -564,40 +564,38 @@ static void mxs_mmc_request(struct mmc_host *mmc, str=
uct mmc_request *mrq)
=20
 static void mxs_mmc_set_clk_rate(struct mxs_mmc_host *host, unsigned int r=
ate)
 {
-	unsigned int ssp_rate, bit_rate;
-	u32 div1, div2;
+	unsigned int ssp_clk, ssp_sck;
+	u32 clock_divide, clock_rate;
 	u32 val;
=20
-	ssp_rate =3D clk_get_rate(host->clk);
+	ssp_clk =3D clk_get_rate(host->clk);
=20
-	for (div1 =3D 2; div1 < 254; div1 +=3D 2) {
-		div2 =3D ssp_rate / rate / div1;
-		if (div2 < 0x100)
+	for (clock_divide =3D 2; clock_divide <=3D 254; clock_divide +=3D 2) {
+		clock_rate =3D DIV_ROUND_UP(ssp_clk, rate * clock_divide);
+		clock_rate =3D (clock_rate > 0) ? clock_rate - 1 : 0;
+		if (clock_rate <=3D 255)
 			break;
 	}
=20
-	if (div1 >=3D 254) {
+	if (clock_divide > 254) {
 		dev_err(mmc_dev(host->mmc),
 			"%s: cannot set clock to %d\n", __func__, rate);
 		return;
 	}
=20
-	if (div2 =3D=3D 0)
-		bit_rate =3D ssp_rate / div1;
-	else
-		bit_rate =3D ssp_rate / div1 / div2;
+	ssp_sck =3D ssp_clk / clock_divide / (1 + clock_rate);
=20
 	val =3D readl(host->base + HW_SSP_TIMING);
 	val &=3D ~(BM_SSP_TIMING_CLOCK_DIVIDE | BM_SSP_TIMING_CLOCK_RATE);
-	val |=3D BF_SSP(div1, TIMING_CLOCK_DIVIDE);
-	val |=3D BF_SSP(div2 - 1, TIMING_CLOCK_RATE);
+	val |=3D BF_SSP(clock_divide, TIMING_CLOCK_DIVIDE);
+	val |=3D BF_SSP(clock_rate, TIMING_CLOCK_RATE);
 	writel(val, host->base + HW_SSP_TIMING);
=20
-	host->clk_rate =3D bit_rate;
+	host->clk_rate =3D ssp_sck;
=20
 	dev_dbg(mmc_dev(host->mmc),
-		"%s: div1 %d, div2 %d, ssp %d, bit %d, rate %d\n",
-		__func__, div1, div2, ssp_rate, bit_rate, rate);
+		"%s: clock_divide %d, clock_rate %d, ssp_clk %d, rate_actual %d, rate_re=
quested %d\n",
+		__func__, clock_divide, clock_rate, ssp_clk, ssp_sck, rate);
 }
=20
 static void mxs_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 3369d1f..ee77b94 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -137,8 +137,9 @@
 #define HV_PM_CTRL		PHY_REG(770, 17)
=20
 /* PHY Low Power Idle Control */
-#define I82579_LPI_CTRL			PHY_REG(772, 20)
-#define I82579_LPI_CTRL_ENABLE_MASK	0x6000
+#define I82579_LPI_CTRL				PHY_REG(772, 20)
+#define I82579_LPI_CTRL_ENABLE_MASK		0x6000
+#define I82579_LPI_CTRL_FORCE_PLL_LOCK_COUNT	0x80
=20
 /* EMI Registers */
 #define I82579_EMI_ADDR         0x10
@@ -1611,6 +1612,7 @@ static s32 e1000_k1_workaround_lv(struct e1000_hw *hw)
 	s32 ret_val =3D 0;
 	u16 status_reg =3D 0;
 	u32 mac_reg;
+	u16 phy_reg;
=20
 	if (hw->mac.type !=3D e1000_pch2lan)
 		goto out;
@@ -1625,12 +1627,19 @@ static s32 e1000_k1_workaround_lv(struct e1000_hw *=
hw)
 		mac_reg =3D er32(FEXTNVM4);
 		mac_reg &=3D ~E1000_FEXTNVM4_BEACON_DURATION_MASK;
=20
-		if (status_reg & HV_M_STATUS_SPEED_1000)
+		ret_val =3D e1e_rphy(hw, I82579_LPI_CTRL, &phy_reg);
+		if (ret_val)
+			goto out;
+
+		if (status_reg & HV_M_STATUS_SPEED_1000) {
 			mac_reg |=3D E1000_FEXTNVM4_BEACON_DURATION_8USEC;
-		else
+			phy_reg &=3D ~I82579_LPI_CTRL_FORCE_PLL_LOCK_COUNT;
+		} else {
 			mac_reg |=3D E1000_FEXTNVM4_BEACON_DURATION_16USEC;
-
+			phy_reg |=3D I82579_LPI_CTRL_FORCE_PLL_LOCK_COUNT;
+		}
 		ew32(FEXTNVM4, mac_reg);
+		ret_val =3D e1e_wphy(hw, I82579_LPI_CTRL, phy_reg);
 	}
=20
 out:
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wirele=
ss/rt2x00/rt2x00queue.c
index ab8c16f..2886d25 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -556,15 +556,21 @@ int rt2x00queue_write_tx_frame(struct data_queue *que=
ue, struct sk_buff *skb,
 			       bool local)
 {
 	struct ieee80211_tx_info *tx_info;
-	struct queue_entry *entry =3D rt2x00queue_get_entry(queue, Q_INDEX);
+	struct queue_entry *entry;
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc;
 	u8 rate_idx, rate_flags;
+	int ret =3D 0;
+
+	spin_lock(&queue->tx_lock);
+
+	entry =3D rt2x00queue_get_entry(queue, Q_INDEX);
=20
 	if (unlikely(rt2x00queue_full(queue))) {
 		ERROR(queue->rt2x00dev,
 		      "Dropping frame due to full tx queue %d.\n", queue->qid);
-		return -ENOBUFS;
+		ret =3D -ENOBUFS;
+		goto out;
 	}
=20
 	if (unlikely(test_and_set_bit(ENTRY_OWNER_DEVICE_DATA,
@@ -573,7 +579,8 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue=
, struct sk_buff *skb,
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
 		      queue->qid, DRV_PROJECT);
-		return -EINVAL;
+		ret =3D -EINVAL;
+		goto out;
 	}
=20
 	/*
@@ -635,7 +642,8 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue=
, struct sk_buff *skb,
 	if (unlikely(rt2x00queue_write_tx_data(entry, &txdesc))) {
 		clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 		entry->skb =3D NULL;
-		return -EIO;
+		ret =3D -EIO;
+		goto out;
 	}
=20
 	set_bit(ENTRY_DATA_PENDING, &entry->flags);
@@ -644,7 +652,9 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue=
, struct sk_buff *skb,
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 	rt2x00queue_kick_tx_queue(queue, &txdesc);
=20
-	return 0;
+out:
+	spin_unlock(&queue->tx_lock);
+	return ret;
 }
=20
 int rt2x00queue_clear_beacon(struct rt2x00_dev *rt2x00dev,
@@ -1185,6 +1195,7 @@ static void rt2x00queue_init(struct rt2x00_dev *rt2x0=
0dev,
 			     struct data_queue *queue, enum data_queue_qid qid)
 {
 	mutex_init(&queue->status_lock);
+	spin_lock_init(&queue->tx_lock);
 	spin_lock_init(&queue->index_lock);
=20
 	queue->rt2x00dev =3D rt2x00dev;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wirele=
ss/rt2x00/rt2x00queue.h
index 167d458..ad3d527 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -432,6 +432,7 @@ enum data_queue_flags {
  * @flags: Entry flags, see &enum queue_entry_flags.
  * @status_lock: The mutex for protecting the start/stop/flush
  *	handling on this queue.
+ * @tx_lock: Spinlock to serialize tx operations on this queue.
  * @index_lock: Spinlock to protect index handling. Whenever @index, @inde=
x_done or
  *	@index_crypt needs to be changed this lock should be grabbed to prevent
  *	index corruption due to concurrency.
@@ -458,6 +459,7 @@ struct data_queue {
 	unsigned long flags;
=20
 	struct mutex status_lock;
+	spinlock_t tx_lock;
 	spinlock_t index_lock;
=20
 	unsigned int count;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_e=
xpander.c
index c9e3dc0..16ad97d 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1769,10 +1769,12 @@ static void sas_unregister_devs_sas_addr(struct dom=
ain_device *parent,
 		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
-	sas_port_delete_phy(phy->port, phy->phy);
-	if (phy->port->num_phys =3D=3D 0)
-		sas_port_delete(phy->port);
-	phy->port =3D NULL;
+	if (phy->port) {
+		sas_port_delete_phy(phy->port, phy->phy);
+		if (phy->port->num_phys =3D=3D 0)
+			sas_port_delete(phy->port);
+		phy->port =3D NULL;
+	}
 }
=20
 static int sas_discover_bfs_by_root_level(struct domain_device *root,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f461925..a2a1a83 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1240,10 +1240,9 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 					qla2x00_sp_compl(ha, sp);
 				} else {
 					ctx =3D sp->ctx;
-					if (ctx->type =3D=3D SRB_LOGIN_CMD ||
-					    ctx->type =3D=3D SRB_LOGOUT_CMD) {
-						ctx->u.iocb_cmd->free(sp);
-					} else {
+					if (ctx->type =3D=3D SRB_ELS_CMD_RPT ||
+					    ctx->type =3D=3D SRB_ELS_CMD_HST ||
+					    ctx->type =3D=3D SRB_CT_CMD) {
 						struct fc_bsg_job *bsg_job =3D
 						    ctx->u.bsg_job;
 						if (bsg_job->request->msgcode
@@ -1255,6 +1254,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 						kfree(sp->ctx);
 						mempool_free(sp,
 							ha->srb_mempool);
+					} else {
+						ctx->u.iocb_cmd->free(sp);
 					}
 				}
 			}
diff --git a/fs/exec.c b/fs/exec.c
index 6075a1e..044c13f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1411,6 +1411,8 @@ int search_binary_handler(struct linux_binprm *bprm,s=
truct pt_regs *regs)
 			    printable(bprm->buf[2]) &&
 			    printable(bprm->buf[3]))
 				break; /* -ENOEXEC */
+			if (try)
+				break; /* -ENOEXEC */
 			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
 #endif
 		}
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9d88e1c..f0c0e8a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -19,6 +19,8 @@
=20
 #include <asm/ftrace.h>
=20
+struct ftrace_hash;
+
 #ifdef CONFIG_FUNCTION_TRACER
=20
 extern int ftrace_enabled;
@@ -29,8 +31,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
=20
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
=20
-struct ftrace_hash;
-
 enum {
 	FTRACE_OPS_FL_ENABLED		=3D 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		=3D 1 << 1,
@@ -123,7 +123,8 @@ stack_trace_sysctl(struct ctl_table *table, int write,
 struct ftrace_func_command {
 	struct list_head	list;
 	char			*name;
-	int			(*func)(char *func, char *cmd,
+	int			(*func)(struct ftrace_hash *hash,
+					char *func, char *cmd,
 					char *params, int enable);
 };
=20
diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index e07e274..1dc420b 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -51,6 +51,7 @@
 #define PTP_CLASS_V2_VLAN (PTP_CLASS_V2 | PTP_CLASS_VLAN)
=20
 #define PTP_EV_PORT 319
+#define PTP_GEN_BIT 0x08 /* indicates general message, if set in message t=
ype */
=20
 #define OFF_ETYPE	12
 #define OFF_IHL		14
@@ -116,14 +117,20 @@ static inline int ptp_filter_init(struct sock_filter =
*f, int len)
 	{OP_OR,		0,   0, PTP_CLASS_IPV6		}, /*              */ \
 	{OP_RETA,	0,   0, 0			}, /*              */ \
 /*L3x*/	{OP_RETK,	0,   0, PTP_CLASS_NONE		}, /*              */ \
-/*L40*/	{OP_JEQ,	0,   6, ETH_P_8021Q		}, /* f goto L50   */ \
+/*L40*/	{OP_JEQ,	0,   9, ETH_P_8021Q		}, /* f goto L50   */ \
 	{OP_LDH,	0,   0, OFF_ETYPE + 4		}, /*              */ \
-	{OP_JEQ,	0,   9, ETH_P_1588		}, /* f goto L60   */ \
+	{OP_JEQ,	0,  15, ETH_P_1588		}, /* f goto L60   */ \
+	{OP_LDB,	0,   0, ETH_HLEN + VLAN_HLEN	}, /*              */ \
+	{OP_AND,	0,   0, PTP_GEN_BIT		}, /*              */ \
+	{OP_JEQ,	0,  12, 0			}, /* f goto L6x   */ \
 	{OP_LDH,	0,   0, ETH_HLEN + VLAN_HLEN	}, /*              */ \
 	{OP_AND,	0,   0, PTP_CLASS_VMASK		}, /*              */ \
 	{OP_OR,		0,   0, PTP_CLASS_VLAN		}, /*              */ \
 	{OP_RETA,	0,   0, 0			}, /*              */ \
-/*L50*/	{OP_JEQ,	0,   4, ETH_P_1588		}, /* f goto L61   */ \
+/*L50*/	{OP_JEQ,	0,   7, ETH_P_1588		}, /* f goto L61   */ \
+	{OP_LDB,	0,   0, ETH_HLEN		}, /*              */ \
+	{OP_AND,	0,   0, PTP_GEN_BIT		}, /*              */ \
+	{OP_JEQ,	0,   4, 0			}, /* f goto L6x   */ \
 	{OP_LDH,	0,   0, ETH_HLEN		}, /*              */ \
 	{OP_AND,	0,   0, PTP_CLASS_VMASK		}, /*              */ \
 	{OP_OR,		0,   0, PTP_CLASS_L2		}, /*              */ \
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 14a6c7b..4ef452b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1937,7 +1937,6 @@ static inline void disable_sched_clock_irqtime(void) =
{}
=20
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
-extern unsigned long long thread_group_sched_runtime(struct task_struct *t=
ask);
=20
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 3b5ac1f..c39121f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -463,7 +463,7 @@ static inline int ipv6_addr_diff(const struct in6_addr =
*a1, const struct in6_add
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
=20
-extern void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt);
+extern void ipv6_select_ident(struct frag_hdr *fhdr, struct in6_addr *addr=
);
=20
 /*
  *	Prototypes exported by ipv6
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 58f405b..c8008dd 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -250,7 +250,7 @@ void thread_group_cputime(struct task_struct *tsk, stru=
ct task_cputime *times)
 	do {
 		times->utime =3D cputime_add(times->utime, t->utime);
 		times->stime =3D cputime_add(times->stime, t->stime);
-		times->sum_exec_runtime +=3D t->se.sum_exec_runtime;
+		times->sum_exec_runtime +=3D task_sched_runtime(t);
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
@@ -312,7 +312,8 @@ static int cpu_clock_sample_group(const clockid_t which=
_clock,
 		cpu->cpu =3D cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched =3D thread_group_sched_runtime(p);
+		thread_group_cputime(p, &cputime);
+		cpu->sched =3D cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
diff --git a/kernel/sched.c b/kernel/sched.c
index 8b37360..063d7a4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3713,30 +3713,6 @@ unsigned long long task_sched_runtime(struct task_st=
ruct *p)
 }
=20
 /*
- * Return sum_exec_runtime for the thread group.
- * In case the task is currently running, return the sum plus current's
- * pending runtime that have not been accounted yet.
- *
- * Note that the thread group might have other running tasks as well,
- * so the return value not includes other pending runtime that other
- * running tasks might have.
- */
-unsigned long long thread_group_sched_runtime(struct task_struct *p)
-{
-	struct task_cputime totals;
-	unsigned long flags;
-	struct rq *rq;
-	u64 ns;
-
-	rq =3D task_rq_lock(p, &flags);
-	thread_group_cputime(p, &totals);
-	ns =3D totals.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, p, &flags);
-
-	return ns;
-}
-
-/*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @cputime: the cpu time spent in user space since the last update
@@ -4335,7 +4311,7 @@ static inline void sched_submit_work(struct task_stru=
ct *tsk)
 		blk_schedule_flush_plug(tsk);
 }
=20
-asmlinkage void schedule(void)
+asmlinkage void __sched schedule(void)
 {
 	struct task_struct *tsk =3D current;
=20
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 10d0182..17f2319 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1038,7 +1038,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag,=
 int flags)
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->rt.nr_cpus_allowed < 2 ||
-	     curr->prio < p->prio) &&
+	     curr->prio <=3D p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int target =3D find_lowest_rq(p);
=20
@@ -1569,7 +1569,7 @@ static void task_woken_rt(struct rq *rq, struct task_=
struct *p)
 	    p->rt.nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
 	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio))
+	     rq->curr->prio <=3D p->prio))
 		push_rt_tasks(rq);
 }
=20
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 908038f..ef9271b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1744,10 +1744,36 @@ static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
=20
+static int ops_traces_mod(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash;
+
+	hash =3D ops->filter_hash;
+	return !!(!hash || !hash->count);
+}
+
 static int ftrace_update_code(struct module *mod)
 {
 	struct dyn_ftrace *p;
 	cycle_t start, stop;
+	unsigned long ref =3D 0;
+
+	/*
+	 * When adding a module, we need to check if tracers are
+	 * currently enabled and if they are set to trace all functions.
+	 * If they are, we need to enable the module functions as well
+	 * as update the reference counts for those function records.
+	 */
+	if (mod) {
+		struct ftrace_ops *ops;
+
+		for (ops =3D ftrace_ops_list;
+		     ops !=3D &ftrace_list_end; ops =3D ops->next) {
+			if (ops->flags & FTRACE_OPS_FL_ENABLED &&
+			    ops_traces_mod(ops))
+				ref++;
+		}
+	}
=20
 	start =3D ftrace_now(raw_smp_processor_id());
 	ftrace_update_cnt =3D 0;
@@ -1760,7 +1786,7 @@ static int ftrace_update_code(struct module *mod)
=20
 		p =3D ftrace_new_addrs;
 		ftrace_new_addrs =3D p->newlist;
-		p->flags =3D 0L;
+		p->flags =3D ref;
=20
 		/*
 		 * Do the initial record conversion from mcount jump
@@ -1783,7 +1809,7 @@ static int ftrace_update_code(struct module *mod)
 		 * conversion puts the module to the correct state, thus
 		 * passing the ftrace_make_call check.
 		 */
-		if (ftrace_start_up) {
+		if (ftrace_start_up && ref) {
 			int failed =3D __ftrace_replace_code(p, 1);
 			if (failed) {
 				ftrace_bug(failed, p->ip);
@@ -2407,10 +2433,9 @@ ftrace_match_module_records(struct ftrace_hash *hash=
, char *buff, char *mod)
  */
=20
 static int
-ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
+ftrace_mod_callback(struct ftrace_hash *hash,
+		    char *func, char *cmd, char *param, int enable)
 {
-	struct ftrace_ops *ops =3D &global_ops;
-	struct ftrace_hash *hash;
 	char *mod;
 	int ret =3D -EINVAL;
=20
@@ -2430,11 +2455,6 @@ ftrace_mod_callback(char *func, char *cmd, char *par=
am, int enable)
 	if (!strlen(mod))
 		return ret;
=20
-	if (enable)
-		hash =3D ops->filter_hash;
-	else
-		hash =3D ops->notrace_hash;
-
 	ret =3D ftrace_match_module_records(hash, func, mod);
 	if (!ret)
 		ret =3D -EINVAL;
@@ -2760,7 +2780,7 @@ static int ftrace_process_regex(struct ftrace_hash *h=
ash,
 	mutex_lock(&ftrace_cmd_mutex);
 	list_for_each_entry(p, &ftrace_commands, list) {
 		if (strcmp(p->name, command) =3D=3D 0) {
-			ret =3D p->func(func, command, next, enable);
+			ret =3D p->func(hash, func, command, next, enable);
 			goto out_unlock;
 		}
 	}
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 8d0e1cc..c7b0c6a 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -324,7 +324,8 @@ ftrace_trace_onoff_unreg(char *glob, char *cmd, char *p=
aram)
 }
=20
 static int
-ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
+ftrace_trace_onoff_callback(struct ftrace_hash *hash,
+			    char *glob, char *cmd, char *param, int enable)
 {
 	struct ftrace_probe_ops *ops;
 	void *count =3D (void *)-1;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 1661296..e17596b 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -620,9 +620,9 @@ static u32 __ipv6_select_ident(const struct in6_addr *a=
ddr)
 	return hash + newid;
 }
=20
-void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
+void ipv6_select_ident(struct frag_hdr *fhdr, struct in6_addr *addr)
 {
-	fhdr->identification =3D htonl(__ipv6_select_ident(&rt->rt6i_dst.addr));
+	fhdr->identification =3D htonl(__ipv6_select_ident(addr));
 }
=20
 int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
@@ -709,7 +709,7 @@ int ip6_fragment(struct sk_buff *skb, int (*output)(str=
uct sk_buff *))
 		skb_reset_network_header(skb);
 		memcpy(skb_network_header(skb), tmp_hdr, hlen);
=20
-		ipv6_select_ident(fh, rt);
+		ipv6_select_ident(fh, &rt->rt6i_dst.addr);
 		fh->nexthdr =3D nexthdr;
 		fh->reserved =3D 0;
 		fh->frag_off =3D htons(IP6_MF);
@@ -855,7 +855,7 @@ slow_path:
 		fh->nexthdr =3D nexthdr;
 		fh->reserved =3D 0;
 		if (!frag_id) {
-			ipv6_select_ident(fh, rt);
+			ipv6_select_ident(fh, &rt->rt6i_dst.addr);
 			frag_id =3D fh->identification;
 		} else
 			fh->identification =3D frag_id;
@@ -1146,7 +1146,7 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 		skb_shinfo(skb)->gso_size =3D (mtu - fragheaderlen -
 					     sizeof(struct frag_hdr)) & ~7;
 		skb_shinfo(skb)->gso_type =3D SKB_GSO_UDP;
-		ipv6_select_ident(&fhdr, rt);
+		ipv6_select_ident(&fhdr, &rt->rt6i_dst.addr);
 		skb_shinfo(skb)->ip6_frag_id =3D fhdr.identification;
 		__skb_queue_tail(&sk->sk_write_queue, skb);
=20
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29213b5..0d920c5 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1309,6 +1309,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_bu=
ff *skb, u32 features)
 	u8 frag_hdr_sz =3D sizeof(struct frag_hdr);
 	int offset;
 	__wsum csum;
+	struct rt6_info *rt =3D (struct rt6_info *)skb_dst(skb);
=20
 	mss =3D skb_shinfo(skb)->gso_size;
 	if (unlikely(skb->len <=3D mss))
@@ -1359,7 +1360,8 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_bu=
ff *skb, u32 features)
 	fptr =3D (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
 	fptr->nexthdr =3D nexthdr;
 	fptr->reserved =3D 0;
-	ipv6_select_ident(fptr, (struct rt6_info *)skb_dst(skb));
+	ipv6_select_ident(fptr,
+			  rt ? &rt->rt6i_dst.addr : &ipv6_hdr(skb)->daddr);
=20
 	/* Fragment the skb. ipv6 header and the remaining fields of the
 	 * fragment header are updated in ipv6_gso_segment()
diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index ffa2ffe..aa091a0 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -1454,8 +1454,8 @@ static int wm8753_probe(struct snd_soc_codec *codec)
 	/* set the update bits */
 	snd_soc_update_bits(codec, WM8753_LDAC, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_RDAC, 0x0100, 0x0100);
-	snd_soc_update_bits(codec, WM8753_LDAC, 0x0100, 0x0100);
-	snd_soc_update_bits(codec, WM8753_RDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_LADC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_RADC, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_LOUT1V, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_ROUT1V, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_LOUT2V, 0x0100, 0x0100);
diff --git a/sound/soc/pxa/zylonite.c b/sound/soc/pxa/zylonite.c
index b644575..2b8350b 100644
--- a/sound/soc/pxa/zylonite.c
+++ b/sound/soc/pxa/zylonite.c
@@ -196,20 +196,20 @@ static int zylonite_probe(struct snd_soc_card *card)
 	if (clk_pout) {
 		pout =3D clk_get(NULL, "CLK_POUT");
 		if (IS_ERR(pout)) {
-			dev_err(&pdev->dev, "Unable to obtain CLK_POUT: %ld\n",
+			dev_err(card->dev, "Unable to obtain CLK_POUT: %ld\n",
 				PTR_ERR(pout));
 			return PTR_ERR(pout);
 		}
=20
 		ret =3D clk_enable(pout);
 		if (ret !=3D 0) {
-			dev_err(&pdev->dev, "Unable to enable CLK_POUT: %d\n",
+			dev_err(card->dev, "Unable to enable CLK_POUT: %d\n",
 				ret);
 			clk_put(pout);
 			return ret;
 		}
=20
-		dev_dbg(&pdev->dev, "MCLK enabled at %luHz\n",
+		dev_dbg(card->dev, "MCLK enabled at %luHz\n",
 			clk_get_rate(pout));
 	}
=20
@@ -241,7 +241,7 @@ static int zylonite_resume_pre(struct snd_soc_card *car=
d)
 	if (clk_pout) {
 		ret =3D clk_enable(pout);
 		if (ret !=3D 0)
-			dev_err(&pdev->dev, "Unable to enable CLK_POUT: %d\n",
+			dev_err(card->dev, "Unable to enable CLK_POUT: %d\n",
 				ret);
 	}
=20

--/e2eDi0V/xtL+Mc8--

--+B+y8wtTXqdUj1xM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOnL77AAoJEDjbvchgkmk+wRoQAM2RHLptyMWxcB93LUjHgQ+d
S+UW+FlSdbeMN6IGxeaS59D7M3oVbACLmGVcWLOJ40TNbI1YUjLQUNLbpEucEEsU
bgC1NjjeFhJKz1H+d9Dbw/B4DzQEEPUPei580OJ+sMO27W2tftgUb3LNBwlBrRbG
fEttkZEZItw8aUhtp5XlpdukemsEQYfxBXlozDjpquHN2EaSOuB/gU6E8M+6FWTw
+uuGZIslo6MiCSr1GWCx/yyFZwvN35lFjp134I+R/vIfAQew5/Pp9BhAiTCiuhmo
ldEBij7OkJd74BDopFdt+h+4j2iITmxNisLRCeaqHxZvAZznehK3hUbfIKLoczXB
5OYfJG6D1/vU12R2df4RsyhCeKPG9XcQJE2oOzkjk3vCn7xi+I7Es6L7uIZMstxd
H68ayOctNZFO0RZmsm9WMhc8qST8jSl2+EhXeUekEwuKy1QavtV6jCdpbO0LdzMo
PlCgCjz2+yHEaEV+kUcps/pupWrOmeDCiu05tDsyC0tJh1M/SafPzF4DJp4YOWHD
HRNGPIgaXLhumefX66+t2EK5YbfmaUSu1qIviSejVbcYNtyNx0QeVW41TBQGqMrI
LFQOs5+YDPERiRjHHwv62pcUfyIdXuxr/tyTnH8r2ccx7YBgr4lQ1MxqcB2fKYRK
0CfU3lNPqLKRyRI9rh55
=kjWP
-----END PGP SIGNATURE-----

--+B+y8wtTXqdUj1xM--
