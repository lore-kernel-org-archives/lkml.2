Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab2E0BId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:08:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab2E0BI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:08:28 -0400
Message-Id: <20120527010428.425537516@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:56 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Hugo Osvaldo Barrera <hugo@osvaldobarrera.com.ar>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 33/94] HID: logitech: read all 32 bits of report type bitfield
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Nieder <jrnieder@gmail.com>

commit 44d27f7dfedd9aadc082cda31462f6600f56e4ec upstream.

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
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-dj.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
@@ -265,8 +266,8 @@ static void logi_dj_recv_add_djhid_devic
 		goto dj_device_allocate_fail;
 	}
 
-	dj_dev->reports_supported = le32_to_cpu(
-		dj_report->report_params[DEVICE_PAIRED_RF_REPORT_TYPE]);
+	dj_dev->reports_supported = get_unaligned_le32(
+		dj_report->report_params + DEVICE_PAIRED_RF_REPORT_TYPE);
 	dj_dev->hdev = dj_hiddev;
 	dj_dev->dj_receiver_dev = djrcv_dev;
 	dj_dev->device_index = dj_report->device_index;


