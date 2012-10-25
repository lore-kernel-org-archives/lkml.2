Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab2JYOOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:14:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61800 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140Ab2JYOLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:11:04 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] HID: hid-input: add usage_index argument in input_mapping and event.
Date: Thu, 25 Oct 2012 16:09:41 +0200
Message-Id: <1351174189-24719-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there is no way to know the index of the current field
in the .input_mapping and .event callbacks  when this field is inside
an array of HID fields.
This patch transfers this index to the input_mapping and event
callbacks.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-a4tech.c       |  2 +-
 drivers/hid/hid-apple.c        |  4 ++--
 drivers/hid/hid-belkin.c       |  2 +-
 drivers/hid/hid-cherry.c       |  2 +-
 drivers/hid/hid-chicony.c      |  2 +-
 drivers/hid/hid-core.c         | 16 +++++++++++-----
 drivers/hid/hid-cypress.c      |  2 +-
 drivers/hid/hid-ezkey.c        |  4 ++--
 drivers/hid/hid-gyration.c     |  4 ++--
 drivers/hid/hid-input.c        | 10 ++++++----
 drivers/hid/hid-kensington.c   |  2 +-
 drivers/hid/hid-lcpower.c      |  2 +-
 drivers/hid/hid-lenovo-tpkbd.c |  3 ++-
 drivers/hid/hid-lg.c           |  4 ++--
 drivers/hid/hid-magicmouse.c   |  3 ++-
 drivers/hid/hid-microsoft.c    |  4 ++--
 drivers/hid/hid-monterey.c     |  2 +-
 drivers/hid/hid-multitouch.c   |  4 ++--
 drivers/hid/hid-ntrig.c        |  4 +++-
 drivers/hid/hid-petalynx.c     |  2 +-
 drivers/hid/hid-prodikeys.c    |  2 +-
 drivers/hid/hid-samsung.c      |  2 +-
 drivers/hid/hid-speedlink.c    |  6 +++---
 drivers/hid/hid-sunplus.c      |  2 +-
 drivers/hid/hid-tivo.c         |  2 +-
 drivers/hid/hid-topseed.c      |  2 +-
 drivers/hid/hid-twinhan.c      |  2 +-
 include/linux/hid.h            |  6 ++++--
 28 files changed, 58 insertions(+), 44 deletions(-)

diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 902d1df..b7aa5a2 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -49,7 +49,7 @@ static int a4_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int a4_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	struct a4tech_sc *a4 = hid_get_drvdata(hdev);
 	struct input_dev *input;
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 585344b..cb5eeae 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -248,7 +248,7 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 }
 
 static int apple_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 
@@ -311,7 +311,7 @@ static void apple_setup_input(struct input_dev *input)
 
 static int apple_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if (usage->hid == (HID_UP_CUSTOM | 0x0003)) {
 		/* The fn key on Apple USB keyboards */
diff --git a/drivers/hid/hid-belkin.c b/drivers/hid/hid-belkin.c
index a1a765a..5a68ad4 100644
--- a/drivers/hid/hid-belkin.c
+++ b/drivers/hid/hid-belkin.c
@@ -29,7 +29,7 @@
 					EV_KEY, (c))
 static int belkin_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index 888ece6..1b26dd0 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -41,7 +41,7 @@ static __u8 *ch_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 					EV_KEY, (c))
 static int ch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
