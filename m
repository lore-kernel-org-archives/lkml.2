Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1EXIgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:36:03 -0400
Received: from smtpout02.highway.telekom.at ([195.3.96.113]:10354 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754560Ab1EXIgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:36:00 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
Subject: [PATCH] support wlan hotkey on Acer Travelmate 5735Z
Date: Tue, 24 May 2011 10:35:55 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Joey Lee <jlee@novell.com>, Carlos Corbacho <carlos@strangeworlds.co.uk>,
        platform-driver-x86@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241035.55877@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Melchior FRANZ <mfranz@aon.at>
    
On an Acer Travelmate 5735Z-452G32Mnss the WLAN-enable/disable key
doesn't send 0x1 as acpi event key code, but 0x3. This patch also
makes the module ignore hotkey acpi events for functions that are
already handled without. This avoids warning message "keyboard:
can't emulate rawmode for keycode 240".

Signed-off-by: Melchior FRANZ <mfranz@aon.at>
---

This patch requires that Joey LEE's 64 bit fix be applied,
otherwise the whole acer-wmi module fails to load on this
machine. See https://bugzilla.kernel.org/show_bug.cgi?id=34142#c21
(0001-acer-wmi-allow-64-bits-return-buffer-from-WMI-metho.patch)


diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 6cb55a6..fb4ee5f 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -98,13 +98,26 @@ enum acer_wmi_event_ids {
 
 static const struct key_entry acer_wmi_keymap[] = {
 	{KE_KEY, 0x01, {KEY_WLAN} },     /* WiFi */
+	{KE_KEY, 0x03, {KEY_WLAN} },     /* WiFi */
 	{KE_KEY, 0x12, {KEY_BLUETOOTH} },	/* BT */
 	{KE_KEY, 0x21, {KEY_PROG1} },    /* Backup */
 	{KE_KEY, 0x22, {KEY_PROG2} },    /* Arcade */
 	{KE_KEY, 0x23, {KEY_PROG3} },    /* P_Key */
 	{KE_KEY, 0x24, {KEY_PROG4} },    /* Social networking_Key */
+	{KE_IGNORE, 0x41, {KEY_MUTE} },
+	{KE_IGNORE, 0x42, {KEY_PREVIOUSSONG} },
+	{KE_IGNORE, 0x43, {KEY_NEXTSONG} },
+	{KE_IGNORE, 0x44, {KEY_PLAYPAUSE} },
+	{KE_IGNORE, 0x45, {KEY_STOP} },
+	{KE_IGNORE, 0x48, {KEY_VOLUMEUP} },
+	{KE_IGNORE, 0x49, {KEY_VOLUMEDOWN} },
+	{KE_IGNORE, 0x61, {KEY_SWITCHVIDEOMODE} },
+	{KE_IGNORE, 0x62, {KEY_BRIGHTNESSUP} },
+	{KE_IGNORE, 0x63, {KEY_BRIGHTNESSDOWN} },
 	{KE_KEY, 0x64, {KEY_SWITCHVIDEOMODE} },	/* Display Switch */
+	{KE_IGNORE, 0x81, {KEY_SLEEP} },
 	{KE_KEY, 0x82, {KEY_TOUCHPAD_TOGGLE} },	/* Touch Pad On/Off */
+	{KE_IGNORE, 0x83, {KEY_TOUCHPAD_TOGGLE} },
 	{KE_END, 0}
 };
 
@@ -1345,7 +1358,7 @@ static void acer_wmi_notify(u32 value, void *context)
 	case WMID_HOTKEY_EVENT:
 		if (return_value.device_state) {
 			u16 device_state = return_value.device_state;
-			pr_debug("deivces states: 0x%x\n", device_state);
+			pr_debug("device state: 0x%x\n", device_state);
 			if (has_cap(ACER_CAP_WIRELESS))
 				rfkill_set_sw_state(wireless_rfkill,
 				!(device_state & ACER_WMID3_GDS_WIRELESS));
