Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0H1O36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 10:29:58 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:38215 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042Ab0H1O34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 10:29:56 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/3] hid: 3m: Correct touchscreen emulation
Date: Sat, 28 Aug 2010 16:29:08 +0200
Message-Id: <1283005748-3293-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283005748-3293-1-git-send-email-rydberg@euromail.se>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OpMPe-0004ub-An.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OpMPe-0004ub-An 55921e9f70325ce2177f1acbeab577d7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code sometimes misses to report the last BTN_TOUCH event
when multiple fingers are lifted simultaneously.  With the
introduction of MT slots, the tracking id is available to determine
the oldest active contact. Use this information to simplify and
correct the touchscreen emulation logic.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-3m-pct.c |   41 +++++------------------------------------
 1 files changed, 5 insertions(+), 36 deletions(-)

diff --git a/drivers/hid/hid-3m-pct.c b/drivers/hid/hid-3m-pct.c
index 9a3b047..65441e0 100644
--- a/drivers/hid/hid-3m-pct.c
+++ b/drivers/hid/hid-3m-pct.c
@@ -33,7 +33,6 @@ MODULE_LICENSE("GPL");
 struct mmm_finger {
 	__s32 x, y, w, h;
 	__u16 id;
-	__u8 rank;
 	bool prev_touch;
 	bool touch, valid;
 };
@@ -41,7 +40,7 @@ struct mmm_finger {
 struct mmm_data {
 	struct mmm_finger f[MAX_SLOTS];
 	__u16 id;
-	__u8 curid, num;
+	__u8 curid;
 	__u8 nexp, nreal;
 	bool touch, valid;
 };
@@ -152,13 +151,7 @@ static int mmm_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 {
 	struct mmm_finger *oldest = 0;
-	bool pressed = false, released = false;
 	int i;
-
-	/*
-	 * we need to iterate on all fingers to decide if we have a press
-	 * or a release event in our touchscreen emulation.
-	 */
 	for (i = 0; i < MAX_SLOTS; ++i) {
 		struct mmm_finger *f = &md->f[i];
 		if (!f->valid) {
@@ -179,34 +172,11 @@ static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 						wide ? f->w : f->h);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR,
 						wide ? f->h : f->w);
-			/*
-			 * touchscreen emulation: maintain the age rank
-			 * of this finger, decide if we have a press
-			 */
-			if (f->rank == 0) {
-				f->rank = ++(md->num);
-				if (f->rank == 1)
-					pressed = true;
-			}
-			if (f->rank == 1)
+			/* touchscreen emulation: pick the oldest contact */
+			if (!oldest || ((f->id - oldest->id) & (SHRT_MAX + 1)))
 				oldest = f;
 		} else {
 			/* this finger took off the screen */
-			/* touchscreen emulation: maintain age rank of others */
-			int j;
-
-			for (j = 0; j < 10; ++j) {
-				struct mmm_finger *g = &md->f[j];
-				if (g->rank > f->rank) {
-					g->rank--;
-					if (g->rank == 1)
-						oldest = g;
-				}
-			}
-			f->rank = 0;
-			--(md->num);
-			if (md->num == 0)
-				released = true;
 			input_event(input, EV_ABS, ABS_MT_TRACKING_ID, -1);
 		}
 		f->prev_touch = f->touch;
@@ -215,11 +185,10 @@ static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 
 	/* touchscreen emulation */
 	if (oldest) {
-		if (pressed)
-			input_event(input, EV_KEY, BTN_TOUCH, 1);
+		input_event(input, EV_KEY, BTN_TOUCH, 1);
 		input_event(input, EV_ABS, ABS_X, oldest->x);
 		input_event(input, EV_ABS, ABS_Y, oldest->y);
-	} else if (released) {
+	} else {
 		input_event(input, EV_KEY, BTN_TOUCH, 0);
 	}
 	input_sync(input);
-- 
1.7.1

