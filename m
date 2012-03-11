Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2CKWld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 18:41:33 -0400
Received: from science.horizon.com ([71.41.210.146]:49377 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751923Ab2CKWla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 18:41:30 -0400
Date: 11 Mar 2012 18:41:28 -0400
Message-ID: <20120311224128.23283.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dmitry.torokhov@gmail.com, dtor@mail.ru
Subject: [PATCH] Input: atkbd - make repeat period more accurate.
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces some inaccurate lookup tables with an
exact computation.  Although the diff adds code lines,
it shrinks binary size.  (By only 50 bytes, but hey!)

AT keyboard repeat rates are multiples of 1/240 second
expressed in a 0.2.3 bit floating point format.  That
is, possible values are ({8..15} << {0..3}) / 240 s.

In addition to a slightly inaccurate lookup table, the
old code would round up to the next repeat period.
E.g. to get a period of 9/60 = 0.15 seconds, you had to
ask for no more than 149 ms; if you asked for 150, it
would round up to 167.  The new code rounds to nearest.

User-visible changes to the repeat periods reported by EVIOCGREP:

Old	 37	109	116	149	182
Exact	 37.50	108.33	116.66	150.00	183.33
New	 38	108	117	150	183

Old	232	270	303	370	435	470
Exact	233.33	266.66	300.00	366.66	433.33	466.66
New	233	267	300	367	433	467

This does not bother utilities like kbdrate(8).

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/input/keyboard/atkbd.c |   41 ++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 14 deletions(-)

Dmitry, you seem to be the one constant name in all recent changes to
this file, so I'm sending this to you for comment.  Like it?  Hate it?

Please DON'T apply this until I've done more testing, but if you
hate it, tell me and I'll abandon it.

Users of the KDKBDREP ioctl seem to assume that it returns the actual
values set, but I'm not sure it really works that way; I don't think
the command to change the parameters makes its way through the event
queue and atkbd's schedule_delayed_work() to actually set dev->rep[]
to the rounded values before kbd_rate_helper returns them to userspace.
But that's a separate problem.

If desired, the fix that's most obvious to me would be to perform the
conversion to a command byte synchronously, and only defer the actual
ps2_command().

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index e05a2e7..73efac1 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -526,25 +526,38 @@ out:
 
 static int atkbd_set_repeat_rate(struct atkbd *atkbd)
 {
-	const short period[32] =
-		{ 33,  37,  42,  46,  50,  54,  58,  63,  67,  75,  83,  92, 100, 109, 116, 125,
-		 133, 149, 167, 182, 200, 217, 232, 250, 270, 303, 333, 370, 400, 435, 470, 500 };
-	const short delay[4] =
-		{ 250, 500, 750, 1000 };
-
 	struct input_dev *dev = atkbd->dev;
 	unsigned char param;
-	int i = 0, j = 0;
+	int delay = dev->rep[REP_DELAY];
+	unsigned exp = 3;			/* Period exponent */
+	int period = dev->rep[REP_PERIOD];	/* Period mantissa */
 
-	while (i < ARRAY_SIZE(period) - 1 && period[i] < dev->rep[REP_PERIOD])
-		i++;
-	dev->rep[REP_PERIOD] = period[i];
+	/* AT kbd delay is {1..4} * 250 ms.  Clamp to range */
+	if (delay < 125)
+		delay = 125;
+	else if (delay > 1000)
+		delay = 1000;
+	/* Round to 2-bit value */
+	delay = (delay + 125) / 250u;
+	/* Store actual value back */
+	dev->rep[REP_DELAY] = delay * 250;
 
-	while (j < ARRAY_SIZE(delay) - 1 && delay[j] < dev->rep[REP_DELAY])
-		j++;
-	dev->rep[REP_DELAY] = delay[j];
+	/* AT kbd period is ({8..15} << {0..3}) / 240 s. */
+	if (period < 34)
+		period = 34;
+	else if (period > 500)
+		period = 500;
+	/* Get correct exponent */
+	while (period <= 250) {
+		period <<= 1;
+		exp--;
+	}
+	/* Convert from 251..500 ms to 8..15 30ths of a second */
+	period = (period * 3 + 50) / 100u;
+	/* Store actual value back */
+	dev->rep[REP_PERIOD] = ((period << exp) * 25 + 3) / 6;
 
-	param = i | (j << 5);
+	param = (delay - 1) << 5 | exp << 3 | (period - 8);
 	return ps2_command(&atkbd->ps2dev, &param, ATKBD_CMD_SETREP);
 }
 
-- 
1.7.9.1

