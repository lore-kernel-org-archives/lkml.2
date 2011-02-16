Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab1BPCGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:06:46 -0500
Received: from kroah.org ([198.145.64.141]:48911 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758247Ab1BPBuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:58 2011
Message-Id: <20110216014658.631954414@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        Tim Gardner <tcanonical@tpi.com>
Subject: [043/115] Input: i8042 - introduce notimeout blacklist for Dell Vostro V13
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -878,6 +878,7 @@ and is between 256 and 4096 characters.
 	i8042.panicblink=
 			[HW] Frequency with which keyboard LEDs should blink
 			     when kernel panics (default is 0.5 sec)
+	i8042.notimeout	[HW] Ignore timeout condition signalled by conroller
 	i8042.reset	[HW] Reset the controller during init and cleanup
 	i8042.unlock	[HW] Unlock (ignore) the keylock
 
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -416,6 +416,13 @@ static const struct dmi_system_id __init
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
 
@@ -537,6 +544,17 @@ static const struct dmi_system_id __init
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
@@ -866,6 +884,9 @@ static int __init i8042_platform_init(vo
 	if (dmi_check_system(i8042_dmi_nomux_table))
 		i8042_nomux = true;
 
+	if (dmi_check_system(i8042_dmi_notimeout_table))
+		i8042_notimeout = true;
+
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = true;
 #endif /* CONFIG_X86 */
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -64,6 +64,10 @@ static unsigned int i8042_blink_frequenc
 module_param_named(panicblink, i8042_blink_frequency, uint, 0600);
 MODULE_PARM_DESC(panicblink, "Frequency with which keyboard LEDs should blink when kernel panics");
 
+static bool i8042_notimeout;
+module_param_named(notimeout, i8042_notimeout, bool, 0);
+MODULE_PARM_DESC(notimeout, "Ignore timeouts signalled by i8042");
+
 #ifdef CONFIG_X86
 static bool i8042_dritek;
 module_param_named(dritek, i8042_dritek, bool, 0);
@@ -434,7 +438,7 @@ static irqreturn_t i8042_interrupt(int i
 	} else {
 
 		dfl = ((str & I8042_STR_PARITY) ? SERIO_PARITY : 0) |
-		      ((str & I8042_STR_TIMEOUT) ? SERIO_TIMEOUT : 0);
+		      ((str & I8042_STR_TIMEOUT && !i8042_notimeout) ? SERIO_TIMEOUT : 0);
 
 		port_no = (str & I8042_STR_AUXDATA) ?
 				I8042_AUX_PORT_NO : I8042_KBD_PORT_NO;


