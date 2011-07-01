Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab1GAWFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 18:05:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64357 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab1GAWFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 18:05:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Build regressions/improvements in v3.0-rc5
Date: Sat, 2 Jul 2011 00:05:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107020005.02075.arnd@arndb.de>
X-Provags-ID: V02:K0:z/0r1ZsMlPkCSYQobb+y2x/cEhgbtJWbcDMGQOa8xEr
 93fQlaBPtkJWfUqgK390Vo2wHWz9nONkxFuIy6NSuMvPJuIg7z
 HEIC0YlkKJu9PHDkEeiJx7kEVNOIsTEdJB43cDs/c9S/8YgaEL
 2WVtY+lwYZ4yijCM2/iurqdbR3qpo6ZN35jePeG6/a4r0iHx7g
 9mUgTjmz4ugrb+JBaoYig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 June 2011 10:13:17 Geert Uytterhoeven wrote:
>   + drivers/block/paride/comm.c: error: implicit declaration of function 'inb':  => 54
>   + drivers/block/paride/comm.c: error: implicit declaration of function 'inl':  => 140
>   + drivers/bluetooth/bluecard_cs.c: error: implicit declaration of function 'inb':  => 348
>   + drivers/char/pcmcia/cm4000_cs.c: error: implicit declaration of function 'outb':  => 429
>   + drivers/char/tpm/tpm_atmel.h: error: implicit declaration of function 'ioport_map':  => 129
>   + drivers/hwmon/dme1737.c: error: implicit declaration of function 'inb':  => 556
>   + drivers/hwmon/f71882fg.c: error: implicit declaration of function 'outb':  => 1051
>   + drivers/hwmon/it87.c: error: implicit declaration of function 'inb':  => 83
>   + drivers/isdn/hardware/avm/avmcard.h: error: implicit declaration of function 'insb':  => 426

These and hundreds of others are all ISA/PCMCIA/PCI drivers that should
only be built if the respective PIO functions are provided. We already
have a CONFIG_HAS_IOPORT symbol for that, but use it inconsistently.

I want to eventually change all ARM subarchitectures that don't have any
of the buses mentioned above to not provide them any more, and to avoid
the build errors, my preferred solution would be to add
'depends on HAS_IOPORT' to a lot of places, like in the (incomplete)
patch below.

This also depends on serial8250 cleanup work that I started.

 arch/arm/Kconfig                            |    1 +
 arch/arm/kernel/setup.c                     |    4 ++++
 drivers/base/platform.c                     |    2 ++
 drivers/char/tpm/Kconfig                    |    2 +-
 drivers/gpio/Kconfig                        |    1 +
 drivers/input/gameport/Kconfig              |    1 +
 drivers/input/joystick/Kconfig              |   12 ++++++++++++
 drivers/input/touchscreen/Kconfig           |    1 +
 drivers/pcmcia/Kconfig                      |    1 +
 drivers/rtc/Kconfig                         |    2 ++
 drivers/staging/altera-stapl/Kconfig        |    1 +
 drivers/usb/host/Kconfig                    |    1 +
 kernel/resource.c                           |   27 +++++++++++++++++++--------
 security/integrity/ima/Kconfig              |    2 +-

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 66e28e7..793dfa2 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -819,6 +819,7 @@ config ARCH_U8500
 	bool "ST-Ericsson U8500 Series"
 	depends on MMU
 	select CPU_V7
