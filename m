Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1DTUet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:34:49 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3051 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1DTUeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:34:46 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Arend van Spriel" <arend@broadcom.com>
To: zajec5@gmail.com
cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, b43-dev@lists.infradead.org,
        "Arnd Bergmann" <arnd@arndb.de>,
        "George Kashperko" <george@znau.edu.ua>,
        "Jonas Gorski" <jonas.gorski@gmail.com>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Andy Botting" <andy@andybotting.com>, "Greg KH" <greg@kroah.com>,
        "Michael Buesch" <m@bues.ch>
Subject: [PATCH] drivers: brcmaxi: provide amba axi functionality in
 separate module
Date: Wed, 20 Apr 2011 22:34:29 +0200
Message-ID: <1303331669-31293-1-git-send-email-arend@broadcom.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
X-WSS-ID: 61B19B9E3I814463295-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The open-source community is looking for a library which will detect
cores in a chip using axi backplane. Another proposal has been
sent by Rafał Miłecki, which registers detected cores in the linux
device tree to be claimed by device drivers. This implies cores will
always provide a system function to the kernel which is indepent from
other cores and have very loose or no coupling. If this is not true,
exceptions need to be added in the device registration process. This
means knowledge of specific devices from specific vendors is sitting
in a bus driver. Whether the exceptions are rarely or likely is a
pending question.

To feed the discussion this implementation takes a different approach.
A calling entity (being a pci device driver, or SoC initialization
sequence) registers a table with core identities and a callback function.
It then starts the scan and for each detected core with a callback
function it does the call providing the core information. Apart from
that it provides some basic operations on the core.

It has been tested using the brcmsmac driver (in drivers/staging/brcm80211).

V1:
	- (brcm)axi interconnect scanning
	- basic core functions (reset, disable, status, control)
	- cores access over PCI(e)

TODO:
	- sliding BAR windows only for PCI with small window size
	- cleanup in Kconfig

Cc: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: b43-dev@lists.infradead.org
Cc: Rafał Miłecki <zajec5@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: George Kashperko <george@znau.edu.ua>
Cc: Jonas Gorski <jonas.gorski@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andy Botting <andy@andybotting.com>
Cc: Greg KH <greg@kroah.com>
Cc: Michael Buesch <m@bues.ch>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/Kconfig            |    2 +
 drivers/Makefile           |    1 +
 drivers/brcmaxi/Kconfig    |   23 ++
 drivers/brcmaxi/Makefile   |   25 ++
 drivers/brcmaxi/axi.c      |  784 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/brcmaxi/axi_priv.h |   55 +++
 drivers/brcmaxi/pci.c      |  118 +++++++
 include/brcmaxi/amba.h     |   87 +++++
 include/brcmaxi/axi.h      |  310 +++++++++++++++++
 include/brcmaxi/pci.h      |  112 +++++++
 10 files changed, 1517 insertions(+), 0 deletions(-)
 create mode 100644 drivers/brcmaxi/Kconfig
 create mode 100644 drivers/brcmaxi/Makefile
 create mode 100644 drivers/brcmaxi/axi.c
 create mode 100644 drivers/brcmaxi/axi_priv.h
 create mode 100644 drivers/brcmaxi/pci.c
 create mode 100644 include/brcmaxi/amba.h
 create mode 100644 include/brcmaxi/axi.h
 create mode 100644 include/brcmaxi/pci.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 177c7d1..8617526 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -68,6 +68,8 @@ source "drivers/watchdog/Kconfig"
 
 source "drivers/ssb/Kconfig"
 
+source "drivers/brcmaxi/Kconfig"
+
 source "drivers/mfd/Kconfig"
 
 source "drivers/regulator/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 3f135b6..1782ac9 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
+obj-$(CONFIG_BRCMAXI)		+= brcmaxi/
 obj-$(CONFIG_VHOST_NET)		+= vhost/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
