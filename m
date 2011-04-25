Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1DYUX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:28 -0400
Received: from 1wt.eu ([62.212.114.60]:33747 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab1DYUXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:25 -0400
Message-Id: <20110425200233.690172553@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        Tim Gardner <tcanonical@tpi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 016/173] Input: i8042 - introduce notimeout blacklist for Dell Vostro V13
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit f8313ef1f448006207f12c107123522c8bc00f15 upstream.

i8042 controller present in Dell Vostro V13 errorneously signals spurious
timeouts.

Introduce i8042.notimeout parameter for ignoring i8042-signalled timeouts
and apply this quirk automatically for Dell Vostro V13, based on DMI match.

In addition to that, this machine also needs to be added to nomux blacklist.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Tim Gardner <tcanonical@tpi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/kernel-parameters.txt   |    1 +
 drivers/input/serio/i8042-x86ia64io.h |   21 +++++++++++++++++++++
 drivers/input/serio/i8042.c           |    6 +++++-
 3 files changed, 27 insertions(+), 1 deletion(-)

Index: longterm-2.6.27/Documentation/kernel-parameters.txt
===================================================================
--- longterm-2.6.27.orig/Documentation/kernel-parameters.txt	2011-04-25 18:15:55.582278324 +0200
+++ longterm-2.6.27/Documentation/kernel-parameters.txt	2011-04-25 18:17:23.642279890 +0200
@@ -811,6 +811,7 @@
 	i8042.panicblink=
 			[HW] Frequency with which keyboard LEDs should blink
 			     when kernel panics (default is 0.5 sec)
+	i8042.notimeout	[HW] Ignore timeout condition signalled by conroller
 	i8042.reset	[HW] Reset the controller during init and cleanup
 	i8042.unlock	[HW] Unlock (ignore) the keylock
 
Index: longterm-2.6.27/drivers/input/serio/i8042-x86ia64io.h
===================================================================
--- longterm-2.6.27.orig/drivers/input/serio/i8042-x86ia64io.h	2011-04-25 18:15:55.587278158 +0200
+++ longterm-2.6.27/drivers/input/serio/i8042-x86ia64io.h	2011-04-25 18:17:23.650279028 +0200
@@ -430,6 +430,13 @@
 			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4280"),
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
 
@@ -655,6 +662,17 @@
 {
 	int retval;
 
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
  * On ix86 platforms touching the i8042 data register region can do really
  * bad things. Because of this the region is always reserved on ix86 boxes.
@@ -681,6 +699,9 @@
 	if (dmi_check_system(i8042_dmi_nomux_table))
 		i8042_nomux = 1;
 
+	if (dmi_check_system(i8042_dmi_notimeout_table))
+		i8042_notimeout = true;
+
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = 1;
 #endif /* CONFIG_X86 */
Index: longterm-2.6.27/drivers/input/serio/i8042.c
===================================================================
--- longterm-2.6.27.orig/drivers/input/serio/i8042.c	2011-04-25 18:15:55.591278225 +0200
+++ longterm-2.6.27/drivers/input/serio/i8042.c	2011-04-25 18:17:56.769279088 +0200
@@ -63,6 +63,10 @@
 module_param_named(panicblink, i8042_blink_frequency, uint, 0600);
 MODULE_PARM_DESC(panicblink, "Frequency with which keyboard LEDs should blink when kernel panics");
 
+static unsigned int i8042_notimeout;
+module_param_named(notimeout, i8042_notimeout, bool, 0);
+MODULE_PARM_DESC(notimeout, "Ignore timeouts signalled by i8042");
+
 #ifdef CONFIG_X86
 static unsigned int i8042_dritek;
 module_param_named(dritek, i8042_dritek, bool, 0);
@@ -362,7 +366,7 @@
 	} else {
 
 		dfl = ((str & I8042_STR_PARITY) ? SERIO_PARITY : 0) |
-		      ((str & I8042_STR_TIMEOUT) ? SERIO_TIMEOUT : 0);
+		      ((str & I8042_STR_TIMEOUT && !i8042_notimeout) ? SERIO_TIMEOUT : 0);
 
 		port_no = (str & I8042_STR_AUXDATA) ?
 				I8042_AUX_PORT_NO : I8042_KBD_PORT_NO;


