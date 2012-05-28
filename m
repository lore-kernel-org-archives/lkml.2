Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab2E1DmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:42:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52123 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994Ab2E1D3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:39 -0400
Message-Id: <20120528031210.194028483@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Nieder <jrnieder@gmail.com>,
        Hugo Osvaldo Barrera <hugo@osvaldobarrera.com.ar>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 053/117] HID: logitech: read all 32 bits of report type bitfield
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-logitech-dj.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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


