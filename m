Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946125Ab2CPXiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:38:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946110Ab2CPXiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:10 -0400
Message-Id: <20120316233448.351304539@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:34:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Dmitry Torokhov <dtor@mail.ru>,
        Corentin Chary <corentincj@iksaif.net>,
        Thomas Renninger <trenn@suse.de>, Florian Heyer <heyho@flanto.de>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [ 12/38] acer-wmi: support Lenovo ideapad S205 wifi switch
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

commit 15b956a0b5651bbb1217ec374fdd67291dabb2af upstream.

The AMW0 function in acer-wmi works on Lenovo ideapad S205 for control
the wifi hardware state. We also found there have a 0x78 EC register
exposes the state of wifi hardware switch on the machine.

So, add this patch to support Lenovo ideapad S205 wifi hardware switch
in acer-wmi driver.

Reference: bko#37892
	https://bugzilla.kernel.org/show_bug.cgi?id=37892

Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Thomas Renninger <trenn@suse.de>
Tested-by: Florian Heyer <heyho@flanto.de>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/acer-wmi.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -304,6 +304,10 @@ static struct quirk_entry quirk_fujitsu_
 	.wireless = 2,
 };
 
+static struct quirk_entry quirk_lenovo_ideapad_s205 = {
+	.wireless = 3,
+};
+
 /* The Aspire One has a dummy ACPI-WMI interface - disable it */
 static struct dmi_system_id __devinitdata acer_blacklist[] = {
 	{
@@ -450,6 +454,15 @@ static struct dmi_system_id acer_quirks[
 		},
 		.driver_data = &quirk_medion_md_98300,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Lenovo Ideapad S205",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "10382LG"),
+		},
+		.driver_data = &quirk_lenovo_ideapad_s205,
+	},
 	{}
 };
 
@@ -542,6 +555,12 @@ struct wmi_interface *iface)
 				return AE_ERROR;
 			*value = result & 0x1;
 			return AE_OK;
+		case 3:
+			err = ec_read(0x78, &result);
+			if (err)
+				return AE_ERROR;
+			*value = result & 0x1;
+			return AE_OK;
 		default:
 			err = ec_read(0xA, &result);
 			if (err)
@@ -1266,8 +1285,13 @@ static void acer_rfkill_update(struct wo
 	acpi_status status;
 
 	status = get_u32(&state, ACER_CAP_WIRELESS);
-	if (ACPI_SUCCESS(status))
-		rfkill_set_sw_state(wireless_rfkill, !state);
+	if (ACPI_SUCCESS(status)) {
+		if (quirks->wireless == 3) {
+			rfkill_set_hw_state(wireless_rfkill, !state);
+		} else {
+			rfkill_set_sw_state(wireless_rfkill, !state);
+		}
+	}
 
 	if (has_cap(ACER_CAP_BLUETOOTH)) {
 		status = get_u32(&state, ACER_CAP_BLUETOOTH);


