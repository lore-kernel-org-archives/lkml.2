Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1AFIER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:04:17 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:40267 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab1AFIEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:04:16 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
In-Reply-To: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
Subject: RE: [PATCHv1 0/8] unicore32 machine related files: summary
Date: Thu, 6 Jan 2011 16:04:17 +0800
Message-ID: <01e601cbad78$50b374d0$f21a5e70$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQD5q7uzdbzaRxzFKhxkjRMpQze/MJVnmPhg
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCHv1 4/8] unicore32 machine related files: ps2 driver
From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 4 implements arch-specific ps2 driver.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 drivers/input/keyboard/Kconfig      |   11 ++++
 drivers/input/keyboard/atkbd.c      |    4 ++
 drivers/input/mouse/psmouse-base.c  |   41 +++++++++++++++
 drivers/input/serio/i8042.h         |    2 +
 drivers/staging/puv3/i8042-ucio.h   |   96 +++++++++++++++++++++++++++++++++++
 drivers/staging/puv3/nb0916-atkbd.h |   43 ++++++++++++++++
 6 files changed, 197 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 3a87f3b..c03c453 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -134,6 +134,17 @@ config KEYBOARD_QT2160
 	  This driver can also be built as a module. If so, the module
 	  will be called qt2160.
 
+config KEYBOARD_ATKBD_PKUNITY_KEYCODES
+	bool "Use PKUnity keyboard scancodes"
+	depends on ARCH_PUV3 && KEYBOARD_ATKBD
+	default y
+	help
+	  Say Y here if you have a PKUnity machine and want to use an AT or
+	  PS/2 keyboard, and your keyboard uses keycodes that are specific to
+	  PKUnity keyboards.
+
+	  Say N if you use a standard keyboard.
+
 config KEYBOARD_BFIN
 	tristate "Blackfin BF54x keypad support"
 	depends on (BF54x && !BF544)
diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 11478eb..c206cf0 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -82,6 +82,10 @@ static const unsigned short atkbd_set2_keycode[ATKBD_KEYMAP_SIZE] = {
 
 #include "hpps2atkbd.h"	/* include the keyboard scancodes */
 
+#elif CONFIG_KEYBOARD_ATKBD_PKUNITY_KEYCODES
+
+#include "../../staging/puv3/nb0916-atkbd.h"
+
 #else
 	  0, 67, 65, 63, 61, 59, 60, 88,  0, 68, 66, 64, 62, 15, 41,117,
 	  0, 56, 42, 93, 29, 16,  2,  0,  0,  0, 44, 31, 30, 17,  3,  0,
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index cd9d0c9..d4497f7 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -61,7 +61,11 @@ static unsigned int psmouse_smartscroll = 1;
 module_param_named(smartscroll, psmouse_smartscroll, bool, 0644);
 MODULE_PARM_DESC(smartscroll, "Logitech Smartscroll autorepeat, 1 = enabled (default), 0 = disabled.");
 
+#if defined(CONFIG_UNICORE32) && defined(CONFIG_ARCH_PUV3)
+static unsigned int psmouse_resetafter = 1;
+#else
 static unsigned int psmouse_resetafter = 5;
+#endif
 module_param_named(resetafter, psmouse_resetafter, uint, 0644);
 MODULE_PARM_DESC(resetafter, "Reset device after so many bad packets (0 = never).");
 
@@ -132,6 +136,27 @@ static psmouse_ret_t psmouse_process_byte(struct psmouse *psmouse)
 	if (psmouse->pktcnt < psmouse->pktsize)
 		return PSMOUSE_GOOD_DATA;
 
+#if defined(CONFIG_UNICORE32) && defined(CONFIG_ARCH_PUV3)
+	if (!(packet[0] & 0x8))
+		return PSMOUSE_BAD_DATA;
+	else {
+		if (packet[1] > 127) {
+			if (!(packet[0] & 0x10))
+				return PSMOUSE_BAD_DATA;
+		} else {
+			if ((packet[0] & 0x10))
+				return PSMOUSE_BAD_DATA;
+		}
+
+		if (packet[2] > 127) {
+			if (!(packet[0] & 0x20))
+				return PSMOUSE_BAD_DATA;
+		} else {
+			if ((packet[0] & 0x20))
+				return PSMOUSE_BAD_DATA;
+		}
+	}
+#endif
 /*
  * Full packet accumulated, process it
  */
@@ -1004,9 +1029,19 @@ static void psmouse_initialize(struct psmouse *psmouse)
 
 static void psmouse_activate(struct psmouse *psmouse)
 {
+#if defined(CONFIG_UNICORE32) && defined(CONFIG_ARCH_PUV3)
+	int i;
+	for (i = 0; i < 1000; i++)
+		if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE))
+			printk(KERN_WARNING "psmouse.c: Failed to enable mouse on %s\n",
+				psmouse->ps2dev.serio->phys);
+		else
+			break;
+#else
 	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE))
 		printk(KERN_WARNING "psmouse.c: Failed to enable mouse on %s\n",
 			psmouse->ps2dev.serio->phys);
