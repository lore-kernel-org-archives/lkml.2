Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2CLACZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:02:25 -0400
Received: from toro.web-alm.net ([62.245.132.31]:41653 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab2CLACS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:02:18 -0400
Message-ID: <4F5D3C69.7050308@osadl.org>
Date: Mon, 12 Mar 2012 00:59:37 +0100
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Airlie <airlied@linux.ie>, Thomas Gleixner <tglx@linutronix.de>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers-gpu-drm-allow-to-load-edid-firmware.patch
References: <20120310202014.828058552@osadl.org>	<20120310202241.764367925@osadl.org> <20120311134405.05942964@pyramind.ukuu.org.uk>
In-Reply-To: <20120311134405.05942964@pyramind.ukuu.org.uk>
Content-Type: multipart/mixed;
 boundary="------------000003000801080404030201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000003000801080404030201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan,

>> This patch allows to load an EDID data set via the firmware interface.
>> It contains data sets of frequently used screen resolutions (1024x768,
>> 1280x1024, 1680x1050 and 1920x1080). The requested EDID data are
>> specified as a module parameter of the drm_kms_helper module, e.g.
>> options drm_kms_helper edid_firmware=edid/1280x1024.bin or as kernel
>> command line parameter.
> [..]
> Given the EDID is tiny and is data not code wouldn't it be simpler (and
> smaller) if this option compiled in a few generic EDIDs to use ?
I liked the idea so much that I gave it a try. The patch looks much 
better now, but has the same functionality as before. As the only 
disadvantage, the patch no longer contains the template to produce a 
particular EDID. But this code may be made available elsewhere - no need 
to have it in the kernel.

Hope you like it.

Thanks,
	-Carsten.

--------------000003000801080404030201
Content-Type: text/x-patch;
 name="drivers-gpu-drm-allow-to-load-edid-firmware.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="drivers-gpu-drm-allow-to-load-edid-firmware.patch"

Broken monitors and/or broken graphic boards may send erroneous or no
EDID data. This also applies to broken KVM devices that are unable to
correctly forward the EDID data of the connected monitor but invent
their own fantasy data.

This patch allows to specify an EDID data set to be used instead of
probing the monitor for it. It contains built-in data sets of frequently
used screen resolutions. In addition, a particular EDID data set may be
provided in the /lib/firmware directory and loaded via the firmware
interface. The name is passed to the kernel as module parameter of the
drm_kms_helper module either when loaded
  options drm_kms_helper edid_firmware=edid/1280x1024.bin
or as kernel commandline parameter
  drm_kms_helper.edid_firmware=edid/1280x1024.bin  

The built-in data sets are
Resolution    Name
--------------------------------
1024x768      edid/1024x768.bin
1280x1024     edid/1280x1024.bin
1680x1050     edid/1680x1050.bin
1920x1080     edid/1920x1080.bin

They are ignored, if a file with the same name is available in the
/lib/firmware directory.

The built-in EDID data sets are based on standard timings that may not
apply to a particular monitor and even crash it. Ideally, EDID data of
the connected monitor should be used. They may be obtained through the 
drm/cardX/cardX-<connector>/edid entry in the /sys/devices PCI directory
of a correctly working graphics adapter.

It is also possible to specify the name of an EDID data set on-the-fly
via the /sys/module interface, e.g.
echo edid/myedid.bin >/sys/module/drm_kms_helper/parameters/edid_firmware
The new screen mode is considered when the related kernel function is
called for the first time after the change. Such calls are made when the
X server is started or when the display settings dialog is opened in an
already running X server.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 Documentation/kernel-parameters.txt |   10 +
 drivers/gpu/drm/Kconfig             |   11 +
 drivers/gpu/drm/Makefile            |    3 
 drivers/gpu/drm/drm_crtc_helper.c   |    8 +
 drivers/gpu/drm/drm_edid.c          |    4 
 drivers/gpu/drm/drm_edid_load.c     |  241 ++++++++++++++++++++++++++++++++++++
 include/drm/drm_crtc.h              |    1 
 include/drm/drm_edid.h              |    1 
 8 files changed, 276 insertions(+), 3 deletions(-)

