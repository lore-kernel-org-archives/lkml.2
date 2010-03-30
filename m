Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0C3Ur3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:47:29 -0400
Received: from legolas.restena.lu ([158.64.1.34]:54506 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab0C3Uq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:46:28 -0400
Date: Tue, 30 Mar 2010 22:42:30 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [PATCH v6 7/8, needs improvement] hid: add suspend/resume hooks for
 hid drivers
Message-ID: <20100330224230.7b84df75@neptune.home>
In-Reply-To: <20100330223224.18fe4f3e@neptune.home>
References: <20100324233707.7243b04d@neptune.home>
	<20100324234022.0361bd80@neptune.home>
	<20100326065656.GC26602@core.coreip.homeip.net>
	<20100326102951.3b9ecda1@neptune.home>
	<alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz>
	<20100327012245.0ace6a09@neptune.home>
	<alpine.LNX.2.00.1003291144350.24576@pobox.suse.cz>
	<20100329121611.0c22dcaf@pluto.restena.lu>
	<alpine.LNX.2.00.1003301010410.24576@pobox.suse.cz>
	<20100330223224.18fe4f3e@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend/resume hooks for HID drivers so these can do some
additional state adjustment when device gets suspended/resumed.

This patch calls these hooks from usbhid suspend/resume functions,
only calling suspend on plain suspend, not autosuspend.
(it might be worth adding an autosuspend parameter to suspend
hook and calling suspend in both cases)

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---

Note:
  this patch needs improvements as mentionned by Olivier Neukum:
  - suspend hook for both system suspend and autosuspend
  - no call of hook on USB-HID-resume failure


 drivers/hid/usbhid/hid-core.c |   19 ++++++++++++++++++-
 include/linux/hid.h           |    8 ++++++++
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 3e7909b..9acf573 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1298,6 +1298,11 @@ static int hid_suspend(struct usb_interface *intf, pm_message_t message)
 		}
 
 	} else {
+		if (hid->driver && hid->driver->suspend) {
+			status = hid->driver->suspend(hid);
+			if (status < 0)
+				return status;
+		}
 		spin_lock_irq(&usbhid->lock);
 		set_bit(HID_REPORTED_IDLE, &usbhid->iofl);
 		spin_unlock_irq(&usbhid->lock);
@@ -1352,6 +1357,11 @@ static int hid_resume(struct usb_interface *intf)
 		hid_io_error(hid);
 	usbhid_restart_queues(usbhid);
 
+	if (hid->driver && hid->driver->resume) {
+		int ret = hid->driver->resume(hid);
+		if (ret < 0 && status == 0)
+			status = ret;
+	}
 	dev_dbg(&intf->dev, "resume status %d\n", status);
 	return 0;
 }
@@ -1360,9 +1370,16 @@ static int hid_reset_resume(struct usb_interface *intf)
 {
 	struct hid_device *hid = usb_get_intfdata(intf);
 	struct usbhid_device *usbhid = hid->driver_data;
+	int status;
 
 	clear_bit(HID_REPORTED_IDLE, &usbhid->iofl);
-	return hid_post_reset(intf);
+	status = hid_post_reset(intf);
+	if (hid->driver && hid->driver->reset_resume) {
+		int ret = hid->driver->reset_resume(hid);
+		if (ret < 0 && status == 0)
+			status = ret;
+	}
+	return status;
 }
 
 #endif /* CONFIG_PM */
diff --git a/include/linux/hid.h b/include/linux/hid.h
index b1344ec..fcf3e5c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -589,6 +589,9 @@ struct hid_usage_id {
  * @report_fixup: called before report descriptor parsing (NULL means nop)
  * @input_mapping: invoked on input registering before mapping an usage
  * @input_mapped: invoked on input registering after mapping an usage
+ * @suspend: invoked on suspend (NULL means nop)
+ * @resume: invoked on resume if device was not reset (NULL means nop)
+ * @reset_resume: invoked on resume if device was reset (NULL means nop)
  *
  * raw_event and event should return 0 on no action performed, 1 when no
  * further processing should be done and negative on error
@@ -629,6 +632,11 @@ struct hid_driver {
 	int (*input_mapped)(struct hid_device *hdev,
 			struct hid_input *hidinput, struct hid_field *field,
 			struct hid_usage *usage, unsigned long **bit, int *max);
+#ifdef CONFIG_PM
+	int (*suspend)(struct hid_device *hdev);
+	int (*resume)(struct hid_device *hdev);
+	int (*reset_resume)(struct hid_device *hdev);
+#endif
 /* private: */
 	struct device_driver driver;
 };
-- 
1.6.4.4

