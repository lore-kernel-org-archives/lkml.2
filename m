Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2D2Pdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 11:33:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41118 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab2D2Pd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 11:33:29 -0400
Message-ID: <4F9D5F43.4000502@gmail.com>
Date: Sun, 29 Apr 2012 18:33:23 +0300
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] hid: Enable report fixup on rebind
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1204222325380.1856@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1204222325380.1856@pobox.suse.cz>
Content-Type: multipart/mixed;
 boundary="------------060705090208060508010100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060705090208060508010100
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/23/2012 12:27 AM, Jiri Kosina wrote:
> On Sun, 22 Apr 2012, Henrik Rydberg wrote:
>
>> This patchset contains a resolution to the problem with
>> driver-specific modification of the report descriptor. The core of the
>> problem lies with the dual semantics of hid_parse_report(), which is
>> therefore split into two functions. As a consequence, the hid core can
>> handle the rebind case internally, with no changes to the
>> drivers. Out-of-tree drivers will work fine as long as they operate in
>> the same way as the in-kernel drivers.
>>
>> The first two patches are bug fixes found in the process. I am hoping
>> for some test feedback on those. The third patch is the main one.

I've tested the last patch and it seems to work as required. I did a series
of generic<->specific driver rebindings both ways in a loop and it works.

So,
Tested-by: Nikolai Kondrashov <spbnick@gmail.com>

Thanks Henrik!

I'm not sure, though, if one thing works as it should: the quirks are not
reset when changing the driver. So, quirks set by one driver may affect
behavior of another. I don't understand full quirks usage and ownership yet,
so can't argue if this is right or wrong.

Regarding the code, could it be the time to fix naming of report
descriptor-handling functions to improve distinction from report-handling
ones? I'm attaching a patch applying on top of Henrik's changes which should
illustrate the proposal.

Thanks!

Sincerely,
Nick

--------------060705090208060508010100
Content-Type: text/x-patch;
 name="0001-hid-Differentiate-report-descriptors-and-reports.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-hid-Differentiate-report-descriptors-and-reports.patch"

>From 2423f42177f13d1b27eac8e4168c39afbd937114 Mon Sep 17 00:00:00 2001
From: Nikolai Kondrashov <spbnick@gmail.com>
Date: Sun, 29 Apr 2012 17:51:21 +0300
Subject: [PATCH 1/1] hid: Differentiate report descriptors and reports

Improve distinction between report descriptors and reports:
  * rename hid_(open|parse|close)_report to hid_(open|parse|close)_rdesc,
  * rename "report_fixup" hid_driver callback to "rdesc_fixup",
  * refine relevant comments.

