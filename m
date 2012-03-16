Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946145Ab2CPXi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:38:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49074 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946120Ab2CPXiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:16 -0400
Message-Id: <20120316233448.529242021@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AceLan Kao <acelan.kao@canonical.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Dmitry Torokhov <dtor@mail.ru>,
        Corentin Chary <corentincj@iksaif.net>,
        Thomas Renninger <trenn@suse.de>, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [ 14/38] acer-wmi: check wireless capability flag before register rfkill
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

commit 1709adab0773616da7a8190f2762e599afb0a295 upstream.

There will be better to check the wireless capability flag
(ACER_CAP_WIRELESS) before register wireless rfkill because maybe
the machine doesn't have wifi module or the module removed by user.

Tested on Acer Travelmate 8572
Tested on Acer Aspire 4739Z

Tested-by: AceLan Kao <acelan.kao@canonical.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/acer-wmi.c |   64 ++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 22 deletions(-)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1293,12 +1293,13 @@ static void acer_rfkill_update(struct wo
 	u32 state;
 	acpi_status status;
 
-	status = get_u32(&state, ACER_CAP_WIRELESS);
-	if (ACPI_SUCCESS(status)) {
-		if (quirks->wireless == 3) {
-			rfkill_set_hw_state(wireless_rfkill, !state);
-		} else {
-			rfkill_set_sw_state(wireless_rfkill, !state);
+	if (has_cap(ACER_CAP_WIRELESS)) {
+		status = get_u32(&state, ACER_CAP_WIRELESS);
+		if (ACPI_SUCCESS(status)) {
+			if (quirks->wireless == 3)
+				rfkill_set_hw_state(wireless_rfkill, !state);
+			else
+				rfkill_set_sw_state(wireless_rfkill, !state);
 		}
 	}
 
@@ -1367,19 +1368,24 @@ static struct rfkill *acer_rfkill_regist
 
 static int acer_rfkill_init(struct device *dev)
 {
-	wireless_rfkill = acer_rfkill_register(dev, RFKILL_TYPE_WLAN,
-		"acer-wireless", ACER_CAP_WIRELESS);
-	if (IS_ERR(wireless_rfkill))
-		return PTR_ERR(wireless_rfkill);
+	int err;
+
+	if (has_cap(ACER_CAP_WIRELESS)) {
+		wireless_rfkill = acer_rfkill_register(dev, RFKILL_TYPE_WLAN,
+			"acer-wireless", ACER_CAP_WIRELESS);
+		if (IS_ERR(wireless_rfkill)) {
+			err = PTR_ERR(wireless_rfkill);
+			goto error_wireless;
+		}
+	}
 
 	if (has_cap(ACER_CAP_BLUETOOTH)) {
 		bluetooth_rfkill = acer_rfkill_register(dev,
 			RFKILL_TYPE_BLUETOOTH, "acer-bluetooth",
 			ACER_CAP_BLUETOOTH);
 		if (IS_ERR(bluetooth_rfkill)) {
-			rfkill_unregister(wireless_rfkill);
-			rfkill_destroy(wireless_rfkill);
-			return PTR_ERR(bluetooth_rfkill);
+			err = PTR_ERR(bluetooth_rfkill);
+			goto error_bluetooth;
 		}
 	}
 
@@ -1388,30 +1394,44 @@ static int acer_rfkill_init(struct devic
 			RFKILL_TYPE_WWAN, "acer-threeg",
 			ACER_CAP_THREEG);
 		if (IS_ERR(threeg_rfkill)) {
-			rfkill_unregister(wireless_rfkill);
-			rfkill_destroy(wireless_rfkill);
-			rfkill_unregister(bluetooth_rfkill);
-			rfkill_destroy(bluetooth_rfkill);
-			return PTR_ERR(threeg_rfkill);
+			err = PTR_ERR(threeg_rfkill);
+			goto error_threeg;
 		}
 	}
 
 	rfkill_inited = true;
 
-	if (ec_raw_mode || !wmi_has_guid(ACERWMID_EVENT_GUID))
+	if ((ec_raw_mode || !wmi_has_guid(ACERWMID_EVENT_GUID)) &&
+	    has_cap(ACER_CAP_WIRELESS | ACER_CAP_BLUETOOTH | ACER_CAP_THREEG))
 		schedule_delayed_work(&acer_rfkill_work,
 			round_jiffies_relative(HZ));
 
 	return 0;
+
+error_threeg:
+	if (has_cap(ACER_CAP_BLUETOOTH)) {
+		rfkill_unregister(bluetooth_rfkill);
+		rfkill_destroy(bluetooth_rfkill);
+	}
+error_bluetooth:
+	if (has_cap(ACER_CAP_WIRELESS)) {
+		rfkill_unregister(wireless_rfkill);
+		rfkill_destroy(wireless_rfkill);
+	}
+error_wireless:
+	return err;
 }
 
 static void acer_rfkill_exit(void)
 {
-	if (ec_raw_mode || !wmi_has_guid(ACERWMID_EVENT_GUID))
+	if ((ec_raw_mode || !wmi_has_guid(ACERWMID_EVENT_GUID)) &&
+	    has_cap(ACER_CAP_WIRELESS | ACER_CAP_BLUETOOTH | ACER_CAP_THREEG))
 		cancel_delayed_work_sync(&acer_rfkill_work);
 
-	rfkill_unregister(wireless_rfkill);
-	rfkill_destroy(wireless_rfkill);
+	if (has_cap(ACER_CAP_WIRELESS)) {
+		rfkill_unregister(wireless_rfkill);
+		rfkill_destroy(wireless_rfkill);
+	}
 
 	if (has_cap(ACER_CAP_BLUETOOTH)) {
 		rfkill_unregister(bluetooth_rfkill);