+	select NO_IOPORT
 	select ARM_AMBA
 	select GENERIC_CLOCKEVENTS
 	select CLKDEV_LOOKUP
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index edcab02..3bec937 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -164,6 +164,7 @@ static struct resource mem_res[] = {
 #define kernel_code mem_res[1]
 #define kernel_data mem_res[2]
 
+#ifdef CONFIG_HAS_IOPORT
 static struct resource io_res[] = {
 	{
 		.name = "reserved",
@@ -188,6 +189,7 @@ static struct resource io_res[] = {
 #define lp0 io_res[0]
 #define lp1 io_res[1]
 #define lp2 io_res[2]
+#endif
 
 static const char *proc_arch[] = {
 	"undefined/unknown",
@@ -566,6 +568,7 @@ static void __init request_standard_resources(struct machine_desc *mdesc)
 		request_resource(&iomem_resource, &video_ram);
 	}
 
+#ifdef CONFIG_HAS_IOPORT
 	/*
 	 * Some machines don't have the possibility of ever
 	 * possessing lp0, lp1 or lp2
@@ -576,6 +579,7 @@ static void __init request_standard_resources(struct machine_desc *mdesc)
 		request_resource(&ioport_resource, &lp1);
 	if (mdesc->reserve_lp2)
 		request_resource(&ioport_resource, &lp2);
+#endif
 }
 
 /*
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 1c291af..ee97499 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -268,8 +268,10 @@ int platform_device_add(struct platform_device *pdev)
 		if (!p) {
 			if (resource_type(r) == IORESOURCE_MEM)
 				p = &iomem_resource;
+#ifdef CONFIG_HAS_IOPORT
 			else if (resource_type(r) == IORESOURCE_IO)
 				p = &ioport_resource;
+#endif
 		}
 
 		if (p && insert_resource(p, r)) {
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index f6595ab..b8224ed 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig TCG_TPM
 	tristate "TPM Hardware Support"
-	depends on HAS_IOMEM
+	depends on HAS_IOMEM && HAS_IOPORT
 	depends on EXPERIMENTAL
 	select SECURITYFS
 	---help---
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 2967002..e67de4c 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -83,6 +83,7 @@ config GPIO_BASIC_MMIO
 
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
+	depends on HAS_IOPORT
 	help
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
diff --git a/drivers/input/gameport/Kconfig b/drivers/input/gameport/Kconfig
index d279454..9a06c93 100644
--- a/drivers/input/gameport/Kconfig
+++ b/drivers/input/gameport/Kconfig
@@ -3,6 +3,7 @@
 #
 config GAMEPORT
 	tristate "Gameport support"
+	depends on HAS_IOPORT
 	---help---
 	  Gameport support is for the standard 15-pin PC gameport. If you
 	  have a joystick, gamepad, gameport card, a soundcard with a gameport
diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 56eb471..04f3fca 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -17,6 +17,7 @@ if INPUT_JOYSTICK
 config JOYSTICK_ANALOG
 	tristate "Classic PC analog joysticks and gamepads"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	---help---
 	  Say Y here if you have a joystick that connects to the PC
 	  gameport. In addition to the usual PC analog joystick, this driver
@@ -34,6 +35,7 @@ config JOYSTICK_ANALOG
 config JOYSTICK_A3D
 	tristate "Assassin 3D and MadCatz Panther devices"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have an FPGaming or MadCatz controller using the
 	  A3D protocol over the PC gameport.
@@ -44,6 +46,7 @@ config JOYSTICK_A3D
 config JOYSTICK_ADI
 	tristate "Logitech ADI digital joysticks and gamepads"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have a Logitech controller using the ADI
 	  protocol over the PC gameport.
@@ -54,6 +57,7 @@ config JOYSTICK_ADI
 config JOYSTICK_COBRA
 	tristate "Creative Labs Blaster Cobra gamepad"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have a Creative Labs Blaster Cobra gamepad.
 
@@ -63,6 +67,7 @@ config JOYSTICK_COBRA
 config JOYSTICK_GF2K
 	tristate "Genius Flight2000 Digital joysticks and gamepads"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have a Genius Flight2000 or MaxFighter digitally
 	  communicating joystick or gamepad.
@@ -73,6 +78,7 @@ config JOYSTICK_GF2K
 config JOYSTICK_GRIP
 	tristate "Gravis GrIP joysticks and gamepads"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have a Gravis controller using the GrIP protocol
 	  over the PC gameport.
@@ -83,6 +89,7 @@ config JOYSTICK_GRIP
 config JOYSTICK_GRIP_MP
 	tristate "Gravis GrIP MultiPort"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have the original Gravis GrIP MultiPort, a hub
 	  that connects to the gameport and you connect gamepads to it.
@@ -93,6 +100,7 @@ config JOYSTICK_GRIP_MP
 config JOYSTICK_GUILLEMOT
 	tristate "Guillemot joysticks and gamepads"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have a Guillemot joystick using a digital
 	  protocol over the PC gameport.
@@ -103,6 +111,7 @@ config JOYSTICK_GUILLEMOT
 config JOYSTICK_INTERACT
 	tristate "InterAct digital joysticks and gamepads"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have an InterAct gameport or joystick
 	  communicating digitally over the gameport.
@@ -113,6 +122,7 @@ config JOYSTICK_INTERACT
 config JOYSTICK_SIDEWINDER
 	tristate "Microsoft SideWinder digital joysticks and gamepads"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have a Microsoft controller using the Digital
 	  Overdrive protocol over PC gameport.
@@ -123,6 +133,7 @@ config JOYSTICK_SIDEWINDER
 config JOYSTICK_TMDC
 	tristate "ThrustMaster DirectConnect joysticks and gamepads"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have a ThrustMaster controller using the
 	  DirectConnect (BSP) protocol over the PC gameport.
@@ -268,6 +279,7 @@ config JOYSTICK_AS5011
 config JOYSTICK_JOYDUMP
 	tristate "Gameport data dumper"
 	select GAMEPORT
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you want to dump data from your joystick into the system
 	  log for debugging purposes. Say N if you are making a production
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index cabd9e5..b5b99b0 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -310,6 +310,7 @@ config TOUCHSCREEN_INTEL_MID
 
 config TOUCHSCREEN_MK712
 	tristate "ICS MicroClock MK712 touchscreen"
+	depends on HAS_IOPORT
 	help
 	  Say Y here if you have the ICS MicroClock MK712 touchscreen
 	  controller chip in your system.
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 6e318ce..9eca7e7 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -19,6 +19,7 @@ if PCCARD
 
 config PCMCIA
 	tristate "16-bit PCMCIA support"
+	depends on HAVE_PCMCIA
 	select CRC32
 	default y
 	---help---
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index ce2aabf..df52628 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -481,6 +481,7 @@ comment "Platform RTC drivers"
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
 	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS || SPARC64
+	depends on HAS_IOPORT
 	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
@@ -636,6 +637,7 @@ config RTC_MXC
 
 config RTC_DRV_BQ4802
 	tristate "TI BQ4802"
+	depends on HAS_IOPORT
 	help
 	  If you say Y here you will get support for the TI
 	  BQ4802 RTC chip.
diff --git a/drivers/staging/altera-stapl/Kconfig b/drivers/staging/altera-stapl/Kconfig
index 7f01d8e..9fab568 100644
--- a/drivers/staging/altera-stapl/Kconfig
+++ b/drivers/staging/altera-stapl/Kconfig
@@ -3,6 +3,7 @@ comment "Altera FPGA firmware download module"
 config ALTERA_STAPL
 	tristate "Altera FPGA firmware download module"
 	depends on I2C
+	depends on HAS_IOPORT
 	default n
 	help
 	  An Altera FPGA module. Say Y when you want to support this tool.
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 5f9f399..787492e 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -260,6 +260,7 @@ config USB_ISP1760_HCD
 config USB_ISP1362_HCD
 	tristate "ISP1362 HCD support"
 	depends on USB
+	depends on HAS_IOPORT
 	default N
 	---help---
 	  Supports the Philips ISP1362 chip as a host controller
diff --git a/kernel/resource.c b/kernel/resource.c
index 798e2fa..f104185 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -21,7 +21,7 @@
 #include <linux/pfn.h>
 #include <asm/io.h>
 
-
+#ifdef IO_SPACE_LIMIT
 struct resource ioport_resource = {
 	.name	= "PCI IO",
 	.start	= 0,
@@ -29,6 +29,7 @@ struct resource ioport_resource = {
 	.flags	= IORESOURCE_IO,
 };
 EXPORT_SYMBOL(ioport_resource);
+#endif
 
 struct resource iomem_resource = {
 	.name	= "PCI mem",
@@ -97,6 +98,7 @@ static const struct seq_operations resource_op = {
 	.show	= r_show,
 };
 
+#ifdef IO_SPACE_LIMIT
 static int ioports_open(struct inode *inode, struct file *file)
 {
 	int res = seq_open(file, &resource_op);
@@ -107,6 +109,14 @@ static int ioports_open(struct inode *inode, struct file *file)
 	return res;
 }
 
+static const struct file_operations proc_ioports_operations = {
+	.open		= ioports_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+#endif
+
 static int iomem_open(struct inode *inode, struct file *file)
 {
 	int res = seq_open(file, &resource_op);
@@ -117,13 +127,6 @@ static int iomem_open(struct inode *inode, struct file *file)
 	return res;
 }
 
-static const struct file_operations proc_ioports_operations = {
-	.open		= ioports_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static const struct file_operations proc_iomem_operations = {
 	.open		= iomem_open,
 	.read		= seq_read,
@@ -133,7 +136,9 @@ static const struct file_operations proc_iomem_operations = {
 
 static int __init ioresources_init(void)
 {
+#ifdef IO_SPACE_LIMIT
 	proc_create("ioports", 0, NULL, &proc_ioports_operations);
+#endif
 	proc_create("iomem", 0, NULL, &proc_iomem_operations);
 	return 0;
 }
@@ -941,8 +946,14 @@ static int __init reserve_setup(char *str)
 			res->end = io_start + io_num - 1;
 			res->flags = IORESOURCE_BUSY;
 			res->child = NULL;
+#ifdef IO_SPACE_LIMIT
 			if (request_resource(res->start >= 0x10000 ? &iomem_resource : &ioport_resource, res) == 0)
 				reserved = x+1;
+#else
+			if (request_resource(&iomem_resource, res) == 0)
+				reserved = x+1;
+
+#endif
 		}
 	}
 	return 1;
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index b6ecfd4..c0bdabc 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -8,7 +8,7 @@ config IMA
 	select CRYPTO_HMAC
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-	select TCG_TPM if !S390
+	select TCG_TPM if HAS_IOPORT
 	select TCG_TIS if TCG_TPM
 	help
 	  The Trusted Computing Group(TCG) runtime Integrity
