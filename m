Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab2GVDme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 23:42:34 -0400
Received: from science.horizon.com ([71.41.210.146]:54893 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751064Ab2GVDmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 23:42:32 -0400
Date: 21 Jul 2012 23:42:28 -0400
Message-ID: <20120722034228.14345.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dmitry.torokhov@gmail.com, dtor@mail.ru, linux-input@vger.kernel.org
Subject: [REPOST #3 PATCH v2] Input: atkbd - make repeat period more accurate.
Cc: linux-kernel@vger.kernel.org, linux@horizon.com
In-Reply-To: <20120714110114.31895.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces some inaccurate lookup tables with an exact
computation.  Although the diff adds source comments,
it shrinks binary size.  (By only 50 bytes, but hey.)

AT keyboard repeat rates are multiples of 1/240 second
expressed in a 0.2.3 bit floating point format.  That
is, possible values are ({8..15} << {0..3}) / 240 s.

In addition to a slightly inaccurate lookup table, the
old code would round up to the next repeat period.
E.g. to get a period of 9/60 = 0.15 seconds, you had to
ask for no more than 149 ms; if you asked for 150, it
would round up to 167.  The new code rounds to nearest.

User-visible changes to the repeat periods reported by EVIOCGREP:

Old	 37	109	116	149	182	232
Exact	 37.50	108.33	116.66	150.00	183.33	233.33
New	 38	108	117	150	183	233

Old	270	303	370	435	470
Exact	266.66	300.00	366.66	433.33	466.66
New	267	300	367	433	467

This does not bother utilities like kbdrate(8).

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/input/keyboard/atkbd.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

Now that 3.5 is out, I'm posting this for a FOURTH time,
hoping for some comments of any sort.


Now that I've tweaked it (v1 had an error in rounding near exponent
range boundaries), I think it's ready for merging upstream.


One possible bug I observed in the code that calls this:

Users of the KDKBDREP ioctl seem to assume that it returns the actual
values set, but I'm not sure it really works that way; I don't think
the command to change the parameters makes its way through the event
queue and atkbd's schedule_delayed_work() to actually set dev->rep[]
to the rounded values before kbd_rate_helper returns them to userspace.

If desired, the fix that's most obvious to me would be to split this
function in two: perform the conversion to a command byte synchronously,
and only defer the actual ps2_command().

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index e05a2e7..3181b86 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -524,27 +524,42 @@ out:
 	return IRQ_HANDLED;
 }
 
+/*
+ * AT keyboard repeat rates are set using a 2-bit initial repeat delay
+ * (250, 500, 750 or 1000 ms), and a 5-bit repeat period.  The latter
+ * is a 0.2.3-bit floating-point number (no sign, 2-bit exponent, and
+ * 3-bit mantissa), encoding a value from 8/240 to 120/240 of second.
+ *
+ * Given the requested delay and period in milliseconds, round to the
+ * nearest representable value, and convert the rounded values back to
+ * milliseconds to report the chosen values.
+ */
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
-
-	while (i < ARRAY_SIZE(period) - 1 && period[i] < dev->rep[REP_PERIOD])
-		i++;
-	dev->rep[REP_PERIOD] = period[i];
-
-	while (j < ARRAY_SIZE(delay) - 1 && delay[j] < dev->rep[REP_DELAY])
-		j++;
-	dev->rep[REP_DELAY] = delay[j];
+	unsigned exp = 3;	/* Period exponent */
+	int period;		/* Period mantissa */
+	int delay = clamp(dev->rep[REP_DELAY], 125, 1000);
+
+	/* AT kbd delay is {1..4} * 250 ms.  Round to 2 bits. */
+	delay = (delay + 125) / 250u;
+	/* Store actual value back */
+	dev->rep[REP_DELAY] = delay * 250;
+
+	/* AT kbd period is ({8..15} << {0..3}) / 240 s. */
+	period = clamp(dev->rep[REP_PERIOD], 33, 500);
+	/* Get correct exponent.  Split is at 258.333 ms */
+	while (period < 259) {
+		period <<= 1;
+		exp--;
+	}
+	/* Convert from 259..516 ms to 8..15 30ths of a second */
+	period = (period * 3 + 50) / 100u;
+	/* Store actual value back.  x * 1000 / 240 = x * 25 / 6 */
+	dev->rep[REP_PERIOD] = ((period << exp) * 25 + 3) / 6u;
 
-	param = i | (j << 5);
+	param = (delay - 1) << 5 | exp << 3 | (period - 8);
 	return ps2_command(&atkbd->ps2dev, &param, ATKBD_CMD_SETREP);
 }
 
