Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab2JZIo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:44:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36011 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab2JZIok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:44:40 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/11] HID: hid-input: add usage_index argument in input_mapping and event.
Date: Fri, 26 Oct 2012 10:44:19 +0200
Message-Id: <1351241067-9521-4-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there is no way to know the index of the current field
in the .input_mapping and .event callbacks  when this field is inside
an array of HID fields.
This patch forwards this index to the input_mapping and event
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
 drivers/hid/hid-ps3remote.c    |  3 ++-
 drivers/hid/hid-samsung.c      |  2 +-
 drivers/hid/hid-speedlink.c    |  6 +++---
 drivers/hid/hid-sunplus.c      |  2 +-
 drivers/hid/hid-tivo.c         |  2 +-
 drivers/hid/hid-topseed.c      |  2 +-
 drivers/hid/hid-twinhan.c      |  2 +-
 drivers/hid/hid-zydacron.c     |  2 +-
 include/linux/hid.h            |  6 ++++--
 30 files changed, 61 insertions(+), 46 deletions(-)

diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 0a23988..62e2aa5 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -48,7 +48,7 @@ static int a4_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int a4_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	struct a4tech_sc *a4 = hid_get_drvdata(hdev);
 	struct input_dev *input;
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 06ebdbb..01e8592 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -247,7 +247,7 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 }
 
 static int apple_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 
@@ -310,7 +310,7 @@ static void apple_setup_input(struct input_dev *input)
 
 static int apple_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if (usage->hid == (HID_UP_CUSTOM | 0x0003)) {
 		/* The fn key on Apple USB keyboards */
diff --git a/drivers/hid/hid-belkin.c b/drivers/hid/hid-belkin.c
index a1a5a12..6999a64 100644
--- a/drivers/hid/hid-belkin.c
+++ b/drivers/hid/hid-belkin.c
@@ -28,7 +28,7 @@
 					EV_KEY, (c))
 static int belkin_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index af034d3..1feec49 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -40,7 +40,7 @@ static __u8 *ch_report_fixup(struct hid_device *hdev, __u8 *rdesc,
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
index 6bde6e4..f1720a0 100644
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
index 3e159a5..453548a 100644
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -70,7 +70,7 @@ static int cp_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int cp_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
diff --git a/drivers/hid/hid-ezkey.c b/drivers/hid/hid-ezkey.c
index 6540af2..3bd9675 100644
--- a/drivers/hid/hid-ezkey.c
+++ b/drivers/hid/hid-ezkey.c
@@ -27,7 +27,7 @@
 
 static int ez_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -48,7 +48,7 @@ static int ez_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int ez_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !field->hidinput ||
 			!usage->type)
diff --git a/drivers/hid/hid-gyration.c b/drivers/hid/hid-gyration.c
index 4442c30..255e5dd 100644
--- a/drivers/hid/hid-gyration.c
+++ b/drivers/hid/hid-gyration.c
@@ -26,7 +26,7 @@
 					EV_KEY, (c))
 static int gyration_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
 		return 0;
@@ -55,7 +55,7 @@ static int gyration_input_mapping(struct hid_device *hdev, struct hid_input *hi,
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
index 22bc14a..5cfbef8 100644
--- a/drivers/hid/hid-lcpower.c
+++ b/drivers/hid/hid-lcpower.c
@@ -22,7 +22,7 @@
 					EV_KEY, (c))
 static int ts_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
 		return 0;
diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index cea016e..7c12fd4 100644
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
index a2f8e88..0c5acc6 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -263,7 +263,7 @@ static int lg_wireless_mapping(struct hid_input *hi, struct hid_usage *usage,
 
 static int lg_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	/* extended mapping for certain Logitech hardware (Logitech cordless
 	   desktop LX500) */
@@ -332,7 +332,7 @@ static int lg_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int lg_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	struct lg_drv_data *drv_data = hid_get_drvdata(hdev);
 
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
index 3acdcfc..2dfe9fa 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -89,7 +89,7 @@ static int ms_presenter_8k_quirk(struct hid_input *hi, struct hid_usage *usage,
 
 static int ms_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
@@ -122,7 +122,7 @@ static int ms_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int ms_event(struct hid_device *hdev, struct hid_field *field,
-		struct hid_usage *usage, __s32 value)
+		struct hid_usage *usage, unsigned int usage_index, __s32 value)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index cd3643e..cbcbcc7 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -35,7 +35,7 @@ static __u8 *mr_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 					EV_KEY, (c))
 static int mr_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 375a38d..725d155 100644
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
index 86a969f..14794b9 100644
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
index 4c521de..590db7d 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -39,7 +39,7 @@ static __u8 *pl_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 					EV_KEY, (c))
 static int pl_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_LOGIVENDOR) {
 		switch (usage->hid & HID_USAGE) {
diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index ec8ca33..b687f4e 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -757,7 +757,7 @@ static __u8 *pk_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 static int pk_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+		unsigned int usage_index, unsigned long **bit, int *max)
 {
 	struct pk_device *pk = hid_get_drvdata(hdev);
 	struct pcmidi_snd *pm;
diff --git a/drivers/hid/hid-ps3remote.c b/drivers/hid/hid-ps3remote.c
index 03811e5..24d3196 100644
--- a/drivers/hid/hid-ps3remote.c
+++ b/drivers/hid/hid-ps3remote.c
@@ -151,7 +151,8 @@ static __u8 *ps3remote_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 static int ps3remote_mapping(struct hid_device *hdev, struct hid_input *hi,
 			     struct hid_field *field, struct hid_usage *usage,
-			     unsigned long **bit, int *max)
+			     unsigned int usage_index, unsigned long **bit,
+			     int *max)
 {
 	unsigned int key = usage->hid & HID_USAGE;
 
diff --git a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
index a5821d3..b88a27a 100644
--- a/drivers/hid/hid-samsung.c
+++ b/drivers/hid/hid-samsung.c
@@ -140,7 +140,7 @@ static __u8 *samsung_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
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
index 45b4b06..9d36bc0 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -37,7 +37,7 @@ static __u8 *sp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
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
diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
index 1ad85f2..af0e171 100644
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -47,7 +47,7 @@ static __u8 *zc_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 static int zc_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	struct hid_field *field, struct hid_usage *usage,
-	unsigned long **bit, int *max)
+	unsigned int usage_index, unsigned long **bit, int *max)
 {
 	int i;
 	struct zc_device *zc = hid_get_drvdata(hdev);
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

