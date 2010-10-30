Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0J3Ja0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 05:30:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50715 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751499Ab0J3JaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 05:30:23 -0400
X-Authenticated: #989139
X-Provags-ID: V01U2FsdGVkX1/T+Dkde9rT1DPgaEWynpWCfk0TKZtK1HA4ZFmIZW
	odA2gFWK2S4Ksg
Message-ID: <4CCBE5A8.2090907@gmx.de>
Date: Sat, 30 Oct 2010 11:30:16 +0200
From: Ignaz Forster <ignaz.forster@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.14) Gecko/20101025 SeaMonkey/2.0.9
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Add Force Feedback support for EMS Trio Linker Plus II
References: <4CC751B1.2010304@gmx.de> <alpine.LNX.2.00.1010291451040.6879@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1010291451040.6879@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina schrieb am 29.10.2010 14:53 Uhr:
> On Wed, 27 Oct 2010, Ignaz Forster wrote:
>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> index 3052e29..3134112 100644
>> --- a/drivers/hid/Kconfig
>> +++ b/drivers/hid/Kconfig
>> @@ -150,6 +150,22 @@ config DRAGONRISE_FF
>>  	Say Y here if you want to enable force feedback support for DragonRise Inc.
>>  	game controllers.
>>  
>> +config HID_EMS
>> +	tristate "EMS Production Ltd. support"
>> +	depends on USB_HID
>> +	---help---
>> +	Say Y here if you have EMS Production Ltd. game controllers.
>> +
>> +config EMS_FF
>> +	bool "EMS Production Inc. force feedback support"
>> +	depends on HID_EMS
>> +	select INPUT_FF_MEMLESS
>> +	---help---
>> +	Say Y here if you want to enable force feedback support for devices by
>> +	EMS Production Ltd.
>> +	Currently the following devices are known to be supported:
>> +	 - Trio Linker Plus II
>> +
> 
> Why do we need both CONFIG_EMS and CONFIG_EMS_FF? There is no 'generic' 
> EMS driver that would care for the device without FF support. So I'd say 
> that introducing CONFIG_HID_EMS_FF solely should be enough (and build the 
> driver only if this option is selected).

I wasn't sure about this, as for kernel 2.6.31 all memless Force Feedback
devices were changed to get their own "generic" entry. Only the Acrux FF
driver which was recently added in kernel 2.6.36 was requested to have a
single entry again, however the other devices still have two entries.

>> diff --git a/drivers/hid/hid-emsff.c b/drivers/hid/hid-emsff.c
>> index e69de29..c61b192 100644
>> --- a/drivers/hid/hid-emsff.c
>> +++ b/drivers/hid/hid-emsff.c
> 
> This is a little bit odd, as your patch should be creating a new file that 
> didn't exist before, so it should rather look like
> 
> 	diff --git a/drivers/hid/hid-emsff.c b/drivers/hid/hid-emsff.c
> 	new file mode 100644
> 	index 0000000..c61b192 100644
> 	--- /dev/null
> 	+++ b/drivers/hid/hid-emsff.c
> 
> otherise it couldn't be applied cleanly.

After several fights with git the patch below should have the problem solved...

> Apart from that, the driver looks fine, thanks for doing the work!

No problem, thanks for your interest!

> Could you please fix the issues mentioned above and re-send?

Done, see the patch below:


The device has connections for GameCube, PlayStation 2 and Dreamcast
controllers, however Force Feedback is only supported for PS2 and GC
controllers.
When using a PS2 controller it may be necessary to press the "Analog"
button to enable support for both motors (this behavior is identical to
the Windows driver, I have found no way to avoid that).

Signed-off-by: Ignaz Forster <ignaz.forster@gmx.de>
---
 drivers/hid/Kconfig     |   10 +++
 drivers/hid/Makefile    |    1 +
 drivers/hid/hid-core.c  |    1 +
 drivers/hid/hid-emsff.c |  162 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-ids.h   |    3 +
 5 files changed, 177 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-emsff.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 3052e29..3d9a95f 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -150,6 +150,16 @@ config DRAGONRISE_FF
 	Say Y here if you want to enable force feedback support for DragonRise Inc.
 	game controllers.
 
+config HID_EMS_FF
+	tristate "EMS Production Inc. force feedback support"
+	depends on USB_HID
+	select INPUT_FF_MEMLESS
+	---help---
+	Say Y here if you want to enable force feedback support for devices by
+	EMS Production Ltd.
+	Currently the following devices are known to be supported:
+	 - Trio Linker Plus II
+
 config HID_EGALAX
 	tristate "eGalax multi-touch panel"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index c335605..86192f6 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
 obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
 obj-$(CONFIG_HID_DRAGONRISE)	+= hid-drff.o
+obj-$(CONFIG_HID_EMS_FF)	+= hid-emsff.o
 obj-$(CONFIG_HID_EGALAX)	+= hid-egalax.o
 obj-$(CONFIG_HID_ELECOM)	+= hid-elecom.o
 obj-$(CONFIG_HID_EZKEY)		+= hid-ezkey.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 515345b..efffb78 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1301,6 +1301,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_EMS, USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EZKEY, USB_DEVICE_ID_BTC_8193) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR) },
