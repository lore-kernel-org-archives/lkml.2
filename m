Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1BBAqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:46:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:59575 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab1BBAp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028720"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: jkosina@suse.cz, dtor@mail.ru, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [137/139] Input: i8042 - introduce 'notimeout' blacklist for Dell Vostro V13
Message-Id: <20110202004537.1DD433E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
i8042 controller present in Dell Vostro V13 errorneously signals spurious
timeouts.

Introduce i8042.notimeout parameter for ignoring i8042-signalled timeouts
and apply this quirk automatically for Dell Vostro V13, based on DMI match.

In addition to that, this machine also needs to be added to nomux blacklist.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Index: linux-2.6.35.y/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.35.y.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.35.y/Documentation/kernel-parameters.txt
@@ -917,6 +917,7 @@ and is between 256 and 4096 characters. 
 			     controller
 	i8042.nopnp	[HW] Don't use ACPIPnP / PnPBIOS to discover KBD/AUX
 			     controllers
+	i8042.notimeout	[HW] Ignore timeout condition signalled by conroller
 	i8042.panicblink=
 			[HW] Frequency with which keyboard LEDs should blink
 			     when kernel panics (default is 0.5 sec)
Index: linux-2.6.35.y/drivers/input/serio/i8042-x86ia64io.h
===================================================================
--- linux-2.6.35.y.orig/drivers/input/serio/i8042-x86ia64io.h
+++ linux-2.6.35.y/drivers/input/serio/i8042-x86ia64io.h
@@ -420,6 +420,13 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
 		},
 	},
+	{
+		/* Dell Vostro V13 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
+		},
+	},
 	{ }
 };
 
@@ -541,6 +548,17 @@ static const struct dmi_system_id __init
 };
 #endif
 
+static const struct dmi_system_id __initconst i8042_dmi_notimeout_table[] = {
+	{
+		/* Dell Vostro V13 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
+		},
+	},
+	{ }
+};
+
 /*
  * Some Wistron based laptops need us to explicitly enable the 'Dritek
  * keyboard extension' to make their extra keys start generating scancodes.
@@ -893,6 +911,9 @@ static int __init i8042_platform_init(vo
 	if (dmi_check_system(i8042_dmi_nomux_table))
 		i8042_nomux = true;
 
+	if (dmi_check_system(i8042_dmi_notimeout_table))
+		i8042_notimeout = true;
+
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = true;
 #endif /* CONFIG_X86 */
Index: linux-2.6.35.y/drivers/input/serio/i8042.c
===================================================================
--- linux-2.6.35.y.orig/drivers/input/serio/i8042.c
+++ linux-2.6.35.y/drivers/input/serio/i8042.c
@@ -65,6 +65,10 @@ static unsigned int i8042_blink_frequenc
 module_param_named(panicblink, i8042_blink_frequency, uint, 0600);
 MODULE_PARM_DESC(panicblink, "Frequency with which keyboard LEDs should blink when kernel panics");
 
+static bool i8042_notimeout;
+module_param_named(notimeout, i8042_notimeout, bool, 0);
+MODULE_PARM_DESC(notimeout, "Ignore timeouts signalled by i8042");
+
 #ifdef CONFIG_X86
 static bool i8042_dritek;
 module_param_named(dritek, i8042_dritek, bool, 0);
@@ -507,7 +511,7 @@ static irqreturn_t i8042_interrupt(int i
 	} else {
 
 		dfl = ((str & I8042_STR_PARITY) ? SERIO_PARITY : 0) |
-		      ((str & I8042_STR_TIMEOUT) ? SERIO_TIMEOUT : 0);
+		      ((str & I8042_STR_TIMEOUT && !i8042_notimeout) ? SERIO_TIMEOUT : 0);
 
 		port_no = (str & I8042_STR_AUXDATA) ?
 				I8042_AUX_PORT_NO : I8042_KBD_PORT_NO;
