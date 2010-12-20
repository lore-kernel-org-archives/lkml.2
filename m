Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab0LTNlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:41:03 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:37282 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754701Ab0LTNlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:41:00 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/3] Input: synaptics - ignore bogus mt packet
Date: Mon, 20 Dec 2010 14:39:24 +0100
Message-Id: <1292852364-19127-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292852364-19127-1-git-send-email-rydberg@euromail.se>
References: <1292852364-19127-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PUfyJ-00085G-6l.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PUfyJ-00085G-6l 5795f3fb58d505511809a3d2687a9c1c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In multitouch mode, at least one device (fw: 7.4 id: 0x1c0b1) sometimes
sends a final main packet with x == 1. Since the normal values are above
1472, this is clearly bogus. At the same time, a two-finger touch is
signaled, even though only one finger was on the pad to begin with. This
patch ignores the packet altogether, removing the problem.

Acked-by: Chris Bagwell <chris@cnpbagwell.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/synaptics.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 2f8a97a..ae85ab2 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -548,7 +548,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 		return;
 	}
 
-	if (hw.z > 0) {
+	if (hw.z > 0 && hw.x > 1) {
 		num_fingers = 1;
 		finger_width = 5;
 		if (SYN_CAP_EXTENDED(priv->capabilities)) {
@@ -582,7 +582,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	if (hw.z > 30) input_report_key(dev, BTN_TOUCH, 1);
 	if (hw.z < 25) input_report_key(dev, BTN_TOUCH, 0);
 
-	if (hw.z > 0) {
+	if (num_fingers > 0) {
 		input_report_abs(dev, ABS_X, hw.x);
 		input_report_abs(dev, ABS_Y, YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
 	}
-- 
1.7.2.3