diff --git a/drivers/brcmaxi/Kconfig b/drivers/brcmaxi/Kconfig
new file mode 100644
index 0000000..255692e
--- /dev/null
+++ b/drivers/brcmaxi/Kconfig
@@ -0,0 +1,23 @@
+menuconfig BRCMAXI
+	tristate "Broadcom AXI utility function module"
+	---help---
+	  This module provides utility functions for detecting, enabling,
+	  initializing, and configuring cores on Broadcom chips which are
+	  using the AMBA AXI bus.
+
+	  The module is called brcmaxi.ko.
+
+config BRCMAXI_AMBA
+	bool "Broadcom AXI direct access"
+	default y
+	depends on BRCMAXI
+	---help---
+	  Selecting Y here allows direct access to the cores on the AMBA
+	  AXI backplane.
+
+config BRCMAXI_PCI
+	bool "Broadcom AXI over PCI"
+	depends on BRCMAXI
+	---help---
+	  Selecting Y here allows access to cores on AMBA AXI backplane
+	  through the PCI host interface.
diff --git a/drivers/brcmaxi/Makefile b/drivers/brcmaxi/Makefile
new file mode 100644
index 0000000..91f7797
--- /dev/null
+++ b/drivers/brcmaxi/Makefile
@@ -0,0 +1,25 @@
+#
+# Makefile for Broadcom AMBA AXI utility module
+#
+# Copyright (c) 2011 Broadcom Corporation
+#
+# Permission to use, copy, modify, and/or distribute this software for any
+# purpose with or without fee is hereby granted, provided that the above
+# copyright notice and this permission notice appear in all copies.
+#
+# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+# OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+
+MODULEPFX := brcmaxi
+
+ccflags-$(CONFIG_DEBUG_KERNEL)		+= -DDEBUG
+
+obj-$(CONFIG_BRCMAXI)			+= $(MODULEPFX).o
+
+$(MODULEPFX)-y				+= axi.o
+$(MODULEPFX)-$(CONFIG_BRCMAXI_PCI)	+= pci.o
diff --git a/drivers/brcmaxi/axi.c b/drivers/brcmaxi/axi.c
new file mode 100644
index 0000000..f9c4d39
--- /dev/null
+++ b/drivers/brcmaxi/axi.c
@@ -0,0 +1,784 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <asm/byteorder.h>
+#include <brcmaxi/axi.h>
+
+#include "axi_priv.h"
+
+#define AXI_DESCRIPTION "Broadcom AXI utility library"
+
+MODULE_DESCRIPTION(AXI_DESCRIPTION);
+MODULE_AUTHOR("Broadcom Corporation");
+MODULE_LICENSE("Dual BSD/GPL");
+
+/* Core enumeration ROM registers */
+#define	ER_EROMENTRY		0x000
+#define	ER_REMAPCONTROL		0xe00
+#define	ER_REMAPSELECT		0xe04
+#define	ER_MASTERSELECT		0xe10
+#define	ER_ITCR			0xf00
+#define	ER_ITIP			0xf04
+
+/* Core enumeration ROM entries */
+#define	ER_TAG			0xe
+#define	ER_TAG1			0x6
+#define	ER_VALID		1
+#define	ER_CI			0
+#define	ER_MP			2
+#define	ER_ADD			4
+#define	ER_END			0xe
+#define	ER_BAD			0xffffffff
+
+/* Core enumeration ROM CompIdentA */
+#define	CIA_MFG_MASK		0xfff00000
+#define	CIA_MFG_SHIFT		20
+#define	CIA_CID_MASK		0x000fff00
+#define	CIA_CID_SHIFT		8
+#define	CIA_CCL_MASK		0x000000f0
+#define	CIA_CCL_SHIFT		4
+
+/* Core enumeration ROM CompIdentB */
+#define	CIB_REV_MASK		0xff000000
+#define	CIB_REV_SHIFT		24
+#define	CIB_NSW_MASK		0x00f80000
+#define	CIB_NSW_SHIFT		19
+#define	CIB_NMW_MASK		0x0007c000
+#define	CIB_NMW_SHIFT		14
+#define	CIB_NSP_MASK		0x00003e00
+#define	CIB_NSP_SHIFT		9
+#define	CIB_NMP_MASK		0x000001f0
+#define	CIB_NMP_SHIFT		4
+
+/* Core enumeration ROM MasterPortDesc */
+#define	MPD_MUI_MASK		0x0000ff00
+#define	MPD_MUI_SHIFT		8
+#define	MPD_MP_MASK		0x000000f0
+#define	MPD_MP_SHIFT		4
+
+/* Core enumeration ROM AddrDesc */
+#define	AD_ADDR_MASK		0xfffff000
+#define	AD_SP_MASK		0x00000f00
+#define	AD_SP_SHIFT		8
+#define	AD_ST_MASK		0x000000c0
+#define	AD_ST_SHIFT		6
+#define	AD_ST_SLAVE		0x00000000
+#define	AD_ST_BRIDGE		0x00000040
+#define	AD_ST_SWRAP		0x00000080
+#define	AD_ST_MWRAP		0x000000c0
+#define	AD_SZ_MASK		0x00000030
+#define	AD_SZ_SHIFT		4
+#define	AD_SZ_4K		0x00000000
+#define	AD_SZ_8K		0x00000010
+#define	AD_SZ_16K		0x00000020
+#define	AD_SZ_SZD		0x00000030
+#define	AD_AG32			0x00000008
+#define	AD_ADDR_ALIGN		0x00000fff
+#define	AD_SZ_BASE		0x00001000	/* 4KB */
+
+/* Core enumeration ROM SizeDesc */
+#define	SD_SZ_MASK		0xfffff000
+#define	SD_SG32			0x00000008
+#define	SD_SZ_ALIGN		0x00000fff
+
+/* resetctrl */
+#define	AIRC_RESET		1
+
+/* definition for specifying padding fields */
+#define	_PADLINE(line)	pad ## line
+#define	_XSTR(line)	_PADLINE(line)
+#define	PAD		_XSTR(__LINE__)
+
+/*
+ * struct aidmp - device management plugin "wrapper" registers.
+ */
+struct aidmp {
+	u32 oobselina30;	/* 0x000 */
+	u32 oobselina74;	/* 0x004 */
+	u32 PAD[6];
+	u32 oobselinb30;	/* 0x020 */
+	u32 oobselinb74;	/* 0x024 */
+	u32 PAD[6];
+	u32 oobselinc30;	/* 0x040 */
+	u32 oobselinc74;	/* 0x044 */
+	u32 PAD[6];
+	u32 oobselind30;	/* 0x060 */
+	u32 oobselind74;	/* 0x064 */
+	u32 PAD[38];
+	u32 oobselouta30;	/* 0x100 */
+	u32 oobselouta74;	/* 0x104 */
+	u32 PAD[6];
+	u32 oobseloutb30;	/* 0x120 */
+	u32 oobseloutb74;	/* 0x124 */
+	u32 PAD[6];
+	u32 oobseloutc30;	/* 0x140 */
+	u32 oobseloutc74;	/* 0x144 */
+	u32 PAD[6];
+	u32 oobseloutd30;	/* 0x160 */
+	u32 oobseloutd74;	/* 0x164 */
+	u32 PAD[38];
+	u32 oobsynca;	/* 0x200 */
+	u32 oobseloutaen;	/* 0x204 */
+	u32 PAD[6];
+	u32 oobsyncb;	/* 0x220 */
+	u32 oobseloutben;	/* 0x224 */
+	u32 PAD[6];
+	u32 oobsyncc;	/* 0x240 */
+	u32 oobseloutcen;	/* 0x244 */
+	u32 PAD[6];
+	u32 oobsyncd;	/* 0x260 */
+	u32 oobseloutden;	/* 0x264 */
+	u32 PAD[38];
+	u32 oobaextwidth;	/* 0x300 */
+	u32 oobainwidth;	/* 0x304 */
+	u32 oobaoutwidth;	/* 0x308 */
+	u32 PAD[5];
+	u32 oobbextwidth;	/* 0x320 */
+	u32 oobbinwidth;	/* 0x324 */
+	u32 oobboutwidth;	/* 0x328 */
+	u32 PAD[5];
+	u32 oobcextwidth;	/* 0x340 */
+	u32 oobcinwidth;	/* 0x344 */
+	u32 oobcoutwidth;	/* 0x348 */
+	u32 PAD[5];
+	u32 oobdextwidth;	/* 0x360 */
+	u32 oobdinwidth;	/* 0x364 */
+	u32 oobdoutwidth;	/* 0x368 */
+	u32 PAD[37];
+	u32 ioctrlset;	/* 0x400 */
+	u32 ioctrlclear;	/* 0x404 */
+	u32 ioctrl;		/* 0x408 */
+	u32 PAD[61];
+	u32 iostatus;	/* 0x500 */
+	u32 PAD[127];
+	u32 ioctrlwidth;	/* 0x700 */
+	u32 iostatuswidth;	/* 0x704 */
+	u32 PAD[62];
+	u32 resetctrl;	/* 0x800 */
+	u32 resetstatus;	/* 0x804 */
+	u32 resetreadid;	/* 0x808 */
+	u32 resetwriteid;	/* 0x80c */
+	u32 PAD[60];
+	u32 errlogctrl;	/* 0x900 */
+	u32 errlogdone;	/* 0x904 */
+	u32 errlogstatus;	/* 0x908 */
+	u32 errlogaddrlo;	/* 0x90c */
+	u32 errlogaddrhi;	/* 0x910 */
+	u32 errlogid;	/* 0x914 */
+	u32 errloguser;	/* 0x918 */
+	u32 errlogflags;	/* 0x91c */
+	u32 PAD[56];
+	u32 intstatus;	/* 0xa00 */
+	u32 PAD[127];
+	u32 config;		/* 0xe00 */
+	u32 PAD[63];
+	u32 itcr;		/* 0xf00 */
+	u32 PAD[3];
+	u32 itipooba;	/* 0xf10 */
+	u32 itipoobb;	/* 0xf14 */
+	u32 itipoobc;	/* 0xf18 */
+	u32 itipoobd;	/* 0xf1c */
+	u32 PAD[4];
+	u32 itipoobaout;	/* 0xf30 */
+	u32 itipoobbout;	/* 0xf34 */
+	u32 itipoobcout;	/* 0xf38 */
+	u32 itipoobdout;	/* 0xf3c */
+	u32 PAD[4];
+	u32 itopooba;	/* 0xf50 */
+	u32 itopoobb;	/* 0xf54 */
+	u32 itopoobc;	/* 0xf58 */
+	u32 itopoobd;	/* 0xf5c */
+	u32 PAD[4];
+	u32 itopoobain;	/* 0xf70 */
+	u32 itopoobbin;	/* 0xf74 */
+	u32 itopoobcin;	/* 0xf78 */
+	u32 itopoobdin;	/* 0xf7c */
+	u32 PAD[4];
+	u32 itopreset;	/* 0xf90 */
+	u32 PAD[15];
+	u32 peripherialid4;	/* 0xfd0 */
+	u32 peripherialid5;	/* 0xfd4 */
+	u32 peripherialid6;	/* 0xfd8 */
+	u32 peripherialid7;	/* 0xfdc */
+	u32 peripherialid0;	/* 0xfe0 */
+	u32 peripherialid1;	/* 0xfe4 */
+	u32 peripherialid2;	/* 0xfe8 */
+	u32 peripherialid3;	/* 0xfec */
+	u32 componentid0;	/* 0xff0 */
+	u32 componentid1;	/* 0xff4 */
+	u32 componentid2;	/* 0xff8 */
+	u32 componentid3;	/* 0xffc */
+};
+
+/* register access macros */
+#ifdef __LITTLE_ENDIAN
+#ifndef __mips__
+#define R_REG(r) \
+	(sizeof(*(r)) == sizeof(u8) ? \
+		readb((u8 *)(r)) : \
+	sizeof(*(r)) == sizeof(u16) ? \
+		readw((u16 *)(r)) : \
+	readl((u32 *)(r)))
+
+#else	/* __mips__ */
+#define R_REG(r) \
+	({ \
+		__typeof(*(r)) __reg_val; \
+		__asm__ __volatile__("sync"); \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8): \
+			__reg_val = readb((u8 *)(r)); \
+			break; \
+		case sizeof(u16): \
+			__reg_val = readw((u16 *)(r)); \
+			break; \
+		case sizeof(u32): \
+			__reg_val = readl((u32 *)(r)); \
+			break; \
+		} \
+		__asm__ __volatile__("sync"); \
+		__reg_val; \
+	})
+#endif	/* __mips__ */
+#define W_REG(r, v) \
+	do { \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8): \
+			writeb((u8)(v), (u8 *)(r)); break; \
+		case sizeof(u16): \
+			writew((u16)(v), (u16 *)(r)); break; \
+		case sizeof(u32): \
+			writel((u32)(v), (u32 *)(r)); break; \
+		} \
+	} while (0)
+#else	/* __LITTLE_ENDIAN */
+#define R_REG(r) \
+	({ \
+		__typeof(*(r)) __reg_val; \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8): \
+			__reg_val = readb((u8 *)((r)^3)); \
+			break; \
+		case sizeof(u16): \
+			__reg_val = readw((u16 *)((r)^2)); \
+			break; \
+		case sizeof(u32): \
+			__reg_val = readl((u32 *)(r)); \
+			break; \
+		} \
+		__reg_val; \
+	})
+#define W_REG(r, v) \
+	do { \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8):	\
+			writeb((u8)(v), \
+			(u8 *)((r)^3)); break; \
+		case sizeof(u16):	\
+			writew((u16)(v), \
+			(u16 *)((r)^2)); break; \
+		case sizeof(u32):	\
+			writel((u32)(v), \
+			(u32 *)(r)); break; \
+		} \
+	} while (0)
+#endif	/* __LITTLE_ENDIAN */
+
+static void *find_core_handler(struct axi_instance *aih,
+			       u32 mfg_id, u32 core_id)
+{
+	const struct axi_core_handler *handler = aih->handler_list;
+	int i;
+
+	for (i = 0; i < aih->num_handler; i++, handler++) {
+		if ((handler->mfg_id != AXI_ANY_ID) &&
+		    (handler->mfg_id != mfg_id))
+			continue;
+		if ((handler->core_id != AXI_ANY_ID) &&
+		    (handler->mfg_id != mfg_id) &&
+		    (handler->core_id != core_id))
+			continue;
+
+		return handler->handler;
+	}
+
+	return NULL;
+}
+
+/*
+ * get_erom_ent - axi core enumeration rom parsing
+ * @eromptr: pointer progressing through enumeration rom.
+ * @mask: mask used on entry to check with provided match.
+ * @match: entry to find in enumeration rom.
+ *
+ * @returns enumeration rom entry
+ */
+static u32
+get_erom_ent(u32 **eromptr, u32 mask, u32 match)
+{
+	u32 ent;
+	uint inv = 0, nom = 0;
+
+	while (true) {
+		ent = R_REG(*eromptr);
+		(*eromptr)++;
+
+		if (mask == 0)
+			break;
+
+		if ((ent & ER_VALID) == 0) {
+			inv++;
+			continue;
+		}
+
+		if (ent == (ER_END | ER_VALID))
+			break;
+
+		if ((ent & mask) == match)
+			break;
+
+		nom++;
+	}
+
+	if (inv + nom) {
+		pr_debug("%d invalid and %d non-matching entries\n",
+		       inv, nom);
+	}
+	pr_debug("%s: Returning ent 0x%08x\n", __func__, ent);
+	return ent;
+}
+
+/*
+ * get_asd - retrieve address descriptor from axi enumeration rom
+ * @eromptr: pointer progressing through enumeration rom.
+ * @sp: slave port for which the descriptor is retrieved.
+ * @ad: address descriptor for which the descriptor is retrieved.
+ * @st: slave type for which the descriptor is retrieved.
+ * @addrl: low part of physical address.
+ * @addrh: high part of physical address.
+ * @sizel: low part of physical area size.
+ * @sizeh: high part of physical area size.
+ */
+static u32
+get_asd(u32 **eromptr, uint sp, uint ad, uint st,
+	u32 *addrl, u32 *addrh, u32 *sizel, u32 *sizeh)
+{
+	u32 asd, sz, szd;
+
+	asd = get_erom_ent(eromptr, ER_VALID, ER_VALID);
+	if (((asd & ER_TAG1) != ER_ADD) ||
+	    (((asd & AD_SP_MASK) >> AD_SP_SHIFT) != sp) ||
+	    ((asd & AD_ST_MASK) != st)) {
+		/* This is not what we want, "push" it back */
+		(*eromptr)--;
+		return 0;
+	}
+	*addrl = asd & AD_ADDR_MASK;
+	if (asd & AD_AG32)
+		*addrh = get_erom_ent(eromptr, 0, 0);
+	else
+		*addrh = 0;
+	*sizeh = 0;
+	sz = asd & AD_SZ_MASK;
+	if (sz == AD_SZ_SZD) {
+		szd = get_erom_ent(eromptr, 0, 0);
+		*sizel = szd & SD_SZ_MASK;
+		if (szd & SD_SG32)
+			*sizeh = get_erom_ent(eromptr, 0, 0);
+	} else
+		*sizel = AD_SZ_BASE << (sz >> AD_SZ_SHIFT);
+
+	pr_debug("  SP %d, ad %d: st = %d, 0x%08x_0x%08x @ 0x%08x_0x%08x\n",
+	       sp, ad, st, *sizeh, *sizel, *addrh, *addrl);
+
+	return asd;
+}
+
+struct axi_local *axi_create(u32 priv_len)
+{
+	struct axi_local *inst;
+	int size = ALIGN(sizeof(*inst), 4) + priv_len;
+
+	inst = kzalloc(size, GFP_ATOMIC);
+	try_module_get(THIS_MODULE);
+
+	return inst;
+}
+struct axi_instance *axi_open(void *regs, u32 erombase, u32 priv_len)
+{
+	struct axi_local *inst = axi_create(priv_len);
+
+	/* fill public fields */
+	inst->pub.regs = regs;
+	inst->pub.priv = (char *)inst + ALIGN(sizeof(*inst), 4);
+
+	inst->enum_rom_ptr = ioremap_nocache((unsigned long)erombase,
+					     AXI_CORE_SIZE);
+
+	return &inst->pub;
+}
+
+void axi_close(struct axi_instance *aih)
+{
+	kfree(aih);
+	module_put(THIS_MODULE);
+}
+EXPORT_SYMBOL(axi_close);
+
+int axi_scan(struct axi_instance *aih)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct axi_core *core = NULL;
+	u32 *eromlim, *eromptr = ail->enum_rom_ptr;
+	int numcores = 0;
+
+	eromlim = eromptr + (ER_REMAPCONTROL / sizeof(u32));
+
+	pr_debug("axi_scan: erom: ptr = 0x%p, limit = 0x%p\n",
+		 eromptr, eromlim);
+
+	while (eromptr < eromlim) {
+		bool (*handler)(struct axi_instance *ai, struct axi_core *core);
+		u32 cia, cib, cid, mfg, crev;
+		u32 n_master_wrap, n_slave_wrap, n_master_port, n_slave_port;
+		u32 mst_port_desc, addr_space_desc, addrl, addrh, sizel, sizeh;
+		u32 *base;
+		uint i, j;
+		bool br;
+
+		br = false;
+		core = NULL;
+
+		/* Grok a component */
+		cia = get_erom_ent(&eromptr, ER_TAG, ER_CI);
+		if (cia == (ER_END | ER_VALID)) {
+			pr_debug("Found END of erom after %d cores\n",
+				 numcores);
+			return numcores;
+		}
+		base = eromptr - 1;
+		cib = get_erom_ent(&eromptr, 0, 0);
+
+		if ((cib & ER_TAG) != ER_CI) {
+			pr_err("CIA not followed by CIB\n");
+			return 0;
+		}
+
+		cid = (cia & CIA_CID_MASK) >> CIA_CID_SHIFT;
+		mfg = (cia & CIA_MFG_MASK) >> CIA_MFG_SHIFT;
+		crev = (cib & CIB_REV_MASK) >> CIB_REV_SHIFT;
+		n_master_wrap = (cib & CIB_NMW_MASK) >> CIB_NMW_SHIFT;
+		n_slave_wrap = (cib & CIB_NSW_MASK) >> CIB_NSW_SHIFT;
+		n_master_port = (cib & CIB_NMP_MASK) >> CIB_NMP_SHIFT;
+		n_slave_port = (cib & CIB_NSP_MASK) >> CIB_NSP_SHIFT;
+
+		pr_debug("Found component 0x%04x/0x%04x rev %d at "
+		       "erom addr 0x%p, with nmw = %d, nsw = %d, nmp = %d & "
+		       "nsp = %d\n", mfg, cid, crev, base, n_master_wrap,
+		       n_slave_wrap, n_master_port, n_slave_port);
+
+		/* ??ignore processor core?? */
+		if (((mfg == MFGID_ARM) && (cid == DEF_AI_COMP)) ||
+		    (n_slave_port == 0))
+			continue;
+
+		/* alloc space to store core information */
+		core = kzalloc(sizeof(struct axi_core), GFP_ATOMIC);
+		if (!core)
+			return 0;
+
+		core->id = cid;
+		core->mfg = mfg;
+		core->rev = crev;
+
+		if ((n_master_wrap + n_slave_wrap) == 0) {
+			/* A component which is not a core */
+			if (cid == OOB_ROUTER_CORE_ID) {
+				addr_space_desc = get_asd(&eromptr, 0, 0,
+					AD_ST_SLAVE, &addrl, &addrh,
+					&sizel, &sizeh);
+				if (addr_space_desc != 0) {
+					core->phys_address = addrl;
+					handler = find_core_handler(aih,
+								     mfg, cid);
+					if (!handler ||
+					    handler(aih, core) == true) {
+						kfree(core);
+					}
+				} else {
+					kfree(core);
+				}
+			}
+			continue;
+		}
+
+		for (i = 0; i < n_master_port; i++) {
+			mst_port_desc =
+				get_erom_ent(&eromptr, ER_VALID, ER_VALID);
+			if ((mst_port_desc & ER_TAG) != ER_MP) {
+				pr_err("Not enough MP entries for "
+				       "component 0x%x\n", cid);
+				goto error;
+			}
+			pr_debug("  Master port %d, mp: %d id: %d\n", i,
+				 (mst_port_desc & MPD_MP_MASK) >> MPD_MP_SHIFT,
+				 (mst_port_desc & MPD_MUI_MASK) >> MPD_MUI_SHIFT
+			);
+		}
+
+		/* First Slave Address Descriptor should be port 0:
+		 * the main register space for the core
+		 */
+		addr_space_desc =
+		    get_asd(&eromptr, 0, 0, AD_ST_SLAVE, &addrl, &addrh,
+			    &sizel, &sizeh);
+		if (addr_space_desc == 0) {
+			/* Try again to see if it is a bridge */
+			addr_space_desc =
+			    get_asd(&eromptr, 0, 0, AD_ST_BRIDGE, &addrl,
+				    &addrh, &sizel, &sizeh);
+			if (addr_space_desc != 0)
+				br = true;
+			else if ((addrh != 0) || (sizeh != 0)
+				 || (sizel != AXI_CORE_SIZE)) {
+				pr_err("First Slave ASD for core "
+				       "0x%04x malformed (0x%08x)\n",
+				       cid, addr_space_desc);
+				goto error;
+			}
+		}
+
+		core->phys_address = addrl;
+		core->phys_space = sizel;
+
+		/* Get any more ASDs in port 0 */
+		j = 1;
+		do {
+			addr_space_desc =
+			    get_asd(&eromptr, 0, j, AD_ST_SLAVE, &addrl,
+				    &addrh, &sizel, &sizeh);
+			if ((addr_space_desc != 0) && (j == 1) &&
+			    (sizel == AXI_CORE_SIZE)) {
+				core->sec_phys_address = addrl;
+				core->sec_phys_space = sizel;
+			}
+			j++;
+		} while (addr_space_desc != 0);
+
+		/* Go through the ASDs for other slave ports */
+		for (i = 1; i < n_slave_port; i++) {
+			j = 0;
+			do {
+				addr_space_desc =
+				    get_asd(&eromptr, i, j++, AD_ST_SLAVE,
+					    &addrl, &addrh, &sizel, &sizeh);
+			} while (addr_space_desc != 0);
+			if (j == 0) {
+				pr_err("SP %d has no address "
+				       "descriptors\n", i);
+				goto error;
+			}
+		}
+
+		/* Now get master wrappers */
+		for (i = 0; i < n_master_wrap; i++) {
+			addr_space_desc =
+			    get_asd(&eromptr, i, 0, AD_ST_MWRAP, &addrl,
+				    &addrh, &sizel, &sizeh);
+			if (addr_space_desc == 0) {
+				pr_err("Missing descriptor for MW %d\n"
+				       , i);
+				goto error;
+			}
+			if ((sizeh != 0) || (sizel != AXI_CORE_SIZE)) {
+				pr_err("Master wrapper %d is not 4KB\n"
+				       , i);
+				goto error;
+			}
+			if (i == 0)
+				core->wrap_phys_address = addrl;
+		}
+
+		/* And finally slave wrappers */
+		for (i = 0; i < n_slave_wrap; i++) {
+			uint fwp = (n_slave_port == 1) ? 0 : 1;
+			addr_space_desc =
+			    get_asd(&eromptr, fwp + i, 0, AD_ST_SWRAP,
+				    &addrl, &addrh, &sizel, &sizeh);
+			if (addr_space_desc == 0) {
+				pr_err("Missing descriptor for SW %d\n", i);
+				goto error;
+			}
+			if ((sizeh != 0) || (sizel != AXI_CORE_SIZE)) {
+				pr_err("Slave wrapper %d is not 4KB\n", i);
+				goto error;
+			}
+			if ((n_master_wrap == 0) && (i == 0))
+				core->wrap_phys_address = addrl;
+		}
+
+		/* Don't record bridges */
+		if (br)
+			continue;
+
+		/* first core is current core */
+		pci_axi_set_curcore(aih, core);
+
+		/* Done with core */
+		handler = find_core_handler(aih, mfg, cid);
+		if (handler && handler(aih, core) == false)
+			numcores++;
+		else
+			kfree(core);
+	}
+
+	pr_err("Reached end of erom without finding END");
+
+error:
+	kfree(core);
+	return 0;
+}
+EXPORT_SYMBOL(axi_scan);
+
+bool axi_iscoreup(struct axi_core *core)
+{
+	struct aidmp *ai;
+
+	ai = core->wrap;
+
+	return (((R_REG(&ai->ioctrl) & (SICF_FGC | SICF_CLOCK_EN)) ==
+		 SICF_CLOCK_EN)
+		&& ((R_REG(&ai->resetctrl) & AIRC_RESET) == 0));
+}
+
+void axi_core_disable(struct axi_core *core, u32 bits)
+{
+	struct aidmp *ai;
+
+	ai = core->wrap;
+
+	/* if core is already in reset, just return */
+	if (R_REG(&ai->resetctrl) & AIRC_RESET)
+		return;
+
+	W_REG(&ai->ioctrl, bits);
+	(void)R_REG(&ai->ioctrl);
+	udelay(10);
+
+	W_REG(&ai->resetctrl, AIRC_RESET);
+	udelay(1);
+}
+
+void axi_core_reset(struct axi_core *core, u32 bits, u32 resetbits)
+{
+	struct aidmp *ai;
+
+	ai = core->wrap;
+
+	/*
+	 * Must do the disable sequence first to work for
+	 * arbitrary current core state.
+	 */
+	axi_core_disable(core, (bits | resetbits));
+
+	/*
+	 * Now do the initialization sequence.
+	 */
+	W_REG(&ai->ioctrl, (bits | SICF_FGC | SICF_CLOCK_EN));
+	(void)R_REG(&ai->ioctrl);
+	W_REG(&ai->resetctrl, 0);
+	udelay(1);
+
+	W_REG(&ai->ioctrl, (bits | SICF_CLOCK_EN));
+	(void)R_REG(&ai->ioctrl);
+	udelay(1);
+}
+
+uint axi_flag(struct axi_core *core)
+{
+	struct aidmp *ai;
+
+	/* TODO: what is with BCM47162 DMP */
+	ai = core->wrap;
+
+	return R_REG(&ai->oobselouta30) & 0x1f;
+}
+
+u32 axi_core_cflags(struct axi_core *core, u32 mask, u32 val)
+{
+	struct aidmp *ai;
+	u32 w;
+
+	/* TODO: what is with BCM47162 DMP */
+	ai = core->wrap;
+
+	WARN_ON((val & ~mask) == 0);
+
+	if (mask || val) {
+		w = ((R_REG(&ai->ioctrl) & ~mask) | val);
+		W_REG(&ai->ioctrl, w);
+	}
+
+	return R_REG(&ai->ioctrl);
+}
+
+u32 axi_core_sflags(struct axi_core *core, u32 mask, u32 val)
+{
+	struct aidmp *ai;
+	u32 w;
+
+	/* TODO: what is with BCM47162 DMP */
+	ai = core->wrap;
+
+	WARN_ON((val & ~mask) == 0);
+	WARN_ON((mask & ~SISF_CORE_BITS) == 0);
+
+	if (mask || val) {
+		w = ((R_REG(&ai->iostatus) & ~mask) | val);
+		W_REG(&ai->iostatus, w);
+	}
+
+	return R_REG(&ai->iostatus);
+}
+
+#ifdef CONFIG_BRCMAXI_AMBA
+EXPORT_SYMBOL(axi_open);
+EXPORT_SYMBOL(axi_iscoreup);
+EXPORT_SYMBOL(axi_core_disable);
+EXPORT_SYMBOL(axi_core_reset);
+EXPORT_SYMBOL(axi_flag);
+EXPORT_SYMBOL(axi_core_cflags);
+EXPORT_SYMBOL(axi_core_sflags);
+#endif
+
+static int __init axi_init(void)
+{
+	pr_info(AXI_DESCRIPTION "\n");
+	return 0;
+}
+
+static void __exit axi_exit(void)
+{
+}
+
+module_init(axi_init);
+module_exit(axi_exit);
diff --git a/drivers/brcmaxi/axi_priv.h b/drivers/brcmaxi/axi_priv.h
new file mode 100644
index 0000000..9fc6d64
--- /dev/null
+++ b/drivers/brcmaxi/axi_priv.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef AXI_PRIV_H_
+#define AXI_PRIV_H_
+
+#include <brcmaxi/axi.h>
+
+/*
+ * struct axi_local - internal instance data
+ *
+ * @pub: &struct axi_instance pointer to public instance data.
+ * @curcore: &struct axi_core pointer to active core.
+ * @bustype: enum axi_bus referring to type of bus between axi and caller.
+ * @enum_rom_ptr: pointer to system discovery enumeration rom.
+ */
+struct axi_local {
+	struct axi_instance pub;
+#ifdef CONFIG_BRCMAXI_PCI
+	struct axi_core *curcore;
+#endif
+	u32 *enum_rom_ptr;
+};
+
+extern struct axi_local *axi_create(u32 priv_len);
+
+#ifdef CONFIG_BRCMAXI_PCI
+static inline void pci_axi_set_curcore(struct axi_instance *aih,
+					      struct axi_core *core)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	if (ail->curcore == NULL) {
+		core->regs = aih->regs;
+		core->wrap = (void *)
+				((unsigned long)core->regs + AXI_CORE_SIZE);
+		ail->curcore = core;
+	}
+}
+#else
+#define pci_axi_set_curcore(a, b)
+#endif
+
+#endif /* AXI_PRIV_H_ */
diff --git a/drivers/brcmaxi/pci.c b/drivers/brcmaxi/pci.c
new file mode 100644
index 0000000..b71832f
--- /dev/null
+++ b/drivers/brcmaxi/pci.c
@@ -0,0 +1,118 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/pci.h>
+#include <brcmaxi/axi.h>
+#include <brcmaxi/amba.h>
+
+#include "axi_priv.h"
+
+/* backplane address space accessed by BAR0 */
+#define	PCI_BAR0_WIN		0x80
+/* backplane address space accessed by second 4KB of BAR0 */
+#define	PCI_BAR0_WIN2		0xac
+
+struct axi_instance *pci_axi_open(void *pbus, void *regs,
+				  u32 erombase, u32 priv_len)
+{
+	struct axi_local *inst = axi_create(priv_len);
+
+	/* fill public fields */
+	inst->pub.pbus = pbus;
+	inst->pub.regs = regs;
+	inst->pub.priv = (char *)inst + ALIGN(sizeof(*inst), 4);
+
+	/* Now point the window at the core enumeration rom */
+	pci_write_config_dword(inst->pub.pbus, PCI_BAR0_WIN, erombase);
+	inst->enum_rom_ptr = regs;
+
+	return &inst->pub;
+}
+EXPORT_SYMBOL(pci_axi_open);
+
+void *pci_axi_set_active_core(struct axi_instance *aih, struct axi_core *ach)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+
+	u32 addr = ach->phys_address;
+	u32 wrap = ach->wrap_phys_address;
+
+	/* point bar0 window */
+	pci_write_config_dword(aih->pbus, PCI_BAR0_WIN, addr);
+	ach->regs = ail->curcore->regs;
+	/* point bar0 2nd 4KB window */
+	pci_write_config_dword(aih->pbus, PCI_BAR0_WIN2, wrap);
+	ach->wrap = ail->curcore->wrap;
+
+	ail->curcore = ach;
+
+	return ach->regs;
+}
+EXPORT_SYMBOL(pci_axi_set_active_core);
+
+bool pci_axi_iscoreup(struct axi_instance *aih)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct axi_core *core = ail->curcore;
+
+	return axi_iscoreup(core);
+}
+EXPORT_SYMBOL(pci_axi_iscoreup);
+
+void pci_axi_core_disable(struct axi_instance *aih, u32 bits)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct axi_core *core = ail->curcore;
+
+	axi_core_disable(core, bits);
+}
+EXPORT_SYMBOL(pci_axi_core_disable);
+
+void pci_axi_core_reset(struct axi_instance *aih, u32 bits, u32 resetbits)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct axi_core *core = ail->curcore;
+
+	axi_core_reset(core, bits, resetbits);
+}
+EXPORT_SYMBOL(pci_axi_core_reset);
+
+uint pci_axi_flag(struct axi_instance *aih)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct axi_core *core = ail->curcore;
+
+	return axi_flag(core);
+}
+EXPORT_SYMBOL(pci_axi_flag);
+
+u32 pci_axi_core_cflags(struct axi_instance *aih, u32 mask, u32 val)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct axi_core *core = ail->curcore;
+
+	return axi_core_cflags(core, mask, val);
+}
+EXPORT_SYMBOL(pci_axi_core_cflags);
+
+u32 pci_axi_core_sflags(struct axi_instance *aih, u32 mask, u32 val)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct axi_core *core = ail->curcore;
+
+	return axi_core_sflags(core, mask, val);
+}
+EXPORT_SYMBOL(pci_axi_core_sflags);
diff --git a/include/brcmaxi/amba.h b/include/brcmaxi/amba.h
new file mode 100644
index 0000000..5940cb6
--- /dev/null
+++ b/include/brcmaxi/amba.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+
+#ifndef AXI_AMBA_H_
+#define AXI_AMBA_H_
+
+/**
+ * axi_open - create instance.
+ * @regs: pointer to currently mapped register area.
+ * @erom_base: physical address where core enumeration rom is located.
+ * @priv_size: additional memory appended to instance for caller to use.
+ *
+ * Creates the instance filling in the provided details.
+ */
+struct axi_instance *axi_open(void *regs, u32 erom_base, u32 priv_size);
+/**
+ * axi_iscoreup - indicates core is reset and enabled.
+ * @core: &struct axi_core pointer to core of interest.
+ *
+ * Indicates whether the given core has reset and is enabled.
+ */
+bool axi_iscoreup(struct axi_core *core);
+/**
+ * axi_core_disable - disable the core.
+ * @core: &struct axi_core pointer to core of interest.
+ * @bits: core specific bits that are set during reset sequence.
+ *
+ * Disables the given core by reset. This will bring the core in
+ * the disabled state. Initialization is required to enable it again.
+ */
+void axi_core_disable(struct axi_core *core, u32 bits);
+/**
+ * axi_core_reset - reset and enable the core.
+ * @core: &struct axi_core pointer to core of interest.
+ * @bits: core specific bits that are set during and after the reset sequence.
+ * @resetbits: core specific bits that are set only during reset sequence.
+ *
+ * Resets and enables the given core.
+ */
+void axi_core_reset(struct axi_core *core, u32 bits, u32 resetbits);
+/**
+ * axi_flag - get axi flag.
+ * @core: &struct axi_core pointer to core of interest.
+ *
+ * Retrieves the axi flag for the given core.
+ */
+uint axi_flag(struct axi_core *core);
+/**
+ * axi_core_cflags - set core control flags.
+ * @core: &struct axi_core pointer to core of interest.
+ * @mask: mask indicating the bits to clear.
+ * @val: value with bits to set. bits must be within mask.
+ *
+ * Set I/O control flags for the given core. The function returns
+ * the resulting value of the control flags. When called with with
+ * mask and val parameters being 0 the current control flags are
+ * returned.
+ */
+u32 axi_core_cflags(struct axi_core *core, u32 mask, u32 val);
+/**
+ * axi_core_sflags - set core status flags.
+ * @core: &struct axi_core pointer to core of interest.
+ * @mask: mask indicating the bits to clear.
+ * @val: value with bits to set. bits must be within mask.
+ *
+ * Set I/O status flags for the given core. The function returns
+ * the resulting value of the status flags. When called with with
+ * mask and val parameters being 0 the current status flags are
+ * returned.
+ */
+u32 axi_core_sflags(struct axi_core *core, u32 mask, u32 val);
+
+#endif /* AXI_AMBA_H_ */
diff --git a/include/brcmaxi/axi.h b/include/brcmaxi/axi.h
new file mode 100644
index 0000000..08e91eb
--- /dev/null
+++ b/include/brcmaxi/axi.h
@@ -0,0 +1,310 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+
+#ifndef AXI_H_
+#define AXI_H_
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+/**
+ * DOC: Introduction
+ *
+ * brcmaxi provides detection of chip cores in chipsets using the AMBA AXI
+ * on-chip interconnect. It also provides basic functions to operate these
+ * cores and obtain/modify common core control and status flags.
+ */
+/**
+ * DOC: Host Interface Support
+ *
+ * The module provides two selectable intefaces. Direct access and by means
+ * of PCI host interface. For access by PCI bus you should use function prefixed
+ * by pci_ instead.
+ */
+/**
+ * DOC: Chip System Discovery
+ *
+ * The discovery of cores in the chip is done parsing through an enumeration
+ * rom located on the chip. After using the @axi_open() function by which the
+ * calling code provides the type of bus present between calling code and the
+ * enumeration rom, physical base address of the enumeration rom and virtual
+ * address of currently mapped memory, the calling code needs to provide a
+ * table of handlers using the macro @AXI_SET_HANDLERS. The argument should
+ * be declared using the macro @AXI_CORE_HANDLER_TABLE. The actual scan is
+ * initiated by calling @axi_scan().
+ *
+ * The user-provided handlers are called for each core that matches.
+ *
+ * NOTE: currently matching is only based on manufacturer and/or core ID.
+ */
+/**
+ * DOC: Core Utility Functions
+ *
+ * When accessing the cores directly over the AMBA AXI backplane the function
+ * with axi_core_ prefix should be used providing the core instance on which
+ * you want to perform the given function. For accessing the cores over a PCI
+ * interface you should use the pci_axi_core_ functions, which are operating on
+ * an active core. This is selected by using @pci_axi_set_active_core(). Before
+ * calling this function the calling code must assure that interrupts from the
+ * currently active core are disabled.
+ *
+ * The mechanism for PCI is needed as for this interface the BAR register window
+ * is changed and the virtual addresses for accessing the cores is the same for
+ * each core.
+ */
+/*
+ * Manufacturer Ids
+ */
+#define	MFGID_ARM			0x43b
+#define	MFGID_BRCM			0x4bf
+#define	MFGID_MIPS			0x4a7
+
+/*
+ * Component Classes
+ *
+ * This is used to have a more specific core identification.
+ */
+#define	CC_SIM				0
+#define	CC_EROM				1
+#define	CC_CORESIGHT			9
+#define	CC_VERIF			0xb
+#define	CC_OPTIMO			0xd
+#define	CC_GEN				0xe
+#define	CC_PRIMECELL			0xf
+
+/* Core Codes */
+#define	NODEV_CORE_ID		0x700	/* Invalid coreid */
+#define	CC_CORE_ID		0x800	/* chipcommon core */
+#define	ILINE20_CORE_ID		0x801	/* iline20 core */
+#define	SRAM_CORE_ID		0x802	/* sram core */
+#define	SDRAM_CORE_ID		0x803	/* sdram core */
+#define	PCI_CORE_ID		0x804	/* pci core */
+#define	MIPS_CORE_ID		0x805	/* mips core */
+#define	ENET_CORE_ID		0x806	/* enet mac core */
+#define	CODEC_CORE_ID		0x807	/* v90 codec core */
+#define	USB_CORE_ID		0x808	/* usb 1.1 host/device core */
+#define	ADSL_CORE_ID		0x809	/* ADSL core */
+#define	ILINE100_CORE_ID	0x80a	/* iline100 core */
+#define	IPSEC_CORE_ID		0x80b	/* ipsec core */
+#define	UTOPIA_CORE_ID		0x80c	/* utopia core */
+#define	PCMCIA_CORE_ID		0x80d	/* pcmcia core */
+#define	SOCRAM_CORE_ID		0x80e	/* internal memory core */
+#define	MEMC_CORE_ID		0x80f	/* memc sdram core */
+#define	OFDM_CORE_ID		0x810	/* OFDM phy core */
+#define	EXTIF_CORE_ID		0x811	/* external interface core */
+#define	D11_CORE_ID		0x812	/* 802.11 MAC core */
+#define	APHY_CORE_ID		0x813	/* 802.11a phy core */
+#define	BPHY_CORE_ID		0x814	/* 802.11b phy core */
+#define	GPHY_CORE_ID		0x815	/* 802.11g phy core */
+#define	MIPS33_CORE_ID		0x816	/* mips3302 core */
+#define	USB11H_CORE_ID		0x817	/* usb 1.1 host core */
+#define	USB11D_CORE_ID		0x818	/* usb 1.1 device core */
+#define	USB20H_CORE_ID		0x819	/* usb 2.0 host core */
+#define	USB20D_CORE_ID		0x81a	/* usb 2.0 device core */
+#define	SDIOH_CORE_ID		0x81b	/* sdio host core */
+#define	ROBO_CORE_ID		0x81c	/* roboswitch core */
+#define	ATA100_CORE_ID		0x81d	/* parallel ATA core */
+#define	SATAXOR_CORE_ID		0x81e	/* serial ATA & XOR DMA core */
+#define	GIGETH_CORE_ID		0x81f	/* gigabit ethernet core */
+#define	PCIE_CORE_ID		0x820	/* pci express core */
+#define	NPHY_CORE_ID		0x821	/* 802.11n 2x2 phy core */
+#define	SRAMC_CORE_ID		0x822	/* SRAM controller core */
+#define	MINIMAC_CORE_ID		0x823	/* MINI MAC/phy core */
+#define	ARM11_CORE_ID		0x824	/* ARM 1176 core */
+#define	ARM7S_CORE_ID		0x825	/* ARM7tdmi-s core */
+#define	LPPHY_CORE_ID		0x826	/* 802.11a/b/g phy core */
+#define	PMU_CORE_ID		0x827	/* PMU core */
+#define	SSNPHY_CORE_ID		0x828	/* 802.11n single-stream phy core */
+#define	SDIOD_CORE_ID		0x829	/* SDIO device core */
+#define	ARMCM3_CORE_ID		0x82a	/* ARM Cortex M3 core */
+#define	HTPHY_CORE_ID		0x82b	/* 802.11n 4x4 phy core */
+#define	MIPS74K_CORE_ID		0x82c	/* mips 74k core */
+#define	GMAC_CORE_ID		0x82d	/* Gigabit MAC core */
+#define	DMEMC_CORE_ID		0x82e	/* DDR1/2 memory controller core */
+#define	PCIERC_CORE_ID		0x82f	/* PCIE Root Complex core */
+#define	OCP_CORE_ID		0x830	/* OCP2OCP bridge core */
+#define	SC_CORE_ID		0x831	/* shared common core */
+#define	AHB_CORE_ID		0x832	/* OCP2AHB bridge core */
+#define	SPIH_CORE_ID		0x833	/* SPI host core */
+#define	I2S_CORE_ID		0x834	/* I2S core */
+#define	DMEMS_CORE_ID		0x835	/* SDR/DDR1 memory controller core */
+#define	DEF_SHIM_COMP		0x837	/* SHIM component in ubus/6362 */
+#define OOB_ROUTER_CORE_ID	0x367	/* OOB router core ID */
+#define	DEF_AI_COMP		0xfff	/* Default component, in ai chips it
+					 * maps all unused address ranges
+					 */
+
+#define AXI_CORE_SIZE		0x1000	/* each core has 4Kbytes registers */
+
+/* match for all values */
+#define AXI_ANY_ID		(~0)
+
+/*
+ * Common core control flags
+ *
+ * used in axi_core_cflags().
+ */
+#define	SICF_BIST_EN		0x8000
+#define	SICF_PME_EN		0x4000
+#define	SICF_CORE_BITS		0x3ffc
+#define	SICF_FGC		0x0002
+#define	SICF_CLOCK_EN		0x0001
+
+/*
+ * Common core status flags
+ *
+ * used in axi_core_sflags().
+ */
+#define	SISF_BIST_DONE		0x8000
+#define	SISF_BIST_ERROR		0x4000
+#define	SISF_GATED_CLK		0x2000
+#define	SISF_DMA64		0x1000
+#define	SISF_CORE_BITS		0x0fff
+
+/**
+ * struct axi_core - core information
+ * @mfg: manufacturer identifier (JEDEC JEP106).
+ * @id: component identifier (manufacturer assigned).
+ * @rev: core revision.
+ * @phys_address: physical backplane address.
+ * @phys_space: size of the area starting at phys_address.
+ * @sec_phys_address: physical backplane address of 2nd register set.
+ * @sec_phys_space: size of the area starting at sec_phys_address.
+ * @wrap_phys_address: physical backplane address of DMP wrapper registers.
+ * @regs: virtual address of mapped phys_address.
+ * @wrap: virtual address of mapped wrap_phys_address.
+ *
+ * The Manufacturer identifier is maintained by JEDEC. For more info refer to
+ * following webpage infocenter.arm.com/help/topic/com.arm.doc.faqs/ka14408.html
+ */
+struct axi_core {
+	u32	mfg;
+	u32	id;
+	u32	rev;
+	u32	phys_address;
+	u32	phys_space;
+	u32	sec_phys_address;
+	u32	sec_phys_space;
+	u32	wrap_phys_address;
+
+	void	*regs;
+	void	*wrap;
+};
+
+/*
+ * forward declaration for handler in axi_core_handler structure.
+ */
+struct axi_instance;
+
+/**
+ * struct axi_core_handler - associates a core with handler callback function
+ * @handler: callback function called for matching core.
+ * @mfg_id: manufacturer identifier of the core.
+ * @core_id: core identifier of the core.
+ * @core_class: component class of the core.
+ *
+ * The structure is to be used by the calling driver to provide a table
+ * of cores which is to be used during the AXI core scan. It is preferred
+ * to use the AXI_CORE_* macros and AXI_SET_CORE_HANDLERS macro.
+ */
+struct axi_core_handler {
+	bool (*handler)(struct axi_instance *ai, struct axi_core *core);
+	u32 mfg_id;
+	u32 core_id;
+	u32 core_class;
+};
+
+/*
+ * example:
+ *
+ * AXI_CORE_HANDLER_TABLE(drv_table) = {
+ *	{ AXI_CORE(MFGID_MIPS, MIPS74K_CORE_ID, mips74k_handler) },
+ *	{ AXI_CORE(MFGID_BRCM, D11_CORE_ID, brcm80211_d11core) },
+ *	{ AXI_CORE(AXI_ANY_ID, AXI_ANY_ID, debug_axi_handler) }
+ * };
+ * The last entry uses the AXI_ANY_ID. The core matching function
+ * will iterate in sequence through the table so any entries after
+ * this one will be rendered useless.
+ */
+#define AXI_CORE_HANDLER_TABLE(_table) \
+	static const struct axi_core_handler _table[]
+
+#define AXI_CORE(mfg, core, _handler) \
+	.handler = (_handler), .core_id = (core), \
+	.mfg_id = (mfg), .core_class = AXI_ANY_ID
+
+#define AXI_CORE_CLASS(mfg, core, _class, _handler) \
+	.handler = (_handler), .core_id = (core) \
+	.mfg_id = (mfg), .core_class = (_class)
+
+#define AXI_SET_CORE_HANDLERS(aih, _table) \
+	axi_set_core_handlers((aih), ARRAY_SIZE(_table), _table)
+
+/**
+ * struct axi_instance - instance data
+ * @pbus: bus access object (ie. struct pci_dev pointer for PCI bus).
+ * @regs: currently mapped register space.
+ * @handler_list: list of handlers for detected cores during axi_scan().
+ * @num_handler: number of handler entries in the handler_list.
+ * @priv: pointer to memory space that can be used by calling driver.
+ */
+struct axi_instance {
+	const struct axi_core_handler *handler_list;
+	size_t num_handler;
+	void *regs;
+#ifdef CONFIG_BRCMAXI_PCI
+	void *pbus;
+#endif
+	void *priv;
+};
+
+/**
+ * axi_set_core_handlers - sets table of handler used in axi_scan()
+ * @aih: &struct axi_instance pointer to instance data.
+ * @n_handler: number of entries in the given handler list.
+ * @list: &struct axi_core_handler pointer to list of handlers.
+ *
+ * Instead of calling this function directly it is recommended to
+ * use the macro AXI_SET_CORE_HANDLERS.
+ */
+static inline void axi_set_core_handlers(struct axi_instance *aih,
+					 size_t n_handler,
+					 const struct axi_core_handler *list)
+{
+	aih->num_handler = n_handler;
+	aih->handler_list = list;
+}
+
+/**
+ * axi_close - release the instance.
+ * @aih: &struct axi_instance pointer to the instance.
+ */
+void axi_close(struct axi_instance *aih);
+/**
+ * axi_scan - scan the chipset for cores.
+ * @aih: &struct axi_instance pointer to the instance.
+ */
+int axi_scan(struct axi_instance *aih);
+
+#ifdef CONFIG_BRCMAXI_AMBA
+#include "amba.h"
+#endif
+#ifdef CONFIG_BRCMAXI_PCI
+#include "pci.h"
+#endif
+
+#endif /* AXI_H_ */
diff --git a/include/brcmaxi/pci.h b/include/brcmaxi/pci.h
new file mode 100644
index 0000000..76d81b8
--- /dev/null
+++ b/include/brcmaxi/pci.h
@@ -0,0 +1,112 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+
+#ifndef AXI_PCI_H_
+#define AXI_PCI_H_
+
+/**
+ * pci_axi_open - create instance.
+ * @pbus: pointer to bus device structure.
+ * @regs: pointer to currently mapped register area.
+ * @erom_base: physical address where core enumeration rom is located.
+ * @priv_size: additional memory appended to instance for caller to use.
+ *
+ * Creates the instance filling in the provided details.
+ */
+struct axi_instance *pci_axi_open(void *pbus, void *regs,
+				  u32 erom_base, u32 priv_size);
+/**
+ * pci_axi_close - wrapper for @axi_close()
+ * @inst: &struct axi_instance pointer to the instance.
+ *
+ * Just to keep the same naming convention.
+ */
+static inline void pci_axi_close(struct axi_instance *inst)
+{
+	axi_close(inst);
+}
+/**
+ * axi_set_active_core - activate given core.
+ * @aih: &struct axi_instance pointer to the instance.
+ * @ach: pointer to core to be activated.
+ *
+ * Activating a core will have the other operations
+ * be acted upon the core activated here.
+ */
+void *pci_axi_set_active_core(struct axi_instance *aih, struct axi_core *ach);
+/**
+ * axi_iscoreup - indicates core is reset and enabled.
+ * @aih: &struct axi_instance pointer to the instance.
+ *
+ * Indicates whether the active core has reset and is enabled.
+ * Active core is set using @axi_set_active_core().
+ */
+bool pci_axi_iscoreup(struct axi_instance *aih);
+/**
+ * axi_core_disable - disable the core.
+ * @aih: &struct axi_instance pointer to the instance.
+ * @bits: core specific bits that are set during reset sequence.
+ *
+ * Disables the active core by reset. This will bring the core in
+ * the disabled state. Initialization is required to enable it again.
+ * Active core is set using @axi_set_active_core().
+ */
+void pci_axi_core_disable(struct axi_instance *aih, u32 bits);
+/**
+ * axi_core_reset - reset and enable the core.
+ * @aih: &struct axi_instance pointer to the instance.
+ * @bits: core specific bits that are set during and after the reset sequence.
+ * @resetbits: core specific bits that are set only during reset sequence.
+ *
+ * Resets and enables the active core. Active core is set
+ * using @axi_set_active_core().
+ */
+void pci_axi_core_reset(struct axi_instance *aih, u32 bits, u32 resetbits);
+/**
+ * axi_flag - get axi flag.
+ * @aih: &struct axi_instance pointer to the instance.
+ *
+ * Retrieves the axi flag for the active core. Active core is set
+ * using @axi_set_active_core().
+ */
+uint pci_axi_flag(struct axi_instance *aih);
+/**
+ * axi_core_cflags - set core control flags.
+ * @aih: &struct axi_instance pointer to the instance.
+ * @mask: mask indicating the bits to clear.
+ * @val: value with bits to set. bits must be within mask.
+ *
+ * Set I/O control flags for the active core. Active core is set
+ * using @axi_set_active_core(). The function returns the resulting
+ * value of the control flags. When called with with mask and val
+ * parameters being 0 the current control flags are returned.
+ */
+u32 pci_axi_core_cflags(struct axi_instance *aih, u32 mask, u32 val);
+/**
+ * axi_core_sflags - set core status flags.
+ * @aih: &struct axi_instance pointer to the instance.
+ * @mask: mask indicating the bits to clear.
+ * @val: value with bits to set. bits must be within mask.
+ *
+ * Set I/O status flags for the active core. Active core is set
+ * using @axi_set_active_core(). The function returns the resulting
+ * value of the status flags. When called with with mask and val
+ * parameters being 0 the current status flags are returned.
+ */
+u32 pci_axi_core_sflags(struct axi_instance *aih, u32 mask, u32 val);
+
+#endif /* AXI_PCI_H_ */
-- 
1.7.1


