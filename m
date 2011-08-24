Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab1HXFng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 01:43:36 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:33543 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1HXFmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 01:42:22 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?UTF-8?q?=C3=89ric=20Piel?= <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>, JJ Ding <jj_ding@emc.com.tw>
Subject: [PATCH v2 1/7] Input: elantech - correct x, y value range for v2 hardware
Date: Wed, 24 Aug 2011 13:44:40 +0800
Message-Id: <1314164686-866-2-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314164686-866-1-git-send-email-jj_ding@emc.com.tw>
References: <1314164686-866-1-git-send-email-jj_ding@emc.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x, y values are actually 12-bit long. Also update protocol document to reflect
the change.

Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
---
 Documentation/input/elantech.txt |    8 ++++----
 drivers/input/mouse/elantech.c   |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/input/elantech.txt b/Documentation/input/elantech.txt
index db798af..bce9941 100644
--- a/Documentation/input/elantech.txt
+++ b/Documentation/input/elantech.txt
@@ -389,14 +389,14 @@ byte 0:
 byte 1:
 
    bit   7   6   5   4   3   2   1   0
-	 p7  p6  p5  p4  .  x10 x9  x8
+	 p7  p6  p5  p4 x11 x10 x9  x8
 
 byte 2:
 
    bit   7   6   5   4   3   2   1   0
 	 x7  x6  x5  x4  x3  x2  x1  x0
 
-         x10..x0 = absolute x value (horizontal)
+         x11..x0 = absolute x value (horizontal)
 
 byte 3:
 
@@ -420,7 +420,7 @@ byte 3:
 byte 4:
 
    bit   7   6   5   4   3   2   1   0
-        p3  p1  p2  p0   .   .  y9  y8
+        p3  p1  p2  p0  y11 y10 y9  y8
 
 	 p7..p0 = pressure (not EF113)
 
@@ -429,7 +429,7 @@ byte 5:
    bit   7   6   5   4   3   2   1   0
         y7  y6  y5  y4  y3  y2  y1  y0
 
-         y9..y0 = absolute y value (vertical)
+         y11..y0 = absolute y value (vertical)
 
 
 4.2.2 Two finger touch
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 3250356..da161da 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -290,15 +290,15 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
 		/* pass through... */
 	case 1:
 		/*
-		 * byte 1:  .   .   .   .   .  x10 x9  x8
+		 * byte 1:  .   .   .   .  x11 x10 x9  x8
 		 * byte 2: x7  x6  x5  x4  x4  x2  x1  x0
 		 */
-		x1 = ((packet[1] & 0x07) << 8) | packet[2];
+		x1 = ((packet[1] & 0x0f) << 8) | packet[2];
 		/*
-		 * byte 4:  .   .   .   .   .   .  y9  y8
+		 * byte 4:  .   .   .   .  y11 y10 y9  y8
 		 * byte 5: y7  y6  y5  y4  y3  y2  y1  y0
 		 */
-		y1 = ETP_YMAX_V2 - (((packet[4] & 0x03) << 8) | packet[5]);
+		y1 = ETP_YMAX_V2 - (((packet[4] & 0x0f) << 8) | packet[5]);
 
 		input_report_abs(dev, ABS_X, x1);
 		input_report_abs(dev, ABS_Y, y1);
-- 
1.7.4.1