diff --git a/drivers/hid/hid-emsff.c b/drivers/hid/hid-emsff.c
new file mode 100644
index 0000000..c61b192
--- /dev/null
+++ b/drivers/hid/hid-emsff.c
@@ -0,0 +1,162 @@
+/*
+ *  Force feedback support for EMS Trio Linker Plus II
+ *
+ *  Copyright (c) 2010 Ignaz Forster <ignaz.forster@gmx.de>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+
+#include <linux/hid.h>
+#include <linux/input.h>
+#include <linux/usb.h>
+
+#include "hid-ids.h"
+#include "usbhid/usbhid.h"
+
+struct emsff_device {
+	struct hid_report *report;
+};
+
+static int emsff_play(struct input_dev *dev, void *data,
+			 struct ff_effect *effect)
+{
+	struct hid_device *hid = input_get_drvdata(dev);
+	struct emsff_device *emsff = data;
+	int weak, strong;
+
+	weak = effect->u.rumble.weak_magnitude;
+	strong = effect->u.rumble.strong_magnitude;
+
+	dbg_hid("called with 0x%04x 0x%04x\n", strong, weak);
+
+	weak = weak * 0xff / 0xffff;
+	strong = strong * 0xff / 0xffff;
+
+	emsff->report->field[0]->value[1] = weak;
+	emsff->report->field[0]->value[2] = strong;
+
+	dbg_hid("running with 0x%02x 0x%02x\n", strong, weak);
+	usbhid_submit_report(hid, emsff->report, USB_DIR_OUT);
+
+	return 0;
+}
+
+static int emsff_init(struct hid_device *hid)
+{
+	struct emsff_device *emsff;
+	struct hid_report *report;
+	struct hid_input *hidinput = list_first_entry(&hid->inputs,
+						struct hid_input, list);
+	struct list_head *report_list =
+			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	struct input_dev *dev = hidinput->input;
+	int error;
+
+	if (list_empty(report_list)) {
+		dev_err(&hid->dev, "no output reports found\n");
+		return -ENODEV;
+	}
+
+	report = list_first_entry(report_list, struct hid_report, list);
+	if (report->maxfield < 1) {
+		dev_err(&hid->dev, "no fields in the report\n");
+		return -ENODEV;
+	}
+
+	if (report->field[0]->report_count < 7) {
+		dev_err(&hid->dev, "not enough values in the field\n");
+		return -ENODEV;
+	}
+
+	emsff = kzalloc(sizeof(struct emsff_device), GFP_KERNEL);
+	if (!emsff)
+		return -ENOMEM;
+
+	set_bit(FF_RUMBLE, dev->ffbit);
+
+	error = input_ff_create_memless(dev, emsff, emsff_play);
+	if (error) {
+		kfree(emsff);
+		return error;
+	}
+
+	emsff->report = report;
+	emsff->report->field[0]->value[0] = 0x01;
+	emsff->report->field[0]->value[1] = 0x00;
+	emsff->report->field[0]->value[2] = 0x00;
+	emsff->report->field[0]->value[3] = 0x00;
+	emsff->report->field[0]->value[4] = 0x00;
+	emsff->report->field[0]->value[5] = 0x00;
+	emsff->report->field[0]->value[6] = 0x00;
+	usbhid_submit_report(hid, emsff->report, USB_DIR_OUT);
+
+	dev_info(&hid->dev, "force feedback for EMS based devices by "
+	       "Ignaz Forster <ignaz.forster@gmx.de>\n");
+
+	return 0;
+}
+
+static int ems_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		dev_err(&hdev->dev, "parse failed\n");
+		goto err;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
+	if (ret) {
+		dev_err(&hdev->dev, "hw start failed\n");
+		goto err;
+	}
+
+	emsff_init(hdev);
+
+	return 0;
+err:
+	return ret;
+}
+
+static const struct hid_device_id ems_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_EMS, 0x118) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, ems_devices);
+
+static struct hid_driver ems_driver = {
+	.name = "hkems",
+	.id_table = ems_devices,
+	.probe = ems_probe,
+};
+
+static int ems_init(void)
+{
+	return hid_register_driver(&ems_driver);
+}
+
+static void ems_exit(void)
+{
+	hid_unregister_driver(&ems_driver);
+}
+
+module_init(ems_init);
+module_exit(ems_exit);
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3341baa..5175001 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -203,6 +203,9 @@
 #define USB_VENDOR_ID_ELO		0x04E7
 #define USB_DEVICE_ID_ELO_TS2700	0x0020
 
+#define USB_VENDOR_ID_EMS		0x2006
+#define USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II 0x0118
+
 #define USB_VENDOR_ID_ESSENTIAL_REALITY	0x0d7f
 #define USB_DEVICE_ID_ESSENTIAL_REALITY_P5 0x0100
 
-- 
1.7.1