Signed-off-by: Nikolai Kondrashov <spbnick@gmail.com>
---
 drivers/hid/hid-apple.c       |    4 ++--
 drivers/hid/hid-cherry.c      |    4 ++--
 drivers/hid/hid-core.c        |   44 ++++++++++++++++++++---------------------
 drivers/hid/hid-cypress.c     |    4 ++--
 drivers/hid/hid-dr.c          |    4 ++--
 drivers/hid/hid-elecom.c      |    4 ++--
 drivers/hid/hid-hyperv.c      |    2 +-
 drivers/hid/hid-keytouch.c    |    4 ++--
 drivers/hid/hid-kye.c         |    4 ++--
 drivers/hid/hid-lg.c          |    4 ++--
 drivers/hid/hid-logitech-dj.c |    2 +-
 drivers/hid/hid-microsoft.c   |    4 ++--
 drivers/hid/hid-monterey.c    |    4 ++--
 drivers/hid/hid-ortek.c       |    4 ++--
 drivers/hid/hid-petalynx.c    |    4 ++--
 drivers/hid/hid-prodikeys.c   |    4 ++--
 drivers/hid/hid-saitek.c      |    4 ++--
 drivers/hid/hid-samsung.c     |    8 ++++----
 drivers/hid/hid-sony.c        |    4 ++--
 drivers/hid/hid-sunplus.c     |    4 ++--
 drivers/hid/hid-uclogic.c     |    4 ++--
 drivers/hid/hid-waltop.c      |    4 ++--
 drivers/hid/hid-zydacron.c    |    4 ++--
 drivers/hid/usbhid/hid-core.c |    2 +-
 include/linux/hid.h           |   18 ++++++++---------
 net/bluetooth/hidp/core.c     |    2 +-
 26 files changed, 77 insertions(+), 77 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 299d238..c2a1641 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -275,7 +275,7 @@ static int apple_event(struct hid_device *hdev, struct hid_field *field,
 /*
  * MacBook JIS keyboard has wrong logical maximum
  */
-static __u8 *apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *apple_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	struct apple_sc *asc = hid_get_drvdata(hdev);
@@ -533,7 +533,7 @@ MODULE_DEVICE_TABLE(hid, apple_devices);
 static struct hid_driver apple_driver = {
 	.name = "apple",
 	.id_table = apple_devices,
-	.report_fixup = apple_report_fixup,
+	.rdesc_fixup = apple_rdesc_fixup,
 	.probe = apple_probe,
 	.remove = apple_remove,
 	.event = apple_event,
diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index 888ece6..3c42b66 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -26,7 +26,7 @@
  * Cherry Cymotion keyboard have an invalid HID report descriptor,
  * that needs fixing before we can parse it.
  */
-static __u8 *ch_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *ch_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 17 && rdesc[11] == 0x3c && rdesc[12] == 0x02) {
@@ -67,7 +67,7 @@ MODULE_DEVICE_TABLE(hid, ch_devices);
 static struct hid_driver ch_driver = {
 	.name = "cherry",
 	.id_table = ch_devices,
-	.report_fixup = ch_report_fixup,
+	.rdesc_fixup = ch_rdesc_fixup,
 	.input_mapping = ch_input_mapping,
 };
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9ed4ff3..e44d588 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -546,10 +546,10 @@ static void hid_free_report(struct hid_report *report)
 }
 
 /*
- * Close report. This function returns the device
- * state to the point prior to hid_open_report().
+ * Close report descriptor. This function returns the device
+ * state to the point prior to hid_open_rdesc().
  */
-static void hid_close_report(struct hid_device *device)
+static void hid_close_rdesc(struct hid_device *device)
 {
 	unsigned i, j;
 
@@ -586,7 +586,7 @@ static void hid_device_release(struct device *dev)
 {
 	struct hid_device *hid = container_of(dev, struct hid_device, dev);
 
-	hid_close_report(hid);
+	hid_close_rdesc(hid);
 	kfree(hid->dev_rdesc);
 	kfree(hid);
 }
@@ -659,16 +659,16 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
 }
 
 /**
- * hid_parse_report - parse device report
+ * hid_parse_rdesc - parse device report descriptor
  *
  * @device: hid device
- * @start: report start
- * @size: report size
+ * @start: report descriptor start
+ * @size: report descriptor size
  *
- * Allocate the device report as read by the bus driver. This function should
- * only be called from parse() in ll drivers.
+ * Allocate the device report descriptor as read by the bus driver.
+ * This function should only be called from parse() in ll drivers.
  */
-int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size)
+int hid_parse_rdesc(struct hid_device *hid, __u8 *start, unsigned size)
 {
 	hid->dev_rdesc = kmemdup(start, size, GFP_KERNEL);
 	if (!hid->dev_rdesc)
@@ -676,21 +676,21 @@ int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size)
 	hid->dev_rsize = size;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(hid_parse_report);
+EXPORT_SYMBOL_GPL(hid_parse_rdesc);
 
 /**
- * hid_open_report - open a driver-specific device report
+ * hid_open_rdesc - open a driver-specific device report descriptor
  *
  * @device: hid device
  *
- * Parse a report description into a hid_device structure. Reports are
+ * Parse a report descriptor into a hid_device structure. Reports are
  * enumerated, fields are attached to these reports.
  * 0 returned on success, otherwise nonzero error value.
  *
  * This function (or the equivalent hid_parse() macro) should only be
  * called from probe() in drivers, before starting the device.
  */
