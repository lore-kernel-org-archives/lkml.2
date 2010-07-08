Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0GHULP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:11:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:41849 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab0GHULN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:11:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,560,1272870000"; 
   d="scan'208";a="816229315"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, jacob.jun.pan@intel.com, dtor@mail.ru,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 5/5] input: i8042 - add runtime check in x86's i8042_platform_init
In-Reply-To: <4C2E52DD.2050306@zytor.com>
References: <1278059716-7147-1-git-send-email-feng.tang@intel.com> <1278059716-7147-6-git-send-email-feng.tang@intel.com> <alpine.LFD.2.00.1007022252480.2525@localhost.localdomain>
Date: Thu, 08 Jul 2010 13:11:12 -0700
Message-Id: <4c3630e0671350429@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have to say there is an awful lot of code in that file which is
> specific to x86 (more so than IA64)... anyone has a feel if it would
> make sense to break it up?

Almost all of the X86 specific lines are actually just data definitions
for dmi_system_id structures that list systems that need special handling.
Many (most) of the recent changes to this file are adding new systems to
these structures.

We could push them all out into a separate file (as shown in the patch
below) ... then the remainining CONFIG_X86 lines in i8042-x86ia64io.h
look a lot less imposing.  But I'm not sure whether this really gains
anything.

I don't think a naive split of the file into x86 and ia64 versions would
be a good idea ... apart from those massive structures there are a fairly
small number of arch specific lines (7 __ia64__ lines and 18 CONFIG_X86
lines out of 353 total lines).

-Tony

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

 drivers/input/serio/i8042-dmi.h       |  535 +++++++++++++++++++++++++++++++++
 drivers/input/serio/i8042-x86ia64io.h |  533 +--------------------------------
 2 files changed, 536 insertions(+), 532 deletions(-)
 create mode 100644 drivers/input/serio/i8042-dmi.h

