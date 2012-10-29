Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267Ab2J2WxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:53:12 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:53279 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2J2WxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 18:53:10 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvicAPAHj1BV5h1yPGdsb2JhbABEilK3KgICgQgZAQEBAR8ZDSeCHgEBBAEnExwTAQ8FCwgDEQMBAi8UDRgKAwkOE4d0AwkKsioNiVQUinpnChEbIYEFgieBeWEDlB+BVIV5hTmHcw6BWgcZ
X-IronPort-AV: E=Sophos;i="4.80,675,1344204000"; 
   d="scan'208";a="215252774"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 29 Oct 2012 23:57:48 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/11] HID: hid-multitouch: get rid of usbhid
 depedency for general path
Message-ID: <20121029225748.GA15632@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
 <1351241067-9521-12-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351241067-9521-12-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> This patch factorizes the hid set_feature command by using
> hid_device->hid_output_raw_report instead of direclty relying on
> usbhid. This makes the driver usb independant.
> 
> However I still can't remove the 2 usb related headers because the
> function mt_resume has a specific patch for usb devices.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 63 ++++++++++++++++++++++++++------------------
>  1 file changed, 37 insertions(+), 26 deletions(-)

In my drawer, I have a patchset that aims to remove all usbhid
dependence, from all the drivers. Perhaps the attached patch is
something to consider here?

> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 21a120b..33038c5 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -670,47 +670,58 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>  	return 1;
>  }
>  
> -static void mt_set_input_mode(struct hid_device *hdev)
> +static void mt_set_feature(struct hid_device *hdev, __s8 feature_id,
> +	u8 value, size_t index)
>  {
> -	struct mt_device *td = hid_get_drvdata(hdev);
>  	struct hid_report *r;
>  	struct hid_report_enum *re;
> +	u8 *data;
> +	u8 max_value;
> +	int len;
> +
> +	if (feature_id < 0 || !hdev->hid_output_raw_report)
> +		return;
> +
> +	re = &hdev->report_enum[HID_FEATURE_REPORT];
> +	r = re->report_id_hash[feature_id];
> +	if (!r)
> +		return;
> +
> +	len = ((r->size - 1) >> 3) + 1 + (r->id > 0);
> +	max_value = r->field[0]->logical_maximum;
> +	value = min(value, max_value);
>  
> -	if (td->inputmode < 0)
> +	if (r->field[0]->value[index] == value || len < 2 || index + 1 >= len)
>  		return;
>  
> -	re = &(hdev->report_enum[HID_FEATURE_REPORT]);
> -	r = re->report_id_hash[td->inputmode];
> -	if (r) {
> -		r->field[0]->value[td->inputmode_index] = 0x02;
> -		usbhid_submit_report(hdev, r, USB_DIR_OUT);
> +	data = kzalloc(len, GFP_ATOMIC);
> +	if (!data) {
> +		hid_warn(hdev, "output queueing failed\n");
> +		return;
>  	}
> +
> +	data[0] = r->id;
> +	data[index + 1] = value;
> +	hdev->hid_output_raw_report(hdev, data, len, HID_FEATURE_REPORT);
> +	kfree(data);
>  }
>  
> -static void mt_set_maxcontacts(struct hid_device *hdev)
> +static void mt_set_input_mode(struct hid_device *hdev)
>  {
>  	struct mt_device *td = hid_get_drvdata(hdev);
> -	struct hid_report *r;
> -	struct hid_report_enum *re;
> -	int fieldmax, max;
>  
> -	if (td->maxcontact_report_id < 0)
> -		return;
> +	mt_set_feature(hdev, td->inputmode, 0x02, td->inputmode_index);
> +}
>  
> -	if (!td->mtclass.maxcontacts)
> +static void mt_set_maxcontacts(struct hid_device *hdev)
> +{
> +	struct mt_device *td = hid_get_drvdata(hdev);
> +	int max = td->mtclass.maxcontacts;
> +
> +	if (!max)
>  		return;
>  
> -	re = &hdev->report_enum[HID_FEATURE_REPORT];
> -	r = re->report_id_hash[td->maxcontact_report_id];
> -	if (r) {
> -		max = td->mtclass.maxcontacts;
> -		fieldmax = r->field[0]->logical_maximum;
> -		max = min(fieldmax, max);
> -		if (r->field[0]->value[0] != max) {
> -			r->field[0]->value[0] = max;
> -			usbhid_submit_report(hdev, r, USB_DIR_OUT);
> -		}
> -	}
> +	mt_set_feature(hdev, td->maxcontact_report_id, max, 0);
>  }
>  
>  static void mt_post_parse_default_settings(struct mt_device *td)
> -- 
> 1.7.11.7
> 

Thanks,
Henrik

---

>From 5d9a791e0a9e41bcea0fcb286e2849b403675f37 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Mon, 2 Jul 2012 20:38:21 +0200
Subject: [PATCH 3/7] hid: extend interface with report requests

---
 drivers/hid/usbhid/hid-core.c | 14 ++++++++++++++
 include/linux/hid.h           | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index de1f9ac..3c618da 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1251,6 +1251,18 @@ static int usbhid_power(struct hid_device *hid, int lvl)
 	return r;
 }
 