-int hid_open_report(struct hid_device *device)
+int hid_open_rdesc(struct hid_device *device)
 {
 	struct hid_parser *parser;
 	struct hid_item item;
@@ -714,8 +714,8 @@ int hid_open_report(struct hid_device *device)
 		return -ENODEV;
 	size = device->dev_rsize;
 
-	if (device->driver->report_fixup)
-		start = device->driver->report_fixup(device, start, &size);
+	if (device->driver->rdesc_fixup)
+		start = device->driver->rdesc_fixup(device, start, &size);
 
 	device->rdesc = kmemdup(start, size, GFP_KERNEL);
 	if (device->rdesc == NULL)
@@ -773,10 +773,10 @@ int hid_open_report(struct hid_device *device)
 	hid_err(device, "item fetching failed at offset %d\n", (int)(end - start));
 err:
 	vfree(parser);
-	hid_close_report(device);
+	hid_close_rdesc(device);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(hid_open_report);
+EXPORT_SYMBOL_GPL(hid_open_rdesc);
 
 /*
  * Convert a signed n-bit integer to signed 32-bit integer. Common
@@ -1781,12 +1781,12 @@ static int hid_device_probe(struct device *dev)
 		if (hdrv->probe) {
 			ret = hdrv->probe(hdev, id);
 		} else { /* default probe */
-			ret = hid_open_report(hdev);
+			ret = hid_open_rdesc(hdev);
 			if (!ret)
 				ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 		}
 		if (ret) {
-			hid_close_report(hdev);
+			hid_close_rdesc(hdev);
 			hdev->driver = NULL;
 		}
 	}
@@ -1809,7 +1809,7 @@ static int hid_device_remove(struct device *dev)
 			hdrv->remove(hdev);
 		else /* default remove */
 			hid_hw_stop(hdev);
-		hid_close_report(hdev);
+		hid_close_rdesc(hdev);
 		hdev->driver = NULL;
 	}
 
@@ -2189,7 +2189,7 @@ struct hid_device *hid_allocate_device(void)
 	hdev->dev.release = hid_device_release;
 	hdev->dev.bus = &hid_bus_type;
 
-	hid_close_report(hdev);
+	hid_close_rdesc(hdev);
 
 	init_waitqueue_head(&hdev->debug_wait);
 	INIT_LIST_HEAD(&hdev->debug_list);
diff --git a/drivers/hid/hid-cypress.c b/drivers/hid/hid-cypress.c
index 2f0be4c..7af1f12 100644
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -31,7 +31,7 @@
  * Some USB barcode readers from cypress have usage min and usage max in
  * the wrong order
  */
