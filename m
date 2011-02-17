Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab1BQSoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:44:14 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39992 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1BQSoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:44:12 -0500
Subject: Re: [PATCH] Enable Dell All-In-One volume up/down keys
From: Colin Ian King <colin.king@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110217172158.GA21932@core.coreip.homeip.net>
References: <1297688524-26123-1-git-send-email-colin.king@canonical.com>
	 <20110217075256.GB19814@core.coreip.homeip.net>
	 <1297941011.2234.32.camel@lenovo>
	 <20110217172158.GA21932@core.coreip.homeip.net>
Content-Type: multipart/mixed; boundary="=-5TFMipSPGqAxZOnV7QSo"
Date: Thu, 17 Feb 2011 18:44:09 +0000
Message-ID: <1297968249.2234.60.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5TFMipSPGqAxZOnV7QSo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2011-02-17 at 09:21 -0800, Dmitry Torokhov wrote:
> On Thu, Feb 17, 2011 at 11:10:11AM +0000, Colin Ian King wrote:
> > Thanks for your feedback Dmitry,
> > 
[ snip ]
> Looks much better, but I just noticed that we are missing calls to
> sparse_keymap_free(dell_wmi_aio_input_dev) in both probe error handling
> path and in remove method (they shoudl be called before unregistering
> the device).
> 
Indeed. Thanks for spotting that.  I've also incorporated your
suggestions below too.  Much appreciated.

Attached is the re-worked patch.

Colin

> Also, can we have probe routine more streamlined, like this:
> 
> static int __init dell_wmi_aio_init(void)
> {
> 	int err;
> 	char *guid;
> 
> 	guid = dell_wmi_aio_find();
> 	if (!guid) {
> 		pr_error("No known WMI GUID found\n");
> 		return -ENXIO;
> 	}
> 
> 	err = dell_wmi_aio_input_setup();
> 	if (err)
> 		return err;
> 
> 	err = wmi_install_notify_handler(guid, dell_wmi_aio_notify, NULL);
> 	if (err) {
> 		pr_err("Unable to register notify handler - %d\n", err);
> 		sparse_keymap_free(dell_wmi_aio_input_dev);
> 		input_unregister_device(dell_wmi_aio_input_dev);
> 		return err;
> 	}
> 
> 	return 0;
> }
> 
> Thanks.
> 


--=-5TFMipSPGqAxZOnV7QSo
Content-Disposition: attachment; filename="0001-Enable-Dell-All-In-One-volume-up-down-keys.patch"
Content-Type: text/x-patch; name="0001-Enable-Dell-All-In-One-volume-up-down-keys.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 89005aa15b03ab269a1368eec6868833d478b4e3 Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Thu, 17 Feb 2011 18:36:02 +0000
Subject: [PATCH] Enable Dell All-In-One volume up/down keys

Enable volume up and down hotkeys on WMI events
GUID 284A0E6B-380E-472A-921F-E52786257FB4 and
GUID 02314822-307C-4F66-bf0E-48AEAEB26CC8.

Also works around a firmware bug where the _WED method
should return an integer containing the key code and in fact
the method returns the key code in element zero of a buffer.

BugLink: http://bugs.launchpad.net/bugs/701530
BugLink: http://bugs.launchpad.net/bugs/676997

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/platform/x86/Kconfig        |   13 +++
 drivers/platform/x86/Makefile       |    1 +
 drivers/platform/x86/dell-wmi-aio.c |  172 +++++++++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+), 0 deletions(-)
 create mode 100644 drivers/platform/x86/dell-wmi-aio.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index d163bc2..b2e8ce0 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -101,6 +101,19 @@ config DELL_WMI
 	  To compile this driver as a module, choose M here: the module will
 	  be called dell-wmi.
 
+config DELL_WMI_AIO
+	tristate "WMI Hotkeys for Dell All-In-One series"
+	depends on ACPI_WMI
+	depends on INPUT
+	select INPUT_SPARSEKMAP
+	---help---
+	  Say Y here if you want to support WMI-based hotkeys on Dell
+	  All-In-One machines.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called dell-wmi.
+
+
 config FUJITSU_LAPTOP
 	tristate "Fujitsu Laptop Extras"
 	depends on ACPI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 4ec4ff8..26c6a57 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_ACPI_CMPC)		+= classmate-laptop.o
 obj-$(CONFIG_COMPAL_LAPTOP)	+= compal-laptop.o
 obj-$(CONFIG_DELL_LAPTOP)	+= dell-laptop.o
 obj-$(CONFIG_DELL_WMI)		+= dell-wmi.o
+obj-$(CONFIG_DELL_WMI_AIO)	+= dell-wmi-aio.o
 obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
 obj-$(CONFIG_ACERHDF)		+= acerhdf.o
 obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
