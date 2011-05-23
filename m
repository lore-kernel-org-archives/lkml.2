Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab1FATpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:45:47 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:57115 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758970Ab1FATpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:45:45 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=cUTwMia+6fMZF7bjUHU44PO5dfBASsAn9IQPzcMrg/g= c=1 sm=1
 a=3762yOXauukA:10 a=BLceEmwcHowA:10 a=n3DLBDIp2lSvWb96zoUu4Q==:17
 a=47LbCVvxAAAA:8 a=izuzgAuKdIS11RDPfukA:9 a=QhNQsjeWOoAA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Antonio Ospite <ospite@studenti.unina.it>,
        Marcin Tolysz <tolysz@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Simon Wood <simon@mungewell.org>
Subject: [PATCH 1/2] sony_ff_hid_descriptor
Date: Mon, 23 May 2011 03:23:25 -0700
Message-Id: <1306146206-15794-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <80b32cfd7dc9e8afee2c4d9e21d1a7e3.squirrel@host171.canaca.com>
References: <80b32cfd7dc9e8afee2c4d9e21d1a7e3.squirrel@host171.canaca.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the HID descriptor to allow the reporting of
the accelerometers and gyro via a joystick axis.

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-sony.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 936c911..5c930dc 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -28,6 +28,12 @@
 #define SIXAXIS_CONTROLLER_USB  (1 << 1)
 #define SIXAXIS_CONTROLLER_BT   (1 << 2)
 
+static const u8 sixaxis_rdesc_fixup[] = {
+	0x95, 0x13, 0x09, 0x01, 0x81, 0x02, 0x95, 0x0C,
+	0x81, 0x01, 0x75, 0x10, 0x95, 0x04, 0x26, 0xFF, 
+	0x03, 0x46, 0xFF, 0x03, 0x09, 0x01, 0x81, 0x02
+	};
+
 struct sony_sc {
 	unsigned long quirks;
 };
@@ -43,6 +49,11 @@ static __u8 *sony_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev, "Fixing up Sony Vaio VGX report descriptor\n");
 		rdesc[55] = 0x06;
 	}
+	if ((sc->quirks & SIXAXIS_CONTROLLER_USB) &&
+			*rsize == 148 && rdesc[83] == 0x75) {
+		hid_info(hdev, "Fixing up Sony Sixaxis report descriptor\n");
+		memcpy((void *)&rdesc[83], (void *) &sixaxis_rdesc_fixup, sizeof(sixaxis_rdesc_fixup));
+	}
 	return rdesc;
 }
 
-- 
1.7.4.1