diff --git a/drivers/hid/hid-chicony.c b/drivers/hid/hid-chicony.c
index a2abb8e..4510ea5 100644
--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -27,7 +27,7 @@
 					EV_KEY, (c))
 static int ch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_MSVENDOR)
 		return 0;
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index b2533f1..93c893b 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1009,7 +1009,8 @@ static int hid_match_usage(struct hid_device *hid, struct hid_usage *usage)
 }
 
 static void hid_process_event(struct hid_device *hid, struct hid_field *field,
-		struct hid_usage *usage, __s32 value, int interrupt)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value,
+		int interrupt)
 {
 	struct hid_driver *hdrv = hid->driver;
 	int ret;
@@ -1018,7 +1019,7 @@ static void hid_process_event(struct hid_device *hid, struct hid_field *field,
 		hid_dump_input(hid, usage, value);
 
 	if (hdrv && hdrv->event && hid_match_usage(hid, usage)) {
-		ret = hdrv->event(hid, field, usage, value);
+		ret = hdrv->event(hid, field, usage, usage_index, value);
 		if (ret != 0) {
 			if (ret < 0)
 				hid_err(hid, "%s's event failed with %d\n",
@@ -1071,19 +1072,24 @@ static void hid_input_field(struct hid_device *hid, struct hid_field *field,
 	for (n = 0; n < count; n++) {
 
 		if (HID_MAIN_ITEM_VARIABLE & field->flags) {
-			hid_process_event(hid, field, &field->usage[n], value[n], interrupt);
+			hid_process_event(hid, field, &field->usage[n], n,
+				value[n], interrupt);
 			continue;
 		}
 
 		if (field->value[n] >= min && field->value[n] <= max
 			&& field->usage[field->value[n] - min].hid
 			&& search(value, field->value[n], count))
-				hid_process_event(hid, field, &field->usage[field->value[n] - min], 0, interrupt);
+				hid_process_event(hid, field,
+					&field->usage[field->value[n] - min], n,
+					0, interrupt);
 
 		if (value[n] >= min && value[n] <= max
 			&& field->usage[value[n] - min].hid
 			&& search(field->value, value[n], count))
-				hid_process_event(hid, field, &field->usage[value[n] - min], 1, interrupt);
+				hid_process_event(hid, field,
+					&field->usage[value[n] - min], n,
+					1, interrupt);
 	}
 
 	memcpy(field->value, value, count * sizeof(__s32));
diff --git a/drivers/hid/hid-cypress.c b/drivers/hid/hid-cypress.c
index 9e43aac..e3c8569 100644
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -71,7 +71,7 @@ static int cp_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int cp_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
diff --git a/drivers/hid/hid-ezkey.c b/drivers/hid/hid-ezkey.c
index ca1163e..664f4fd 100644
--- a/drivers/hid/hid-ezkey.c
+++ b/drivers/hid/hid-ezkey.c
@@ -28,7 +28,7 @@
 
 static int ez_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -49,7 +49,7 @@ static int ez_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int ez_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !field->hidinput ||
 			!usage->type)
diff --git a/drivers/hid/hid-gyration.c b/drivers/hid/hid-gyration.c
index e88b951..7d27943 100644
--- a/drivers/hid/hid-gyration.c
+++ b/drivers/hid/hid-gyration.c
@@ -27,7 +27,7 @@
 					EV_KEY, (c))
 static int gyration_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
 		return 0;
@@ -56,7 +56,7 @@ static int gyration_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int gyration_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 
 	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !field->hidinput)
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index fc9f2b5..16cc89a 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -464,7 +464,8 @@ static void hidinput_cleanup_battery(struct hid_device *dev)
 #endif	/* CONFIG_HID_BATTERY_STRENGTH */
 
 static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_field *field,
-				     struct hid_usage *usage)
+				     struct hid_usage *usage,
+				     unsigned int usage_index)
 {
 	struct input_dev *input = hidinput->input;
 	struct hid_device *device = input_get_drvdata(input);
@@ -484,7 +485,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 
 	if (device->driver->input_mapping) {
 		int ret = device->driver->input_mapping(device, hidinput, field,
-				usage, &bit, &max);
+				usage, usage_index, &bit, &max);
 		if (ret > 0)
 			goto mapped;
 		if (ret < 0)
@@ -1233,8 +1234,9 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 
 			for (i = 0; i < report->maxfield; i++)
 				for (j = 0; j < report->field[i]->maxusage; j++)
-					hidinput_configure_usage(hidinput, report->field[i],
-								 report->field[i]->usage + j);
+					hidinput_configure_usage(hidinput,
+						report->field[i],
+						report->field[i]->usage + j, j);
 
 			if (hid->quirks & HID_QUIRK_MULTI_INPUT) {
 				/* This will leave hidinput NULL, so that it
diff --git a/drivers/hid/hid-kensington.c b/drivers/hid/hid-kensington.c
index a5b4016..af9b9da 100644
--- a/drivers/hid/hid-kensington.c
+++ b/drivers/hid/hid-kensington.c
@@ -22,7 +22,7 @@
 
 static int ks_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_MSVENDOR)
 		return 0;
diff --git a/drivers/hid/hid-lcpower.c b/drivers/hid/hid-lcpower.c
index c4fe9bd0..d499a0a 100644
--- a/drivers/hid/hid-lcpower.c
+++ b/drivers/hid/hid-lcpower.c
@@ -22,7 +22,7 @@
 					EV_KEY, (c))
 static int ts_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != 0x0ffbc0000)
 		return 0;
diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index 60c4e1e..86ea802 100644
--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -39,7 +39,8 @@ struct tpkbd_data_pointer {
 
 static int tpkbd_input_mapping(struct hid_device *hdev,
 		struct hid_input *hi, struct hid_field *field,
-		struct hid_usage *usage, unsigned long **bit, int *max)
+		struct hid_usage *usage, unsigned int usage_index,
+		unsigned long **bit, int *max)
 {
 	struct usbhid_device *uhdev;
 
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index fc37ed6..cdcd4d5 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -264,7 +264,7 @@ static int lg_wireless_mapping(struct hid_input *hi, struct hid_usage *usage,
 
 static int lg_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	/* extended mapping for certain Logitech hardware (Logitech cordless
 	   desktop LX500) */
@@ -333,7 +333,7 @@ static int lg_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int lg_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	struct lg_drv_data *drv_data = (struct lg_drv_data *)hid_get_drvdata(hdev);
 
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 25ddf3e..aca56ee 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -447,7 +447,8 @@ static int magicmouse_setup_input(struct input_dev *input, struct hid_device *hd
 
 static int magicmouse_input_mapping(struct hid_device *hdev,
 		struct hid_input *hi, struct hid_field *field,
-		struct hid_usage *usage, unsigned long **bit, int *max)
+		struct hid_usage *usage, unsigned int usage_index,
+		unsigned long **bit, int *max)
 {
 	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
 
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index e5c699b..62304e1 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -90,7 +90,7 @@ static int ms_presenter_8k_quirk(struct hid_input *hi, struct hid_usage *usage,
 
 static int ms_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
@@ -123,7 +123,7 @@ static int ms_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int ms_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index dedf757..513cd1b 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -36,7 +36,7 @@ static __u8 *mr_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 					EV_KEY, (c))
 static int mr_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 9a0804b..1382554 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -314,7 +314,7 @@ static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
 
 static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
 	struct mt_class *cls = &td->mtclass;
@@ -520,7 +520,7 @@ static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
 }
 
 static int mt_event(struct hid_device *hid, struct hid_field *field,
-				struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	struct mt_device *td = hid_get_drvdata(hid);
 	__s32 quirks = td->mtclass.quirks;
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 9fae2eb..b0b66606 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -456,6 +456,7 @@ static struct attribute_group ntrig_attribute_group = {
 
 static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			       struct hid_field *field, struct hid_usage *usage,
+			       unsigned int usage_index,
 			       unsigned long **bit, int *max)
 {
 	struct ntrig_data *nd = hid_get_drvdata(hdev);
@@ -567,7 +568,8 @@ static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
  * and call input_mt_sync after each point if necessary
  */
 static int ntrig_event (struct hid_device *hid, struct hid_field *field,
-			struct hid_usage *usage, __s32 value)
+			struct hid_usage *usage, unsigned int usage_index,
+			__s32 value)
 {
 	struct ntrig_data *nd = hid_get_drvdata(hid);
 	struct input_dev *input;
diff --git a/drivers/hid/hid-petalynx.c b/drivers/hid/hid-petalynx.c
index f1ea3ff..30aacb8 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -40,7 +40,7 @@ static __u8 *pl_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 					EV_KEY, (c))
 static int pl_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_LOGIVENDOR) {
 		switch (usage->hid & HID_USAGE) {
diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index b71b77a..2faf83a 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -757,7 +757,7 @@ static __u8 *pk_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 static int pk_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	struct pk_device *pk = (struct pk_device *)hid_get_drvdata(hdev);
 	struct pcmidi_snd *pm;
diff --git a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
index 3c1fd8a..d0dd311 100644
--- a/drivers/hid/hid-samsung.c
+++ b/drivers/hid/hid-samsung.c
@@ -141,7 +141,7 @@ static __u8 *samsung_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 static int samsung_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	struct hid_field *field, struct hid_usage *usage,
-	unsigned long **bit, int *max)
+	unsigned int usage_index, unsigned long **bit, int *max)
 {
 	int ret = 0;
 
diff --git a/drivers/hid/hid-speedlink.c b/drivers/hid/hid-speedlink.c
index 6020137..da50735 100644
--- a/drivers/hid/hid-speedlink.c
+++ b/drivers/hid/hid-speedlink.c
@@ -27,8 +27,8 @@ static const struct hid_device_id speedlink_devices[] = {
 };
 
 static int speedlink_input_mapping(struct hid_device *hdev,
-		struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned int usage_index,
 		unsigned long **bit, int *max)
 {
 	/*
@@ -45,7 +45,7 @@ static int speedlink_input_mapping(struct hid_device *hdev,
 }
 
 static int speedlink_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	/* No other conditions due to usage_table. */
 	/* Fix "jumpy" cursor (invalid events sent by device). */
diff --git a/drivers/hid/hid-sunplus.c b/drivers/hid/hid-sunplus.c
index d484a00..4e62a26 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -38,7 +38,7 @@ static __u8 *sp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		EV_KEY, (c))
 static int sp_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
diff --git a/drivers/hid/hid-tivo.c b/drivers/hid/hid-tivo.c
index 9f85f82..e7684fd 100644
--- a/drivers/hid/hid-tivo.c
+++ b/drivers/hid/hid-tivo.c
@@ -24,7 +24,7 @@
 
 static int tivo_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	switch (usage->hid & HID_USAGE_PAGE) {
 	case HID_UP_TIVOVENDOR:
diff --git a/drivers/hid/hid-topseed.c b/drivers/hid/hid-topseed.c
index 613ff7b..e924b7d 100644
--- a/drivers/hid/hid-topseed.c
+++ b/drivers/hid/hid-topseed.c
@@ -28,7 +28,7 @@
 					EV_KEY, (c))
 static int ts_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
 		return 0;
diff --git a/drivers/hid/hid-twinhan.c b/drivers/hid/hid-twinhan.c
index f23456b..b38e6b3 100644
--- a/drivers/hid/hid-twinhan.c
+++ b/drivers/hid/hid-twinhan.c
@@ -62,7 +62,7 @@
 					EV_KEY, (c))
 static int twinhan_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_KEYBOARD)
 		return 0;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 9edb06c..6216529 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -660,14 +660,16 @@ struct hid_driver {
 			u8 *data, int size);
 	const struct hid_usage_id *usage_table;
 	int (*event)(struct hid_device *hdev, struct hid_field *field,
-			struct hid_usage *usage, __s32 value);
+			struct hid_usage *usage, unsigned int usage_index,
+			__s32 value);
 
 	__u8 *(*report_fixup)(struct hid_device *hdev, __u8 *buf,
 			unsigned int *size);
 
 	int (*input_mapping)(struct hid_device *hdev,
 			struct hid_input *hidinput, struct hid_field *field,
-			struct hid_usage *usage, unsigned long **bit, int *max);
+			struct hid_usage *usage, unsigned int usage_index,
+			unsigned long **bit, int *max);
 	int (*input_mapped)(struct hid_device *hdev,
 			struct hid_input *hidinput, struct hid_field *field,
 			struct hid_usage *usage, unsigned long **bit, int *max);
-- 
1.7.11.7