diff --git a/drivers/input/serio/i8042-dmi.h b/drivers/input/serio/i8042-dmi.h
new file mode 100644
index 0000000..4c29aff
--- /dev/null
+++ b/drivers/input/serio/i8042-dmi.h
@@ -0,0 +1,535 @@
+#ifndef _I8042_DMI_H
+#define _I8042_DMI_H
+
+#include <linux/dmi.h>
+
+static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
+	{
+		/*
+		 * Arima-Rioworks HDAMB -
+		 * AUX LOOP command does not raise AUX IRQ
+		 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RIOWORKS"),
+			DMI_MATCH(DMI_BOARD_NAME, "HDAMB"),
+			DMI_MATCH(DMI_BOARD_VERSION, "Rev E"),
+		},
+	},
+	{
+		/* ASUS G1S */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "G1S"),
+			DMI_MATCH(DMI_BOARD_VERSION, "1.0"),
+		},
+	},
+	{
+		/* ASUS P65UP5 - AUX LOOP command does not raise AUX IRQ */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P/I-P65UP5"),
+			DMI_MATCH(DMI_BOARD_VERSION, "REV 2.X"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
+			DMI_MATCH(DMI_PRODUCT_NAME , "ProLiant"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "8500"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
+			DMI_MATCH(DMI_PRODUCT_NAME , "ProLiant"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "DL760"),
+		},
+	},
+	{
+		/* OQO Model 01 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "OQO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZEPTO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "00"),
+		},
+	},
+	{
+		/* ULI EV4873 - AUX LOOP does not work properly */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ULI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EV4873"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
+		},
+	},
+	{
+		/* Microsoft Virtual Machine */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "VS2005R2"),
+		},
+	},
+	{
+		/* Medion MAM 2070 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MAM 2070"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
+		},
+	},
+	{
+		/* Blue FB5601 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "blue"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FB5601"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "M606"),
+		},
+	},
+	{
+		/* Gigabyte M912 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M912"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "01"),
+		},
+	},
+	{
+		/* Gigabyte M1022M netbook */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co.,Ltd."),
+			DMI_MATCH(DMI_BOARD_NAME, "M1022E"),
+			DMI_MATCH(DMI_BOARD_VERSION, "1.02"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv9700"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Rev 1"),
+		},
+	},
+	{ }
+};
+
+/*
+ * Some Fujitsu notebooks are having trouble with touchpads if
+ * active multiplexing mode is activated. Luckily they don't have
+ * external PS/2 ports so we can safely disable it.
+ * ... apparently some Toshibas don't like MUX mode either and
+ * die horrible death on reboot.
+ */
+static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
+	{
+		/* Fujitsu Lifebook P7010/P7010D */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P7010"),
+		},
+	},
+	{
+		/* Fujitsu Lifebook P7010 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "0000000000"),
+		},
+	},
+	{
+		/* Fujitsu Lifebook P5020D */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook P Series"),
+		},
+	},
+	{
+		/* Fujitsu Lifebook S2000 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S Series"),
+		},
+	},
+	{
+		/* Fujitsu Lifebook S6230 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S6230"),
+		},
+	},
+	{
+		/* Fujitsu T70H */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FMVLT70H"),
+		},
+	},
+	{
+		/* Fujitsu-Siemens Lifebook T3010 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T3010"),
+		},
+	},
+	{
+		/* Fujitsu-Siemens Lifebook E4010 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E4010"),
+		},
+	},
+	{
+		/* Fujitsu-Siemens Amilo Pro 2010 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro V2010"),
+		},
+	},
+	{
+		/* Fujitsu-Siemens Amilo Pro 2030 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO PRO V2030"),
+		},
+	},
+	{
+		/*
+		 * No data is coming from the touchscreen unless KBC
+		 * is in legacy mode.
+		 */
+		/* Panasonic CF-29 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Matsushita"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CF-29"),
+		},
+	},
+	{
+		/*
+		 * HP Pavilion DV4017EA -
+		 * errors on MUX ports are reported without raising AUXDATA
+		 * causing "spurious NAK" messages.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EA032EA#ABF)"),
+		},
+	},
+	{
+		/*
+		 * HP Pavilion ZT1000 -
+		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Notebook PC"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "HP Pavilion Notebook ZT1000"),
+		},
+	},
+	{
+		/*
+		 * HP Pavilion DV4270ca -
+		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EH476UA#ABL)"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P10"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EQUIUM A110"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ALIENWARE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Sentia"),
+		},
+	},
+	{
+		/* Sharp Actius MM20 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SHARP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PC-MM20 Series"),
+		},
+	},
+	{
+		/* Sony Vaio FS-115b */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FS115B"),
+		},
+	},
+	{
+		/*
+		 * Sony Vaio FZ-240E -
+		 * reset and GET ID commands issued via KBD port are
+		 * sometimes being delivered to AUX3.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FZ240E"),
+		},
+	},
+	{
+		/* Amoi M636/A737 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Amoi Electronics CO.,LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M636/A737 platform"),
+		},
+	},
+	{
+		/* Lenovo 3000 n100 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1360"),
+		},
+	},
+	{
+		/* Gericom Bellagio */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Gericom"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N34AS6"),
+		},
+	},
+	{
+		/* IBM 2656 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "2656"),
+		},
+	},
+	{
+		/* Dell XPS M1530 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS M1530"),
+		},
+	},
+	{
+		/* Compal HEL80I */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "COMPAL"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HEL80I"),
+		},
+	},
+	{
+		/* Dell Vostro 1510 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro1510"),
+		},
+	},
+	{
+		/* Acer Aspire 5536 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5536"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
+		},
+	},
+	{ }
+};
+
+static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
+	{
+		/* MSI Wind U-100 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+		},
+	},
+	{
+		/* LG Electronics X110 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X110"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
+		},
+	},
+	{
+		/* Acer Aspire One 150 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
+		},
+	},
+	{
+		/* Advent 4211 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "DIXONSXP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Advent 4211"),
+		},
+	},
+	{
+		/* Medion Akoya Mini E1210 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E1210"),
+		},
+	},
+	{
+		/* Medion Akoya E1222 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E122X"),
+		},
+	},
+	{
+		/* Mivvy M310 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "VIOOO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N10"),
+		},
+	},
+	{
+		/* Dell Vostro 1320 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1320"),
+		},
+	},
+	{
+		/* Dell Vostro 1520 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1520"),
+		},
+	},
+	{
+		/* Dell Vostro 1720 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1720"),
+		},
+	},
+	{ }
+};
+
+#ifdef CONFIG_PNP
+static const struct dmi_system_id __initconst i8042_dmi_nopnp_table[] = {
+	{
+		/* Intel MBO Desktop D845PESV */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+		},
+	},
+	{
+		/* MSI Wind U-100 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+		},
+	},
+	{ }
+};
+
+static const struct dmi_system_id __initconst i8042_dmi_laptop_table[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_CHASSIS_TYPE, "9"), /* Laptop */
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_CHASSIS_TYPE, "14"), /* Sub-Notebook */
+		},
+	},
+	{ }
+};
+#endif
+
+/*
+ * Some Wistron based laptops need us to explicitly enable the 'Dritek
+ * keyboard extension' to make their extra keys start generating scancodes.
+ * Originally, this was just confined to older laptops, but a few Acer laptops
+ * have turned up in 2007 that also need this again.
+ */
+static const struct dmi_system_id __initconst i8042_dmi_dritek_table[] = {
+	{
+		/* Acer Aspire 5610 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5610"),
+		},
+	},
+	{
+		/* Acer Aspire 5630 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5630"),
+		},
+	},
+	{
+		/* Acer Aspire 5650 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5650"),
+		},
+	},
+	{
+		/* Acer Aspire 5680 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5680"),
+		},
+	},
+	{
+		/* Acer Aspire 5720 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5720"),
+		},
+	},
+	{
+		/* Acer Aspire 9110 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 9110"),
+		},
+	},
+	{
+		/* Acer TravelMate 660 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
+		},
+	},
+	{
+		/* Acer TravelMate 2490 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2490"),
+		},
+	},
+	{
+		/* Acer TravelMate 4280 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4280"),
+		},
+	},
+	{ }
+};
+
+#endif /*_I8042_DMI_H*/
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 6168469..2dc484b 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -64,538 +64,7 @@ static inline void i8042_write_command(int val)
 }
 
 #ifdef CONFIG_X86
-
-#include <linux/dmi.h>
-
-static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
-	{
-		/*
-		 * Arima-Rioworks HDAMB -
-		 * AUX LOOP command does not raise AUX IRQ
-		 */
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "RIOWORKS"),
-			DMI_MATCH(DMI_BOARD_NAME, "HDAMB"),
-			DMI_MATCH(DMI_BOARD_VERSION, "Rev E"),
-		},
-	},
-	{
-		/* ASUS G1S */
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_BOARD_NAME, "G1S"),
-			DMI_MATCH(DMI_BOARD_VERSION, "1.0"),
-		},
-	},
-	{
-		/* ASUS P65UP5 - AUX LOOP command does not raise AUX IRQ */
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "P/I-P65UP5"),
-			DMI_MATCH(DMI_BOARD_VERSION, "REV 2.X"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
-			DMI_MATCH(DMI_PRODUCT_NAME , "ProLiant"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "8500"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
-			DMI_MATCH(DMI_PRODUCT_NAME , "ProLiant"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "DL760"),
-		},
-	},
-	{
-		/* OQO Model 01 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "OQO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZEPTO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "00"),
-		},
-	},
-	{
-		/* ULI EV4873 - AUX LOOP does not work properly */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ULI"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "EV4873"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
-		},
-	},
-	{
-		/* Microsoft Virtual Machine */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "VS2005R2"),
-		},
-	},
-	{
-		/* Medion MAM 2070 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MAM 2070"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
-		},
-	},
-	{
-		/* Blue FB5601 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "blue"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "FB5601"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "M606"),
-		},
-	},
-	{
-		/* Gigabyte M912 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "M912"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "01"),
-		},
-	},
-	{
-		/* Gigabyte M1022M netbook */
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co.,Ltd."),
-			DMI_MATCH(DMI_BOARD_NAME, "M1022E"),
-			DMI_MATCH(DMI_BOARD_VERSION, "1.02"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv9700"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "Rev 1"),
-		},
-	},
-	{ }
-};
-
-/*
- * Some Fujitsu notebooks are having trouble with touchpads if
- * active multiplexing mode is activated. Luckily they don't have
- * external PS/2 ports so we can safely disable it.
- * ... apparently some Toshibas don't like MUX mode either and
- * die horrible death on reboot.
- */
-static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
-	{
-		/* Fujitsu Lifebook P7010/P7010D */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P7010"),
-		},
-	},
-	{
-		/* Fujitsu Lifebook P7010 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "0000000000"),
-		},
-	},
-	{
-		/* Fujitsu Lifebook P5020D */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook P Series"),
-		},
-	},
-	{
-		/* Fujitsu Lifebook S2000 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S Series"),
-		},
-	},
-	{
-		/* Fujitsu Lifebook S6230 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S6230"),
-		},
-	},
-	{
-		/* Fujitsu T70H */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "FMVLT70H"),
-		},
-	},
-	{
-		/* Fujitsu-Siemens Lifebook T3010 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T3010"),
-		},
-	},
-	{
-		/* Fujitsu-Siemens Lifebook E4010 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E4010"),
-		},
-	},
-	{
-		/* Fujitsu-Siemens Amilo Pro 2010 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro V2010"),
-		},
-	},
-	{
-		/* Fujitsu-Siemens Amilo Pro 2030 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO PRO V2030"),
-		},
-	},
-	{
-		/*
-		 * No data is coming from the touchscreen unless KBC
-		 * is in legacy mode.
-		 */
-		/* Panasonic CF-29 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Matsushita"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CF-29"),
-		},
-	},
-	{
-		/*
-		 * HP Pavilion DV4017EA -
-		 * errors on MUX ports are reported without raising AUXDATA
-		 * causing "spurious NAK" messages.
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EA032EA#ABF)"),
-		},
-	},
-	{
-		/*
-		 * HP Pavilion ZT1000 -
-		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Notebook PC"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "HP Pavilion Notebook ZT1000"),
-		},
-	},
-	{
-		/*
-		 * HP Pavilion DV4270ca -
-		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EH476UA#ABL)"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P10"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "EQUIUM A110"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ALIENWARE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Sentia"),
-		},
-	},
-	{
-		/* Sharp Actius MM20 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SHARP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PC-MM20 Series"),
-		},
-	},
-	{
-		/* Sony Vaio FS-115b */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FS115B"),
-		},
-	},
-	{
-		/*
-		 * Sony Vaio FZ-240E -
-		 * reset and GET ID commands issued via KBD port are
-		 * sometimes being delivered to AUX3.
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FZ240E"),
-		},
-	},
-	{
-		/* Amoi M636/A737 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Amoi Electronics CO.,LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "M636/A737 platform"),
-		},
-	},
-	{
-		/* Lenovo 3000 n100 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1360"),
-		},
-	},
-	{
-		/* Gericom Bellagio */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Gericom"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N34AS6"),
-		},
-	},
-	{
-		/* IBM 2656 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "2656"),
-		},
-	},
-	{
-		/* Dell XPS M1530 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "XPS M1530"),
-		},
-	},
-	{
-		/* Compal HEL80I */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "COMPAL"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HEL80I"),
-		},
-	},
-	{
-		/* Dell Vostro 1510 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro1510"),
-		},
-	},
-	{
-		/* Acer Aspire 5536 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5536"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
-		},
-	},
-	{ }
-};
-
-static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
-	{
-		/* MSI Wind U-100 */
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
-		},
-	},
-	{
-		/* LG Electronics X110 */
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "X110"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
-		},
-	},
-	{
-		/* Acer Aspire One 150 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
-		},
-	},
-	{
-		/* Advent 4211 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "DIXONSXP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Advent 4211"),
-		},
-	},
-	{
-		/* Medion Akoya Mini E1210 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "E1210"),
-		},
-	},
-	{
-		/* Medion Akoya E1222 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "E122X"),
-		},
-	},
-	{
-		/* Mivvy M310 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "VIOOO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N10"),
-		},
-	},
-	{
-		/* Dell Vostro 1320 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1320"),
-		},
-	},
-	{
-		/* Dell Vostro 1520 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1520"),
-		},
-	},
-	{
-		/* Dell Vostro 1720 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1720"),
-		},
-	},
-	{ }
-};
-
-#ifdef CONFIG_PNP
-static const struct dmi_system_id __initconst i8042_dmi_nopnp_table[] = {
-	{
-		/* Intel MBO Desktop D845PESV */
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
-		},
-	},
-	{
-		/* MSI Wind U-100 */
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
-		},
-	},
-	{ }
-};
-
-static const struct dmi_system_id __initconst i8042_dmi_laptop_table[] = {
-	{
-		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "9"), /* Laptop */
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_CHASSIS_TYPE, "14"), /* Sub-Notebook */
-		},
-	},
-	{ }
-};
-#endif
-
-/*
- * Some Wistron based laptops need us to explicitly enable the 'Dritek
- * keyboard extension' to make their extra keys start generating scancodes.
- * Originally, this was just confined to older laptops, but a few Acer laptops
- * have turned up in 2007 that also need this again.
- */
-static const struct dmi_system_id __initconst i8042_dmi_dritek_table[] = {
-	{
-		/* Acer Aspire 5610 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5610"),
-		},
-	},
-	{
-		/* Acer Aspire 5630 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5630"),
-		},
-	},
-	{
-		/* Acer Aspire 5650 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5650"),
-		},
-	},
-	{
-		/* Acer Aspire 5680 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5680"),
-		},
-	},
-	{
-		/* Acer Aspire 5720 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5720"),
-		},
-	},
-	{
-		/* Acer Aspire 9110 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 9110"),
-		},
-	},
-	{
-		/* Acer TravelMate 660 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
-		},
-	},
-	{
-		/* Acer TravelMate 2490 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2490"),
-		},
-	},
-	{
-		/* Acer TravelMate 4280 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4280"),
-		},
-	},
-	{ }
-};
-
+#include "i8250-dmi.h"
 #endif /* CONFIG_X86 */
 
 #ifdef CONFIG_PNP