+static void usbhid_send(struct hid_device *hid, struct hid_report *rep, int req)
+{
+	switch (req) {
+	case HID_REQ_GET_REPORT:
+		usbhid_submit_report(hid, rep, USB_DIR_IN);
+		break;
+	case HID_REQ_SET_REPORT:
+		usbhid_submit_report(hid, rep, USB_DIR_OUT);
+		break;
+	}
+}
+
 static struct hid_ll_driver usb_hid_driver = {
 	.parse = usbhid_parse,
 	.start = usbhid_start,
@@ -1259,6 +1271,8 @@ static struct hid_ll_driver usb_hid_driver = {
 	.close = usbhid_close,
 	.power = usbhid_power,
 	.hidinput_input_event = usb_hidinput_input_event,
+	.send = usbhid_send,
+	.wait = usbhid_wait_io,
 };
 
 static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *id)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 241eb40..5e169c1 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -686,6 +686,8 @@ struct hid_driver {
  * @hidinput_input_event: event input event (e.g. ff or leds)
  * @parse: this method is called only once to parse the device data,
  *	   shouldn't allocate anything to not leak memory
+ * @send: send report request to device (e.g. feature report)
+ * @wait: wait for buffered io to complete (send/recv reports)
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -700,6 +702,11 @@ struct hid_ll_driver {
 			unsigned int code, int value);
 
 	int (*parse)(struct hid_device *hdev);
+
+	void (*send)(struct hid_device *hdev,
+		     struct hid_report *report, int req);
+	int (*wait)(struct hid_device *hdev);
+
 };
 
 #define	PM_HINT_FULLON	1<<5
@@ -892,6 +899,32 @@ static inline int hid_hw_power(struct hid_device *hdev, int level)
 	return hdev->ll_driver->power ? hdev->ll_driver->power(hdev, level) : 0;
 }
 
+
+/**
+ * hid_hw_send - send report request to device
+ *
+ * @hdev: hid device
+ * @report: report to send
+ * @req: hid request type
+ */
+static inline void hid_hw_send(struct hid_device *hdev,
+			       struct hid_report *report, int req)
+{
+	if (hdev->ll_driver->send)
+		hdev->ll_driver->send(hdev, report, req);
+}
+
+/**
+ * hid_hw_wait - wait for buffered io to complete
+ *
+ * @hdev: hid device
+ */
+static inline void hid_hw_wait(struct hid_device *hdev)
+{
+	if (hdev->ll_driver->wait)
+		hdev->ll_driver->wait(hdev);
+}
+
 int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		int interrupt);
 
-- 
1.7.11.1