Index: linux-3.3-rc6/Documentation/kernel-parameters.txt
===================================================================
--- linux-3.3-rc6.orig/Documentation/kernel-parameters.txt
+++ linux-3.3-rc6/Documentation/kernel-parameters.txt
@@ -713,6 +713,16 @@ bytes respectively. Such letter suffixes
 			The filter can be disabled or changed to another
 			driver later using sysfs.
 
+	drm_kms_helper.edid_firmware=<file>
+			Broken monitors, graphic adapters and KVMs may
+			send no or broken EDID data sets. This parameter
+			allows to specify an EDID data set in the
+			/lib/firmware directory that is used instead.
+			Generic built-in EDID data sets are used, if one of
+			edid/1024x768.bin, edid/1280x1024.bin,
+			edid/1680x1050.bin, or edid/1920x1080.bin is given
+			and no file with the same name exists.
+
 	dscc4.setup=	[NET]
 
 	earlycon=	[KNL] Output early console device and options.
Index: linux-3.3-rc6/drivers/gpu/drm/Kconfig
===================================================================
--- linux-3.3-rc6.orig/drivers/gpu/drm/Kconfig
+++ linux-3.3-rc6/drivers/gpu/drm/Kconfig
@@ -27,6 +27,17 @@ config DRM_KMS_HELPER
 	help
 	  FB and CRTC helpers for KMS drivers.
 
+config DRM_LOAD_EDID_FIRMWARE
+	bool "Allow to specify an EDID data set instead of probing for it"
+	depends on DRM_KMS_HELPER
+	help
+	  Say Y here, if you want to use EDID data to be loaded from the
+	  /lib/firmware directory or one of the provided built-in
+	  data sets. This may be necessary, if the graphics adapter or
+	  monitor are unable to provide appropriate EDID data. Since this
+	  feature is provided as a workaround for broken hardware, the
+	  default case is N.
+
 config DRM_TTM
 	tristate
 	depends on DRM
Index: linux-3.3-rc6/drivers/gpu/drm/Makefile
===================================================================
--- linux-3.3-rc6.orig/drivers/gpu/drm/Makefile
+++ linux-3.3-rc6/drivers/gpu/drm/Makefile
@@ -17,6 +17,9 @@ drm-y       :=	drm_auth.o drm_buffer.o d
 drm-$(CONFIG_COMPAT) += drm_ioc32.o
 
 drm_kms_helper-y := drm_fb_helper.o drm_crtc_helper.o drm_dp_i2c_helper.o
+ifdef CONFIG_DRM_LOAD_EDID_FIRMWARE
+drm_kms_helper-y += drm_edid_load.o
+endif
 
 obj-$(CONFIG_DRM_KMS_HELPER) += drm_kms_helper.o
 
Index: linux-3.3-rc6/drivers/gpu/drm/drm_crtc_helper.c
===================================================================
--- linux-3.3-rc6.orig/drivers/gpu/drm/drm_crtc_helper.c
+++ linux-3.3-rc6/drivers/gpu/drm/drm_crtc_helper.c
@@ -37,6 +37,7 @@
 #include "drm_fourcc.h"
 #include "drm_crtc_helper.h"
 #include "drm_fb_helper.h"
+#include "drm_edid.h"
 
 static bool drm_kms_helper_poll = true;
 module_param_named(poll, drm_kms_helper_poll, bool, 0600);
@@ -118,7 +119,12 @@ int drm_helper_probe_single_connector_mo
 		goto prune;
 	}
 
-	count = (*connector_funcs->get_modes)(connector);
+#ifdef CONFIG_DRM_LOAD_EDID_FIRMWARE
+	count = load_edid_firmware(connector);
+	if (count == 0)
+#endif
+		count = (*connector_funcs->get_modes)(connector);
+
 	if (count == 0 && connector->status == connector_status_connected)
 		count = drm_add_modes_noedid(connector, 1024, 768);
 	if (count == 0)
Index: linux-3.3-rc6/drivers/gpu/drm/drm_edid.c
===================================================================
--- linux-3.3-rc6.orig/drivers/gpu/drm/drm_edid.c
+++ linux-3.3-rc6/drivers/gpu/drm/drm_edid.c
@@ -149,8 +149,7 @@ EXPORT_SYMBOL(drm_edid_header_is_valid);
  * Sanity check the EDID block (base or extension).  Return 0 if the block
  * doesn't check out, or 1 if it's valid.
  */
