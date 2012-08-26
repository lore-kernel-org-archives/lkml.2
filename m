Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2HZMyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 08:54:04 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:47396 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2HZMx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 08:53:59 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApVZADUbOlBV5qoUPGdsb2JhbABFhRqFI7AtGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESG4d2u0kUkgUDm0CNDw
X-IronPort-AV: E=Sophos;i="4.77,830,1336341600"; 
   d="scan'208";a="397048785"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 14/20] Input: bcm5974 - Drop pressure and width emulation
Date: Sun, 26 Aug 2012 14:57:32 +0200
Message-Id: <1345985858-445-15-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345985858-445-1-git-send-email-rydberg@euromail.se>
References: <1345985858-445-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ABS_PRESSURE and ABS_WIDTH have special scales, and were initially
added solely for thumb and palm recognition in the synaptics driver.
This never really get used, however, and userspace quickly moved to
MT solutions instead. This patch drops the unused events.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index cb9383e..d53628f 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -417,10 +417,6 @@ static void setup_events_to_report(struct input_dev *input_dev,
 {
 	__set_bit(EV_ABS, input_dev->evbit);
 
-	input_set_abs_params(input_dev, ABS_PRESSURE,
-				0, cfg->p.dim, cfg->p.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_TOOL_WIDTH,
-				0, cfg->w.dim, cfg->w.fuzz, 0);
 	input_set_abs_params(input_dev, ABS_X,
 				0, cfg->x.dim, cfg->x.fuzz, 0);
 	input_set_abs_params(input_dev, ABS_Y,
@@ -502,9 +498,9 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	const struct bcm5974_config *c = &dev->cfg;
 	const struct tp_finger *f;
 	struct input_dev *input = dev->input;
-	int raw_p, raw_w, raw_x, raw_y, raw_n, i;
+	int raw_p, raw_x, raw_y, raw_n, i;
 	int ptest, origin, ibt = 0, nmin = 0, nmax = 0;
-	int abs_p = 0, abs_w = 0, abs_x = 0, abs_y = 0;
+	int abs_x = 0, abs_y = 0;
 
 	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
 		return -EIO;
@@ -521,22 +517,19 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 			report_finger_data(input, c, &f[i]);
 
 		raw_p = raw2int(f->touch_major);
-		raw_w = raw2int(f->tool_major);
 		raw_x = raw2int(f->abs_x);
 		raw_y = raw2int(f->abs_y);
 
 		dprintk(9,
 			"bcm5974: "
-			"raw: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
-			raw_p, raw_w, raw_x, raw_y, raw_n);
+			"raw: p: %+05d x: %+05d y: %+05d n: %d\n",
+			raw_p, raw_x, raw_y, raw_n);
 
 		ptest = int2bound(&c->p, raw_p);
 		origin = raw2int(f->origin);
 
 		/* while tracking finger still valid, count all fingers */
 		if (ptest > PRESSURE_LOW && origin) {
-			abs_p = ptest;
-			abs_w = int2bound(&c->w, raw_w);
 			abs_x = int2bound(&c->x, raw_x - c->x.devmin);
 			abs_y = int2bound(&c->y, c->y.devmax - raw_y);
 			while (raw_n--) {
@@ -566,18 +559,9 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers == 3);
 	input_report_key(input, BTN_TOOL_QUADTAP, dev->fingers > 3);
 
-	input_report_abs(input, ABS_PRESSURE, abs_p);
-	input_report_abs(input, ABS_TOOL_WIDTH, abs_w);
-
-	if (abs_p) {
+	if (dev->fingers > 0) {
 		input_report_abs(input, ABS_X, abs_x);
 		input_report_abs(input, ABS_Y, abs_y);
-
-		dprintk(8,
-			"bcm5974: abs: p: %+05d w: %+05d x: %+05d y: %+05d "
-			"nmin: %d nmax: %d n: %d ibt: %d\n", abs_p, abs_w,
-			abs_x, abs_y, nmin, nmax, dev->fingers, ibt);
-
 	}
 
 	/* type 2 reports button events via ibt only */
-- 
1.7.12

