Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab2CJVGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 16:06:18 -0500
Received: from toro.web-alm.net ([62.245.132.31]:54325 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab2CJVFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 16:05:45 -0500
Message-Id: <20120310202241.764367925@osadl.org>
User-Agent: quilt/0.48-1
Date: Sat, 10 Mar 2012 21:20:15 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: David Airlie <airlied@linux.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] drivers-gpu-drm-allow-to-load-edid-firmware.patch
References: <20120310202014.828058552@osadl.org>
Content-Disposition: inline; filename=drivers-gpu-drm-allow-to-load-edid-firmware.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Broken monitors and/or broken graphic boards may send erroneous or no
EDID data. This also applies to broken KVM devices that are unable to
correctly forward the EDID data of the connected monitor but invent
their own fantasy data.

This patch allows to load an EDID data set via the firmware interface.
It contains data sets of frequently used screen resolutions (1024x768,
1280x1024, 1680x1050 and 1920x1080). The requested EDID data are
specified as a module parameter of the drm_kms_helper module, e.g.
options drm_kms_helper edid_firmware=edid/1280x1024.bin or as kernel
command line parameter.

In addition, an EDID data set can be specified on-the-fly via the
/sys/module interface, e.g.
echo edid/myedid.bin >/sys/module/drm_kms_helper/parameters/edid_firmware
The new screen mode is considered when the related kernel function is
called for the first time after the change. Such calls are made when the
X server is started or when the display settings dialog is opened in an
already running X server.

EDID data source files are provided for documentation purpose and as a
template to create EDID data sets for other screen resolutions. Note
that source compilation is not part of the build process, but needs to
be done manually, e.g.

#!/bin/bash
cd firmware/edid
for i in [1-9]*.S
do
  base=`echo $i | sed "s/\.S$//"`
  cc -c $base.S
  objcopy -O ihex $base.o $base.bin.ihex
  dos2unix $base.bin.ihex 2>/dev/null
done

The EDID data sets are based on standard timings that may not apply to a
particular monitor and even crash it. Ideally, EDID data of the
connected monitor should be used. They may be obtained through the 
drm/cardX/cardX-<connector>/edid entry in the /sys/devices PCI directory
of a correctly working graphics adapter.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 Documentation/kernel-parameters.txt |    6 
 drivers/gpu/drm/Kconfig             |   10 +
 drivers/gpu/drm/Makefile            |    3 
 drivers/gpu/drm/drm_crtc_helper.c   |    8 -
 drivers/gpu/drm/drm_edid.c          |    3 
 drivers/gpu/drm/drm_edid_load.c     |  147 ++++++++++++++++++++
 firmware/Makefile                   |    7 
 firmware/edid/1024x768.S            |   44 ++++++
 firmware/edid/1024x768.bin.ihex     |    9 +
 firmware/edid/1280x1024.S           |   44 ++++++
 firmware/edid/1280x1024.bin.ihex    |    9 +
 firmware/edid/1680x1050.S           |   44 ++++++
 firmware/edid/1680x1050.bin.ihex    |    9 +
 firmware/edid/1920x1080.S           |   44 ++++++
 firmware/edid/1920x1080.bin.ihex    |    9 +
 firmware/edid/edid.S                |  261 ++++++++++++++++++++++++++++++++++++
 include/drm/drm_crtc.h              |    1 
 include/drm/drm_edid.h              |    1 
 18 files changed, 657 insertions(+), 2 deletions(-)

Index: linux-3.3-rc6/Documentation/kernel-parameters.txt
===================================================================
--- linux-3.3-rc6.orig/Documentation/kernel-parameters.txt
+++ linux-3.3-rc6/Documentation/kernel-parameters.txt
@@ -713,6 +713,12 @@ bytes respectively. Such letter suffixes
 			The filter can be disabled or changed to another
 			driver later using sysfs.
 
+	drm_kms_helper.edid_firmware=<file>
+			Broken monitors, graphic adapters and KVMs may
+			send no or broken EDID data sets. This parameter
+			allows to specify an EDID data set in the
+			/lib/firmware directory that is used instead.
+
 	dscc4.setup=	[NET]
 
 	earlycon=	[KNL] Output early console device and options.
