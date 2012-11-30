Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375Ab2K3MET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:04:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58520 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030350Ab2K3MEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:04:10 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4 9/9] davinci: vpfe: Add documentation and TODO
Date: Fri, 30 Nov 2012 17:31:19 +0530
Message-Id: <1354276879-27244-10-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354276879-27244-1-git-send-email-prabhakar.lad@ti.com>
References: <1354276879-27244-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Add documentation on the Davinci VPFE driver. Document the subdevs,
and private IOTCLs the driver implements. This patch also includes
the TODO's to fit into drivers/media/ folder.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/davinci_vpfe/TODO            |   37 +++++
 .../staging/media/davinci_vpfe/davinci-vpfe-mc.txt |  154 ++++++++++++++++++++
 2 files changed, 191 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/media/davinci_vpfe/TODO
 create mode 100644 drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt

diff --git a/drivers/staging/media/davinci_vpfe/TODO b/drivers/staging/media/davinci_vpfe/TODO
new file mode 100644
index 0000000..7015ab3
--- /dev/null
+++ b/drivers/staging/media/davinci_vpfe/TODO
@@ -0,0 +1,37 @@
+TODO (general):
+==================================
+
+- User space interface refinement
+        - Controls should be used when possible rather than private ioctl
+        - No enums should be used
+        - Use of MC and V4L2 subdev APIs when applicable
+        - Single interface header might suffice
+        - Current interface forces to configure everything at once
+- Get rid of the dm365_ipipe_hw.[ch] layer
+- Active external sub-devices defined by link configuration; no strcmp
+  needed
+- More generic platform data (i2c adapters)
+- The driver should have no knowledge of possible external subdevs; see
+  struct vpfe_subdev_id
+- Some of the hardware control should be refactorede
+- Check proper serialisation (through mutexes and spinlocks)
+- Names that are visible in kernel global namespace should have a common
+  prefix (or a few)
+- While replacing the older driver in media folder, provide a compatibility
+  layer and compatibility tests that warrants (using the libv4l's LD_PRELOAD
+  approach) there is no regression for the users using the older driver.
+
+Building of uImage and Applications:
+==================================
+
+As of now since the interface will undergo few changes all the include
+files are present in staging itself, to build for dm365 follow below steps,
+
+- copy vpfe.h from drivers/staging/media/davinci_vpfe/ to
+  include/media/davinci/ folder for building the uImage.
+- copy davinci_vpfe_user.h from drivers/staging/media/davinci_vpfe/ to
+  include/uapi/linux/davinci_vpfe.h, and add a entry in Kbuild (required
+  for building application).
+- copy dm365_ipipeif_user.h from drivers/staging/media/davinci_vpfe/ to
+  include/uapi/linux/dm365_ipipeif.h and a entry in Kbuild (required
+  for building application).
diff --git a/drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt b/drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt
new file mode 100644
index 0000000..1dbd564
--- /dev/null
+++ b/drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt
@@ -0,0 +1,154 @@
+Davinci Video processing Front End (VPFE) driver
+
+Copyright (C) 2012 Texas Instruments Inc
+
+Contacts: Manjunath Hadli <manjunath.hadli@ti.com>
+	  Prabhakar Lad <prabhakar.lad@ti.com>
+
+
+Introduction
+============
+
+This file documents the Texas Instruments Davinci Video processing Front End
+(VPFE) driver located under drivers/media/platform/davinci. The original driver
+exists for Davinci VPFE, which is now being changed to Media Controller
+Framework.
+
+Currently the driver has been successfully used on the following
+version of Davinci:
+
+	DM365/DM368
+
+The driver implements V4L2, Media controller and v4l2_subdev interfaces. Sensor,
+lens and flash drivers using the v4l2_subdev interface in the kernel are
+supported.
+
+
+Split to subdevs
+================
+
+The Davinci VPFE is split into V4L2 subdevs, each of the blocks inside the VPFE
+having one subdev to represent it. Each of the subdevs provide a V4L2 subdev
+interface to userspace.
+
+	DAVINCI ISIF
+	DAVINCI IPIPEIF
+	DAVINCI IPIPE
+	DAVINCI CROP RESIZER
+	DAVINCI RESIZER A
+	DAVINCI RESIZER B
+
+Each possible link in the VPFE is modeled by a link in the Media controller
+interface. For an example program see [1].
+
+
+ISIF, IPIPE, and RESIZER block IOCTLs
+======================================
+
+The Davinci Video processing Front End (VPFE) driver supports standard V4L2
+IOCTLs and controls where possible and practical. Much of the functions provided
+by the VPFE, however, does not fall under the standard IOCTL's.
+
+In general, there is a private ioctl for configuring each of the blocks
+containing hardware-dependent functions.
+
+The following private IOCTLs are supported:
+
+	VIDIOC_VPFE_ISIF_[S/G]_RAW_PARAMS
+	VIDIOC_VPFE_IPIPE_[S/G]_CONFIG
+	VIDIOC_VPFE_RSZ_[S/G]_CONFIG
+
+The parameter structures used by these ioctl's are described in
+include/uapi/linux/davinci_vpfe.h.
+
+The VIDIOC_VPFE_ISIF_S_RAW_PARAMS, VIDIOC_VPFE_IPIPE_S_CONFIG and
+VIDIOC_VPFE_RSZ_S_CONFIG are used to configure, enable and disable functions in
+the isif, ipipe and resizer blocks respectively. These IOCTL's control several
+functions in the blocks they control. VIDIOC_VPFE_ISIF_S_RAW_PARAMS IOCTL
+accepts a pointer to struct vpfe_isif_raw_config as its argument. Similarly
+VIDIOC_VPFE_IPIPE_S_CONFIG accepts a pointer to struct vpfe_ipipe_config. And
+VIDIOC_VPFE_RSZ_S_CONFIG accepts a pointer to struct vpfe_rsz_config as its
+argument. Similarly VIDIOC_VPFE_ISIF_G_RAW_PARAMS, VIDIOC_VPFE_IPIPE_G_CONFIG
+and VIDIOC_VPFE_RSZ_G_CONFIG are used to get the current configuration set in
+the isif, ipipe and resizer blocks respectively.
+
+The detailed functions of the VPFE itself related to a given VPFE block is
+described in the Technical Reference Manuals (TRMs) --- see the end of the
+document for those.
+
+
+IPIPEIF block IOCTLs
+======================================
+
+The following private IOCTLs are supported:
+
+	VIDIOC_VPFE_IPIPEIF_[S/G]_CONFIG
+
+The parameter structures used by these ioctl's are described in
+include/uapi/linux/dm365_ipipeif.h
+
+The VIDIOC_VPFE_IPIPEIF_S_CONFIG is used to configure the ipipeif
+hardware block. The VIDIOC_VPFE_IPIPEIF_S_CONFIG and
+VIDIOC_VPFE_IPIPEIF_G_CONFIG accepts a pointer to struct ipipeif_params
+as its argument.
+
+
+VPFE Operating Modes
+==========================================
+
+a: Continuous Modes
+------------------------
+
+1: tvp514x/tvp7002/mt9p031---> DAVINCI ISIF---> SDRAM
+
+2: tvp514x/tvp7002/mt9p031---> DAVINCI ISIF---> DAVINCI IPIPEIF--->|
+                                                                   |
+   <--------------------<----------------<---------------------<---|
+   |
+   V
+ DAVINCI CROP RESIZER--->DAVINCI RESIZER [A/B]---> SDRAM
+
+3: tvp514x/tvp7002/mt9p031---> DAVINCI ISIF---> DAVINCI IPIPEIF--->|
+                                                                   |
+   <--------------------<----------------<---------------------<---|
+   |
+   V
+ DAVINCI IPIPE---> DAVINCI CROP RESIZER--->DAVINCI RESIZER [A/B]---> SDRAM
+
+a: Single Shot Modes
+------------------------
+
+1: SDRAM---> DAVINCI IPIPEIF---> DAVINCI IPIPE---> DAVINCI CROP RESIZER--->|
+                                                                           |
+   <----------------<----------------<------------------<---------------<--|
+   |
+   V
+DAVINCI RESIZER [A/B]---> SDRAM
+
+2: SDRAM---> DAVINCI IPIPEIF---> DAVINCI CROP RESIZER--->|
+                                                         |
+   <----------------<----------------<---------------<---|
+   |
+   V
+DAVINCI RESIZER [A/B]---> SDRAM
+
+
+Technical reference manuals (TRMs) and other documentation
+==========================================================
+
+Davinci DM365 TRM:
+<URL:http://www.ti.com/lit/ds/sprs457e/sprs457e.pdf>
+Referenced MARCH 2009-REVISED JUNE 2011
+
+Davinci DM368 TRM:
+<URL:http://www.ti.com/lit/ds/sprs668c/sprs668c.pdf>
+Referenced APRIL 2010-REVISED JUNE 2011
+
+Davinci Video Processing Front End (VPFE) DM36x
+<URL:http://www.ti.com/lit/ug/sprufg8c/sprufg8c.pdf>
+
+
+References
+==========
+
+[1] http://git.ideasonboard.org/?p=media-ctl.git;a=summary
-- 
1.7.4.1

