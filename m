Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab0DVT6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:58:12 -0400
Received: from kroah.org ([198.145.64.141]:40761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab0DVT2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:24 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:13 2010
Message-Id: <20100422190913.840741581@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Dmitry Torokhov <dtor@mail.ru>, Len Brown <len.brown@intel.com>
Subject: [072/197] thinkpad-acpi: sync input device EV_SW initial state
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit d89a727aff649f6768f7a34ee57f031ebf8bab4c upstream.

Before we register the input device, sync the input layer EV_SW state
through a call to input_report_switch(), to avoid issuing a gratuitous
event for the initial state of these switches.

This fixes some annoyances caused by the interaction with rfkill and
EV_SW SW_RFKILL_ALL events.

Reported-by: Kevin Locke <kevin@kevinlocke.name>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3188,6 +3188,8 @@ static int __init hotkey_init(struct ibm
 	int res, i;
 	int status;
 	int hkeyv;
+	bool radiosw_state  = false;
+	bool tabletsw_state = false;
 
 	unsigned long quirks;
 
@@ -3293,6 +3295,7 @@ static int __init hotkey_init(struct ibm
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_wlswemul) {
 		tp_features.hotkey_wlsw = 1;
+		radiosw_state = !!tpacpi_wlsw_emulstate;
 		printk(TPACPI_INFO
 			"radio switch emulation enabled\n");
 	} else
@@ -3300,6 +3303,7 @@ static int __init hotkey_init(struct ibm
 	/* Not all thinkpads have a hardware radio switch */
 	if (acpi_evalf(hkey_handle, &status, "WLSW", "qd")) {
 		tp_features.hotkey_wlsw = 1;
+		radiosw_state = !!status;
 		printk(TPACPI_INFO
 			"radio switch found; radios are %s\n",
 			enabled(status, 0));
@@ -3311,11 +3315,11 @@ static int __init hotkey_init(struct ibm
 	/* For X41t, X60t, X61t Tablets... */
 	if (!res && acpi_evalf(hkey_handle, &status, "MHKG", "qd")) {
 		tp_features.hotkey_tablet = 1;
+		tabletsw_state = !!(status & TP_HOTKEY_TABLET_MASK);
 		printk(TPACPI_INFO
 			"possible tablet mode switch found; "
 			"ThinkPad in %s mode\n",
-			(status & TP_HOTKEY_TABLET_MASK)?
-				"tablet" : "laptop");
+			(tabletsw_state) ? "tablet" : "laptop");
 		res = add_to_attr_set(hotkey_dev_attributes,
 				&dev_attr_hotkey_tablet_mode.attr);
 	}
@@ -3366,9 +3370,13 @@ static int __init hotkey_init(struct ibm
 
 	if (tp_features.hotkey_wlsw) {
 		input_set_capability(tpacpi_inputdev, EV_SW, SW_RFKILL_ALL);
+		input_report_switch(tpacpi_inputdev,
+				    SW_RFKILL_ALL, radiosw_state);
 	}
 	if (tp_features.hotkey_tablet) {
 		input_set_capability(tpacpi_inputdev, EV_SW, SW_TABLET_MODE);
+		input_report_switch(tpacpi_inputdev,
+				    SW_TABLET_MODE, tabletsw_state);
 	}
 
 	/* Do not issue duplicate brightness change events to
@@ -3435,8 +3443,6 @@ static int __init hotkey_init(struct ibm
 	tpacpi_inputdev->close = &hotkey_inputdev_close;
 
 	hotkey_poll_setup_safe(true);
-	tpacpi_send_radiosw_update();
-	tpacpi_input_send_tabletsw();
 
 	return 0;
 