diff --git a/drivers/platform/x86/dell-wmi-aio.c b/drivers/platform/x86/dell-wmi-aio.c
new file mode 100644
index 0000000..3efe788
--- /dev/null
+++ b/drivers/platform/x86/dell-wmi-aio.c
@@ -0,0 +1,172 @@
+/*
+ *  WMI hotkeys support for Dell All-In-One series
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
+#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
+#include <linux/string.h>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+MODULE_DESCRIPTION("WMI hotkeys driver for Dell All-In-One series");
+MODULE_LICENSE("GPL");
+
+#define EVENT_GUID1 "284A0E6B-380E-472A-921F-E52786257FB4"
+#define EVENT_GUID2 "02314822-307C-4F66-BF0E-48AEAEB26CC8"
+
+static const char *dell_wmi_aio_guids[] = {
+	EVENT_GUID1,
+	EVENT_GUID2,
+	NULL
+};
+
+MODULE_ALIAS("wmi:"EVENT_GUID1);
+MODULE_ALIAS("wmi:"EVENT_GUID2);
+
+static const struct key_entry dell_wmi_aio_keymap[] = {
+	{ KE_KEY, 0xc0, { KEY_VOLUMEUP } },
+	{ KE_KEY, 0xc1, { KEY_VOLUMEDOWN } },
+	{ KE_END, 0 }
+};
+
+static struct input_dev *dell_wmi_aio_input_dev;
+
+static void dell_wmi_aio_notify(u32 value, void *context)
+{
+	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj;
+	acpi_status status;
+
+	status = wmi_get_event_data(value, &response);
+	if (status != AE_OK) {
+		pr_info("bad event status 0x%x\n", status);
+		return;
+	}
+
+	obj = (union acpi_object *)response.pointer;
+	if (obj) {
+		unsigned int scancode;
+
+		switch (obj->type) {
+		case ACPI_TYPE_INTEGER:
+			/* Most All-In-One correctly return integer scancode */
+			scancode = obj->integer.value;
+			sparse_keymap_report_event(dell_wmi_aio_input_dev,
+				scancode, 1, true);
+			break;
+		case ACPI_TYPE_BUFFER:
+			/* Broken machines return the scancode in a buffer */
+			if (obj->buffer.pointer && obj->buffer.length > 0) {
+				scancode = obj->buffer.pointer[0];
+				sparse_keymap_report_event(
+					dell_wmi_aio_input_dev,
+					scancode, 1, true);
+			}
+			break;
+		}
+	}
+	kfree(obj);
+}
+
+static int __init dell_wmi_aio_input_setup(void)
+{
+	int err;
+
+	dell_wmi_aio_input_dev = input_allocate_device();
+
+	if (!dell_wmi_aio_input_dev)
+		return -ENOMEM;
+
+	dell_wmi_aio_input_dev->name = "Dell AIO WMI hotkeys";
+	dell_wmi_aio_input_dev->phys = "wmi/input0";
+	dell_wmi_aio_input_dev->id.bustype = BUS_HOST;
+
+	err = sparse_keymap_setup(dell_wmi_aio_input_dev,
+			dell_wmi_aio_keymap, NULL);
+	if (err) {
+		pr_err("Unable to setup input device keymap\n");
+		goto err_free_dev;
+	}
+	err = input_register_device(dell_wmi_aio_input_dev);
+	if (err) {
+		pr_info("Unable to register input device\n");
+		goto err_free_keymap;
+	}
+	return 0;
+
+err_free_keymap:
+	sparse_keymap_free(dell_wmi_aio_input_dev);
+err_free_dev:
+	input_free_device(dell_wmi_aio_input_dev);
+	return err;
+}
+
+static char *dell_wmi_aio_find(void)
+{
+	int i;
+
+	for (i = 0; dell_wmi_aio_guids[i] != NULL; i++)
+		if (wmi_has_guid(dell_wmi_aio_guids[i]))
+			return dell_wmi_aio_guids[i];
+
+	return NULL;
+}
+
+static int __init dell_wmi_aio_init(void)
+{
+	int err;
+	char *guid;
+
+	guid = dell_wmi_aio_find();
+	if (!guid) {
+		pr_warning("No known WMI GUID found\n");
+		return -ENXIO;
+	}
+
+	err = dell_wmi_aio_input_setup();
+	if (err)
+		return err;
+
+	err = wmi_install_notify_handler(guid, dell_wmi_aio_notify, NULL);
+	if (err) {
+		pr_err("Unable to register notify handler - %d\n", err);
+		sparse_keymap_free(dell_wmi_aio_input_dev);
+		input_unregister_device(dell_wmi_aio_input_dev);
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit dell_wmi_aio_exit(void)
+{
+	char *guid;
+
+	guid = dell_wmi_aio_find();
+	wmi_remove_notify_handler(guid);
+	sparse_keymap_free(dell_wmi_aio_input_dev);
+	input_unregister_device(dell_wmi_aio_input_dev);
+}
+
+module_init(dell_wmi_aio_init);
+module_exit(dell_wmi_aio_exit);
-- 
1.7.2.3


--=-5TFMipSPGqAxZOnV7QSo--