-static __u8 *cp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *cp_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
@@ -138,7 +138,7 @@ MODULE_DEVICE_TABLE(hid, cp_devices);
 static struct hid_driver cp_driver = {
 	.name = "cypress",
 	.id_table = cp_devices,
-	.report_fixup = cp_report_fixup,
+	.rdesc_fixup = cp_rdesc_fixup,
 	.input_mapped = cp_input_mapped,
 	.event = cp_event,
 	.probe = cp_probe,
diff --git a/drivers/hid/hid-dr.c b/drivers/hid/hid-dr.c
index e832f44..01b9043 100644
--- a/drivers/hid/hid-dr.c
+++ b/drivers/hid/hid-dr.c
@@ -236,7 +236,7 @@ static __u8 pid0011_rdesc_fixed[] = {
 	0xC0                /*  End Collection                  */
 };
 
-static __u8 *dr_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *dr_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 				unsigned int *rsize)
 {
 	switch (hdev->product) {
@@ -294,7 +294,7 @@ MODULE_DEVICE_TABLE(hid, dr_devices);
 static struct hid_driver dr_driver = {
 	.name = "dragonrise",
 	.id_table = dr_devices,
-	.report_fixup = dr_report_fixup,
+	.rdesc_fixup = dr_rdesc_fixup,
 	.probe = dr_probe,
 };
 
diff --git a/drivers/hid/hid-elecom.c b/drivers/hid/hid-elecom.c
index 79d0c61..37ac28e 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -20,7 +20,7 @@
 
 #include "hid-ids.h"
 
-static __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *elecom_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 48 && rdesc[46] == 0x05 && rdesc[47] == 0x0c) {
@@ -39,7 +39,7 @@ MODULE_DEVICE_TABLE(hid, elecom_devices);
 static struct hid_driver elecom_driver = {
 	.name = "elecom",
 	.id_table = elecom_devices,
-	.report_fixup = elecom_report_fixup
+	.rdesc_fixup = elecom_rdesc_fixup
 };
 
 static int __init elecom_init(void)
diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 032e6c0..406c02c 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -435,7 +435,7 @@ static int mousevsc_hid_parse(struct hid_device *hid)
 	struct hv_device *dev = hid_get_drvdata(hid);
 	struct mousevsc_dev *input_dev = hv_get_drvdata(dev);
 
-	return hid_parse_report(hid, input_dev->report_desc,
+	return hid_parse_rdesc(hid, input_dev->report_desc,
 				input_dev->report_desc_size);
 }
 
diff --git a/drivers/hid/hid-keytouch.c b/drivers/hid/hid-keytouch.c
index 07cd825..2a2a49c 100644
--- a/drivers/hid/hid-keytouch.c
+++ b/drivers/hid/hid-keytouch.c
@@ -27,7 +27,7 @@ static __u8 keytouch_fixed_rdesc[] = {
 0x26, 0xff, 0x00, 0x05, 0x07, 0x19, 0x00, 0x2a, 0xff, 0x00, 0x81, 0x00, 0xc0
 };
 
-static __u8 *keytouch_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *keytouch_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	hid_info(hdev, "fixing up Keytouch IEC report descriptor\n");
@@ -47,7 +47,7 @@ MODULE_DEVICE_TABLE(hid, keytouch_devices);
 static struct hid_driver keytouch_driver = {
 	.name = "keytouch",
 	.id_table = keytouch_devices,
-	.report_fixup = keytouch_report_fixup,
+	.rdesc_fixup = keytouch_rdesc_fixup,
 };
 
 static int __init keytouch_init(void)
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index b4f0d82..1eca937 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -270,7 +270,7 @@ static __u8 easypen_m610x_rdesc_fixed[] = {
 	0xC0                          /*  End Collection                  */
 };
 
-static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *kye_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	switch (hdev->product) {
@@ -417,7 +417,7 @@ static struct hid_driver kye_driver = {
 	.name = "kye",
 	.id_table = kye_devices,
 	.probe = kye_probe,
-	.report_fixup = kye_report_fixup,
+	.rdesc_fixup = kye_rdesc_fixup,
 };
 
 static int __init kye_init(void)
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index e7a7bd1..16e3a56 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -106,7 +106,7 @@ static __u8 dfp_rdesc_fixed[] = {
  * above the logical maximum described in descriptor. This extends
  * the original value of 0x28c of logical maximum to 0x104d
  */
-static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *lg_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
@@ -485,7 +485,7 @@ MODULE_DEVICE_TABLE(hid, lg_devices);
 static struct hid_driver lg_driver = {
 	.name = "logitech",
 	.id_table = lg_devices,
-	.report_fixup = lg_report_fixup,
+	.rdesc_fixup = lg_rdesc_fixup,
 	.input_mapping = lg_input_mapping,
 	.input_mapped = lg_input_mapped,
 	.event = lg_event,
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index e1c38bb..523d38a 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -538,7 +538,7 @@ static int logi_dj_ll_parse(struct hid_device *hid)
 			__func__, djdev->reports_supported);
 	}
 
-	retval = hid_parse_report(hid, rdesc, rsize);
+	retval = hid_parse_rdesc(hid, rdesc, rsize);
 	kfree(rdesc);
 
 	return retval;
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index e5c699b..43b1ad4 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -34,7 +34,7 @@
  * Microsoft Wireless Desktop Receiver (Model 1028) has
  * 'Usage Min/Max' where it ought to have 'Physical Min/Max'
  */
-static __u8 *ms_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *ms_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
@@ -208,7 +208,7 @@ MODULE_DEVICE_TABLE(hid, ms_devices);
 static struct hid_driver ms_driver = {
 	.name = "microsoft",
 	.id_table = ms_devices,
-	.report_fixup = ms_report_fixup,
+	.rdesc_fixup = ms_rdesc_fixup,
 	.input_mapping = ms_input_mapping,
 	.input_mapped = ms_input_mapped,
 	.event = ms_event,
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index dedf757..f0b739a 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -22,7 +22,7 @@
 
 #include "hid-ids.h"
 
-static __u8 *mr_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *mr_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 30 && rdesc[29] == 0x05 && rdesc[30] == 0x09) {
@@ -61,7 +61,7 @@ MODULE_DEVICE_TABLE(hid, mr_devices);
 static struct hid_driver mr_driver = {
 	.name = "monterey",
 	.id_table = mr_devices,
-	.report_fixup = mr_report_fixup,
+	.rdesc_fixup = mr_rdesc_fixup,
 	.input_mapping = mr_input_mapping,
 };
 
diff --git a/drivers/hid/hid-ortek.c b/drivers/hid/hid-ortek.c
index 0ffa1d2..697d463 100644
--- a/drivers/hid/hid-ortek.c
+++ b/drivers/hid/hid-ortek.c
@@ -24,7 +24,7 @@
 
 #include "hid-ids.h"
 
-static __u8 *ortek_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *ortek_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 56 && rdesc[54] == 0x25 && rdesc[55] == 0x01) {
@@ -48,7 +48,7 @@ MODULE_DEVICE_TABLE(hid, ortek_devices);
 static struct hid_driver ortek_driver = {
 	.name = "ortek",
 	.id_table = ortek_devices,
-	.report_fixup = ortek_report_fixup
+	.rdesc_fixup = ortek_rdesc_fixup
 };
 
 static int __init ortek_init(void)
diff --git a/drivers/hid/hid-petalynx.c b/drivers/hid/hid-petalynx.c
index f1ea3ff..1ca2821e 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -23,7 +23,7 @@
 #include "hid-ids.h"
 
 /* Petalynx Maxter Remote has maximum for consumer page set too low */
-static __u8 *pl_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *pl_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 60 && rdesc[39] == 0x2a && rdesc[40] == 0xf5 &&
@@ -100,7 +100,7 @@ MODULE_DEVICE_TABLE(hid, pl_devices);
 static struct hid_driver pl_driver = {
 	.name = "petalynx",
 	.id_table = pl_devices,
-	.report_fixup = pl_report_fixup,
+	.rdesc_fixup = pl_rdesc_fixup,
 	.input_mapping = pl_input_mapping,
 	.probe = pl_probe,
 };
diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index b71b77a..f9f6d8b 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -741,7 +741,7 @@ static int pcmidi_snd_terminate(struct pcmidi_snd *pm)
 /*
  * PC-MIDI report descriptor for report id is wrong.
  */
-static __u8 *pk_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *pk_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize == 178 &&
@@ -883,7 +883,7 @@ MODULE_DEVICE_TABLE(hid, pk_devices);
 static struct hid_driver pk_driver = {
 	.name = "prodikeys",
 	.id_table = pk_devices,
-	.report_fixup = pk_report_fixup,
+	.rdesc_fixup = pk_rdesc_fixup,
 	.input_mapping = pk_input_mapping,
 	.raw_event = pk_raw_event,
 	.probe = pk_probe,
diff --git a/drivers/hid/hid-saitek.c b/drivers/hid/hid-saitek.c
index 45aea77..30efbfe 100644
--- a/drivers/hid/hid-saitek.c
+++ b/drivers/hid/hid-saitek.c
@@ -21,7 +21,7 @@
 
 #include "hid-ids.h"
 
-static __u8 *saitek_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *saitek_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize == 137 && rdesc[20] == 0x09 && rdesc[21] == 0x33
@@ -52,7 +52,7 @@ MODULE_DEVICE_TABLE(hid, saitek_devices);
 static struct hid_driver saitek_driver = {
 	.name = "saitek",
 	.id_table = saitek_devices,
-	.report_fixup = saitek_report_fixup
+	.rdesc_fixup = saitek_rdesc_fixup
 };
 
 static int __init saitek_init(void)
diff --git a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
index 3c1fd8a..1b2ba50 100644
--- a/drivers/hid/hid-samsung.c
+++ b/drivers/hid/hid-samsung.c
@@ -61,7 +61,7 @@ static inline void samsung_irda_dev_trace(struct hid_device *hdev,
 		 rsize);
 }
 
-static __u8 *samsung_irda_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *samsung_irda_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize == 184 && rdesc[175] == 0x25 && rdesc[176] == 0x40 &&
@@ -131,11 +131,11 @@ static int samsung_kbd_mouse_input_mapping(struct hid_device *hdev,
 	return 1;
 }
 
-static __u8 *samsung_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *samsung_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 	unsigned int *rsize)
 {
 	if (USB_DEVICE_ID_SAMSUNG_IR_REMOTE == hdev->product)
-		rdesc = samsung_irda_report_fixup(hdev, rdesc, rsize);
+		rdesc = samsung_irda_rdesc_fixup(hdev, rdesc, rsize);
 	return rdesc;
 }
 
@@ -193,7 +193,7 @@ MODULE_DEVICE_TABLE(hid, samsung_devices);
 static struct hid_driver samsung_driver = {
 	.name = "samsung",
 	.id_table = samsung_devices,
-	.report_fixup = samsung_report_fixup,
+	.rdesc_fixup = samsung_rdesc_fixup,
 	.input_mapping = samsung_input_mapping,
 	.probe = samsung_probe,
 };
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 5cd25bd..0254b4e 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -39,7 +39,7 @@ struct sony_sc {
 };
 
 /* Sony Vaio VGX has wrongly mouse pointer declared as constant */
-static __u8 *sony_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *sony_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	struct sony_sc *sc = hid_get_drvdata(hdev);
@@ -227,7 +227,7 @@ static struct hid_driver sony_driver = {
 	.id_table = sony_devices,
 	.probe = sony_probe,
 	.remove = sony_remove,
-	.report_fixup = sony_report_fixup,
+	.rdesc_fixup = sony_rdesc_fixup,
 	.raw_event = sony_raw_event
 };
 
diff --git a/drivers/hid/hid-sunplus.c b/drivers/hid/hid-sunplus.c
index d484a00..28bdc26 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -22,7 +22,7 @@
 
 #include "hid-ids.h"
 
-static __u8 *sp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *sp_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 107 && rdesc[104] == 0x26 && rdesc[105] == 0x80 &&
@@ -61,7 +61,7 @@ MODULE_DEVICE_TABLE(hid, sp_devices);
 static struct hid_driver sp_driver = {
 	.name = "sunplus",
 	.id_table = sp_devices,
-	.report_fixup = sp_report_fixup,
+	.rdesc_fixup = sp_rdesc_fixup,
 	.input_mapping = sp_input_mapping,
 };
 
diff --git a/drivers/hid/hid-uclogic.c b/drivers/hid/hid-uclogic.c
index 1f11289..fad6076 100644
--- a/drivers/hid/hid-uclogic.c
+++ b/drivers/hid/hid-uclogic.c
@@ -352,7 +352,7 @@ static __u8 pf1209_rdesc_fixed[] = {
 	0xC0                /*  End Collection                      */
 };
 
-static __u8 *uclogic_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *uclogic_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 					unsigned int *rsize)
 {
 	switch (hdev->product) {
@@ -409,7 +409,7 @@ MODULE_DEVICE_TABLE(hid, uclogic_devices);
 static struct hid_driver uclogic_driver = {
 	.name = "uclogic",
 	.id_table = uclogic_devices,
-	.report_fixup = uclogic_report_fixup,
+	.rdesc_fixup = uclogic_rdesc_fixup,
 };
 
 static int __init uclogic_init(void)
diff --git a/drivers/hid/hid-waltop.c b/drivers/hid/hid-waltop.c
index 2cfd95c..3314eae 100644
--- a/drivers/hid/hid-waltop.c
+++ b/drivers/hid/hid-waltop.c
@@ -543,7 +543,7 @@ err:
 	return ret;
 }
 
-static __u8 *waltop_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *waltop_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	switch (hdev->product) {
@@ -646,7 +646,7 @@ static struct hid_driver waltop_driver = {
 	.name = "waltop",
 	.id_table = waltop_devices,
 	.probe = waltop_probe,
-	.report_fixup = waltop_report_fixup,
+	.rdesc_fixup = waltop_rdesc_fixup,
 	.raw_event = waltop_raw_event,
 	.remove = waltop_remove,
 };
diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
index 1ad85f2..7e6adc1 100644
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -27,7 +27,7 @@ struct zc_device {
 * Zydacron remote control has an invalid HID report descriptor,
 * that needs fixing before we can parse it.
 */
-static __u8 *zc_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *zc_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 	unsigned int *rsize)
 {
 	if (*rsize >= 253 &&
@@ -213,7 +213,7 @@ MODULE_DEVICE_TABLE(hid, zc_devices);
 static struct hid_driver zc_driver = {
 	.name = "zydacron",
 	.id_table = zc_devices,
-	.report_fixup = zc_report_fixup,
+	.rdesc_fixup = zc_rdesc_fixup,
 	.input_mapping = zc_input_mapping,
 	.raw_event = zc_raw_event,
 	.probe = zc_probe,
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 5bf91db..6f0f556 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1009,7 +1009,7 @@ static int usbhid_parse(struct hid_device *hid)
 		goto err;
 	}
 
-	ret = hid_parse_report(hid, rdesc, rsize);
+	ret = hid_parse_rdesc(hid, rdesc, rsize);
 	kfree(rdesc);
 	if (ret) {
 		dbg_hid("parsing report descriptor failed\n");
diff --git a/include/linux/hid.h b/include/linux/hid.h
index d8e7cc7..e1c083a 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -466,7 +466,7 @@ enum hid_type {
 struct hid_driver;
 struct hid_ll_driver;
 
-struct hid_device {							/* device report descriptor */
+struct hid_device {
 	__u8 *dev_rdesc;
 	unsigned dev_rsize;
 	__u8 *rdesc;
@@ -616,7 +616,7 @@ struct hid_usage_id {
  * @raw_event: if report in report_table, this hook is called (NULL means nop)
  * @usage_table: on which events to call event (NULL means all)
  * @event: if usage in usage_table, this hook is called (NULL means nop)
- * @report_fixup: called before report descriptor parsing (NULL means nop)
+ * @rdesc_fixup: called before report descriptor parsing (NULL means nop)
  * @input_mapping: invoked on input registering before mapping an usage
  * @input_mapped: invoked on input registering after mapping an usage
  * @feature_mapping: invoked on feature registering
@@ -654,7 +654,7 @@ struct hid_driver {
 	int (*event)(struct hid_device *hdev, struct hid_field *field,
 			struct hid_usage *usage, __s32 value);
 
-	__u8 *(*report_fixup)(struct hid_device *hdev, __u8 *buf,
+	__u8 *(*rdesc_fixup)(struct hid_device *hdev, __u8 *buf,
 			unsigned int *size);
 
 	int (*input_mapping)(struct hid_device *hdev,
@@ -736,8 +736,8 @@ unsigned int hidinput_count_leds(struct hid_device *hid);
 void hid_output_report(struct hid_report *report, __u8 *data);
 struct hid_device *hid_allocate_device(void);
 struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id);
-int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
-int hid_open_report(struct hid_device *device);
+int hid_parse_rdesc(struct hid_device *hid, __u8 *start, unsigned size);
+int hid_open_rdesc(struct hid_device *device);
 int hid_check_keys_pressed(struct hid_device *hid);
 int hid_connect(struct hid_device *hid, unsigned int connect_mask);
 void hid_disconnect(struct hid_device *hid);
@@ -798,17 +798,17 @@ static inline void hid_map_usage_clear(struct hid_input *hidinput,
 }
 
 /**
- * hid_parse - parse HW reports
+ * hid_parse - parse HW report descriptors
  *
  * @hdev: hid device
  *
  * Call this from probe after you set up the device (if needed). Your
- * report_fixup will be called (if non-NULL) after reading raw report from
- * device before passing it to hid layer for real parsing.
+ * rdesc_fixup will be called (if non-NULL) after reading raw report descriptor
+ * from device before passing it to hid layer for real parsing.
  */
 static inline int __must_check hid_parse(struct hid_device *hdev)
 {
-	return hid_open_report(hdev);
+	return hid_open_rdesc(hdev);
 }
 
 /**
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index d478be1..0e6ad45 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -873,7 +873,7 @@ static int hidp_parse(struct hid_device *hid)
 {
 	struct hidp_session *session = hid->driver_data;
 
-	return hid_parse_report(session->hid, session->rd_data,
+	return hid_parse_rdesc(session->hid, session->rd_data,
 			session->rd_size);
 }
 
-- 
1.7.10


--------------060705090208060508010100--
