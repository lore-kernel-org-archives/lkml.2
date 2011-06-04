Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1FHDYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:24:32 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:6494 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1FHDYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:24:30 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=I0jFHxriRJwyplOnjK2nOSNCO7GacXBAI5CCNqI8fuI= c=1 sm=1
 a=3762yOXauukA:10 a=BLceEmwcHowA:10 a=oaxjXb+On79cRBAvziGSJw==:17
 a=47LbCVvxAAAA:8 a=toXUOTWnoOkK3WuCcE8A:9 a=QhNQsjeWOoAA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Michael Bauer <michael@m-bauer.org>, Marcin Tolysz <tolysz@gmail.com>,
        Simon Wood <simon@mungewell.org>,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCHv4 3/3] sony_ff_bluetooth
Date: Sat,  4 Jun 2011 02:32:37 -0700
Message-Id: <1307179957-24458-3-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307179957-24458-1-git-send-email-simon@mungewell.org>
References: <1307179957-24458-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for patching the HID descriptor when Sixaxis is connect
via Bluetooth. In this mode the desciptor contains a trailing '0x00'.

Patch suggested by Antonio

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-sony.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index f219746..5d37f97 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -49,8 +49,11 @@ static __u8 *sony_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev, "Fixing up Sony Vaio VGX report descriptor\n");
 		rdesc[55] = 0x06;
 	}
-	if ((sc->quirks & SIXAXIS_CONTROLLER_USB) &&
-			*rsize == 148 && rdesc[83] == 0x75) {
+
+	/* The HID descriptor exposed over BT has a trailing zero byte */
+	if ((((sc->quirks & SIXAXIS_CONTROLLER_USB) && *rsize == 148) ||
+			((sc->quirks & SIXAXIS_CONTROLLER_BT)  && *rsize == 149 )) &&
+			rdesc[83] == 0x75) {
 		hid_info(hdev, "Fixing up Sony Sixaxis report descriptor\n");
 		memcpy((void *)&rdesc[83], (void *) &sixaxis_rdesc_fixup, sizeof(sixaxis_rdesc_fixup));
 	}
@@ -64,7 +67,7 @@ static int sony_raw_event(struct hid_device *hdev, struct hid_report *report, __
 {
 	struct sony_sc *sc = hid_get_drvdata(hdev);
 
-	if ((sc->quirks & SIXAXIS_CONTROLLER_USB) &&
+	if ((sc->quirks & (SIXAXIS_CONTROLLER_USB | SIXAXIS_CONTROLLER_BT)) &&
 			rd[0] == 0x01 && size == 49) {
 		swap(rd[41], rd[42]);
 		swap(rd[43], rd[44]);
-- 
1.7.4.1