Index: linux-3.3-rc6/drivers/gpu/drm/Kconfig
===================================================================
--- linux-3.3-rc6.orig/drivers/gpu/drm/Kconfig
+++ linux-3.3-rc6/drivers/gpu/drm/Kconfig
@@ -27,6 +27,16 @@ config DRM_KMS_HELPER
 	help
 	  FB and CRTC helpers for KMS drivers.
 
+config DRM_LOAD_EDID_FIRMWARE
+	bool "Allow to load an EDID data set instead of probing it"
+	depends on DRM_KMS_HELPER
+	help
+	  Say Y here, if you want to specify an EDID data blob to be
+	  loaded from the /lib/firmware directory. This may be necessary,
+	  if the graphics adapter or monitor are unable to provide
+	  appropriate EDID data. Since this feature is provided as a
+	  workaround for broken hardware, the default case is N.
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
@@ -149,7 +149,7 @@ EXPORT_SYMBOL(drm_edid_header_is_valid);
  * Sanity check the EDID block (base or extension).  Return 0 if the block
  * doesn't check out, or 1 if it's valid.
  */
-static bool
+bool
 drm_edid_block_valid(u8 *raw_edid)
 {
 	int i;
@@ -203,6 +203,7 @@ bad:
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
@@ -0,0 +1,147 @@
+/*
+   drm_edid_load.c: load an EDID data set via the firmware interface
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
+	"in /lib/firmware instead");
+
+MODULE_FIRMWARE("edid/1024x768.bin");
+MODULE_FIRMWARE("edid/1280x1024.bin");
+MODULE_FIRMWARE("edid/1680x1050.bin");
+MODULE_FIRMWARE("edid/1920x1080.bin");
+
+static int edid_load(struct drm_connector *connector, char *name,
+		     char *connector_name)
+{
+	const struct firmware *fw;
+	struct platform_device *pdev;
+	u8 *edid;
+	int expected;
+	int err = 0;
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
+		DRM_ERROR("Requesting EDID firmware \"%s\" failed (err=%d)\n",
+		    name, err);
+		goto out;
+	}
+
+	expected = (fw->data[0x7e] + 1) * EDID_LENGTH;
+	if (expected != fw->size) {
+		DRM_ERROR("Size of loaded EDID firmware \"%s\" is invalid "
+		    "(expected %d, got %d)\n", name, expected, (int) fw->size);
+		err = -EINVAL;
+		goto relfw_out;
+	}
+
+	edid = kmalloc(fw->size, GFP_KERNEL);
+	if (edid == NULL) {
+		err = -ENOMEM;
+		goto relfw_out;
+	}
+	memcpy(edid, fw->data, fw->size);
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
+	DRM_INFO("Loaded EDID base block and %d extension%s from "
+	    "\"%s\" for connector \"%s\"\n", valid_extensions,
+	    valid_extensions == 1 ? "" : "s", name, connector_name);
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
+	DRM_INFO("Module parameter \"edid_firmware=%s\" found\n",
+	    edid_firmware);
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
Index: linux-3.3-rc6/firmware/Makefile
===================================================================
--- linux-3.3-rc6.orig/firmware/Makefile
+++ linux-3.3-rc6/firmware/Makefile
@@ -141,6 +141,13 @@ fw-shipped-$(CONFIG_USB_VICAM) += vicam/
 fw-shipped-$(CONFIG_VIDEO_CPIA2) += cpia2/stv0672_vp4.bin
 fw-shipped-$(CONFIG_YAM) += yam/1200.bin yam/9600.bin
 
+ifdef CONFIG_DRM_LOAD_EDID_FIRMWARE
+fw-shipped-$(CONFIG_DRM_KMS_HELPER) += edid/1024x768.bin
+fw-shipped-$(CONFIG_DRM_KMS_HELPER) += edid/1280x1024.bin
+fw-shipped-$(CONFIG_DRM_KMS_HELPER) += edid/1680x1050.bin
+fw-shipped-$(CONFIG_DRM_KMS_HELPER) += edid/1920x1080.bin
+endif
+
 fw-shipped-all := $(fw-shipped-y) $(fw-shipped-m) $(fw-shipped-)
 
 # Directories which we _might_ need to create, so we have a rule for them.
Index: linux-3.3-rc6/firmware/edid/1024x768.S
===================================================================
--- /dev/null
+++ linux-3.3-rc6/firmware/edid/1024x768.S
@@ -0,0 +1,44 @@
+/*
+   1024x768.S: EDID data set for standard 1024x768 60 Hz monitor
+
+   Copyright (C) 2011 Carsten Emde <C.Emde@osadl.org>
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
+/* EDID */
+#define VERSION 1
+#define REVISION 3
+
+/* Display */
+#define CLOCK 65000 /* kHz */
+#define XPIX 1024
+#define YPIX 768
+#define XY_RATIO XY_RATIO_4_3
+#define XBLANK 320
+#define YBLANK 38
+#define XOFFSET 8
+#define XPULSE 144
+#define YOFFSET (63+3)
+#define YPULSE (63+6)
+#define DPI 72
+#define VFREQ 60 /* Hz */
+#define TIMING_NAME "Linux XGA"
+#define ESTABLISHED_TIMINGS_BITS 0x08 /* Bit 3 -> 1024x768 @60 Hz */
+#define HSYNC_POL 0
+#define VSYNC_POL 0
+#define CRC 0x55
+
+#include "edid.S"
Index: linux-3.3-rc6/firmware/edid/1024x768.bin.ihex
===================================================================
--- /dev/null
+++ linux-3.3-rc6/firmware/edid/1024x768.bin.ihex
@@ -0,0 +1,9 @@
+:1000000000FFFFFFFFFFFF0031D8000000000000ED
+:10001000051601036D231A78EA5EC0A4594A982593
+:10002000205054000800614001010101010101015B
+:1000300001010101010164190040410026300890CE
+:100040003600630A11000018000000FF004C696EC2
+:1000500075782023300A20202020000000FD003B7E
+:100060003D2F3107000A202020202020000000FC26
+:10007000004C696E7578205847410A2020200055B1
+:00000001FF
Index: linux-3.3-rc6/firmware/edid/1280x1024.S
===================================================================
--- /dev/null
+++ linux-3.3-rc6/firmware/edid/1280x1024.S
@@ -0,0 +1,44 @@
+/*
+   1280x1024.S: EDID data set for standard 1280x1024 60 Hz monitor
+
+   Copyright (C) 2011 Carsten Emde <C.Emde@osadl.org>
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
+/* EDID */
+#define VERSION 1
+#define REVISION 3
+
+/* Display */
+#define CLOCK 108000 /* kHz */
+#define XPIX 1280
+#define YPIX 1024
+#define XY_RATIO XY_RATIO_5_4
+#define XBLANK 408
+#define YBLANK 42
+#define XOFFSET 48
+#define XPULSE 112
+#define YOFFSET (63+1)
+#define YPULSE (63+3)
+#define DPI 72
+#define VFREQ 60 /* Hz */
+#define TIMING_NAME "Linux SXGA"
+#define ESTABLISHED_TIMINGS_BITS 0x00 /* none */
+#define HSYNC_POL 1
+#define VSYNC_POL 1
+#define CRC 0xa0
+
+#include "edid.S"
Index: linux-3.3-rc6/firmware/edid/1280x1024.bin.ihex
===================================================================
--- /dev/null
+++ linux-3.3-rc6/firmware/edid/1280x1024.bin.ihex
@@ -0,0 +1,9 @@
+:1000000000FFFFFFFFFFFF0031D8000000000000ED
+:10001000051601036D2C2378EA5EC0A4594A982581
+:100020002050540000008180010101010101010103
+:10003000010101010101302A009851002A4030706D
+:100040001300BC631100001E000000FF004C696E2D
+:1000500075782023300A20202020000000FD003B7E
+:100060003D3E400B000A202020202020000000FC04
+:10007000004C696E757820535847410A202000A033
+:00000001FF
Index: linux-3.3-rc6/firmware/edid/1680x1050.S
===================================================================
--- /dev/null
+++ linux-3.3-rc6/firmware/edid/1680x1050.S
@@ -0,0 +1,44 @@
+/*
+   1680x1050.S: EDID data set for standard 1680x1050 60 Hz monitor
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
+/* EDID */
+#define VERSION 1
+#define REVISION 3
+
+/* Display */
+#define CLOCK 146250 /* kHz */
+#define XPIX 1680
+#define YPIX 1050
+#define XY_RATIO XY_RATIO_16_10
+#define XBLANK 560
+#define YBLANK 39
+#define XOFFSET 104
+#define XPULSE 176
+#define YOFFSET (63+3)
+#define YPULSE (63+6)
+#define DPI 96
+#define VFREQ 60 /* Hz */
+#define TIMING_NAME "Linux WSXGA"
+#define ESTABLISHED_TIMINGS_BITS 0x00 /* none */
+#define HSYNC_POL 1
+#define VSYNC_POL 1
+#define CRC 0x26
+
+#include "edid.S"
Index: linux-3.3-rc6/firmware/edid/1680x1050.bin.ihex
===================================================================
--- /dev/null
+++ linux-3.3-rc6/firmware/edid/1680x1050.bin.ihex
@@ -0,0 +1,9 @@
+:1000000000FFFFFFFFFFFF0031D8000000000000ED
+:10001000051601036D2B1B78EA5EC0A4594A98258A
+:10002000205054000000B300010101010101010151
+:1000300001010101010121399030621A274068B0A5
+:100040003600B5111100001E000000FF004C696E63
+:1000500075782023300A20202020000000FD003B7E
+:100060003D40420F000A202020202020000000FCFC
+:10007000004C696E75782057535847410A20002676
+:00000001FF
Index: linux-3.3-rc6/firmware/edid/1920x1080.S
===================================================================
--- /dev/null
+++ linux-3.3-rc6/firmware/edid/1920x1080.S
@@ -0,0 +1,44 @@
+/*
+   1920x1080.S: EDID data set for standard 1920x1080 60 Hz monitor
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
+/* EDID */
+#define VERSION 1
+#define REVISION 3
+
+/* Display */
+#define CLOCK 148500 /* kHz */
+#define XPIX 1920
+#define YPIX 1080
+#define XY_RATIO XY_RATIO_16_9
+#define XBLANK 280
+#define YBLANK 45
+#define XOFFSET 88
+#define XPULSE 44
+#define YOFFSET (63+4)
+#define YPULSE (63+5)
+#define DPI 96
+#define VFREQ 60 /* Hz */
+#define TIMING_NAME "Linux FHD"
+#define ESTABLISHED_TIMINGS_BITS 0x00 /* none */
+#define HSYNC_POL 1
+#define VSYNC_POL 1
+#define CRC 0x05
+
+#include "edid.S"
Index: linux-3.3-rc6/firmware/edid/1920x1080.bin.ihex
===================================================================
--- /dev/null
+++ linux-3.3-rc6/firmware/edid/1920x1080.bin.ihex
@@ -0,0 +1,9 @@
+:1000000000FFFFFFFFFFFF0031D8000000000000ED
+:10001000051601036D321C78EA5EC0A4594A982582
+:10002000205054000000D1C0010101010101010173
+:10003000010101010101023A801871382D40582C4C
+:100040004500F4191100001E000000FF004C696E0D
+:1000500075782023300A20202020000000FD003B7E
+:100060003D42440F000A202020202020000000FCF8
+:10007000004C696E7578204648440A20202000050F
+:00000001FF
Index: linux-3.3-rc6/firmware/edid/edid.S
===================================================================
--- /dev/null
+++ linux-3.3-rc6/firmware/edid/edid.S
@@ -0,0 +1,261 @@
+/*
+   edid.S: EDID data template
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
+
+/* Manufacturer */
+#define MFG_LNX1 'L'
+#define MFG_LNX2 'N'
+#define MFG_LNX3 'X'
+#define SERIAL 0
+#define YEAR 2012
+#define WEEK 5
+
+/* EDID 1.3 standard definitions */
+#define XY_RATIO_16_10	0b00
+#define XY_RATIO_4_3	0b01
+#define XY_RATIO_5_4	0b10
+#define XY_RATIO_16_9	0b11
+
+#define mfgname2id(v1,v2,v3) \
+	((((v1-'@')&0x1f)<<10)+(((v2-'@')&0x1f)<<5)+((v3-'@')&0x1f))
+#define swap16(v1) ((v1>>8)+((v1&0xff)<<8))
+#define msbs2(v1,v2) ((((v1>>8)&0x0f)<<4)+((v2>>8)&0x0f))
+#define msbs4(v1,v2,v3,v4) \
+	(((v1&0x03)>>2)+((v2&0x03)>>4)+((v3&0x03)>>6)+((v4&0x03)>>8))
+#define pixdpi2mm(pix,dpi) ((pix*25)/dpi)
+#define xsize pixdpi2mm(XPIX,DPI)
+#define ysize pixdpi2mm(YPIX,DPI)
+
+		.data
+
+/* Fixed header pattern */
+header:		.byte	0x00,0xff,0xff,0xff,0xff,0xff,0xff,0x00
+
+mfg_id:		.word	swap16(mfgname2id(MFG_LNX1, MFG_LNX2, MFG_LNX3))
+
+prod_code:	.word	0
+
+/* Serial number. 32 bits, little endian. */
+serial_number:	.long	SERIAL
+
+/* Week of manufacture */
+week:		.byte	WEEK
+
+/* Year of manufacture, less 1990. (1990-2245)
+   If week=255, it is the model year instead */
+year:		.byte	YEAR-1990
+
+version:	.byte	VERSION 	/* EDID version, usually 1 (for 1.3) */
+revision:	.byte	REVISION	/* EDID revision, usually 3 (for 1.3) */
+
+/* If Bit 7=1	Digital input. If set, the following bit definitions apply:
+     Bits 6-1	Reserved, must be 0
+     Bit 0	Signal is compatible with VESA DFP 1.x TMDS CRGB,
+		  1 pixel per clock, up to 8 bits per color, MSB aligned,
+   If Bit 7=0	Analog input. If clear, the following bit definitions apply:
+     Bits 6-5	Video white and sync levels, relative to blank
+		  00=+0.7/-0.3 V; 01=+0.714/-0.286 V;
+		  10=+1.0/-0.4 V; 11=+0.7/0 V
+   Bit 4	Blank-to-black setup (pedestal) expected
+   Bit 3	Separate sync supported
+   Bit 2	Composite sync (on HSync) supported
+   Bit 1	Sync on green supported
+   Bit 0	VSync pulse must be serrated when somposite or
+		  sync-on-green is used. */
+video_parms:	.byte	0x6d
+
+/* Maximum horizontal image size, in centimetres
+   (max 292 cm/115 in at 16:9 aspect ratio) */
+max_hor_size:	.byte	xsize/10
+
+/* Maximum vertical image size, in centimetres.
+   If either byte is 0, undefined (e.g. projector) */
+max_vert_size:	.byte	ysize/10
+
+/* Display gamma, minus 1, times 100 (range 1.00-3.5 */
+gamma:		.byte	120
+
+/* Bit 7	DPMS standby supported
+   Bit 6	DPMS suspend supported
+   Bit 5	DPMS active-off supported
+   Bits 4-3	Display type: 00=monochrome; 01=RGB colour;
+		  10=non-RGB multicolour; 11=undefined
+   Bit 2	Standard sRGB colour space. Bytes 25-34 must contain
+		  sRGB standard values.
+   Bit 1	Preferred timing mode specified in descriptor block 1.
+   Bit 0	GTF supported with default parameter values. */
+dsp_features:	.byte	0xea
+
+/* Chromaticity coordinates. */
+/* Red and green least-significant bits
+   Bits 7-6	Red x value least-significant 2 bits
+   Bits 5-4	Red y value least-significant 2 bits
+   Bits 3-2	Green x value lst-significant 2 bits
+   Bits 1-0	Green y value least-significant 2 bits */
+red_green_lsb:	.byte	0x5e
+
+/* Blue and white least-significant 2 bits */
+blue_white_lsb:	.byte	0xc0
+
+/* Red x value most significant 8 bits.
+   0-255 encodes 0-0.996 (255/256); 0-0.999 (1023/1024) with lsbits */
+red_x_msb:	.byte	0xa4
+
+/* Red y value most significant 8 bits */
+red_y_msb:	.byte	0x59
+
+/* Green x and y value most significant 8 bits */
+green_x_y_msb:	.byte	0x4a,0x98
+
+/* Blue x and y value most significant 8 bits */
+blue_x_y_msb:	.byte	0x25,0x20
+
+/* Default white point x and y value most significant 8 bits */
+white_x_y_msb:	.byte	0x50,0x54
+
+/* Established timings */
+/* Bit 7	720x400 @ 70 Hz
+   Bit 6	720x400 @ 88 Hz
+   Bit 5	640x480 @ 60 Hz
+   Bit 4	640x480 @ 67 Hz
+   Bit 3	640x480 @ 72 Hz
+   Bit 2	640x480 @ 75 Hz
+   Bit 1	800x600 @ 56 Hz
+   Bit 0	800x600 @ 60 Hz */
+estbl_timing1:	.byte	0x00
+
+/* Bit 7	800x600 @ 72 Hz
+   Bit 6	800x600 @ 75 Hz
+   Bit 5	832x624 @ 75 Hz
+   Bit 4	1024x768 @ 87 Hz, interlaced (1024x768)
+   Bit 3	1024x768 @ 60 Hz
+   Bit 2	1024x768 @ 72 Hz
+   Bit 1	1024x768 @ 75 Hz
+   Bit 0	1280x1024 @ 75 Hz */
+estbl_timing2:	.byte	ESTABLISHED_TIMINGS_BITS
+
+/* Bit 7	1152x870 @ 75 Hz (Apple Macintosh II)
+   Bits 6-0 	Other manufacturer-specific display mod */
+estbl_timing3:	.byte	0x00
+
+/* Standard timing */
+/* X resolution, less 31, divided by 8 (256-2288 pixels) */
+std_xres:	.byte	(XPIX/8)-31
+/* Y resolution, X:Y pixel ratio
+   Bits 7-6	X:Y pixel ratio: 00=16:10; 01=4:3; 10=5:4; 11=16:9.
+   Bits 5-0	Vertical frequency, less 60 (60-123 Hz) */
+std_vres:	.byte	(XY_RATIO<<6)+VFREQ-60
+		.fill	7,2,0x0101	/* Unused */
+
+descriptor1:
+/* Pixel clock in 10 kHz units. (0.-655.35 MHz, little-endian) */
+clock:		.word	CLOCK/10
+
+/* Horizontal active pixels 8 lsbits (0-4095) */
+x_act_lsb:	.byte	XPIX&0xff
+/* Horizontal blanking pixels 8 lsbits (0-4095)
+   End of active to start of next active. */
+x_blk_lsb:	.byte	XBLANK&0xff
+/* Bits 7-4 	Horizontal active pixels 4 msbits
+   Bits 3-0	Horizontal blanking pixels 4 msbits */
+x_msbs:		.byte	msbs2(XPIX,XBLANK)
+
+/* Vertical active lines 8 lsbits (0-4095) */
+y_act_lsb:	.byte	YPIX&0xff
+/* Vertical blanking lines 8 lsbits (0-4095) */
+y_blk_lsb:	.byte	YBLANK&0xff
+/* Bits 7-4 	Vertical active lines 4 msbits
+   Bits 3-0 	Vertical blanking lines 4 msbits */
+y_msbs:		.byte	msbs2(YPIX,YBLANK)
+
+/* Horizontal sync offset pixels 8 lsbits (0-1023) From blanking start */
+x_snc_off_lsb:	.byte	XOFFSET&0xff
+/* Horizontal sync pulse width pixels 8 lsbits (0-1023) */
+x_snc_pls_lsb:	.byte	XPULSE&0xff
+/* Bits 7-4 	Vertical sync offset lines 4 lsbits -63)
+   Bits 3-0 	Vertical sync pulse width lines 4 lsbits -63) */
+y_snc_lsb:	.byte	((YOFFSET-63)<<4)+(YPULSE-63)
+/* Bits 7-6 	Horizontal sync offset pixels 2 msbits
+   Bits 5-4 	Horizontal sync pulse width pixels 2 msbits
+   Bits 3-2 	Vertical sync offset lines 2 msbits
+   Bits 1-0 	Vertical sync pulse width lines 2 msbits */
+xy_snc_msbs:	.byte	msbs4(XOFFSET,XPULSE,YOFFSET,YPULSE)
+
+/* Horizontal display size, mm, 8 lsbits (0-4095 mm, 161 in) */
+x_dsp_size:	.byte	xsize&0xff
+
+/* Vertical display size, mm, 8 lsbits (0-4095 mm, 161 in) */
+y_dsp_size:	.byte	ysize&0xff
+
+/* Bits 7-4 	Horizontal display size, mm, 4 msbits
+   Bits 3-0 	Vertical display size, mm, 4 msbits */
+dsp_size_mbsb:	.byte	msbs2(xsize,ysize)
+
+/* Horizontal border pixels (each side; total is twice this) */
+x_border:	.byte	0
+/* Vertical border lines (each side; total is twice this) */
+y_border:	.byte	0
+
+/* Bit 7 	Interlaced
+   Bits 6-5 	Stereo mode: 00=No stereo; other values depend on bit 0:
+   Bit 0=0: 01=Field sequential, sync=1 during right; 10=similar,
+     sync=1 during left; 11=4-way interleaved stereo
+   Bit 0=1 2-way interleaved stereo: 01=Right image on even lines;
+     10=Left image on even lines; 11=side-by-side
+   Bits 4-3 	Sync type: 00=Analog composite; 01=Bipolar analog composite;
+     10=Digital composite (on HSync); 11=Digital separate
+   Bit 2 	If digital separate: Vertical sync polarity (1=positive)
+   Other types: VSync serrated (HSync during VSync)
+   Bit 1 	If analog sync: Sync on all 3 RGB lines (else green only)
+   Digital: HSync polarity (1=positive)
+   Bit 0 	2-way line-interleaved stereo, if bits 4-3 are not 00. */
+features:	.byte	0x18+(VSYNC_POL<<2)+(HSYNC_POL<<1)
+
+descriptor2:	.byte	0,0	/* Not a detailed timing descriptor */
+		.byte	0	/* Must be zero */
+		.byte	0xff	/* Descriptor is monitor serial number (text) */
+		.byte	0	/* Must be zero */
+start1:		.ascii	"Linux #0"
+end1:		.byte	0x0a	/* End marker */
+		.fill	12-(end1-start1), 1, 0x20 /* Padded spaces */
+descriptor3:	.byte	0,0	/* Not a detailed timing descriptor */
+		.byte	0	/* Must be zero */
+		.byte	0xfd	/* Descriptor is monitor range limits */
+		.byte	0	/* Must be zero */
+start2:		.byte	VFREQ-1	/* Minimum vertical field rate (1-255 Hz) */
+		.byte	VFREQ+1	/* Maximum vertical field rate (1-255 Hz) */
+		.byte	(CLOCK/(XPIX+XBLANK))-1 /* Minimum horizontal line rate
+						    (1-255 kHz) */
+		.byte	(CLOCK/(XPIX+XBLANK))+1 /* Maximum horizontal line rate
+						    (1-255 kHz) */
+		.byte	(CLOCK/10000)+1	/* Maximum pixel clock rate, rounded up
+					   to 10 MHz multiple (10-2550 MHz) */
+		.byte	0	/* No extended timing information type */
+end2:		.byte	0x0a	/* End marker */
+		.fill	12-(end2-start2), 1, 0x20 /* Padded spaces */
+descriptor4:	.byte	0,0	/* Not a detailed timing descriptor */
+		.byte	0	/* Must be zero */
+		.byte	0xfc	/* Descriptor is text */
+		.byte	0	/* Must be zero */
+start3:		.ascii	TIMING_NAME
+end3:		.byte	0x0a	/* End marker */
+		.fill	12-(end3-start3), 1, 0x20 /* Padded spaces */
+extensions:	.byte	0	/* Number of extensions to follow */
+checksum:	.byte	CRC	/* Sum of all bytes must be 0 */
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

