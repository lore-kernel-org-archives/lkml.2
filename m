Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2FKAlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:41:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42360 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748Ab2FKAkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:40:49 -0400
Message-ID: <1339375241.21665.218.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.20
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net
Date: Mon, 11 Jun 2012 01:40:41 +0100
In-Reply-To: <QyJ8ZD.A.dXF.R3T1PB@deadeye>
References: <QyJ8ZD.A.dXF.R3T1PB@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-otW017dzY7rMG2NrR3wW"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-otW017dzY7rMG2NrR3wW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index c291184..c7e9cc4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 19
+SUBLEVEL =3D 20
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ef642a0..987c72d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -520,7 +520,7 @@ config ARCH_IXP4XX
 	depends on MMU
 	select CLKSRC_MMIO
 	select CPU_XSCALE
-	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_CLOCKEVENTS
 	select HAVE_SCHED_CLOCK
 	select MIGHT_HAVE_PCI
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index b86a005..caf28fc 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -29,6 +29,7 @@
 #include <linux/clockchips.h>
 #include <linux/io.h>
 #include <linux/export.h>
+#include <linux/gpio.h>
=20
 #include <mach/udc.h>
 #include <mach/hardware.h>
@@ -106,7 +107,7 @@ static signed char irq2gpio[32] =3D {
 	 7,  8,  9, 10, 11, 12, -1, -1,
 };
=20
-int gpio_to_irq(int gpio)
+static int ixp4xx_gpio_to_irq(struct gpio_chip *chip, unsigned gpio)
 {
 	int irq;
=20
@@ -116,7 +117,6 @@ int gpio_to_irq(int gpio)
 	}
 	return -EINVAL;
 }
