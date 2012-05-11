Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2EKOTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:19:40 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:52994 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666Ab2EKOTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:19:39 -0400
From: Nestor Lopez Casado <nlopezcasad@logitech.com>
To: jrnieder@gmail.com
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        hugo@osvaldobarrera.com.ar, 671292@bugs.debian.org,
        stable@vger.kernel.org, Nestor Lopez Casado <nlopezcasad@logitech.com>
Subject: [PATCH v2 1/1] HID: logitech: read all 32 bits of report type bitfield
Date: Fri, 11 May 2012 16:17:16 +0200
Message-Id: <1336745836-17385-1-git-send-email-nlopezcasad@logitech.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Nieder <jrnieder@gmail.com>

On big-endian systems (e.g., Apple PowerBook), trying to use a
logitech wireless mouse with the Logitech Unifying Receiver does not
work with v3.2 and later kernels.  The device doesn't show up in
/dev/input.  Older kernels work fine.

That is because the new hid-logitech-dj driver claims the device.  The
device arrival notification appears:

	20 00 41 02 00 00 00 00 00 00 00 00 00 00 00

and we read the report_types bitfield (02 00 00 00) to find out what
kind of device it is.  Unfortunately the driver only reads the first 8
bits and treats that value as a 32-bit little-endian number, so on a
powerpc the report type seems to be 0x02000000 and is not recognized.

Even on little-endian machines, connecting a media center remote
control (report type 00 01 00 00) with this driver loaded would
presumably fail for the same reason.

Fix both problems by using get_unaligned_le32() to read all four
bytes, which is a little clearer anyway.  After this change, the
wireless mouse works on Hugo's PowerBook again.

Based on a patch by Nestor Lopez Casado.
Addresses http://bugs.debian.org/671292

Reported-by: Hugo Osvaldo Barrera <hugo@osvaldobarrera.com.ar>
Inspired-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hid/hid-logitech-dj.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 2b56efc..d44ea58 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -26,6 +26,7 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/usb.h>
+#include <asm/unaligned.h>
 #include "usbhid/usbhid.h"
 #include "hid-ids.h"
 #include "hid-logitech-dj.h"
@@ -265,8 +266,8 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
 		goto dj_device_allocate_fail;
 	}
 
-	dj_dev->reports_supported = le32_to_cpu(
-		dj_report->report_params[DEVICE_PAIRED_RF_REPORT_TYPE]);
+	dj_dev->reports_supported = get_unaligned_le32(
+		dj_report->report_params + DEVICE_PAIRED_RF_REPORT_TYPE);
 	dj_dev->hdev = dj_hiddev;
 	dj_dev->dj_receiver_dev = djrcv_dev;
 	dj_dev->device_index = dj_report->device_index;
-- 
1.7.5.3

