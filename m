Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab2F1V3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 17:29:12 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:48276 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2F1V3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 17:29:11 -0400
X-Greylist: delayed 1859 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2012 17:29:11 EDT
X-SMTPAUTH-GN: [zoltan.kelemen@privat.utfors.se]
X-SENDER-IP: [78.82.105.213]
X-LISTENER: [smtp.glocalnet.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAH7E7E9OUmnV/2dsb2JhbAANOLozLwE8FhgDAgECAUwMAQUCAQHBN5FBA45HmU8
X-IronPort-AV: E=Sophos;i="4.77,494,1336341600"; 
   d="scan'208";a="144716434"
Message-ID: <4FECC562.6060105@digisec.se>
Date: Thu, 28 Jun 2012 22:58:10 +0200
From: Zoltan Kelemen <zoltan@digisec.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: willy@meta-x.org, gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging:panel: Add support for APEX lcd/keypad
Content-Type: multipart/mixed;
 boundary="------------070408080707090404070500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070408080707090404070500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------070408080707090404070500
Content-Type: text/plain;
 name="panel-patch2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="panel-patch2"

Patch containing the following changes:
* Adds support for lcd/keypad from Taiwanese company APEX. 
* Fixes lcd type constants in code to match the ones in Kconfig.

This patch depends on patch 1 and should therefore be applied after it.

Signed-off-by: Zoltan Kelemen <zoltan@digisec.se>
----
diff -ru linux-next/drivers/staging/panel/Kconfig panel-patch2/drivers/staging/panel/Kconfig
--- linux-next/drivers/staging/panel/Kconfig	2012-06-28 13:05:05.196967738 +0200
+++ panel-patch2/drivers/staging/panel/Kconfig	2012-06-28 13:10:37.274466384 +0200
@@ -23,9 +23,9 @@
 	  and so on.
 
 config PANEL_PROFILE
-	int "Default panel profile (0-5, 0=custom)"
+	int "Default panel profile (0-6, 0=custom)"
 	depends on PANEL
-	range 0 5
+	range 0 6
 	default "5"
 	---help---
 	  To ease configuration, the driver supports different configuration
@@ -39,6 +39,7 @@
 	    3 = 2x16 parallel LCD (Hantronix), no keypad
 	    4 = 2x16 parallel LCD (Nexcom NSA1045) with Nexcom's keypad
 	    5 = 2x40 parallel LCD (old one), with old keypad
+	    6 = 2x20 parallel LCD (APEX) with APEX's keypad
 
 	  Custom configurations allow you to define how your display is
 	  wired to the parallel port, and how it works. This is only intended
@@ -46,8 +47,8 @@
 
 config PANEL_KEYPAD
 	depends on PANEL && PANEL_PROFILE="0"
-	int "Keypad type (0=none, 1=old 6 keys, 2=new 6 keys, 3=Nexcom 4 keys)"
-	range 0 3
+	int "Keypad type (0=none, 1=old 6 keys, 2=new 6 keys, 3=Nexcom 4 keys, 4=APEX 4 keys)"
+	range 0 4
 	default 0
 	---help---
 	  This enables and configures a keypad connected to the parallel port.
@@ -57,14 +58,15 @@
 	    1 : old 6 keys keypad
 	    2 : new 6 keys keypad, as used on the server at www.ant-computing.com
 	    3 : Nexcom NSA1045's 4 keys keypad
+	    4 : APEX 4 keys keypad
 
 	  New profiles can be described in the driver source. The driver also
 	  supports simultaneous keys pressed when the keypad supports them.
 
 config PANEL_LCD
 	depends on PANEL && PANEL_PROFILE="0"
-	int "LCD type (0=none, 1=custom, 2=old //, 3=ks0074, 4=hantronix, 5=Nexcom)"
-	range 0 5
+	int "LCD type (0=none, 1=custom, 2=old, 3=ks0074, 4=hantronix, 5=Nexcom, 6=APEX)"
+	range 0 6
 	default 0
 	---help---
 	   This enables and configures an LCD connected to the parallel port.
@@ -79,6 +81,7 @@
 	     3 : 2x16 serial LCD (KS-0074 based)
 	     4 : 2x16 parallel LCD (Hantronix wiring)
 	     5 : 2x16 parallel LCD (Nexcom wiring)
+             6 : 2x20 parallel LCD (APEX wiring)
 
 	   When type '1' is specified, other options will appear to configure
 	   more precise aspects (wiring, dimensions, protocol, ...). Please note
diff -ru linux-next/drivers/staging/panel/panel.c panel-patch2/drivers/staging/panel/panel.c
--- linux-next/drivers/staging/panel/panel.c	2012-06-28 13:07:14.824466481 +0200
+++ panel-patch2/drivers/staging/panel/panel.c	2012-06-28 13:10:37.274466384 +0200
@@ -307,11 +307,12 @@
  * LCD types
  */
 #define LCD_TYPE_NONE		0
-#define LCD_TYPE_OLD		1
-#define LCD_TYPE_KS0074		2
-#define LCD_TYPE_HANTRONIX	3
-#define LCD_TYPE_NEXCOM		4
-#define LCD_TYPE_CUSTOM		5
+#define LCD_TYPE_CUSTOM		1
+#define LCD_TYPE_OLD		2
+#define LCD_TYPE_KS0074		3
+#define LCD_TYPE_HANTRONIX	4
+#define LCD_TYPE_NEXCOM		5
+#define LCD_TYPE_APEX		6
 
 /*
  * keypad types
@@ -320,6 +321,7 @@
 #define KEYPAD_TYPE_OLD		1
 #define KEYPAD_TYPE_NEW		2
 #define KEYPAD_TYPE_NEXCOM	3
+#define KEYPAD_TYPE_APEX	4
 
 /*
  * panel profiles
@@ -330,6 +332,7 @@
 #define PANEL_PROFILE_HANTRONIX	3
 #define PANEL_PROFILE_NEXCOM	4
 #define PANEL_PROFILE_LARGE	5
+#define PANEL_PROFILE_APEX	6
 
 /*
  * Construct custom config from the kernel's configuration
@@ -468,8 +471,8 @@
 static int lcd_type = -1;
 module_param(lcd_type, int, 0000);
 MODULE_PARM_DESC(lcd_type,
-		 "LCD type: 0=none, 1=old //, 2=serial ks0074, "
-		 "3=hantronix //, 4=nexcom //, 5=compiled-in");
+		 "LCD type: 0=none, 1=custom, 2=old, 3=serial ks0074, "
+		 "4=hantronix, 5=nexcom, 6=apex");
 
 static int lcd_proto = -1;
 module_param(lcd_proto, int, 0000);
@@ -485,7 +488,7 @@
 module_param(keypad_type, int, 0000);
 MODULE_PARM_DESC(keypad_type,
 		 "Keypad type: 0=none, 1=old 6 keys, 2=new 6+1 keys, "
-		 "3=nexcom 4 keys");
+		 "3=nexcom 4 keys, 4=apex 4 keys");
 
 static int profile = DEFAULT_PROFILE;
 module_param(profile, int, 0000);
@@ -610,6 +613,16 @@
 	{"", "", "", ""}
 };
 
+/* signals, press, repeat, release */
+char apex_keypad_profile[][4][9] = {
+	{"a-p-E-", "Left\n", "Left\n", ""},
+	{"a-P-E-", "Up\n", "Up\n", ""},
+	{"a-P-e-", "Down\n", "Down\n", ""},
+	{"a-p-e-", "Right\n", "Right\n", ""},
+	/* add new signals above this line */
+	{"", "", "", ""}
+};
+
 static char (*keypad_profile)[4][9] = old_keypad_profile;
 
 /* FIXME: this should be converted to a bit array containing signals states */
@@ -1503,6 +1516,7 @@
 			lcd_height = 2;
 		break;
 	case LCD_TYPE_NEXCOM:
+	case LCD_TYPE_APEX:
 		/* parallel mode, 8 bits, generic */
 		if (lcd_proto < 0)
 			lcd_proto = LCD_PROTO_PARALLEL;
@@ -1514,9 +1528,11 @@
 			lcd_rs_pin = PIN_SELECP;
 		if (lcd_rw_pin == PIN_NOT_SET)
 			lcd_rw_pin = PIN_INITP;
+		if (lcd_type == LCD_TYPE_APEX && lcd_bl_pin == PIN_NOT_SET)
+			lcd_bl_pin = PIN_STROBE;
 
 		if (lcd_width < 0)
-			lcd_width = 16;
+			lcd_width = (lcd_type == LCD_TYPE_NEXCOM) ? 16 : 20;
 		if (lcd_bwidth < 0)
 			lcd_bwidth = 40;
 		if (lcd_hwidth < 0)
@@ -2487,6 +2503,13 @@
 		if (lcd_type < 0)
 			lcd_type = LCD_TYPE_OLD;
 		break;
+	case PANEL_PROFILE_APEX:
+		/* generic 8 bits, 2*20, APEX keypad */
+		if (keypad_type < 0)
+			keypad_type = KEYPAD_TYPE_APEX;
+		if (lcd_type < 0)
+			lcd_type = LCD_TYPE_APEX;
+		break;
 	}
 
 	lcd_enabled = (lcd_type > 0);
@@ -2502,6 +2525,9 @@
 	case KEYPAD_TYPE_NEXCOM:
 		keypad_profile = nexcom_keypad_profile;
 		break;
+	case KEYPAD_TYPE_APEX:
+		keypad_profile = apex_keypad_profile;
+		break;
 	}
 
 	lcd_init_globals();

--------------070408080707090404070500--