-static bool
-drm_edid_block_valid(u8 *raw_edid)
+bool drm_edid_block_valid(u8 *raw_edid)
 {
 	int i;
 	u8 csum = 0;
@@ -203,6 +202,7 @@ bad:
 	}
 	return 0;
 }
+EXPORT_SYMBOL(drm_edid_block_valid);
 
 /**
  * drm_edid_is_valid - sanity check EDID data
Index: linux-3.3-rc6/drivers/gpu/drm/drm_edid_load.c
===================================================================
--- /dev/null
+++ linux-3.3-rc6/drivers/gpu/drm/drm_edid_load.c
@@ -0,0 +1,241 @@
+/*
+   drm_edid_load.c: use a built-in EDID data set or load it via the firmware
+		    interface
+
+   Copyright (C) 2012 Carsten Emde <C.Emde@osadl.org>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA.
+*/
+
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include "drmP.h"
+#include "drm_crtc.h"
+#include "drm_crtc_helper.h"
+#include "drm_edid.h"
+
+static char edid_firmware[PATH_MAX];
+module_param_string(edid_firmware, edid_firmware, sizeof(edid_firmware), 0644);
+MODULE_PARM_DESC(edid_firmware, "Do not probe monitor, use specified EDID blob "
+	"from built-in data or /lib/firmware instead. ");
+
+#define GENERIC_EDIDS 4
+static char *generic_edid_name[GENERIC_EDIDS] = {
+	"edid/1024x768.bin",
+	"edid/1280x1024.bin",
+	"edid/1680x1050.bin",
+	"edid/1920x1080.bin",
+};
+
+static u8 generic_edid[GENERIC_EDIDS][128] = {
+	{
+	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00,
+	0x31, 0xd8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x05, 0x16, 0x01, 0x03, 0x6d, 0x23, 0x1a, 0x78,
+	0xea, 0x5e, 0xc0, 0xa4, 0x59, 0x4a, 0x98, 0x25,
+	0x20, 0x50, 0x54, 0x00, 0x08, 0x00, 0x61, 0x40,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x64, 0x19,
+	0x00, 0x40, 0x41, 0x00, 0x26, 0x30, 0x08, 0x90,
+	0x36, 0x00, 0x63, 0x0a, 0x11, 0x00, 0x00, 0x18,
+	0x00, 0x00, 0x00, 0xff, 0x00, 0x4c, 0x69, 0x6e,
+	0x75, 0x78, 0x20, 0x23, 0x30, 0x0a, 0x20, 0x20,
+	0x20, 0x20, 0x00, 0x00, 0x00, 0xfd, 0x00, 0x3b,
+	0x3d, 0x2f, 0x31, 0x07, 0x00, 0x0a, 0x20, 0x20,
+	0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0xfc,
+	0x00, 0x4c, 0x69, 0x6e, 0x75, 0x78, 0x20, 0x58,
+	0x47, 0x41, 0x0a, 0x20, 0x20, 0x20, 0x00, 0x55,
+	},
+	{
+	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00,
+	0x31, 0xd8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x05, 0x16, 0x01, 0x03, 0x6d, 0x2c, 0x23, 0x78,
+	0xea, 0x5e, 0xc0, 0xa4, 0x59, 0x4a, 0x98, 0x25,
+	0x20, 0x50, 0x54, 0x00, 0x00, 0x00, 0x81, 0x80,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x30, 0x2a,
+	0x00, 0x98, 0x51, 0x00, 0x2a, 0x40, 0x30, 0x70,
+	0x13, 0x00, 0xbc, 0x63, 0x11, 0x00, 0x00, 0x1e,
+	0x00, 0x00, 0x00, 0xff, 0x00, 0x4c, 0x69, 0x6e,
+	0x75, 0x78, 0x20, 0x23, 0x30, 0x0a, 0x20, 0x20,
+	0x20, 0x20, 0x00, 0x00, 0x00, 0xfd, 0x00, 0x3b,
+	0x3d, 0x3e, 0x40, 0x0b, 0x00, 0x0a, 0x20, 0x20,
+	0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0xfc,
+	0x00, 0x4c, 0x69, 0x6e, 0x75, 0x78, 0x20, 0x53,
+	0x58, 0x47, 0x41, 0x0a, 0x20, 0x20, 0x00, 0xa0,
+	},
+	{
+	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00,
+	0x31, 0xd8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x05, 0x16, 0x01, 0x03, 0x6d, 0x2b, 0x1b, 0x78,
+	0xea, 0x5e, 0xc0, 0xa4, 0x59, 0x4a, 0x98, 0x25,
+	0x20, 0x50, 0x54, 0x00, 0x00, 0x00, 0xb3, 0x00,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x21, 0x39,
+	0x90, 0x30, 0x62, 0x1a, 0x27, 0x40, 0x68, 0xb0,
+	0x36, 0x00, 0xb5, 0x11, 0x11, 0x00, 0x00, 0x1e,
+	0x00, 0x00, 0x00, 0xff, 0x00, 0x4c, 0x69, 0x6e,
+	0x75, 0x78, 0x20, 0x23, 0x30, 0x0a, 0x20, 0x20,
+	0x20, 0x20, 0x00, 0x00, 0x00, 0xfd, 0x00, 0x3b,
+	0x3d, 0x40, 0x42, 0x0f, 0x00, 0x0a, 0x20, 0x20,
+	0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0xfc,
+	0x00, 0x4c, 0x69, 0x6e, 0x75, 0x78, 0x20, 0x57,
+	0x53, 0x58, 0x47, 0x41, 0x0a, 0x20, 0x00, 0x26,
+	},
+	{
+	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00,
+	0x31, 0xd8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x05, 0x16, 0x01, 0x03, 0x6d, 0x32, 0x1c, 0x78,
+	0xea, 0x5e, 0xc0, 0xa4, 0x59, 0x4a, 0x98, 0x25,
+	0x20, 0x50, 0x54, 0x00, 0x00, 0x00, 0xd1, 0xc0,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x02, 0x3a,
+	0x80, 0x18, 0x71, 0x38, 0x2d, 0x40, 0x58, 0x2c,
+	0x45, 0x00, 0xf4, 0x19, 0x11, 0x00, 0x00, 0x1e,
+	0x00, 0x00, 0x00, 0xff, 0x00, 0x4c, 0x69, 0x6e,
+	0x75, 0x78, 0x20, 0x23, 0x30, 0x0a, 0x20, 0x20,
+	0x20, 0x20, 0x00, 0x00, 0x00, 0xfd, 0x00, 0x3b,
+	0x3d, 0x42, 0x44, 0x0f, 0x00, 0x0a, 0x20, 0x20,
+	0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0xfc,
+	0x00, 0x4c, 0x69, 0x6e, 0x75, 0x78, 0x20, 0x46,
+	0x48, 0x44, 0x0a, 0x20, 0x20, 0x20, 0x00, 0x05,
+	},
+};
+
+static int edid_load(struct drm_connector *connector, char *name,
+		     char *connector_name)
+{
+	const struct firmware *fw;
+	struct platform_device *pdev;
+	u8 *fwdata = NULL, *edid;
+	int fwsize, expected;
+	int builtin = 0, err = 0;
+	int i, valid_extensions = 0;
+
+	pdev = platform_device_register_simple(connector_name, -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		DRM_ERROR("Failed to register EDID firmware platform device "
+		    "for connector \"%s\"\n", connector_name);
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = request_firmware(&fw, name, &pdev->dev);
+	platform_device_unregister(pdev);
+
+	if (err) {
+		i = 0;
+		while (i < GENERIC_EDIDS && strcmp(name, generic_edid_name[i]))
+			i++;
+		if (i < GENERIC_EDIDS) {
+			err = 0;
+			builtin = 1;
+			fwdata = generic_edid[i];
+			fwsize = sizeof(generic_edid[i]);
+		}
+	}
+
+	if (err) {
+		DRM_ERROR("Requesting EDID firmware \"%s\" failed (err=%d)\n",
+		    name, err);
+		goto out;
+	}
+
+	if (fwdata == NULL) {
+		fwdata = (u8 *) fw->data;
+		fwsize = fw->size;
+	}
+
+	expected = (fwdata[0x7e] + 1) * EDID_LENGTH;
+	if (expected != fwsize) {
+		DRM_ERROR("Size of EDID firmware \"%s\" is invalid "
+		    "(expected %d, got %d)\n", name, expected, (int) fwsize);
+		err = -EINVAL;
+		goto relfw_out;
+	}
+
+	edid = kmalloc(fwsize, GFP_KERNEL);
+	if (edid == NULL) {
+		err = -ENOMEM;
+		goto relfw_out;
+	}
+	memcpy(edid, fwdata, fwsize);
+
+	if (!drm_edid_block_valid(edid)) {
+		DRM_ERROR("Base block of EDID firmware \"%s\" is invalid ",
+		    name);
+		kfree(edid);
+		err = -EINVAL;
+		goto relfw_out;
+	}
+
+	for (i = 1; i <= edid[0x7e]; i++) {
+		if (i != valid_extensions + 1)
+			memcpy(edid + (valid_extensions + 1) * EDID_LENGTH,
+			    edid + i * EDID_LENGTH, EDID_LENGTH);
+		if (drm_edid_block_valid(edid + i * EDID_LENGTH))
+			valid_extensions++;
+	}
+
+	if (valid_extensions != edid[0x7e]) {
+		edid[EDID_LENGTH-1] += edid[0x7e] - valid_extensions;
+		DRM_INFO("Found %d valid extensions instead of %d in EDID data "
+		    "\"%s\" for connector \"%s\"\n", valid_extensions,
+		    edid[0x7e], name, connector_name);
+		edid[0x7e] = valid_extensions;
+		edid = krealloc(edid, (valid_extensions + 1) * EDID_LENGTH,
+		    GFP_KERNEL);
+		if (edid == NULL) {
+			err = -ENOMEM;
+			goto relfw_out;
+		}
+	}
+
+	connector->display_info.raw_edid = edid;
+	DRM_INFO("Got %s EDID base block and %d extension%s from "
+	    "\"%s\" for connector \"%s\"\n", builtin ? "built-in" :
+	    "external", valid_extensions, valid_extensions == 1 ? "" : "s",
+	    name, connector_name);
+
+relfw_out:
+	release_firmware(fw);
+
+out:
+	return err;
+}
+
+int load_edid_firmware(struct drm_connector *connector)
+{
+	char *connector_name = drm_get_connector_name(connector);
+	char *last;
+	int ret = 0;
+
+	if (edid_firmware[0] == '\0')
+		return ret;
+
+	last = edid_firmware + strlen(edid_firmware) - 1;
+	if (*last == '\n')
+		*last = '\0';
+
+	ret = edid_load(connector, edid_firmware, connector_name);
+	if (ret)
+		return 0;
+
+	drm_mode_connector_update_edid_property(connector,
+	    (struct edid *) connector->display_info.raw_edid);
+
+	return drm_add_edid_modes(connector, (struct edid *)
+	    connector->display_info.raw_edid);
+}
Index: linux-3.3-rc6/include/drm/drm_crtc.h
===================================================================
--- linux-3.3-rc6.orig/include/drm/drm_crtc.h
+++ linux-3.3-rc6/include/drm/drm_crtc.h
@@ -995,6 +995,7 @@ extern int drm_add_modes_noedid(struct d
 				int hdisplay, int vdisplay);
 
 extern int drm_edid_header_is_valid(const u8 *raw_edid);
+extern bool drm_edid_block_valid(u8 *raw_edid);
 extern bool drm_edid_is_valid(struct edid *edid);
 struct drm_display_mode *drm_mode_find_dmt(struct drm_device *dev,
 					   int hsize, int vsize, int fresh);
Index: linux-3.3-rc6/include/drm/drm_edid.h
===================================================================
--- linux-3.3-rc6.orig/include/drm/drm_edid.h
+++ linux-3.3-rc6/include/drm/drm_edid.h
@@ -238,5 +238,6 @@ int drm_av_sync_delay(struct drm_connect
 		      struct drm_display_mode *mode);
 struct drm_connector *drm_select_eld(struct drm_encoder *encoder,
 				     struct drm_display_mode *mode);
+int load_edid_firmware(struct drm_connector *connector);
 
 #endif /* __DRM_EDID_H__ */

--------------000003000801080404030201--
