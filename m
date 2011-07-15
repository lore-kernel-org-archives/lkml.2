Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1GORfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:35:53 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60226
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754235Ab1GORaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 102/117] Staging: hv: storvsc: Cleanup storvsc_drv.c after adding the contents of storvsc.c
Date: Fri, 15 Jul 2011 10:47:30 -0700
Message-Id: <1310752065-27895-102-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup storvsc_drv.c after adding the contents of storvsc.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |  107 +++-----------------------------------
 1 files changed, 7 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 3ce43a3..5c06f5d 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -19,11 +19,17 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  *   K. Y. Srinivasan <kys@microsoft.com>
  */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/device.h>
-#include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -37,40 +43,6 @@
 #include "hyperv_storage.h"
 
 
-/*
- * Copyright (c) 2009, Microsoft Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- *
- * Authors:
- *   Haiyang Zhang <haiyangz@microsoft.com>
- *   Hank Janssen  <hjanssen@microsoft.com>
- *   K. Y. Srinivasan <kys@microsoft.com>
- *
- */
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/completion.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/mm.h>
-#include <linux/delay.h>
-
-#include "hyperv.h"
-#include "hyperv_storage.h"
-
-
 static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
@@ -498,71 +470,6 @@ int storvsc_do_io(struct hv_device *device,
 	return ret;
 }
 
-/*
- * The channel properties uniquely specify how the device is to be
- * presented to the guest. Map this information for use by the block
- * driver. For Linux guests on Hyper-V, we emulate a scsi HBA in the guest
- * (storvsc_drv) and so scsi devices in the guest  are handled by
- * native upper level Linux drivers. Consequently, Hyper-V
- * block driver, while being a generic block driver, presently does not
- * deal with anything other than devices that would need to be presented
- * to the guest as an IDE disk.
- *
- * This function maps the channel properties as embedded in the input
- * parameter device_info onto information necessary to register the
- * corresponding block device.
- *
- * Currently, there is no way to stop the emulation of the block device
- * on the host side. And so, to prevent the native IDE drivers in Linux
- * from taking over these devices (to be managedby Hyper-V block
- * driver), we will take over if need be the major of the IDE controllers.
- *
- */
-
-int storvsc_get_major_info(struct storvsc_device_info *device_info,
-			    struct storvsc_major_info *major_info)
-{
-	static bool ide0_registered;
-	static bool ide1_registered;
-
-	/*
-	 * For now we only support IDE disks.
-	 */
-	major_info->devname = "ide";
-	major_info->diskname = "hd";
-
-	if (device_info->path_id) {
-		major_info->major = 22;
-		if (!ide1_registered) {
-			major_info->do_register = true;
-			ide1_registered = true;
-		} else
-			major_info->do_register = false;
-
-		if (device_info->target_id)
-			major_info->index = 3;
-		else
-			major_info->index = 2;
-
-		return 0;
-	} else {
-		major_info->major = 3;
-		if (!ide0_registered) {
-			major_info->do_register = true;
-			ide0_registered = true;
-		} else
-			major_info->do_register = false;
-
-		if (device_info->target_id)
-			major_info->index = 1;
-		else
-			major_info->index = 0;
-
-		return 0;
-	}
-
-	return -ENODEV;
-}
 static int storvsc_ringbuffer_size = STORVSC_RING_BUFFER_SIZE;
 
 module_param(storvsc_ringbuffer_size, int, S_IRUGO);
-- 
1.7.4.1