-EXPORT_SYMBOL(gpio_to_irq);
=20
 int irq_to_gpio(unsigned int irq)
 {
@@ -376,12 +376,56 @@ static struct platform_device *ixp46x_devices[] __ini=
tdata =3D {
 unsigned long ixp4xx_exp_bus_size;
 EXPORT_SYMBOL(ixp4xx_exp_bus_size);
=20
+static int ixp4xx_gpio_direction_input(struct gpio_chip *chip, unsigned gp=
io)
+{
+	gpio_line_config(gpio, IXP4XX_GPIO_IN);
+
+	return 0;
+}
+
+static int ixp4xx_gpio_direction_output(struct gpio_chip *chip, unsigned g=
pio,
+					int level)
+{
+	gpio_line_set(gpio, level);
+	gpio_line_config(gpio, IXP4XX_GPIO_OUT);
+
+	return 0;
+}
+
+static int ixp4xx_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
+{
+	int value;
+
+	gpio_line_get(gpio, &value);
+
+	return value;
+}
+
+static void ixp4xx_gpio_set_value(struct gpio_chip *chip, unsigned gpio,
+				  int value)
+{
+	gpio_line_set(gpio, value);
+}
+
+static struct gpio_chip ixp4xx_gpio_chip =3D {
+	.label			=3D "IXP4XX_GPIO_CHIP",
+	.direction_input	=3D ixp4xx_gpio_direction_input,
+	.direction_output	=3D ixp4xx_gpio_direction_output,
+	.get			=3D ixp4xx_gpio_get_value,
+	.set			=3D ixp4xx_gpio_set_value,
+	.to_irq			=3D ixp4xx_gpio_to_irq,
+	.base			=3D 0,
+	.ngpio			=3D 16,
+};
+
 void __init ixp4xx_sys_init(void)
 {
 	ixp4xx_exp_bus_size =3D SZ_16M;
=20
 	platform_add_devices(ixp4xx_devices, ARRAY_SIZE(ixp4xx_devices));
=20
+	gpiochip_add(&ixp4xx_gpio_chip);
+
 	if (cpu_is_ixp46x()) {
 		int region;
=20
diff --git a/arch/arm/mach-ixp4xx/include/mach/gpio.h b/arch/arm/mach-ixp4x=
x/include/mach/gpio.h
index 83d6b4e..ef37f26 100644
--- a/arch/arm/mach-ixp4xx/include/mach/gpio.h
+++ b/arch/arm/mach-ixp4xx/include/mach/gpio.h
@@ -1,79 +1,2 @@
-/*
- * arch/arm/mach-ixp4xx/include/mach/gpio.h
- *
- * IXP4XX GPIO wrappers for arch-neutral GPIO calls
- *
- * Written by Milan Svoboda <msvoboda@ra.rockwell.com>
- * Based on PXA implementation by Philipp Zabel <philipp.zabel@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- */
-
-#ifndef __ASM_ARCH_IXP4XX_GPIO_H
-#define __ASM_ARCH_IXP4XX_GPIO_H
-
-#include <linux/kernel.h>
-#include <mach/hardware.h>
-
-#define __ARM_GPIOLIB_COMPLEX
-
-static inline int gpio_request(unsigned gpio, const char *label)
-{
-	return 0;
-}
-
-static inline void gpio_free(unsigned gpio)
-{
-	might_sleep();
-
-	return;
-}
-
-static inline int gpio_direction_input(unsigned gpio)
-{
-	gpio_line_config(gpio, IXP4XX_GPIO_IN);
-	return 0;
-}
-
-static inline int gpio_direction_output(unsigned gpio, int level)
-{
-	gpio_line_set(gpio, level);
-	gpio_line_config(gpio, IXP4XX_GPIO_OUT);
-	return 0;
-}
-
-static inline int gpio_get_value(unsigned gpio)
-{
-	int value;
-
-	gpio_line_get(gpio, &value);
-
-	return value;
-}
-
-static inline void gpio_set_value(unsigned gpio, int value)
-{
-	gpio_line_set(gpio, value);
-}
-
-#include <asm-generic/gpio.h>			/* cansleep wrappers */
-
-extern int gpio_to_irq(int gpio);
-#define gpio_to_irq gpio_to_irq
-extern int irq_to_gpio(unsigned int irq);
-
-#endif
+/* empty */
=20
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index e446bab..a93ed04 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -46,7 +46,7 @@ config GENERIC_CLOCKEVENTS
 	def_bool y
=20
 config GENERIC_GPIO
-	def_bool y
+	bool
=20
 config GENERIC_CSUM
 	def_bool y
diff --git a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h b/arch/mips/=
include/asm/mach-bcm63xx/bcm63xx_gpio.h
index 3999ec0..67d1ce0 100644
--- a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h
+++ b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h
@@ -2,6 +2,7 @@
 #define BCM63XX_GPIO_H
=20
 #include <linux/init.h>
+#include <bcm63xx_cpu.h>
=20
 int __init bcm63xx_gpio_init(void);
=20
diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
index 5350342..07ef351 100644
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -552,7 +552,7 @@
 	 * entry (identifying the physical page) and %r23 up with
 	 * the from tlb entry (or nothing if only a to entry---for
 	 * clear_user_page_asm) */
-	.macro		do_alias	spc,tmp,tmp1,va,pte,prot,fault
+	.macro		do_alias	spc,tmp,tmp1,va,pte,prot,fault,patype
 	cmpib,COND(<>),n 0,\spc,\fault
 	ldil		L%(TMPALIAS_MAP_START),\tmp
 #if defined(CONFIG_64BIT) && (TMPALIAS_MAP_START >=3D 0x80000000)
@@ -581,11 +581,15 @@
 	 */
 	cmpiclr,=3D	0x01,\tmp,%r0
 	ldi		(_PAGE_DIRTY|_PAGE_READ|_PAGE_WRITE),\prot
-#ifdef CONFIG_64BIT
+.ifc \patype,20
 	depd,z		\prot,8,7,\prot
-#else
+.else
+.ifc \patype,11
 	depw,z		\prot,8,7,\prot
-#endif
+.else
+	.error "undefined PA type to do_alias"
+.endif
+.endif
 	/*
 	 * OK, it is in the temp alias region, check whether "from" or "to".
 	 * Check "subtle" note in pacache.S re: r23/r26.
@@ -1189,7 +1193,7 @@ dtlb_miss_20w:
 	nop
=20
 dtlb_check_alias_20w:
-	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault,20
=20
 	idtlbt          pte,prot
=20
@@ -1213,7 +1217,7 @@ nadtlb_miss_20w:
 	nop
=20
 nadtlb_check_alias_20w:
-	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate
+	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate,20
=20
 	idtlbt          pte,prot
=20
@@ -1245,7 +1249,7 @@ dtlb_miss_11:
 	nop
=20
 dtlb_check_alias_11:
-	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault,11
=20
 	idtlba          pte,(va)
 	idtlbp          prot,(va)
@@ -1277,7 +1281,7 @@ nadtlb_miss_11:
 	nop
=20
 nadtlb_check_alias_11:
-	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate
+	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate,11
=20
 	idtlba          pte,(va)
 	idtlbp          prot,(va)
@@ -1304,7 +1308,7 @@ dtlb_miss_20:
 	nop
=20
 dtlb_check_alias_20:
-	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,dtlb_fault,20
 =09
 	idtlbt          pte,prot
=20
@@ -1330,7 +1334,7 @@ nadtlb_miss_20:
 	nop
=20
 nadtlb_check_alias_20:
-	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate
+	do_alias	spc,t0,t1,va,pte,prot,nadtlb_emulate,20
=20
 	idtlbt          pte,prot
=20
@@ -1457,7 +1461,7 @@ naitlb_miss_20w:
 	nop
=20
 naitlb_check_alias_20w:
-	do_alias	spc,t0,t1,va,pte,prot,naitlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,naitlb_fault,20
=20
 	iitlbt		pte,prot
=20
@@ -1511,7 +1515,7 @@ naitlb_miss_11:
 	nop
=20
 naitlb_check_alias_11:
-	do_alias	spc,t0,t1,va,pte,prot,itlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,itlb_fault,11
=20
 	iitlba          pte,(%sr0, va)
 	iitlbp          prot,(%sr0, va)
@@ -1557,7 +1561,7 @@ naitlb_miss_20:
 	nop
=20
 naitlb_check_alias_20:
-	do_alias	spc,t0,t1,va,pte,prot,naitlb_fault
+	do_alias	spc,t0,t1,va,pte,prot,naitlb_fault,20
=20
 	iitlbt          pte,prot
=20
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.=
lds.S
index fa6f2b8..64a9998 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -50,8 +50,10 @@ SECTIONS
 	. =3D KERNEL_BINARY_TEXT_START;
=20
 	_text =3D .;		/* Text and read-only data */
-	.text ALIGN(16) : {
+	.head ALIGN(16) : {
 		HEAD_TEXT
+	} =3D 0
+	.text ALIGN(16) : {
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -65,7 +67,7 @@ SECTIONS
 		*(.fixup)
 		*(.lock.text)		/* out-of-line lock text */
 		*(.gnu.warning)
-	} =3D 0
+	}
 	/* End of text section */
 	_etext =3D .;
=20
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e7c920b..cca659e 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -982,7 +982,10 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst=
 =3D {
 	.wbinvd =3D native_wbinvd,
=20
 	.read_msr =3D native_read_msr_safe,
+	.rdmsr_regs =3D native_rdmsr_safe_regs,
 	.write_msr =3D xen_write_msr_safe,
+	.wrmsr_regs =3D native_wrmsr_safe_regs,
+
 	.read_tsc =3D native_read_tsc,
 	.read_pmc =3D native_read_pmc,
=20
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 7711d94..5535477 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -643,11 +643,19 @@ static int acpi_battery_update(struct acpi_battery *b=
attery)
=20
 static void acpi_battery_refresh(struct acpi_battery *battery)
 {
+	int power_unit;
+
 	if (!battery->bat.dev)
 		return;
=20
+	power_unit =3D battery->power_unit;
+
 	acpi_battery_get_info(battery);
-	/* The battery may have changed its reporting units. */
+
+	if (power_unit =3D=3D battery->power_unit)
+		return;
+
+	/* The battery has changed its reporting units. */
 	sysfs_remove_battery(battery);
 	sysfs_add_battery(battery);
 }
diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 5d1d076..d452592 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -984,6 +984,7 @@ static uint32_t fpga_tx(struct solos_card *card)
 			} else if (skb && card->using_dma) {
 				SKB_CB(skb)->dma_addr =3D pci_map_single(card->dev, skb->data,
 								       skb->len, PCI_DMA_TODEVICE);
+				card->tx_skb[port] =3D skb;
 				iowrite32(SKB_CB(skb)->dma_addr,
 					  card->config_regs + TX_DMA_ADDR(port));
 			}
@@ -1152,7 +1153,8 @@ static int fpga_probe(struct pci_dev *dev, const stru=
ct pci_device_id *id)
 		db_fpga_upgrade =3D db_firmware_upgrade =3D 0;
 	}
=20
-	if (card->fpga_version >=3D DMA_SUPPORTED){
+	if (card->fpga_version >=3D DMA_SUPPORTED) {
+		pci_set_master(dev);
 		card->using_dma =3D 1;
 	} else {
 		card->using_dma =3D 0;
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 99fefbd..f1bd44f 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -74,10 +74,15 @@ static struct usb_device_id ath3k_table[] =3D {
 	{ USB_DEVICE(0x0CF3, 0x311D) },
 	{ USB_DEVICE(0x13d3, 0x3375) },
 	{ USB_DEVICE(0x04CA, 0x3005) },
+	{ USB_DEVICE(0x13d3, 0x3362) },
+	{ USB_DEVICE(0x0CF3, 0xE004) },
=20
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
=20
+	/* Atheros AR5BBU22 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xE03C) },
+
 	{ }	/* Terminating entry */
 };
=20
@@ -93,6 +98,11 @@ static struct usb_device_id ath3k_blist_tbl[] =3D {
 	{ USB_DEVICE(0x0cf3, 0x311D), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3362), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info =3D BTUSB_ATH3012 },
+
+	/* Atheros AR5BBU22 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xE03C), .driver_info =3D BTUSB_ATH3012 },
=20
 	{ }	/* Terminating entry */
 };
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index e56da6a..fc4bcd6 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -61,7 +61,7 @@ static struct usb_device_id btusb_table[] =3D {
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
=20
 	/* Broadcom SoftSailing reporting vendor specific */
-	{ USB_DEVICE(0x05ac, 0x21e1) },
+	{ USB_DEVICE(0x0a5c, 0x21e1) },
=20
 	/* Apple MacBookPro 7,1 */
 	{ USB_DEVICE(0x05ac, 0x8213) },
@@ -101,9 +101,16 @@ static struct usb_device_id btusb_table[] =3D {
 	{ USB_DEVICE(0x0c10, 0x0000) },
=20
 	/* Broadcom BCM20702A0 */
+	{ USB_DEVICE(0x0489, 0xe042) },
 	{ USB_DEVICE(0x0a5c, 0x21e3) },
+	{ USB_DEVICE(0x0a5c, 0x21e6) },
+	{ USB_DEVICE(0x0a5c, 0x21e8) },
+	{ USB_DEVICE(0x0a5c, 0x21f3) },
 	{ USB_DEVICE(0x413c, 0x8197) },
=20
+	/* Foxconn - Hon Hai */
+	{ USB_DEVICE(0x0489, 0xe033) },
+
 	{ }	/* Terminating entry */
 };
=20
@@ -130,10 +137,15 @@ static struct usb_device_id blacklist_table[] =3D {
 	{ USB_DEVICE(0x0cf3, 0x311d), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3362), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info =3D BTUSB_ATH3012 },
=20
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info =3D BTUSB_IGNORE },
=20
+	/* Atheros AR5BBU12 with sflash firmware */
+	{ USB_DEVICE(0x0489, 0xe03c), .driver_info =3D BTUSB_ATH3012 },
+
 	/* Broadcom BCM2035 */
 	{ USB_DEVICE(0x0a5c, 0x2035), .driver_info =3D BTUSB_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x200a), .driver_info =3D BTUSB_WRONG_SCO_MTU },
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_re=
g.h
index a1d53b6..06ec1e5 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3533,7 +3533,11 @@
 #define   GEN6_CAGF_MASK			(0x7f << GEN6_CAGF_SHIFT)
 #define GEN6_RP_CONTROL				0xA024
 #define   GEN6_RP_MEDIA_TURBO			(1<<11)
-#define   GEN6_RP_USE_NORMAL_FREQ		(1<<9)
+#define   GEN6_RP_MEDIA_MODE_MASK		(3<<9)
+#define   GEN6_RP_MEDIA_HW_TURBO_MODE		(3<<9)
+#define   GEN6_RP_MEDIA_HW_NORMAL_MODE		(2<<9)
+#define   GEN6_RP_MEDIA_HW_MODE			(1<<9)
+#define   GEN6_RP_MEDIA_SW_MODE			(0<<9)
 #define   GEN6_RP_MEDIA_IS_GFX			(1<<8)
 #define   GEN6_RP_ENABLE			(1<<7)
 #define   GEN6_RP_UP_IDLE_MIN			(0x1<<3)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 3ff980d..4720397 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1864,7 +1864,7 @@ static void intel_update_fbc(struct drm_device *dev)
 	if (enable_fbc < 0) {
 		DRM_DEBUG_KMS("fbc set to per-chip default\n");
 		enable_fbc =3D 1;
-		if (INTEL_INFO(dev)->gen <=3D 5)
+		if (INTEL_INFO(dev)->gen <=3D 6)
 			enable_fbc =3D 0;
 	}
 	if (!enable_fbc) {
@@ -8005,7 +8005,7 @@ void gen6_enable_rps(struct drm_i915_private *dev_pri=
v)
 	I915_WRITE(GEN6_RP_IDLE_HYSTERSIS, 10);
 	I915_WRITE(GEN6_RP_CONTROL,
 		   GEN6_RP_MEDIA_TURBO |
-		   GEN6_RP_USE_NORMAL_FREQ |
+		   GEN6_RP_MEDIA_HW_NORMAL_MODE |
 		   GEN6_RP_MEDIA_IS_GFX |
 		   GEN6_RP_ENABLE |
 		   GEN6_RP_UP_BUSY_AVG |
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_d=
p.c
index 12eb789..d4c4937 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1149,10 +1149,10 @@ static void ironlake_edp_panel_off(struct intel_dp =
*intel_dp)
=20
 	DRM_DEBUG_KMS("Turn eDP power off\n");
=20
-	WARN(intel_dp->want_panel_vdd, "Cannot turn power off while VDD is on\n")=
;
+	WARN(!intel_dp->want_panel_vdd, "Need VDD to turn off panel\n");
=20
 	pp =3D ironlake_get_pp_control(dev_priv);
-	pp &=3D ~(POWER_TARGET_ON | EDP_FORCE_VDD | PANEL_POWER_RESET | EDP_BLC_E=
NABLE);
+	pp &=3D ~(POWER_TARGET_ON | PANEL_POWER_RESET | EDP_BLC_ENABLE);
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
=20
@@ -1260,18 +1260,16 @@ static void intel_dp_prepare(struct drm_encoder *en=
coder)
 {
 	struct intel_dp *intel_dp =3D enc_to_intel_dp(encoder);
=20
+
+	/* Make sure the panel is off before trying to change the mode. But also
+	 * ensure that we have vdd while we switch off the panel. */
+	ironlake_edp_panel_vdd_on(intel_dp);
 	ironlake_edp_backlight_off(intel_dp);
 	ironlake_edp_panel_off(intel_dp);
=20
-	/* Wake up the sink first */
-	ironlake_edp_panel_vdd_on(intel_dp);
 	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
 	intel_dp_link_down(intel_dp);
 	ironlake_edp_panel_vdd_off(intel_dp, false);
-
-	/* Make sure the panel is off before trying to
-	 * change the mode
-	 */
 }
=20
 static void intel_dp_commit(struct drm_encoder *encoder)
@@ -1303,10 +1301,11 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode=
)
 	uint32_t dp_reg =3D I915_READ(intel_dp->output_reg);
=20
 	if (mode !=3D DRM_MODE_DPMS_ON) {
+		/* Switching the panel off requires vdd. */
+		ironlake_edp_panel_vdd_on(intel_dp);
 		ironlake_edp_backlight_off(intel_dp);
 		ironlake_edp_panel_off(intel_dp);
=20
-		ironlake_edp_panel_vdd_on(intel_dp);
 		intel_dp_sink_dpms(intel_dp, mode);
 		intel_dp_link_down(intel_dp);
 		ironlake_edp_panel_vdd_off(intel_dp, false);
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel=
_lvds.c
index 583c2d0..ceec71b 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -716,6 +716,14 @@ static const struct dmi_system_id intel_no_lvds[] =3D =
{
 		},
 	},
 	{
+                .callback =3D intel_no_lvds_dmi_callback,
+                .ident =3D "Clientron E830",
+                .matches =3D {
+                        DMI_MATCH(DMI_SYS_VENDOR, "Clientron"),
+                        DMI_MATCH(DMI_PRODUCT_NAME, "E830"),
+                },
+        },
+        {
 		.callback =3D intel_no_lvds_dmi_callback,
 		.ident =3D "Asus EeeBox PC EB1007",
 		.matches =3D {
@@ -733,6 +741,30 @@ static const struct dmi_system_id intel_no_lvds[] =3D =
{
 	},
 	{
 		.callback =3D intel_no_lvds_dmi_callback,
+		.ident =3D "Hewlett-Packard HP t5740e Thin Client",
+		.matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP t5740e Thin Client"),
+		},
+	},
+	{
+		.callback =3D intel_no_lvds_dmi_callback,
+		.ident =3D "Hewlett-Packard t5745",
+		.matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_BOARD_NAME, "hp t5745"),
+		},
+	},
+	{
+		.callback =3D intel_no_lvds_dmi_callback,
+		.ident =3D "Hewlett-Packard st5747",
+		.matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_BOARD_NAME, "hp st5747"),
+		},
+	},
+	{
+		.callback =3D intel_no_lvds_dmi_callback,
 		.ident =3D "MSI Wind Box DC500",
 		.matches =3D {
 			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel=
_sdvo.c
index 8eddcca..a8d8ee5 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -769,10 +769,12 @@ static void intel_sdvo_get_dtd_from_mode(struct intel=
_sdvo_dtd *dtd,
 		((v_sync_len & 0x30) >> 4);
=20
 	dtd->part2.dtd_flags =3D 0x18;
+	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
+		dtd->part2.dtd_flags |=3D DTD_FLAG_INTERLACE;
 	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
-		dtd->part2.dtd_flags |=3D 0x2;
+		dtd->part2.dtd_flags |=3D DTD_FLAG_HSYNC_POSITIVE;
 	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
-		dtd->part2.dtd_flags |=3D 0x4;
+		dtd->part2.dtd_flags |=3D DTD_FLAG_VSYNC_POSITIVE;
=20
 	dtd->part2.sdvo_flags =3D 0;
 	dtd->part2.v_sync_off_high =3D v_sync_offset & 0xc0;
@@ -806,9 +808,11 @@ static void intel_sdvo_get_mode_from_dtd(struct drm_di=
splay_mode * mode,
 	mode->clock =3D dtd->part1.clock * 10;
=20
 	mode->flags &=3D ~(DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC);
-	if (dtd->part2.dtd_flags & 0x2)
+	if (dtd->part2.dtd_flags & DTD_FLAG_INTERLACE)
+		mode->flags |=3D DRM_MODE_FLAG_INTERLACE;
+	if (dtd->part2.dtd_flags & DTD_FLAG_HSYNC_POSITIVE)
 		mode->flags |=3D DRM_MODE_FLAG_PHSYNC;
-	if (dtd->part2.dtd_flags & 0x4)
+	if (dtd->part2.dtd_flags & DTD_FLAG_VSYNC_POSITIVE)
 		mode->flags |=3D DRM_MODE_FLAG_PVSYNC;
 }
=20
diff --git a/drivers/gpu/drm/i915/intel_sdvo_regs.h b/drivers/gpu/drm/i915/=
intel_sdvo_regs.h
index 4aa6f34..372f33b 100644
--- a/drivers/gpu/drm/i915/intel_sdvo_regs.h
+++ b/drivers/gpu/drm/i915/intel_sdvo_regs.h
@@ -61,6 +61,11 @@ struct intel_sdvo_caps {
 	u16 output_flags;
 } __attribute__((packed));
=20
+/* Note: SDVO detailed timing flags match EDID misc flags. */
+#define DTD_FLAG_HSYNC_POSITIVE (1 << 1)
+#define DTD_FLAG_VSYNC_POSITIVE (1 << 2)
+#define DTD_FLAG_INTERLACE	(1 << 7)
+
 /** This matches the EDID DTD structure, more or less */
 struct intel_sdvo_dtd {
 	struct {
diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_t=
v.c
index 2b1fcad..12041fa 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1307,6 +1307,11 @@ intel_tv_detect_type(struct intel_tv *intel_tv,
=20
 	I915_WRITE(TV_DAC, save_tv_dac & ~TVDAC_STATE_CHG_EN);
 	I915_WRITE(TV_CTL, save_tv_ctl);
+	POSTING_READ(TV_CTL);
+
+	/* For unknown reasons the hw barfs if we don't do this vblank wait. */
+	intel_wait_for_vblank(intel_tv->base.base.dev,
+			      to_intel_crtc(intel_tv->base.base.crtc)->pipe);
=20
 	/* Restore interrupt config */
 	if (connector->polled & DRM_CONNECTOR_POLL_HPD) {
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/ev=
ergreen.c
index 92c9628..dac178b 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -977,6 +977,11 @@ int evergreen_pcie_gart_enable(struct radeon_device *r=
dev)
 		WREG32(MC_VM_MD_L1_TLB0_CNTL, tmp);
 		WREG32(MC_VM_MD_L1_TLB1_CNTL, tmp);
 		WREG32(MC_VM_MD_L1_TLB2_CNTL, tmp);
+		if ((rdev->family =3D=3D CHIP_JUNIPER) ||
+		    (rdev->family =3D=3D CHIP_CYPRESS) ||
+		    (rdev->family =3D=3D CHIP_HEMLOCK) ||
+		    (rdev->family =3D=3D CHIP_BARTS))
+			WREG32(MC_VM_MD_L1_TLB3_CNTL, tmp);
 	}
 	WREG32(MC_VM_MB_L1_TLB0_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB1_CNTL, tmp);
@@ -2074,9 +2079,12 @@ static void evergreen_gpu_init(struct radeon_device =
*rdev)
 	/* num banks is 8 on all fusion asics. 0 =3D 4, 1 =3D 8, 2 =3D 16 */
 	if (rdev->flags & RADEON_IS_IGP)
 		rdev->config.evergreen.tile_config |=3D 1 << 4;
-	else
-		rdev->config.evergreen.tile_config |=3D
-			((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) << 4;
+	else {
+		if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
+			rdev->config.evergreen.tile_config |=3D 1 << 4;
+		else
+			rdev->config.evergreen.tile_config |=3D 0 << 4;
+	}
 	rdev->config.evergreen.tile_config |=3D
 		((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT) << 8;
 	rdev->config.evergreen.tile_config |=3D
@@ -2108,9 +2116,9 @@ static void evergreen_gpu_init(struct radeon_device *=
rdev)
 		WREG32(CC_SYS_RB_BACKEND_DISABLE, rb);
 		WREG32(GC_USER_RB_BACKEND_DISABLE, rb);
 		WREG32(CC_GC_SHADER_PIPE_CONFIG, sp);
-        }
+	}
=20
-	grbm_gfx_index |=3D SE_BROADCAST_WRITES;
+	grbm_gfx_index =3D INSTANCE_BROADCAST_WRITES | SE_BROADCAST_WRITES;
 	WREG32(GRBM_GFX_INDEX, grbm_gfx_index);
 	WREG32(RLC_GFX_INDEX, grbm_gfx_index);
=20
diff --git a/drivers/gpu/drm/radeon/evergreend.h b/drivers/gpu/drm/radeon/e=
vergreend.h
index e00039e..0128445 100644
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -230,6 +230,7 @@
 #define	MC_VM_MD_L1_TLB0_CNTL				0x2654
 #define	MC_VM_MD_L1_TLB1_CNTL				0x2658
 #define	MC_VM_MD_L1_TLB2_CNTL				0x265C
+#define	MC_VM_MD_L1_TLB3_CNTL				0x2698
=20
 #define	FUS_MC_VM_MD_L1_TLB0_CNTL			0x265C
 #define	FUS_MC_VM_MD_L1_TLB1_CNTL			0x2660
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 0e57998..9e50814 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -804,8 +804,10 @@ static void cayman_gpu_init(struct radeon_device *rdev=
)
 		rdev->config.cayman.tile_config |=3D (3 << 0);
 		break;
 	}
-	rdev->config.cayman.tile_config |=3D
-		((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) << 4;
+	if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
+		rdev->config.cayman.tile_config |=3D 1 << 4;
+	else
+		rdev->config.cayman.tile_config |=3D 0 << 4;
 	rdev->config.cayman.tile_config |=3D
 		((gb_addr_config & PIPE_INTERLEAVE_SIZE_MASK) >> PIPE_INTERLEAVE_SIZE_SH=
IFT) << 8;
 	rdev->config.cayman.tile_config |=3D
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/rad=
eon/radeon_atombios.c
index 8e1532f..9d2c369 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -438,7 +438,9 @@ static bool radeon_atom_apply_quirks(struct drm_device =
*dev,
 	 */
 	if ((dev->pdev->device =3D=3D 0x9498) &&
 	    (dev->pdev->subsystem_vendor =3D=3D 0x1682) &&
-	    (dev->pdev->subsystem_device =3D=3D 0x2452)) {
+	    (dev->pdev->subsystem_device =3D=3D 0x2452) &&
+	    (i2c_bus->valid =3D=3D false) &&
+	    !(supported_device & (ATOM_DEVICE_TV_SUPPORT | ATOM_DEVICE_CV_SUPPORT=
))) {
 		struct radeon_device *rdev =3D dev->dev_private;
 		*i2c_bus =3D radeon_lookup_i2c_gpio(rdev, 0x93);
 	}
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.=
c
index 23ae1c6..e36ba7f 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -151,6 +151,8 @@ int rv770_pcie_gart_enable(struct radeon_device *rdev)
 	WREG32(MC_VM_MD_L1_TLB0_CNTL, tmp);
 	WREG32(MC_VM_MD_L1_TLB1_CNTL, tmp);
 	WREG32(MC_VM_MD_L1_TLB2_CNTL, tmp);
+	if (rdev->family =3D=3D CHIP_RV740)
+		WREG32(MC_VM_MD_L1_TLB3_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB0_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB1_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB2_CNTL, tmp);
@@ -689,8 +691,12 @@ static void rv770_gpu_init(struct radeon_device *rdev)
=20
 	if (rdev->family =3D=3D CHIP_RV770)
 		gb_tiling_config |=3D BANK_TILING(1);
-	else
-		gb_tiling_config |=3D BANK_TILING((mc_arb_ramcfg & NOOFBANK_MASK) >> NOO=
FBANK_SHIFT);
+	else {
+		if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
+			gb_tiling_config |=3D BANK_TILING(1);
+		else
+			gb_tiling_config |=3D BANK_TILING(0);
+	}
 	rdev->config.rv770.tiling_nbanks =3D 4 << ((gb_tiling_config >> 4) & 0x3)=
;
 	gb_tiling_config |=3D GROUP_SIZE((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BU=
RSTLENGTH_SHIFT);
 	if ((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT)
diff --git a/drivers/gpu/drm/radeon/rv770d.h b/drivers/gpu/drm/radeon/rv770=
d.h
index 79fa588..7538092 100644
--- a/drivers/gpu/drm/radeon/rv770d.h
+++ b/drivers/gpu/drm/radeon/rv770d.h
@@ -174,6 +174,7 @@
 #define	MC_VM_MD_L1_TLB0_CNTL				0x2654
 #define	MC_VM_MD_L1_TLB1_CNTL				0x2658
 #define	MC_VM_MD_L1_TLB2_CNTL				0x265C
+#define	MC_VM_MD_L1_TLB3_CNTL				0x2698
 #define	MC_VM_SYSTEM_APERTURE_DEFAULT_ADDR		0x203C
 #define	MC_VM_SYSTEM_APERTURE_HIGH_ADDR			0x2038
 #define	MC_VM_SYSTEM_APERTURE_LOW_ADDR			0x2034
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 0bb0f5f..0d27bff 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1816,6 +1816,7 @@ static int ttm_bo_swapout(struct ttm_mem_shrink *shri=
nk)
 			spin_unlock(&glob->lru_lock);
 			(void) ttm_bo_cleanup_refs(bo, false, false, false);
 			kref_put(&bo->list_kref, ttm_bo_release_list);
+			spin_lock(&glob->lru_lock);
 			continue;
 		}
=20
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c b/drivers/gpu/drm/vmwgfx/v=
mwgfx_gmr.c
index f4e7763..c41226a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
@@ -66,7 +66,7 @@ static int vmw_gmr2_bind(struct vmw_private *dev_priv,
 	cmd +=3D sizeof(remap_cmd) / sizeof(uint32);
=20
 	for (i =3D 0; i < num_pages; ++i) {
-		if (VMW_PPN_SIZE > 4)
+		if (VMW_PPN_SIZE <=3D 4)
 			*cmd =3D page_to_pfn(*pages++);
 		else
 			*((uint64_t *)cmd) =3D page_to_pfn(*pages++);
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 966a6e7..f1d5408 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -381,12 +381,27 @@ static void dump_command(unsigned long phys_addr)
=20
 static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 {
-	u32 *event =3D __evt;
-	int type  =3D (event[1] >> EVENT_TYPE_SHIFT)  & EVENT_TYPE_MASK;
-	int devid =3D (event[0] >> EVENT_DEVID_SHIFT) & EVENT_DEVID_MASK;
-	int domid =3D (event[1] >> EVENT_DOMID_SHIFT) & EVENT_DOMID_MASK;
-	int flags =3D (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
-	u64 address =3D (u64)(((u64)event[3]) << 32) | event[2];
+	int type, devid, domid, flags;
+	volatile u32 *event =3D __evt;
+	int count =3D 0;
+	u64 address;
+
+retry:
+	type    =3D (event[1] >> EVENT_TYPE_SHIFT)  & EVENT_TYPE_MASK;
+	devid   =3D (event[0] >> EVENT_DEVID_SHIFT) & EVENT_DEVID_MASK;
+	domid   =3D (event[1] >> EVENT_DOMID_SHIFT) & EVENT_DOMID_MASK;
+	flags   =3D (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
+	address =3D (u64)(((u64)event[3]) << 32) | event[2];
+
+	if (type =3D=3D 0) {
+		/* Did we hit the erratum? */
+		if (++count =3D=3D LOOP_TIMEOUT) {
+			pr_err("AMD-Vi: No event written to event log\n");
+			return;
+		}
+		udelay(1);
+		goto retry;
+	}
=20
 	printk(KERN_ERR "AMD-Vi: Event logged [");
=20
@@ -439,6 +454,8 @@ static void iommu_print_event(struct amd_iommu *iommu, =
void *__evt)
 	default:
 		printk(KERN_ERR "UNKNOWN type=3D0x%02x]\n", type);
 	}
+
+	memset(__evt, 0, 4 * sizeof(u32));
 }
=20
 static void iommu_poll_events(struct amd_iommu *iommu)
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.=
c
index 20d5852..6269eb0 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -943,6 +943,9 @@ static int __init init_iommu_one(struct amd_iommu *iomm=
u, struct ivhd_header *h)
 	if (!iommu->dev)
 		return 1;
=20
+	iommu->root_pdev =3D pci_get_bus_and_slot(iommu->dev->bus->number,
+						PCI_DEVFN(0, 0));
+
 	iommu->cap_ptr =3D h->cap_ptr;
 	iommu->pci_seg =3D h->pci_seg;
 	iommu->mmio_phys =3D h->mmio_phys;
@@ -1225,20 +1228,16 @@ static void iommu_apply_resume_quirks(struct amd_io=
mmu *iommu)
 {
 	int i, j;
 	u32 ioc_feature_control;
-	struct pci_dev *pdev =3D NULL;
+	struct pci_dev *pdev =3D iommu->root_pdev;
=20
 	/* RD890 BIOSes may not have completely reconfigured the iommu */
-	if (!is_rd890_iommu(iommu->dev))
+	if (!is_rd890_iommu(iommu->dev) || !pdev)
 		return;
=20
 	/*
 	 * First, we need to ensure that the iommu is enabled. This is
 	 * controlled by a register in the northbridge
 	 */
-	pdev =3D pci_get_bus_and_slot(iommu->dev->bus->number, PCI_DEVFN(0, 0));
-
-	if (!pdev)
-		return;
=20
 	/* Select Northbridge indirect register 0x75 and enable writing */
 	pci_write_config_dword(pdev, 0x60, 0x75 | (1 << 7));
@@ -1248,8 +1247,6 @@ static void iommu_apply_resume_quirks(struct amd_iomm=
u *iommu)
 	if (!(ioc_feature_control & 0x1))
 		pci_write_config_dword(pdev, 0x64, ioc_feature_control | 1);
=20
-	pci_dev_put(pdev);
-
 	/* Restore the iommu BAR */
 	pci_write_config_dword(iommu->dev, iommu->cap_ptr + 4,
 			       iommu->stored_addr_lo);
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_type=
s.h
index 5b9c507..40ab83b 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -385,6 +385,9 @@ struct amd_iommu {
 	/* Pointer to PCI device of this IOMMU */
 	struct pci_dev *dev;
=20
+	/* Cache pdev to root device for resume quirks */
+	struct pci_dev *root_pdev;
+
 	/* physical address of MMIO space */
 	u64 mmio_phys;
 	/* virtual address of MMIO space */
diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 318a869..4035b6d 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -128,7 +128,7 @@ config MTD_AFS_PARTS
=20
 config MTD_OF_PARTS
 	tristate "OpenFirmware partitioning information support"
-	default Y
+	default y
 	depends on OF
 	help
 	  This provides a partition parsing function which derives
diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
index 69148ae..f024375 100644
--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -324,6 +324,7 @@ static int scan_read_raw_oob(struct mtd_info *mtd, uint=
8_t *buf, loff_t offs,
=20
 		buf +=3D mtd->oobsize + mtd->writesize;
 		len -=3D mtd->writesize;
+		offs +=3D mtd->writesize;
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/eth=
ernet/freescale/fec_mpc52xx.c
index 30745b5..1e52736 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -437,7 +437,7 @@ static irqreturn_t mpc52xx_fec_rx_interrupt(int irq, vo=
id *dev_id)
 		length =3D status & BCOM_FEC_RX_BD_LEN_MASK;
 		skb_put(rskb, length - 4);	/* length without CRC32 */
 		rskb->protocol =3D eth_type_trans(rskb, dev);
-		if (!skb_defer_rx_timestamp(skb))
+		if (!skb_defer_rx_timestamp(rskb))
 			netif_rx(rskb);
=20
 		spin_lock(&priv->lock);
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/re=
altek/r8169.c
index 697cae3..cc2565c 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -62,8 +62,12 @@
 #define R8169_MSG_DEFAULT \
 	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
=20
-#define TX_BUFFS_AVAIL(tp) \
-	(tp->dirty_tx + NUM_TX_DESC - tp->cur_tx - 1)
+#define TX_SLOTS_AVAIL(tp) \
+	(tp->dirty_tx + NUM_TX_DESC - tp->cur_tx)
+
+/* A skbuff with nr_frags needs nr_frags+1 entries in the tx queue */
+#define TX_FRAGS_READY_FOR(tp,nr_frags) \
+	(TX_SLOTS_AVAIL(tp) >=3D (nr_frags + 1))
=20
 /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
    The RTL chips use a 64 element hash table based on the Ethernet CRC. */
@@ -5512,7 +5516,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff =
*skb,
 	u32 opts[2];
 	int frags;
=20
-	if (unlikely(TX_BUFFS_AVAIL(tp) < skb_shinfo(skb)->nr_frags)) {
+	if (unlikely(!TX_FRAGS_READY_FOR(tp, skb_shinfo(skb)->nr_frags))) {
 		netif_err(tp, drv, dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
 	}
@@ -5560,10 +5564,21 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buf=
f *skb,
=20
 	RTL_W8(TxPoll, NPQ);
=20
-	if (TX_BUFFS_AVAIL(tp) < MAX_SKB_FRAGS) {
+	if (!TX_FRAGS_READY_FOR(tp, MAX_SKB_FRAGS)) {
+		/* Avoid wrongly optimistic queue wake-up: rtl_tx thread must
+		 * not miss a ring update when it notices a stopped queue.
+		 */
+		smp_wmb();
 		netif_stop_queue(dev);
-		smp_rmb();
-		if (TX_BUFFS_AVAIL(tp) >=3D MAX_SKB_FRAGS)
+		/* Sync with rtl_tx:
+		 * - publish queue status and cur_tx ring index (write barrier)
+		 * - refresh dirty_tx ring index (read barrier).
+		 * May the current thread have a pessimistic view of the ring
+		 * status and forget to wake up queue, a racing rtl_tx thread
+		 * can't.
+		 */
+		smp_mb();
+		if (TX_FRAGS_READY_FOR(tp, MAX_SKB_FRAGS))
 			netif_wake_queue(dev);
 	}
=20
@@ -5663,9 +5678,16 @@ static void rtl8169_tx_interrupt(struct net_device *=
dev,
=20
 	if (tp->dirty_tx !=3D dirty_tx) {
 		tp->dirty_tx =3D dirty_tx;
-		smp_wmb();
+		/* Sync with rtl8169_start_xmit:
+		 * - publish dirty_tx ring index (write barrier)
+		 * - refresh cur_tx ring index and queue status (read barrier)
+		 * May the current thread miss the stopped queue condition,
+		 * a racing xmit thread can only have a right view of the
+		 * ring status.
+		 */
+		smp_mb();
 		if (netif_queue_stopped(dev) &&
-		    (TX_BUFFS_AVAIL(tp) >=3D MAX_SKB_FRAGS)) {
+		    TX_FRAGS_READY_FOR(tp, MAX_SKB_FRAGS)) {
 			netif_wake_queue(dev);
 		}
 		/*
@@ -5674,7 +5696,6 @@ static void rtl8169_tx_interrupt(struct net_device *d=
ev,
 		 * of start_xmit activity is detected (if it is not detected,
 		 * it is slow enough). -- FR
 		 */
-		smp_rmb();
 		if (tp->cur_tx !=3D dirty_tx)
 			RTL_W8(TxPoll, NPQ);
 	}
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 959d448..97f342e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -258,7 +258,7 @@ static int macvlan_queue_xmit(struct sk_buff *skb, stru=
ct net_device *dev)
=20
 xmit_world:
 	skb->ip_summed =3D ip_summed;
-	skb_set_dev(skb, vlan->lowerdev);
+	skb->dev =3D vlan->lowerdev;
 	return dev_queue_xmit(skb);
 }
=20
diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index a9abee8..fc147a5 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -35,6 +35,7 @@
 #include <linux/crc32.h>
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
+#include <linux/if_vlan.h>
=20
 #define DRIVER_VERSION "08-Nov-2011"
 #define DRIVER_NAME "asix"
@@ -348,7 +349,7 @@ static int asix_rx_fixup(struct usbnet *dev, struct sk_=
buff *skb)
 			return 2;
 		}
=20
-		if (size > dev->net->mtu + ETH_HLEN) {
+		if (size > dev->net->mtu + ETH_HLEN + VLAN_HLEN) {
 			netdev_err(dev->net, "asix_rx_fixup() Bad RX Length %d\n",
 				   size);
 			return 0;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/a=
th/ath9k/xmit.c
index 03b0a65..76fd277 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -64,7 +64,8 @@ static void ath_tx_update_baw(struct ath_softc *sc, struc=
t ath_atx_tid *tid,
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb);
+					   struct sk_buff *skb,
+					   bool dequeue);
=20
 enum {
 	MCS_HT20,
@@ -761,7 +762,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath=
_softc *sc,
 		fi =3D get_frame_info(skb);
 		bf =3D fi->bf;
 		if (!fi->bf)
-			bf =3D ath_tx_setup_buffer(sc, txq, tid, skb);
+			bf =3D ath_tx_setup_buffer(sc, txq, tid, skb, true);
=20
 		if (!bf)
 			continue;
@@ -1669,7 +1670,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, s=
truct ath_atx_tid *tid,
 		return;
 	}
=20
-	bf =3D ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	bf =3D ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
 	if (!bf)
 		return;
=20
@@ -1696,7 +1697,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, =
struct ath_txq *txq,
=20
 	bf =3D fi->bf;
 	if (!bf)
-		bf =3D ath_tx_setup_buffer(sc, txq, tid, skb);
+		bf =3D ath_tx_setup_buffer(sc, txq, tid, skb, false);
=20
 	if (!bf)
 		return;
@@ -1761,7 +1762,8 @@ u8 ath_txchainmask_reduction(struct ath_softc *sc, u8=
 chainmask, u32 rate)
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb)
+					   struct sk_buff *skb,
+					   bool dequeue)
 {
 	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
 	struct ath_frame_info *fi =3D get_frame_info(skb);
@@ -1802,6 +1804,8 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath=
_softc *sc,
 	return bf;
=20
 error:
+	if (dequeue)
+		__skb_unlink(skb, &tid->buf_q);
 	dev_kfree_skb_any(skb);
 	return NULL;
 }
@@ -1833,7 +1837,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, st=
ruct sk_buff *skb,
 		 */
 		ath_tx_send_ampdu(sc, tid, skb, txctl);
 	} else {
-		bf =3D ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+		bf =3D ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
 		if (!bf)
 			goto out;
=20
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless=
/iwlwifi/iwl-2000.c
index 9823e41..a97a52a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -211,7 +211,7 @@ static struct iwl_base_params iwl2000_base_params =3D {
 	.chain_noise_scale =3D 1000,
 	.wd_timeout =3D IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size =3D 512,
-	.shadow_reg_enable =3D true,
+	.shadow_reg_enable =3D false, /* TODO: fix bugs using this feature */
 	.hd_v2 =3D true,
 };
=20
@@ -230,7 +230,7 @@ static struct iwl_base_params iwl2030_base_params =3D {
 	.chain_noise_scale =3D 1000,
 	.wd_timeout =3D IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size =3D 512,
-	.shadow_reg_enable =3D true,
+	.shadow_reg_enable =3D false, /* TODO: fix bugs using this feature */
 	.hd_v2 =3D true,
 };
=20
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless=
/iwlwifi/iwl-6000.c
index b4f809c..0b9f797 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -308,7 +308,7 @@ static struct iwl_base_params iwl6000_base_params =3D {
 	.chain_noise_scale =3D 1000,
 	.wd_timeout =3D IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size =3D 512,
-	.shadow_reg_enable =3D true,
+	.shadow_reg_enable =3D false, /* TODO: fix bugs using this feature */
 };
=20
 static struct iwl_base_params iwl6050_base_params =3D {
@@ -325,7 +325,7 @@ static struct iwl_base_params iwl6050_base_params =3D {
 	.chain_noise_scale =3D 1500,
 	.wd_timeout =3D IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size =3D 1024,
-	.shadow_reg_enable =3D true,
+	.shadow_reg_enable =3D false, /* TODO: fix bugs using this feature */
 };
 static struct iwl_base_params iwl6000_g2_base_params =3D {
 	.eeprom_size =3D OTP_LOW_IMAGE_SIZE,
@@ -341,7 +341,7 @@ static struct iwl_base_params iwl6000_g2_base_params =
=3D {
 	.chain_noise_scale =3D 1000,
 	.wd_timeout =3D IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size =3D 512,
-	.shadow_reg_enable =3D true,
+	.shadow_reg_enable =3D false, /* TODO: fix bugs using this feature */
 };
=20
 static struct iwl_ht_params iwl6000_ht_params =3D {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wirele=
ss/iwlwifi/iwl-agn-rs.c
index 66118ce..9ba2c1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -886,6 +886,7 @@ static void rs_bt_update_lq(struct iwl_priv *priv, stru=
ct iwl_rxon_context *ctx,
 	if ((priv->bt_traffic_load !=3D priv->last_bt_traffic_load) ||
 	    (priv->bt_full_concurrent !=3D full_concurrent)) {
 		priv->bt_full_concurrent =3D full_concurrent;
+		priv->last_bt_traffic_load =3D priv->bt_traffic_load;
=20
 		/* Update uCode's rate table. */
 		tbl =3D &(lq_sta->lq_info[lq_sta->active_tbl]);
diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl12=
51/sdio.c
index 1b851f6..e2750a1 100644
--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -260,6 +260,7 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	}
=20
 	if (wl->irq) {
+		irq_set_status_flags(wl->irq, IRQ_NOAUTOEN);
 		ret =3D request_irq(wl->irq, wl1251_line_irq, 0, "wl1251", wl);
 		if (ret < 0) {
 			wl1251_error("request_irq() failed: %d", ret);
@@ -267,7 +268,6 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 		}
=20
 		irq_set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
-		disable_irq(wl->irq);
=20
 		wl1251_sdio_ops.enable_irq =3D wl1251_enable_line_irq;
 		wl1251_sdio_ops.disable_irq =3D wl1251_disable_line_irq;
diff --git a/drivers/net/wireless/wl1251/spi.c b/drivers/net/wireless/wl125=
1/spi.c
index eaa5f95..134ae9c 100644
--- a/drivers/net/wireless/wl1251/spi.c
+++ b/drivers/net/wireless/wl1251/spi.c
@@ -281,6 +281,7 @@ static int __devinit wl1251_spi_probe(struct spi_device=
 *spi)
=20
 	wl->use_eeprom =3D pdata->use_eeprom;
=20
+	irq_set_status_flags(wl->irq, IRQ_NOAUTOEN);
 	ret =3D request_irq(wl->irq, wl1251_irq, 0, DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1251_error("request_irq() failed: %d", ret);
@@ -289,8 +290,6 @@ static int __devinit wl1251_spi_probe(struct spi_device=
 *spi)
=20
 	irq_set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
=20
-	disable_irq(wl->irq);
-
 	ret =3D wl1251_init_ieee80211(wl);
 	if (ret)
 		goto out_irq;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f85cfa6..f0ab58e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1382,16 +1382,19 @@ static int scsi_lld_busy(struct request_queue *q)
 {
 	struct scsi_device *sdev =3D q->queuedata;
 	struct Scsi_Host *shost;
-	struct scsi_target *starget;
=20
 	if (!sdev)
 		return 0;
=20
 	shost =3D sdev->host;
-	starget =3D scsi_target(sdev);
=20
-	if (scsi_host_in_recovery(shost) || scsi_host_is_busy(shost) ||
-	    scsi_target_is_busy(starget) || scsi_device_is_busy(sdev))
+	/*
+	 * Ignore host/starget busy state.
+	 * Since block layer does not have a concept of fairness across
+	 * multiple queues, congestion of host/starget needs to be handled
+	 * in SCSI layer.
+	 */
+	if (scsi_host_in_recovery(shost) || scsi_device_is_busy(sdev))
 		return 1;
=20
 	return 0;
diff --git a/drivers/scsi/scsi_wait_scan.c b/drivers/scsi/scsi_wait_scan.c
index 74708fc..ae78148 100644
--- a/drivers/scsi/scsi_wait_scan.c
+++ b/drivers/scsi/scsi_wait_scan.c
@@ -12,7 +12,7 @@
=20
 #include <linux/module.h>
 #include <linux/device.h>
-#include <scsi/scsi_scan.h>
+#include "scsi_priv.h"
=20
 static int __init wait_scan_init(void)
 {
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core=
_file.c
index cad8b92..455a251 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -134,21 +134,11 @@ static struct se_device *fd_create_virtdevice(
 		ret =3D PTR_ERR(dev_p);
 		goto fail;
 	}
-#if 0
-	if (di->no_create_file)
-		flags =3D O_RDWR | O_LARGEFILE;
-	else
-		flags =3D O_RDWR | O_CREAT | O_LARGEFILE;
-#else
-	flags =3D O_RDWR | O_CREAT | O_LARGEFILE;
-#endif
-/*	flags |=3D O_DIRECT; */
 	/*
-	 * If fd_buffered_io=3D1 has not been set explicitly (the default),
-	 * use O_SYNC to force FILEIO writes to disk.
+	 * Use O_DSYNC by default instead of O_SYNC to forgo syncing
+	 * of pure timestamp updates.
 	 */
-	if (!(fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO))
-		flags |=3D O_SYNC;
+	flags =3D O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
=20
 	file =3D filp_open(dev_p, flags, 0600);
 	if (IS_ERR(file)) {
@@ -400,26 +390,6 @@ static void fd_emulate_sync_cache(struct se_task *task=
)
 		transport_complete_sync_cache(cmd, ret =3D=3D 0);
 }
=20
-/*
- * WRITE Force Unit Access (FUA) emulation on a per struct se_task
- * LBA range basis..
- */
-static void fd_emulate_write_fua(struct se_cmd *cmd, struct se_task *task)
-{
-	struct se_device *dev =3D cmd->se_dev;
-	struct fd_dev *fd_dev =3D dev->dev_ptr;
-	loff_t start =3D task->task_lba * dev->se_sub_dev->se_dev_attrib.block_si=
ze;
-	loff_t end =3D start + task->task_size;
-	int ret;
-
-	pr_debug("FILEIO: FUA WRITE LBA: %llu, bytes: %u\n",
-			task->task_lba, task->task_size);
-
-	ret =3D vfs_fsync_range(fd_dev->fd_file, start, end, 1);
-	if (ret !=3D 0)
-		pr_err("FILEIO: vfs_fsync_range() failed: %d\n", ret);
-}
-
 static int fd_do_task(struct se_task *task)
 {
 	struct se_cmd *cmd =3D task->task_se_cmd;
@@ -434,19 +404,21 @@ static int fd_do_task(struct se_task *task)
 		ret =3D fd_do_readv(task);
 	} else {
 		ret =3D fd_do_writev(task);
-
+		/*
+		 * Perform implict vfs_fsync_range() for fd_do_writev() ops
+		 * for SCSI WRITEs with Forced Unit Access (FUA) set.
+		 * Allow this to happen independent of WCE=3D0 setting.
+		 */
 		if (ret > 0 &&
-		    dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0 &&
 		    dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0 &&
 		    (cmd->se_cmd_flags & SCF_FUA)) {
-			/*
-			 * We might need to be a bit smarter here
-			 * and return some sense data to let the initiator
-			 * know the FUA WRITE cache sync failed..?
-			 */
-			fd_emulate_write_fua(cmd, task);
-		}
+			struct fd_dev *fd_dev =3D dev->dev_ptr;
+			loff_t start =3D task->task_lba *
+				dev->se_sub_dev->se_dev_attrib.block_size;
+			loff_t end =3D start + task->task_size;
=20
+			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
+		}
 	}
=20
 	if (ret < 0) {
@@ -478,7 +450,6 @@ enum {
 static match_table_t tokens =3D {
 	{Opt_fd_dev_name, "fd_dev_name=3D%s"},
 	{Opt_fd_dev_size, "fd_dev_size=3D%s"},
-	{Opt_fd_buffered_io, "fd_buffered_io=3D%d"},
 	{Opt_err, NULL}
 };
=20
@@ -490,7 +461,7 @@ static ssize_t fd_set_configfs_dev_params(
 	struct fd_dev *fd_dev =3D se_dev->se_dev_su_ptr;
 	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	int ret =3D 0, arg, token;
+	int ret =3D 0, token;
=20
 	opts =3D kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -534,19 +505,6 @@ static ssize_t fd_set_configfs_dev_params(
 					" bytes\n", fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |=3D FBDF_HAS_SIZE;
 			break;
-		case Opt_fd_buffered_io:
-			match_int(args, &arg);
-			if (arg !=3D 1) {
-				pr_err("bogus fd_buffered_io=3D%d value\n", arg);
-				ret =3D -EINVAL;
-				goto out;
-			}
-
-			pr_debug("FILEIO: Using buffered I/O"
-				" operations for struct fd_dev\n");
-
-			fd_dev->fbd_flags |=3D FDBD_USE_BUFFERED_IO;
-			break;
 		default:
 			break;
 		}
@@ -578,10 +536,8 @@ static ssize_t fd_show_configfs_dev_params(
 	ssize_t bl =3D 0;
=20
 	bl =3D sprintf(b + bl, "TCM FILEIO ID: %u", fd_dev->fd_dev_id);
-	bl +=3D sprintf(b + bl, "        File: %s  Size: %llu  Mode: %s\n",
-		fd_dev->fd_dev_name, fd_dev->fd_dev_size,
-		(fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO) ?
-		"Buffered" : "Synchronous");
+	bl +=3D sprintf(b + bl, "        File: %s  Size: %llu  Mode: O_DSYNC\n",
+		fd_dev->fd_dev_name, fd_dev->fd_dev_size);
 	return bl;
 }
=20
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core=
_file.h
index 59e6e73..53ece69 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -18,7 +18,6 @@ struct fd_request {
=20
 #define FBDF_HAS_PATH		0x01
 #define FBDF_HAS_SIZE		0x02
-#define FDBD_USE_BUFFERED_IO	0x04
=20
 struct fd_dev {
 	u32		fbd_flags;
diff --git a/fs/attr.c b/fs/attr.c
index 7ee7ba4..b8f55c4 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -176,6 +176,11 @@ int notify_change(struct dentry * dentry, struct iattr=
 * attr)
 			return -EPERM;
 	}
=20
+	if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
+		if (attr->ia_size !=3D inode->i_size)
+			inode_inc_iversion(inode);
+	}
+
 	if ((ia_valid & ATTR_MODE)) {
 		mode_t amode =3D attr->ia_mode;
 		/* Flag setting protected by i_mutex */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c467ac8..2f3ff59 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -43,6 +43,7 @@
=20
 #define CIFS_MIN_RCV_POOL 4
=20
+#define MAX_REOPEN_ATT	5 /* these many maximum attempts to reopen a file *=
/
 /*
  * default attribute cache timeout (jiffies)
  */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6f4e243..26917d3 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -184,11 +184,13 @@ extern int CIFSTCon(unsigned int xid, struct cifs_ses=
 *ses,
=20
 extern int CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
 		const char *searchName, const struct nls_table *nls_codepage,
-		__u16 *searchHandle, struct cifs_search_info *psrch_inf,
+		__u16 *searchHandle, __u16 search_flags,
+		struct cifs_search_info *psrch_inf,
 		int map, const char dirsep);
=20
 extern int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
-		__u16 searchHandle, struct cifs_search_info *psrch_inf);
+		__u16 searchHandle, __u16 search_flags,
+		struct cifs_search_info *psrch_inf);
=20
 extern int CIFSFindClose(const int, struct cifs_tcon *tcon,
 			const __u16 search_handle);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e89803b..6aa7457 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4327,7 +4327,7 @@ int
 CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
 	      const char *searchName,
 	      const struct nls_table *nls_codepage,
-	      __u16 *pnetfid,
+	      __u16 *pnetfid, __u16 search_flags,
 	      struct cifs_search_info *psrch_inf, int remap, const char dirsep)
 {
 /* level 257 SMB_ */
@@ -4399,8 +4399,7 @@ findFirstRetry:
 	    cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM |
 			ATTR_DIRECTORY);
 	pSMB->SearchCount =3D cpu_to_le16(CIFSMaxBufSize/sizeof(FILE_UNIX_INFO));
-	pSMB->SearchFlags =3D cpu_to_le16(CIFS_SEARCH_CLOSE_AT_END |
-		CIFS_SEARCH_RETURN_RESUME);
+	pSMB->SearchFlags =3D cpu_to_le16(search_flags);
 	pSMB->InformationLevel =3D cpu_to_le16(psrch_inf->info_level);
=20
 	/* BB what should we set StorageType to? Does it matter? BB */
@@ -4470,8 +4469,8 @@ findFirstRetry:
 	return rc;
 }
=20
-int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
-		 __u16 searchHandle, struct cifs_search_info *psrch_inf)
+int CIFSFindNext(const int xid, struct cifs_tcon *tcon, __u16 searchHandle=
,
+		 __u16 search_flags, struct cifs_search_info *psrch_inf)
 {
 	TRANSACTION2_FNEXT_REQ *pSMB =3D NULL;
 	TRANSACTION2_FNEXT_RSP *pSMBr =3D NULL;
@@ -4514,8 +4513,7 @@ int CIFSFindNext(const int xid, struct cifs_tcon *tco=
n,
 		cpu_to_le16(CIFSMaxBufSize / sizeof(FILE_UNIX_INFO));
 	pSMB->InformationLevel =3D cpu_to_le16(psrch_inf->info_level);
 	pSMB->ResumeKey =3D psrch_inf->resume_key;
-	pSMB->SearchFlags =3D
-	      cpu_to_le16(CIFS_SEARCH_CLOSE_AT_END | CIFS_SEARCH_RETURN_RESUME);
+	pSMB->SearchFlags =3D cpu_to_le16(search_flags);
=20
 	name_len =3D psrch_inf->resume_name_len;
 	params +=3D name_len;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0f7dc22..0bb785f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1534,10 +1534,11 @@ struct cifsFileInfo *find_readable_file(struct cifs=
InodeInfo *cifs_inode,
 struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 					bool fsuid_only)
 {
-	struct cifsFileInfo *open_file;
+	struct cifsFileInfo *open_file, *inv_file =3D NULL;
 	struct cifs_sb_info *cifs_sb;
 	bool any_available =3D false;
 	int rc;
+	unsigned int refind =3D 0;
=20
 	/* Having a null inode here (because mapping->host was set to zero by
 	the VFS or MM) should not happen but we had reports of on oops (due to
@@ -1557,40 +1558,25 @@ struct cifsFileInfo *find_writable_file(struct cifs=
InodeInfo *cifs_inode,
=20
 	spin_lock(&cifs_file_list_lock);
 refind_writable:
+	if (refind > MAX_REOPEN_ATT) {
+		spin_unlock(&cifs_file_list_lock);
+		return NULL;
+	}
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
 		if (!any_available && open_file->pid !=3D current->tgid)
 			continue;
 		if (fsuid_only && open_file->uid !=3D current_fsuid())
 			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
-			cifsFileInfo_get(open_file);
-
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
+				cifsFileInfo_get(open_file);
 				spin_unlock(&cifs_file_list_lock);
 				return open_file;
+			} else {
+				if (!inv_file)
+					inv_file =3D open_file;
 			}
-
-			spin_unlock(&cifs_file_list_lock);
-
-			/* Had to unlock since following call can block */
-			rc =3D cifs_reopen_file(open_file, false);
-			if (!rc)
-				return open_file;
-
-			/* if it fails, try another handle if possible */
-			cFYI(1, "wp failed on reopen file");
-			cifsFileInfo_put(open_file);
-
-			spin_lock(&cifs_file_list_lock);
-
-			/* else we simply continue to the next entry. Thus
-			   we do not loop on reopen errors.  If we
-			   can not reopen the file, for example if we
-			   reconnected to a server with another client
-			   racing to delete or lock the file we would not
-			   make progress if we restarted before the beginning
-			   of the loop here. */
 		}
 	}
 	/* couldn't find useable FH with same pid, try any available */
@@ -1598,7 +1584,30 @@ refind_writable:
 		any_available =3D true;
 		goto refind_writable;
 	}
+
+	if (inv_file) {
+		any_available =3D false;
+		cifsFileInfo_get(inv_file);
+	}
+
 	spin_unlock(&cifs_file_list_lock);
+
+	if (inv_file) {
+		rc =3D cifs_reopen_file(inv_file, false);
+		if (!rc)
+			return inv_file;
+		else {
+			spin_lock(&cifs_file_list_lock);
+			list_move_tail(&inv_file->flist,
+					&cifs_inode->openFileList);
+			spin_unlock(&cifs_file_list_lock);
+			cifsFileInfo_put(inv_file);
+			spin_lock(&cifs_file_list_lock);
+			++refind;
+			goto refind_writable;
+		}
+	}
+
 	return NULL;
 }
=20
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index a090bbe..db4a138 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -219,6 +219,7 @@ int get_symlink_reparse_path(char *full_path, struct ci=
fs_sb_info *cifs_sb,
=20
 static int initiate_cifs_search(const int xid, struct file *file)
 {
+	__u16 search_flags;
 	int rc =3D 0;
 	char *full_path =3D NULL;
 	struct cifsFileInfo *cifsFile;
@@ -270,8 +271,12 @@ ffirst_retry:
 		cifsFile->srch_inf.info_level =3D SMB_FIND_FILE_DIRECTORY_INFO;
 	}
=20
+	search_flags =3D CIFS_SEARCH_CLOSE_AT_END | CIFS_SEARCH_RETURN_RESUME;
+	if (backup_cred(cifs_sb))
+		search_flags |=3D CIFS_SEARCH_BACKUP_SEARCH;
+
 	rc =3D CIFSFindFirst(xid, pTcon, full_path, cifs_sb->local_nls,
-		&cifsFile->netfid, &cifsFile->srch_inf,
+		&cifsFile->netfid, search_flags, &cifsFile->srch_inf,
 		cifs_sb->mnt_cifs_flags &
 			CIFS_MOUNT_MAP_SPECIAL_CHR, CIFS_DIR_SEP(cifs_sb));
 	if (rc =3D=3D 0)
@@ -502,11 +507,13 @@ static int cifs_save_resume_key(const char *current_e=
ntry,
 static int find_cifs_entry(const int xid, struct cifs_tcon *pTcon,
 	struct file *file, char **ppCurrentEntry, int *num_to_ret)
 {
+	__u16 search_flags;
 	int rc =3D 0;
 	int pos_in_buf =3D 0;
 	loff_t first_entry_in_buffer;
 	loff_t index_to_find =3D file->f_pos;
 	struct cifsFileInfo *cifsFile =3D file->private_data;
+	struct cifs_sb_info *cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
 	/* check if index in the buffer */
=20
 	if ((cifsFile =3D=3D NULL) || (ppCurrentEntry =3D=3D NULL) ||
@@ -560,10 +567,14 @@ static int find_cifs_entry(const int xid, struct cifs=
_tcon *pTcon,
 						cifsFile);
 	}
=20
+	search_flags =3D CIFS_SEARCH_CLOSE_AT_END | CIFS_SEARCH_RETURN_RESUME;
+	if (backup_cred(cifs_sb))
+		search_flags |=3D CIFS_SEARCH_BACKUP_SEARCH;
+
 	while ((index_to_find >=3D cifsFile->srch_inf.index_of_last_entry) &&
 	      (rc =3D=3D 0) && !cifsFile->srch_inf.endOfSearch) {
 		cFYI(1, "calling findnext2");
-		rc =3D CIFSFindNext(xid, pTcon, cifsFile->netfid,
+		rc =3D CIFSFindNext(xid, pTcon, cifsFile->netfid, search_flags,
 				  &cifsFile->srch_inf);
 		/* FindFirst/Next set last_entry to NULL on malformed reply */
 		if (cifsFile->srch_inf.last_entry)
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index e6085ec..7ed5000 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -745,7 +745,6 @@ static int exofs_fill_super(struct super_block *sb, voi=
d *data, int silent)
 	sbi->one_comp.obj.partition =3D opts->pid;
 	sbi->one_comp.obj.id =3D 0;
 	exofs_make_credential(sbi->one_comp.cred, &sbi->one_comp.obj);
-	sbi->oc.numdevs =3D 1;
 	sbi->oc.single_comp =3D EC_SINGLE_COMP;
 	sbi->oc.comps =3D &sbi->one_comp;
=20
@@ -803,6 +802,7 @@ static int exofs_fill_super(struct super_block *sb, voi=
d *data, int silent)
 			goto free_sbi;
=20
 		ore_comp_set_dev(&sbi->oc, 0, od);
+		sbi->oc.numdevs =3D 1;
 	}
=20
 	__sbi_read_stats(sbi);
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 12ccacd..914bf9e 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -88,8 +88,8 @@ unsigned ext4_num_overhead_clusters(struct super_block *s=
b,
 	 * unusual file system layouts.
 	 */
 	if (ext4_block_in_group(sb, ext4_block_bitmap(sb, gdp), block_group)) {
-		block_cluster =3D EXT4_B2C(sbi, (start -
-					       ext4_block_bitmap(sb, gdp)));
+		block_cluster =3D EXT4_B2C(sbi,
+					 ext4_block_bitmap(sb, gdp) - start);
 		if (block_cluster < num_clusters)
 			block_cluster =3D -1;
 		else if (block_cluster =3D=3D num_clusters) {
@@ -100,7 +100,7 @@ unsigned ext4_num_overhead_clusters(struct super_block =
*sb,
=20
 	if (ext4_block_in_group(sb, ext4_inode_bitmap(sb, gdp), block_group)) {
 		inode_cluster =3D EXT4_B2C(sbi,
-					 start - ext4_inode_bitmap(sb, gdp));
+					 ext4_inode_bitmap(sb, gdp) - start);
 		if (inode_cluster < num_clusters)
 			inode_cluster =3D -1;
 		else if (inode_cluster =3D=3D num_clusters) {
@@ -112,7 +112,7 @@ unsigned ext4_num_overhead_clusters(struct super_block =
*sb,
 	itbl_blk =3D ext4_inode_table(sb, gdp);
 	for (i =3D 0; i < sbi->s_itb_per_group; i++) {
 		if (ext4_block_in_group(sb, itbl_blk + i, block_group)) {
-			c =3D EXT4_B2C(sbi, start - itbl_blk + i);
+			c =3D EXT4_B2C(sbi, itbl_blk + i - start);
 			if ((c < num_clusters) || (c =3D=3D inode_cluster) ||
 			    (c =3D=3D block_cluster) || (c =3D=3D itbl_cluster))
 				continue;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index ab25f57..76a6e3b 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -36,7 +36,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsi=
gned long arg)
 		handle_t *handle =3D NULL;
 		int err, migrate =3D 0;
 		struct ext4_iloc iloc;
-		unsigned int oldflags;
+		unsigned int oldflags, mask, i;
 		unsigned int jflag;
=20
 		if (!inode_owner_or_capable(inode))
@@ -113,9 +113,14 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, u=
nsigned long arg)
 		if (err)
 			goto flags_err;
=20
-		flags =3D flags & EXT4_FL_USER_MODIFIABLE;
-		flags |=3D oldflags & ~EXT4_FL_USER_MODIFIABLE;
-		ei->i_flags =3D flags;
+		for (i =3D 0, mask =3D 1; i < 32; i++, mask <<=3D 1) {
+			if (!(mask & EXT4_FL_USER_MODIFIABLE))
+				continue;
+			if (mask & flags)
+				ext4_set_inode_flag(inode, i);
+			else
+				ext4_clear_inode_flag(inode, i);
+		}
=20
 		ext4_set_inode_flags(inode);
 		inode->i_ctime =3D ext4_current_time(inode);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2d8be8..1d07c12 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2567,6 +2567,9 @@ int ext4_mb_release(struct super_block *sb)
 	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
 	struct kmem_cache *cachep =3D get_groupinfo_cache(sb->s_blocksize_bits);
=20
+	if (sbi->s_proc)
+		remove_proc_entry("mb_groups", sbi->s_proc);
+
 	if (sbi->s_group_info) {
 		for (i =3D 0; i < ngroups; i++) {
 			grinfo =3D ext4_get_group_info(sb, i);
@@ -2614,8 +2617,6 @@ int ext4_mb_release(struct super_block *sb)
 	}
=20
 	free_percpu(sbi->s_locality_groups);
-	if (sbi->s_proc)
-		remove_proc_entry("mb_groups", sbi->s_proc);
=20
 	return 0;
 }
@@ -4693,6 +4694,7 @@ do_more:
 		 */
 		new_entry =3D kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
 		if (!new_entry) {
+			ext4_mb_unload_buddy(&e4b);
 			err =3D -ENOMEM;
 			goto error_return;
 		}
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index aa4c782..4dd0890 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1037,6 +1037,12 @@ static struct dentry *ext4_lookup(struct inode *dir,=
 struct dentry *dentry, stru
 			EXT4_ERROR_INODE(dir, "bad inode number: %u", ino);
 			return ERR_PTR(-EIO);
 		}
+		if (unlikely(ino =3D=3D dir->i_ino)) {
+			EXT4_ERROR_INODE(dir, "'%.*s' linked to parent dir",
+					 dentry->d_name.len,
+					 dentry->d_name.name);
+			return ERR_PTR(-EIO);
+		}
 		inode =3D ext4_iget(dir->i_sb, ino);
 		if (inode =3D=3D ERR_PTR(-ESTALE)) {
 			EXT4_ERROR_INODE(dir,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 961059b..ab7aa3f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -480,6 +480,7 @@ void __ext4_error(struct super_block *sb, const char *f=
unction,
 	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: comm %s: %pV\n",
 	       sb->s_id, function, line, current->comm, &vaf);
 	va_end(args);
+	save_error_info(sb, function, line);
=20
 	ext4_handle_error(sb);
 }
@@ -3727,7 +3728,8 @@ no_journal:
 		goto failed_mount4;
 	}
=20
-	ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY);
+	if (ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY))
+		sb->s_flags |=3D MS_RDONLY;
=20
 	/* determine the minimum size of new large inodes, if present */
 	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
diff --git a/fs/namespace.c b/fs/namespace.c
index cfc6d44..ca4913a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1244,8 +1244,9 @@ void umount_tree(struct vfsmount *mnt, int propagate,=
 struct list_head *kill)
 		list_del_init(&p->mnt_expire);
 		list_del_init(&p->mnt_list);
 		__touch_mnt_namespace(p->mnt_ns);
+		if (p->mnt_ns)
+			__mnt_make_shortterm(p);
 		p->mnt_ns =3D NULL;
-		__mnt_make_shortterm(p);
 		list_del_init(&p->mnt_child);
 		if (p->mnt_parent !=3D p) {
 			p->mnt_parent->mnt_ghosts++;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 03d9b90..a3cae5d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -96,6 +96,8 @@ static int nfs4_map_errors(int err)
 	case -NFS4ERR_BADOWNER:
 	case -NFS4ERR_BADNAME:
 		return -EINVAL;
+	case -NFS4ERR_SHARE_DENIED:
+		return -EACCES;
 	default:
 		dprintk("%s could not handle NFSv4 error %d\n",
 				__func__, -err);
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 14b6cd0..def807c 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -181,6 +181,7 @@
 	{0x1002, 0x6747, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMM=
AP}, \
 	{0x1002, 0x6748, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMM=
AP}, \
 	{0x1002, 0x6749, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMM=
AP}, \
+	{0x1002, 0x674A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMM=
AP}, \
 	{0x1002, 0x6750, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMM=
AP}, \
 	{0x1002, 0x6751, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMM=
AP}, \
 	{0x1002, 0x6758, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMM=
AP}, \
@@ -198,6 +199,7 @@
 	{0x1002, 0x6767, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEM=
MAP}, \
 	{0x1002, 0x6768, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEM=
MAP}, \
 	{0x1002, 0x6770, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEM=
MAP}, \
+	{0x1002, 0x6771, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEM=
MAP}, \
 	{0x1002, 0x6772, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEM=
MAP}, \
 	{0x1002, 0x6778, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEM=
MAP}, \
 	{0x1002, 0x6779, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEM=
MAP}, \
@@ -493,6 +495,7 @@
 	{0x1002, 0x9645, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO2|RADEON_IS_MOBIL=
ITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9647, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILI=
TY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x9648, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILI=
TY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
+	{0x1002, 0x9649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILI=
TY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x964a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMA=
P|RADEON_IS_IGP}, \
 	{0x1002, 0x964b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMA=
P|RADEON_IS_IGP}, \
 	{0x1002, 0x964c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMA=
P|RADEON_IS_IGP}, \
@@ -512,6 +515,7 @@
 	{0x1002, 0x9807, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMA=
P|RADEON_IS_IGP}, \
 	{0x1002, 0x9808, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMA=
P|RADEON_IS_IGP}, \
 	{0x1002, 0x9809, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMA=
P|RADEON_IS_IGP}, \
+	{0x1002, 0x980A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMA=
P|RADEON_IS_IGP}, \
 	{0, 0, 0}
=20
 #define r128_PCI_IDS \
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 619b565..bd21ecd 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -224,6 +224,7 @@ header-y +=3D kd.h
 header-y +=3D kdev_t.h
 header-y +=3D kernel.h
 header-y +=3D kernelcapi.h
+header-y +=3D kernel-page-flags.h
 header-y +=3D keyboard.h
 header-y +=3D keyctl.h
 header-y +=3D l2tp.h
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-=
flags.h
index bd92a89..096b05d 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -31,6 +31,8 @@
=20
 #define KPF_KSM			21
=20
+#ifdef __KERNEL__
+
 /* kernel hacking assistances
  * WARNING: subject to change, never rely on them!
  */
@@ -43,4 +45,6 @@
 #define KPF_ARCH		38
 #define KPF_UNCACHED		39
=20
+#endif /* __KERNEL__ */
+
 #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cbeb586..cb52340 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1420,15 +1420,6 @@ static inline bool netdev_uses_dsa_tags(struct net_d=
evice *dev)
 	return 0;
 }
=20
-#ifndef CONFIG_NET_NS
-static inline void skb_set_dev(struct sk_buff *skb, struct net_device *dev=
)
-{
-	skb->dev =3D dev;
-}
-#else /* CONFIG_NET_NS */
-void skb_set_dev(struct sk_buff *skb, struct net_device *dev);
-#endif
-
 static inline bool netdev_uses_trailer_tags(struct net_device *dev)
 {
 #ifdef CONFIG_NET_DSA_TAG_TRAILER
diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bri=
dge.h
index 0ddd161..31d2844 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -104,9 +104,18 @@ struct bridge_skb_cb {
 	} daddr;
 };
=20
+static inline void br_drop_fake_rtable(struct sk_buff *skb)
+{
+	struct dst_entry *dst =3D skb_dst(skb);
+
+	if (dst && (dst->flags & DST_FAKE_RTABLE))
+		skb_dst_drop(skb);
+}
+
 #else
 #define nf_bridge_maybe_copy_header(skb)	(0)
 #define nf_bridge_pad(skb)			(0)
+#define br_drop_fake_rtable(skb)	        do { } while (0)
 #endif /* CONFIG_BRIDGE_NETFILTER */
=20
 #endif /* __KERNEL__ */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e689b47..bdb4590 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1866,8 +1866,6 @@ static inline int __skb_cow(struct sk_buff *skb, unsi=
gned int headroom,
 {
 	int delta =3D 0;
=20
-	if (headroom < NET_SKB_PAD)
-		headroom =3D NET_SKB_PAD;
 	if (headroom > skb_headroom(skb))
 		delta =3D headroom - skb_headroom(skb);
=20
diff --git a/include/net/dst.h b/include/net/dst.h
index 75766b4..16010d1 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -54,6 +54,8 @@ struct dst_entry {
 #define DST_NOCACHE		0x0010
 #define DST_NOCOUNT		0x0020
 #define DST_NOPEER		0x0040
+#define DST_FAKE_RTABLE		0x0080
+#define DST_XFRM_TUNNEL		0x0100
=20
 	short			error;
 	short			obsolete;
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 6a72a58..ad03988 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -703,4 +703,17 @@ static inline void sctp_v4_map_v6(union sctp_addr *add=
r)
 	addr->v6.sin6_addr.s6_addr32[2] =3D htonl(0x0000ffff);
 }
=20
+/* The cookie is always 0 since this is how it's used in the
+ * pmtu code.
+ */
+static inline struct dst_entry *sctp_transport_dst_check(struct sctp_trans=
port *t)
+{
+	if (t->dst && !dst_check(t->dst, 0)) {
+		dst_release(t->dst);
+		t->dst =3D NULL;
+	}
+
+	return t->dst;
+}
+
 #endif /* __net_sctp_h__ */
diff --git a/kernel/fork.c b/kernel/fork.c
index 26f1ab0..79ee71f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -352,7 +352,8 @@ static int dup_mmap(struct mm_struct *mm, struct mm_str=
uct *oldmm)
 		}
 		charge =3D 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
-			unsigned int len =3D (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
+			unsigned long len;
+			len =3D (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
 			if (security_vm_enough_memory(len))
 				goto fail_nomem;
 			charge =3D len;
diff --git a/lib/btree.c b/lib/btree.c
index 2a34392..297124d 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -319,8 +319,8 @@ void *btree_get_prev(struct btree_head *head, struct bt=
ree_geo *geo,
=20
 	if (head->height =3D=3D 0)
 		return NULL;
-retry:
 	longcpy(key, __key, geo->keylen);
+retry:
 	dec_key(geo, key);
=20
 	node =3D head->node;
@@ -351,7 +351,7 @@ retry:
 	}
 miss:
 	if (retry_key) {
-		__key =3D retry_key;
+		longcpy(key, retry_key, geo->keylen);
 		retry_key =3D NULL;
 		goto retry;
 	}
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7120c2e..5f5c545 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2068,6 +2068,15 @@ static void hugetlb_vm_op_open(struct vm_area_struct=
 *vma)
 		kref_get(&reservations->refs);
 }
=20
+static void resv_map_put(struct vm_area_struct *vma)
+{
+	struct resv_map *reservations =3D vma_resv_map(vma);
+
+	if (!reservations)
+		return;
+	kref_put(&reservations->refs, resv_map_release);
+}
+
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 {
 	struct hstate *h =3D hstate_vma(vma);
@@ -2083,7 +2092,7 @@ static void hugetlb_vm_op_close(struct vm_area_struct=
 *vma)
 		reserve =3D (end - start) -
 			region_count(&reservations->regions, start, end);
=20
-		kref_put(&reservations->refs, resv_map_release);
+		resv_map_put(vma);
=20
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
@@ -2884,12 +2893,16 @@ int hugetlb_reserve_pages(struct inode *inode,
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
=20
-	if (chg < 0)
-		return chg;
+	if (chg < 0) {
+		ret =3D chg;
+		goto out_err;
+	}
=20
 	/* There must be enough filesystem quota for the mapping */
-	if (hugetlb_get_quota(inode->i_mapping, chg))
-		return -ENOSPC;
+	if (hugetlb_get_quota(inode->i_mapping, chg)) {
+		ret =3D -ENOSPC;
+		goto out_err;
+	}
=20
 	/*
 	 * Check enough hugepages are available for the reservation.
@@ -2898,7 +2911,7 @@ int hugetlb_reserve_pages(struct inode *inode,
 	ret =3D hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
 		hugetlb_put_quota(inode->i_mapping, chg);
-		return ret;
+		goto out_err;
 	}
=20
 	/*
@@ -2915,6 +2928,10 @@ int hugetlb_reserve_pages(struct inode *inode,
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
+out_err:
+	if (vma)
+		resv_map_put(vma);
+	return ret;
 }
=20
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
diff --git a/mm/slub.c b/mm/slub.c
index a99c785..af47188 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1506,15 +1506,19 @@ static inline void *acquire_slab(struct kmem_cache =
*s,
 		freelist =3D page->freelist;
 		counters =3D page->counters;
 		new.counters =3D counters;
-		if (mode)
+		if (mode) {
 			new.inuse =3D page->objects;
+			new.freelist =3D NULL;
+		} else {
+			new.freelist =3D freelist;
+		}
=20
 		VM_BUG_ON(new.frozen);
 		new.frozen =3D 1;
=20
 	} while (!__cmpxchg_double_slab(s, page,
 			freelist, counters,
-			NULL, new.counters,
+			new.freelist, new.counters,
 			"lock and freeze"));
=20
 	remove_partial(n, page);
@@ -1556,7 +1560,6 @@ static void *get_partial_node(struct kmem_cache *s,
 			object =3D t;
 			available =3D  page->objects - page->inuse;
 		} else {
-			page->freelist =3D t;
 			available =3D put_cpu_partial(s, page, 0);
 		}
 		if (kmem_cache_debug(s) || available > s->cpu_partial / 2)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 27be2f0..eeba3bb 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -256,7 +256,7 @@ struct vmap_area {
 	struct rb_node rb_node;		/* address sorted rbtree */
 	struct list_head list;		/* address sorted list */
 	struct list_head purge_list;	/* "lazy purge" list */
-	void *private;
+	struct vm_struct *vm;
 	struct rcu_head rcu_head;
 };
=20
@@ -1160,9 +1160,10 @@ void __init vmalloc_init(void)
 	/* Import existing vmlist entries. */
 	for (tmp =3D vmlist; tmp; tmp =3D tmp->next) {
 		va =3D kzalloc(sizeof(struct vmap_area), GFP_NOWAIT);
-		va->flags =3D tmp->flags | VM_VM_AREA;
+		va->flags =3D VM_VM_AREA;
 		va->va_start =3D (unsigned long)tmp->addr;
 		va->va_end =3D va->va_start + tmp->size;
+		va->vm =3D tmp;
 		__insert_vmap_area(va);
 	}
=20
@@ -1260,7 +1261,7 @@ static void setup_vmalloc_vm(struct vm_struct *vm, st=
ruct vmap_area *va,
 	vm->addr =3D (void *)va->va_start;
 	vm->size =3D va->va_end - va->va_start;
 	vm->caller =3D caller;
-	va->private =3D vm;
+	va->vm =3D vm;
 	va->flags |=3D VM_VM_AREA;
 }
=20
@@ -1383,7 +1384,7 @@ static struct vm_struct *find_vm_area(const void *add=
r)
=20
 	va =3D find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA)
-		return va->private;
+		return va->vm;
=20
 	return NULL;
 }
@@ -1402,7 +1403,7 @@ struct vm_struct *remove_vm_area(const void *addr)
=20
 	va =3D find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA) {
-		struct vm_struct *vm =3D va->private;
+		struct vm_struct *vm =3D va->vm;
=20
 		if (!(vm->flags & VM_UNLIST)) {
 			struct vm_struct *tmp, **p;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index cb33d9c..fbe2d2c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -697,7 +697,7 @@ static enum page_references page_check_references(struc=
t page *page,
 		return PAGEREF_RECLAIM;
=20
 	if (referenced_ptes) {
-		if (PageAnon(page))
+		if (PageSwapBacked(page))
 			return PAGEREF_ACTIVATE;
 		/*
 		 * All mapped pages start out with page table
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index bc25286..0cccca8 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -156,7 +156,7 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_b=
uff *skb,
 		skb =3D __vlan_hwaccel_put_tag(skb, vlan_tci);
 	}
=20
-	skb_set_dev(skb, vlan_dev_info(dev)->real_dev);
+	skb->dev =3D vlan_dev_info(dev)->real_dev;
 	len =3D skb->len;
 	ret =3D dev_queue_xmit(skb);
=20
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index ee64287..e221f88 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -47,6 +47,7 @@ int br_dev_queue_push_xmit(struct sk_buff *skb)
 		kfree_skb(skb);
 	} else {
 		skb_push(skb, ETH_HLEN);
+		br_drop_fake_rtable(skb);
 		dev_queue_xmit(skb);
 	}
=20
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index fa8b8f7..577ea5d 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -147,7 +147,7 @@ void br_netfilter_rtable_init(struct net_bridge *br)
 	rt->dst.dev =3D br->dev;
 	rt->dst.path =3D &rt->dst;
 	dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
-	rt->dst.flags	=3D DST_NOXFRM | DST_NOPEER;
+	rt->dst.flags	=3D DST_NOXFRM | DST_NOPEER | DST_FAKE_RTABLE;
 	rt->dst.ops =3D &fake_dst_ops;
 }
=20
@@ -687,11 +687,7 @@ static unsigned int br_nf_local_in(unsigned int hook, =
struct sk_buff *skb,
 				   const struct net_device *out,
 				   int (*okfn)(struct sk_buff *))
 {
-	struct rtable *rt =3D skb_rtable(skb);
-
-	if (rt && rt =3D=3D bridge_parent_rtable(in))
-		skb_dst_drop(skb);
-
+	br_drop_fake_rtable(skb);
 	return NF_ACCEPT;
 }
=20
diff --git a/net/core/dev.c b/net/core/dev.c
index 61a7baa..1cbddc9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1607,10 +1607,14 @@ int dev_forward_skb(struct net_device *dev, struct =
sk_buff *skb)
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
-	skb_set_dev(skb, dev);
+	skb->dev =3D dev;
+	skb_dst_drop(skb);
 	skb->tstamp.tv64 =3D 0;
 	skb->pkt_type =3D PACKET_HOST;
 	skb->protocol =3D eth_type_trans(skb, dev);
+	skb->mark =3D 0;
+	secpath_reset(skb);
+	nf_reset(skb);
 	return netif_rx(skb);
 }
 EXPORT_SYMBOL_GPL(dev_forward_skb);
@@ -1865,36 +1869,6 @@ void netif_device_attach(struct net_device *dev)
 }
 EXPORT_SYMBOL(netif_device_attach);
=20
-/**
- * skb_dev_set -- assign a new device to a buffer
- * @skb: buffer for the new device
- * @dev: network device
- *
- * If an skb is owned by a device already, we have to reset
- * all data private to the namespace a device belongs to
- * before assigning it a new device.
- */
-#ifdef CONFIG_NET_NS
-void skb_set_dev(struct sk_buff *skb, struct net_device *dev)
-{
-	skb_dst_drop(skb);
-	if (skb->dev && !net_eq(dev_net(skb->dev), dev_net(dev))) {
-		secpath_reset(skb);
-		nf_reset(skb);
-		skb_init_secmark(skb);
-		skb->mark =3D 0;
-		skb->priority =3D 0;
-		skb->nf_trace =3D 0;
-		skb->ipvs_property =3D 0;
-#ifdef CONFIG_NET_SCHED
-		skb->tc_index =3D 0;
-#endif
-	}
-	skb->dev =3D dev;
-}
-EXPORT_SYMBOL(skb_set_dev);
-#endif /* CONFIG_NET_NS */
-
 /*
  * Invalidate hardware checksum when packet is to be mangled, and
  * complete checksum manually on outgoing path.
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index a5b4134..530787b 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -457,28 +457,22 @@ static u32 esp4_get_mtu(struct xfrm_state *x, int mtu=
)
 	struct esp_data *esp =3D x->data;
 	u32 blksize =3D ALIGN(crypto_aead_blocksize(esp->aead), 4);
 	u32 align =3D max_t(u32, blksize, esp->padlen);
-	u32 rem;
-
-	mtu -=3D x->props.header_len + crypto_aead_authsize(esp->aead);
-	rem =3D mtu & (align - 1);
-	mtu &=3D ~(align - 1);
+	unsigned int net_adj;
=20
 	switch (x->props.mode) {
-	case XFRM_MODE_TUNNEL:
-		break;
-	default:
 	case XFRM_MODE_TRANSPORT:
-		/* The worst case */
-		mtu -=3D blksize - 4;
-		mtu +=3D min_t(u32, blksize - 4, rem);
-		break;
 	case XFRM_MODE_BEET:
-		/* The worst case. */
-		mtu +=3D min_t(u32, IPV4_BEET_PHMAXLEN, rem);
+		net_adj =3D sizeof(struct iphdr);
 		break;
+	case XFRM_MODE_TUNNEL:
+		net_adj =3D 0;
+		break;
+	default:
+		BUG();
 	}
=20
-	return mtu - 2;
+	return ((mtu - x->props.header_len - crypto_aead_authsize(esp->aead) -
+		 net_adj) & ~(align - 1)) + (net_adj - 2);
 }
=20
 static void esp4_err(struct sk_buff *skb, u32 info)
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 80106d8..d01f9c6 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -146,6 +146,12 @@ static void free_fib_info_rcu(struct rcu_head *head)
 {
 	struct fib_info *fi =3D container_of(head, struct fib_info, rcu);
=20
+	change_nexthops(fi) {
+		if (nexthop_nh->nh_dev)
+			dev_put(nexthop_nh->nh_dev);
+	} endfor_nexthops(fi);
+
+	release_net(fi->fib_net);
 	if (fi->fib_metrics !=3D (u32 *) dst_default_metrics)
 		kfree(fi->fib_metrics);
 	kfree(fi);
@@ -157,13 +163,7 @@ void free_fib_info(struct fib_info *fi)
 		pr_warning("Freeing alive fib_info %p\n", fi);
 		return;
 	}
-	change_nexthops(fi) {
-		if (nexthop_nh->nh_dev)
-			dev_put(nexthop_nh->nh_dev);
-		nexthop_nh->nh_dev =3D NULL;
-	} endfor_nexthops(fi);
 	fib_info_cnt--;
-	release_net(fi->fib_net);
 	call_rcu(&fi->rcu, free_fib_info_rcu);
 }
=20
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 3ce23f9..cd2d639 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1372,6 +1372,8 @@ static int check_leaf(struct fib_table *tb, struct tr=
ie *t, struct leaf *l,
=20
 			if (fa->fa_tos && fa->fa_tos !=3D flp->flowi4_tos)
 				continue;
+			if (fi->fib_dead)
+				continue;
 			if (fa->fa_info->fib_scope < flp->flowi4_scope)
 				continue;
 			fib_alias_accessed(fa);
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 1ac7938..65dd543 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -411,19 +411,15 @@ static u32 esp6_get_mtu(struct xfrm_state *x, int mtu=
)
 	struct esp_data *esp =3D x->data;
 	u32 blksize =3D ALIGN(crypto_aead_blocksize(esp->aead), 4);
 	u32 align =3D max_t(u32, blksize, esp->padlen);
-	u32 rem;
+	unsigned int net_adj;
=20
-	mtu -=3D x->props.header_len + crypto_aead_authsize(esp->aead);
-	rem =3D mtu & (align - 1);
-	mtu &=3D ~(align - 1);
-
-	if (x->props.mode !=3D XFRM_MODE_TUNNEL) {
-		u32 padsize =3D ((blksize - 1) & 7) + 1;
-		mtu -=3D blksize - padsize;
-		mtu +=3D min_t(u32, blksize - padsize, rem);
-	}
+	if (x->props.mode !=3D XFRM_MODE_TUNNEL)
+		net_adj =3D sizeof(struct ipv6hdr);
+	else
+		net_adj =3D 0;
=20
-	return mtu - 2;
+	return ((mtu - x->props.header_len - crypto_aead_authsize(esp->aead) -
+		 net_adj) & ~(align - 1)) + (net_adj - 2);
 }
=20
 static void esp6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f7f07e2..ae98e09 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1178,6 +1178,29 @@ static inline struct ipv6_rt_hdr *ip6_rthdr_dup(stru=
ct ipv6_rt_hdr *src,
 	return src ? kmemdup(src, (src->hdrlen + 1) * 8, gfp) : NULL;
 }
=20
+static void ip6_append_data_mtu(int *mtu,
+				int *maxfraglen,
+				unsigned int fragheaderlen,
+				struct sk_buff *skb,
+				struct rt6_info *rt)
+{
+	if (!(rt->dst.flags & DST_XFRM_TUNNEL)) {
+		if (skb =3D=3D NULL) {
+			/* first fragment, reserve header_len */
+			*mtu =3D *mtu - rt->dst.header_len;
+
+		} else {
+			/*
+			 * this fragment is not first, the headers
+			 * space is regarded as data space.
+			 */
+			*mtu =3D dst_mtu(rt->dst.path);
+		}
+		*maxfraglen =3D ((*mtu - fragheaderlen) & ~7)
+			      + fragheaderlen - sizeof(struct frag_hdr);
+	}
+}
+
 int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	int offset, int len, int odd, struct sk_buff *skb),
 	void *from, int length, int transhdrlen,
@@ -1187,7 +1210,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void=
 *from, char *to,
 	struct inet_sock *inet =3D inet_sk(sk);
 	struct ipv6_pinfo *np =3D inet6_sk(sk);
 	struct inet_cork *cork;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *skb_prev =3D NULL;
 	unsigned int maxfraglen, fragheaderlen;
 	int exthdrlen;
 	int dst_exthdrlen;
@@ -1245,8 +1268,12 @@ int ip6_append_data(struct sock *sk, int getfrag(voi=
d *from, char *to,
 		inet->cork.fl.u.ip6 =3D *fl6;
 		np->cork.hop_limit =3D hlimit;
 		np->cork.tclass =3D tclass;
-		mtu =3D np->pmtudisc =3D=3D IPV6_PMTUDISC_PROBE ?
-		      rt->dst.dev->mtu : dst_mtu(&rt->dst);
+		if (rt->dst.flags & DST_XFRM_TUNNEL)
+			mtu =3D np->pmtudisc =3D=3D IPV6_PMTUDISC_PROBE ?
+			      rt->dst.dev->mtu : dst_mtu(&rt->dst);
+		else
+			mtu =3D np->pmtudisc =3D=3D IPV6_PMTUDISC_PROBE ?
+			      rt->dst.dev->mtu : dst_mtu(rt->dst.path);
 		if (np->frag_size < mtu) {
 			if (np->frag_size)
 				mtu =3D np->frag_size;
@@ -1342,25 +1369,27 @@ int ip6_append_data(struct sock *sk, int getfrag(vo=
id *from, char *to,
 			unsigned int fraglen;
 			unsigned int fraggap;
 			unsigned int alloclen;
-			struct sk_buff *skb_prev;
 alloc_new_skb:
-			skb_prev =3D skb;
-
 			/* There's no room in the current skb */
-			if (skb_prev)
-				fraggap =3D skb_prev->len - maxfraglen;
+			if (skb)
+				fraggap =3D skb->len - maxfraglen;
 			else
 				fraggap =3D 0;
+			/* update mtu and maxfraglen if necessary */
+			if (skb =3D=3D NULL || skb_prev =3D=3D NULL)
+				ip6_append_data_mtu(&mtu, &maxfraglen,
+						    fragheaderlen, skb, rt);
+
+			skb_prev =3D skb;
=20
 			/*
 			 * If remaining data exceeds the mtu,
 			 * we know we need more fragment(s).
 			 */
 			datalen =3D length + fraggap;
-			if (datalen > (cork->length <=3D mtu && !(cork->flags & IPCORK_ALLFRAG)=
 ? mtu : maxfraglen) - fragheaderlen)
-				datalen =3D maxfraglen - fragheaderlen;
=20
-			fraglen =3D datalen + fragheaderlen;
+			if (datalen > (cork->length <=3D mtu && !(cork->flags & IPCORK_ALLFRAG)=
 ? mtu : maxfraglen) - fragheaderlen)
+				datalen =3D maxfraglen - fragheaderlen - rt->dst.trailer_len;
 			if ((flags & MSG_MORE) &&
 			    !(rt->dst.dev->features&NETIF_F_SG))
 				alloclen =3D mtu;
@@ -1369,13 +1398,16 @@ alloc_new_skb:
=20
 			alloclen +=3D dst_exthdrlen;
=20
-			/*
-			 * The last fragment gets additional space at tail.
-			 * Note: we overallocate on fragments with MSG_MODE
-			 * because we have no idea if we're the last one.
-			 */
-			if (datalen =3D=3D length + fraggap)
-				alloclen +=3D rt->dst.trailer_len;
+			if (datalen !=3D length + fraggap) {
+				/*
+				 * this is not the last fragment, the trailer
+				 * space is regarded as data space.
+				 */
+				datalen +=3D rt->dst.trailer_len;
+			}
+
+			alloclen +=3D rt->dst.trailer_len;
+			fraglen =3D datalen + fragheaderlen;
=20
 			/*
 			 * We just reserve space for fragment header.
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 2a2a3e7..2fbbe1f 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -251,9 +251,16 @@ static int l2tp_ip_bind(struct sock *sk, struct sockad=
dr *uaddr, int addr_len)
 {
 	struct inet_sock *inet =3D inet_sk(sk);
 	struct sockaddr_l2tpip *addr =3D (struct sockaddr_l2tpip *) uaddr;
-	int ret =3D -EINVAL;
+	int ret;
 	int chk_addr_ret;
=20
+	if (!sock_flag(sk, SOCK_ZAPPED))
+		return -EINVAL;
+	if (addr_len < sizeof(struct sockaddr_l2tpip))
+		return -EINVAL;
+	if (addr->l2tp_family !=3D AF_INET)
+		return -EINVAL;
+
 	ret =3D -EADDRINUSE;
 	read_lock_bh(&l2tp_ip_lock);
 	if (__l2tp_ip_bind_lookup(&init_net, addr->l2tp_addr.s_addr, sk->sk_bound=
_dev_if, addr->l2tp_conn_id))
@@ -283,6 +290,8 @@ static int l2tp_ip_bind(struct sock *sk, struct sockadd=
r *uaddr, int addr_len)
 	sk_del_node_init(sk);
 	write_unlock_bh(&l2tp_ip_lock);
 	ret =3D 0;
+	sock_reset_flag(sk, SOCK_ZAPPED);
+
 out:
 	release_sock(sk);
=20
@@ -303,13 +312,14 @@ static int l2tp_ip_connect(struct sock *sk, struct so=
ckaddr *uaddr, int addr_len
 	__be32 saddr;
 	int oif, rc;
=20
-	rc =3D -EINVAL;
+	if (sock_flag(sk, SOCK_ZAPPED)) /* Must bind first - autobinding does not=
 work */
+		return -EINVAL;
+
 	if (addr_len < sizeof(*lsa))
-		goto out;
+		return -EINVAL;
=20
-	rc =3D -EAFNOSUPPORT;
 	if (lsa->l2tp_family !=3D AF_INET)
-		goto out;
+		return -EAFNOSUPPORT;
=20
 	lock_sock(sk);
=20
@@ -363,6 +373,14 @@ out:
 	return rc;
 }
=20
+static int l2tp_ip_disconnect(struct sock *sk, int flags)
+{
+	if (sock_flag(sk, SOCK_ZAPPED))
+		return 0;
+
+	return udp_disconnect(sk, flags);
+}
+
 static int l2tp_ip_getname(struct socket *sock, struct sockaddr *uaddr,
 			   int *uaddr_len, int peer)
 {
@@ -598,7 +616,7 @@ static struct proto l2tp_ip_prot =3D {
 	.close		   =3D l2tp_ip_close,
 	.bind		   =3D l2tp_ip_bind,
 	.connect	   =3D l2tp_ip_connect,
-	.disconnect	   =3D udp_disconnect,
+	.disconnect	   =3D l2tp_ip_disconnect,
 	.ioctl		   =3D udp_ioctl,
 	.destroy	   =3D l2tp_ip_destroy_sock,
 	.setsockopt	   =3D ip_setsockopt,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d5230ec..7095ae5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1111,6 +1111,12 @@ int ieee80211_reconfig(struct ieee80211_local *local=
)
 		}
 	}
=20
+	/* add back keys */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (ieee80211_sdata_running(sdata))
+			ieee80211_enable_keys(sdata);
+
+ wake_up:
 	/*
 	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
 	 * sessions can be established after a resume.
@@ -1132,12 +1138,6 @@ int ieee80211_reconfig(struct ieee80211_local *local=
)
 		mutex_unlock(&local->sta_mtx);
 	}
=20
-	/* add back keys */
-	list_for_each_entry(sdata, &local->interfaces, list)
-		if (ieee80211_sdata_running(sdata))
-			ieee80211_enable_keys(sdata);
-
- wake_up:
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
=20
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 817174e..8fc4dcd 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -377,9 +377,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 */
 	skb_set_owner_w(nskb, sk);
=20
-	/* The 'obsolete' field of dst is set to 2 when a dst is freed. */
-	if (!dst || (dst->obsolete > 1)) {
-		dst_release(dst);
+	if (!sctp_transport_dst_check(tp)) {
 		sctp_transport_route(tp, NULL, sctp_sk(sk));
 		if (asoc && (asoc->param_flags & SPP_PMTUD_ENABLE)) {
 			sctp_assoc_sync_pmtu(asoc);
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 394c57c..8da4481 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -226,23 +226,6 @@ void sctp_transport_pmtu(struct sctp_transport *transp=
ort, struct sock *sk)
 		transport->pathmtu =3D SCTP_DEFAULT_MAXSEGMENT;
 }
=20
-/* this is a complete rip-off from __sk_dst_check
- * the cookie is always 0 since this is how it's used in the
- * pmtu code
- */
-static struct dst_entry *sctp_transport_dst_check(struct sctp_transport *t=
)
-{
-	struct dst_entry *dst =3D t->dst;
-
-	if (dst && dst->obsolete && dst->ops->check(dst, 0) =3D=3D NULL) {
-		dst_release(t->dst);
-		t->dst =3D NULL;
-		return NULL;
-	}
-
-	return dst;
-}
-
 void sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 {
 	struct dst_entry *dst;
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f0268ea..b2250da 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -959,6 +959,8 @@ call_reserveresult(struct rpc_task *task)
 	}
=20
 	switch (status) {
+	case -ENOMEM:
+		rpc_delay(task, HZ >> 2);
 	case -EAGAIN:	/* woken up; retry */
 		task->tk_action =3D call_reserve;
 		return;
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index c64c0ef..3ac9789 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -977,15 +977,16 @@ static void xprt_alloc_slot(struct rpc_task *task)
 		goto out_init_req;
 	switch (PTR_ERR(req)) {
 	case -ENOMEM:
-		rpc_delay(task, HZ >> 2);
 		dprintk("RPC:       dynamic allocation of request slot "
 				"failed! Retrying\n");
+		task->tk_status =3D -ENOMEM;
 		break;
 	case -EAGAIN:
 		rpc_sleep_on(&xprt->backlog, task, NULL);
 		dprintk("RPC:       waiting for request slot\n");
+	default:
+		task->tk_status =3D -EAGAIN;
 	}
-	task->tk_status =3D -EAGAIN;
 	return;
 out_init_req:
 	task->tk_status =3D 0;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 9049a5c..0174034 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1919,6 +1919,9 @@ no_transform:
 	}
 ok:
 	xfrm_pols_put(pols, drop_pols);
+	if (dst && dst->xfrm &&
+	    dst->xfrm->props.mode =3D=3D XFRM_MODE_TUNNEL)
+		dst->flags |=3D DST_XFRM_TUNNEL;
 	return dst;
=20
 nopol:
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 0220b0f..839165f 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -698,6 +698,9 @@ static int snd_usb_pcm_check_knot(struct snd_pcm_runtim=
e *runtime,
 	int count =3D 0, needs_knot =3D 0;
 	int err;
=20
+	kfree(subs->rate_list.list);
+	subs->rate_list.list =3D NULL;
+
 	list_for_each_entry(fp, &subs->fmt_list, list) {
 		if (fp->rates & SNDRV_PCM_RATE_CONTINUOUS)
 			return 0;


--=-otW017dzY7rMG2NrR3wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9U+iee/yOyVhhEJAQqwjA/+N7oh+ce9Vz0tFUDJ0MnGgiQLq0P1wMuw
HqL+rc593C1c/XAbax+a2NuCnJKDKK8M2GN1HPeyeo1rXLlUII93mGmyxSZds9xS
htQis5hR83H/OB1Za1JLqA4DXm9V2qSncUrwvEL5ncZk/bhba16xtoNTCnBXEhtj
J0IhwnZ9oyK3Q+TCrAHL+pFPdA3XmyUUQsZ3OjudZY7h1+AB0kstSzkVqXUwhNbd
6IckTgAZApiVzZ7+XUs9D6yXT+py6py5CxeiNHPZ/bcXitkd4rcjj6j0ooIcJX7y
w0PNGXU7A5/RouuDZmEe7oNhUqMYUaMkTvbI+SbBYpyplVu/UPw9iIPPEBS9IAYO
SSv/iua0oicjemLQOokJFhUEJ+DsN7JVKdMBzYYnzMzmJ6I+hY7dPa+09fS8nl85
5iL83BSmTXiwrSDb5/q23tUd/JycsqgNugsmFaA3k6360ca+Uv+sHXHgIeSWzc0N
yqOFda7HIb9O17R3yiAnLQvOdJnV37UA8v6CK28uY6a6eWQXd0IJgWcuKTs78bg2
Ag68nP+z9rAQeTQdo7yFEDpx9qXG3lPSAfi8rHjp3n9spUYC2osqbch+VOZDwsQA
XXqbg1drMt0gmLgkTRHupqHOZbpZIALxSWcseblGtxBo3nAs+G6jdvJ6wsSOn4YG
j23RfJVG8tg=
=8kWh
-----END PGP SIGNATURE-----

--=-otW017dzY7rMG2NrR3wW--