+#endif
 
 	psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
 }
@@ -1413,6 +1448,12 @@ static int psmouse_reconnect(struct serio *serio)
 
 	psmouse_set_state(psmouse, PSMOUSE_INITIALIZING);
 
+#if defined(CONFIG_UNICORE32) && defined(CONFIG_ARCH_PUV3)
+	if (psmouse->protocol_handler(psmouse) ==  PSMOUSE_BAD_DATA) {
+		if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS))
+			goto out;
+	} else
+#endif
 	if (psmouse->reconnect) {
 		if (psmouse->reconnect(psmouse))
 			goto out;
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index cbc1beb..711b41c 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -26,6 +26,8 @@
 #include "i8042-sparcio.h"
 #elif defined(CONFIG_X86) || defined(CONFIG_IA64)
 #include "i8042-x86ia64io.h"
+#elif defined(CONFIG_UNICORE32)
+#include "../../staging/puv3/i8042-ucio.h"
 #else
 #include "i8042-io.h"
 #endif
diff --git a/drivers/staging/puv3/i8042-ucio.h b/drivers/staging/puv3/i8042-ucio.h
new file mode 100644
index 0000000..1e6e310
--- /dev/null
+++ b/drivers/staging/puv3/i8042-ucio.h
@@ -0,0 +1,96 @@
+/*
+ * linux/drivers/staging/puv3/i8042-ucio.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on: drivers/input/serio/i8042-io.h
+ *
+ * Contributors & Additions/Fixes:
+ *	2008: First version by HUANG Tao
+ *
+ * TODO:
+ */
+#ifndef _I8042_UCIO_H
+#define _I8042_UCIO_H
+
+#include <asm/mach/hardware.h>
+#include <linux/clk.h>
+
+/*
+ * Names.
+ */
+
+#define I8042_KBD_PHYS_DESC "isa0060/serio0"
+#define I8042_AUX_PHYS_DESC "isa0060/serio1"
+#define I8042_MUX_PHYS_DESC "isa0060/serio%d"
+
+/*
+ * IRQs.
+ */
+#define I8042_KBD_IRQ           IRQ_PS2_KBD
+#define I8042_AUX_IRQ           IRQ_PS2_AUX
+
+/*
+ * Register numbers.
+ */
+
+#define I8042_COMMAND_REG	((unsigned long)&PS2_COMMAND)
+#define I8042_STATUS_REG	((unsigned long)&PS2_STATUS)
+#define I8042_DATA_REG		((unsigned long)&PS2_DATA)
+
+void puv3_ps2_init(void)
+{
+	struct clk *bclk32;
+
+	bclk32 = clk_get(NULL, "BUS32_CLK");
+	PS2_CNT = clk_get_rate(bclk32) / 200000; /* should > 5us */
+}
+
+static inline int i8042_read_data(void)
+{
+	return inb(I8042_DATA_REG);
+}
+
+static inline int i8042_read_status(void)
+{
+	return inb(I8042_STATUS_REG);
+}
+
+static inline void i8042_write_data(int val)
+{
+	outb(val, I8042_DATA_REG);
+}
+
+static inline void i8042_write_command(int val)
+{
+	outb(val, I8042_COMMAND_REG);
+}
+
+static inline int i8042_platform_init(void)
+{
+/*
+ * On some platforms touching the i8042 data register region can do really
+ * bad things. Because of this the region is always reserved on such boxes.
+ */
+	puv3_ps2_init();
+
+	if (!request_region(I8042_DATA_REG, 16, "i8042"))
+		return -EBUSY;
+
+	i8042_reset = 1;
+	return 0;
+}
+
+static inline void i8042_platform_exit(void)
+{
+	release_region(I8042_DATA_REG, 16);
+}
+
+#endif /* _I8042_UCIO_H */
diff --git a/drivers/staging/puv3/nb0916-atkbd.h b/drivers/staging/puv3/nb0916-atkbd.h
new file mode 100644
index 0000000..2abd398
--- /dev/null
+++ b/drivers/staging/puv3/nb0916-atkbd.h
@@ -0,0 +1,43 @@
+/*
+ * Special Key for NB0916
+ *	KEY_CAMERA: 212
+ *	KEY_WLAN: 238
+ *	KEY_BRIGHTNESSUP: 225
+ *	KEY_BRIGHTNESSDOWN: 224
+ *	KEY_SWITCHVIDEOMODE: 227
+ */
+	  0,  67,  65,  63,  61,  59,  60,  88,
+	  0,  68,  66,  64,  62,  15,  41, 117,
+	  0,  56,  42,  93,  29,  16,   2,   0,
+	  0,   0,  44,  31,  30,  17,   3,   0,
+	  0,  46,  45,  32,  18,   5,   4,  95,
+	  0,  57,  47,  33,  20,  19,   6, 183,
+	  0,  49,  48,  35,  34,  21,   7, 184,
+	  0,   0,  50,  36,  22,   8,   9, 185,
+	  0,  51,  37,  23,  24,  11,  10,   0,
+	  0,  52,  53,  38,  39,  25,  12,   0,
+	  0,  89,  40,   0,  26,  13,   0,   0,
+	 58,  54,  28,  27,   0,  43,   0,  85,
+	  0,  86,  91,  90,  92,   0,  14,  94,
+	  0,  79, 124,  75,  71, 121,   0,   0,
+	 82,  83,  80,  76,  77,  72,   1,  69,
+	 87,  78,  81,  74,  55,  73,  70,  99,
+
+	  0,   0,   0,   0,   0, 212,   0,   0,
+	  0,   0,   0,   0,   0,   0,   0,   0,
+	217, 100, 255,   0,  97, 165,   0,   0,
+	156,   0, 238,   0,   0,   0,   0, 125,
+	173, 114,   0, 113,   0,   0,   0, 126,
+	128,   0,   0, 140,   0,   0,   0, 127,
+	159,   0, 115,   0, 164, 225,   0, 116,
+	158,   0, 172, 166, 224,   0,   0, 142,
+	157,   0,   0,   0,   0,   0,   0,   0,
+	155,   0,  98,   0,   0, 163,   0,   0,
+	226,   0,   0,   0,   0,   0,   0,   0,
+	  0, 255,  96,   0,   0,   0, 143,   0,
+	  0,   0,   0, 227,   0,   0,   0,   0,
+	  0, 107,   0, 105, 102,   0,   0, 112,
+	110, 111, 108, 112, 106, 103,   0, 119,
+	  0, 118, 109,   0,  99, 104, 119,   0,
+
+	  0,   0,   0,  65,  99,

> -----Original Message-----
> From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-owner@vger.kernel.org] On Behalf Of Guan Xuetao
> Sent: Thursday, January 06, 2011 3:57 PM
> To: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCHv1 0/8] unicore32 machine related files: summary
> 
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> The whole patch could be fetched from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/epip/unicore32.git
>   with branch name: unicore32.
> And it is divided into  three patch sets: core architecture files,
>   additional architecture files, and machine related files.
> 
> This patch set adds the machine related files for UniCore32 ISA and PKUnity SoC.
> 
> Patch 1 adds machine related  core files, also including build infrastructure.
> 
> Patch 2 add all hardware registers definitions, which are not split and inserted into
>  different drivers.
> 
> Patch 3 implements arch-specific pci bus driver.
> 
> Patch 4 implements arch-specific ps2 dirver.
> 
> Patch 5 implements frame buffer driver.
> 
> Patch 6 implements ac97 driver.
> 
> Patch 7 implements arch-specific i2c bus driver.
> 
> Patch 8 implements network driver.
> 
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> ---
>  arch/unicore32/include/asm/mach/PKUnity.h     |  104 ++
>  arch/unicore32/include/asm/mach/bitfield.h    |   24 +
>  arch/unicore32/include/asm/mach/hardware.h    |   45 +
>  arch/unicore32/include/asm/mach/regs-ac97.h   |   32 +
>  arch/unicore32/include/asm/mach/regs-dmac.h   |   81 +
>  arch/unicore32/include/asm/mach/regs-gpio.h   |   70 +
>  arch/unicore32/include/asm/mach/regs-i2c.h    |   63 +
>  arch/unicore32/include/asm/mach/regs-intc.h   |   28 +
>  arch/unicore32/include/asm/mach/regs-nand.h   |   79 +
>  arch/unicore32/include/asm/mach/regs-ost.h    |   92 ++
>  arch/unicore32/include/asm/mach/regs-pci.h    |   94 ++
>  arch/unicore32/include/asm/mach/regs-pm.h     |  126 ++
>  arch/unicore32/include/asm/mach/regs-ps2.h    |   20 +
>  arch/unicore32/include/asm/mach/regs-resetc.h |   34 +
>  arch/unicore32/include/asm/mach/regs-rtc.h    |   37 +
>  arch/unicore32/include/asm/mach/regs-sdc.h    |  156 ++
>  arch/unicore32/include/asm/mach/regs-spi.h    |   98 ++
>  arch/unicore32/include/asm/mach/regs-uart.h   |    3 +
>  arch/unicore32/include/asm/mach/regs-umal.h   |  229 +++
>  arch/unicore32/include/asm/mach/regs-unigfx.h |  200 +++
>  arch/unicore32/include/asm/pci.h              |   46 +
>  arch/unicore32/kernel/pci.c                   |  404 +++++
>  arch/unicore32/kernel/puv3-core.c             |  266 ++++
>  arch/unicore32/kernel/puv3-nb0916.c           |  183 +++
>  arch/unicore32/kernel/puv3-smw0919.c          |  120 ++
>  drivers/input/keyboard/Kconfig                |   11 +
>  drivers/input/keyboard/atkbd.c                |    4 +
>  drivers/input/mouse/psmouse-base.c            |   41 +
>  drivers/input/serio/i8042.h                   |    2 +
>  drivers/pci/Makefile                          |    1 +
>  drivers/staging/puv3/Kconfig                  |  142 ++
>  drivers/staging/puv3/Makefile                 |   27 +
>  drivers/staging/puv3/TODO                     |    7 +
>  drivers/staging/puv3/i8042-ucio.h             |   96 ++
>  drivers/staging/puv3/nb0916-atkbd.h           |   43 +
>  drivers/staging/puv3/puv3_ac97.c              |  383 +++++
>  drivers/staging/puv3/puv3_i2c.c               |  325 ++++
>  drivers/staging/puv3/puv3_pcm.c               |  449 ++++++
>  drivers/staging/puv3/puv3_pcm.h               |   33 +
>  drivers/staging/puv3/puv3_umal.c              | 2082 +++++++++++++++++++++++++
>  drivers/staging/puv3/puv3_unifb.c             |  972 ++++++++++++
>  include/linux/fb.h                            |    2 +
>  42 files changed, 7254 insertions(+), 0 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

