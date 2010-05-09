Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0EIXCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 19:02:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:46620 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0EIXCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 19:02:10 -0400
Date: Sun, 9 May 2010 16:04:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org
Subject: [PATCH 2/2] cpuidle: Add a repeating pattern detector to the menu
 governor
Message-ID: <20100509160444.260ca9c9@infradead.org>
In-Reply-To: <20100509160242.2e351e6a@infradead.org>
References: <20100509160242.2e351e6a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 9 May 2010 15:49:43 -0700
Subject: [PATCH 2/2] cpuidle: Add a repeating pattern detector to the menu governor

Currently, the menu governor uses the (corrected) next timer as key
item for predicting the idle duration.

It turns out that there are specific cases where this breaks down:
There are cases where we have a very repetitive pattern of idle durations,
where the idle period is pretty much the same, for reasons completely
unrelated to the next timer event. Examples of such repeating patterns
are network loads with irq mitigation, the mouse moving but in theory
also the wifi beacons.

This patch adds a relatively simple detector for such repeating patterns,
where the standard deviation of the last 8 idle periods is compared
to a threshold.

With this extra predictor in place, measurements show that the DECAY
factor can now be increased (the decaying average will now decay slower)
to get an even more stable result.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/cpuidle/governors/menu.c |   60 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f8e57c6..4eeef00 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -21,9 +21,12 @@
 #include <linux/math64.h>
 
 #define BUCKETS 12
+#define INTERVALS 8
 #define RESOLUTION 1024
-#define DECAY 4
+#define DECAY 8
 #define MAX_INTERESTING 50000
+#define STDDEV_THRESH 400
+
 
 /*
  * Concepts and ideas behind the menu governor
@@ -64,6 +67,16 @@
  * indexed based on the magnitude of the expected duration as well as the
  * "is IO outstanding" property.
  *
+ * Repeatable-interval-detector
+ * ----------------------------
+ * There are some cases where "next timer" is a completely unusable predictor:
+ * Those cases where the interval is fixed, for example due to hardware
+ * interrupt mitigation, but also due to fixed transfer rate devices such as
+ * mice.
+ * For this, we use a different predictor: We track the duration of the last 8
+ * intervals and if the stand deviation of these 8 intervals is below a
+ * threshold value, we use the average of these intervals as prediction.
+ *
  * Limiting Performance Impact
  * ---------------------------
  * C states, especially those with large exit latencies, can have a real
@@ -104,6 +117,8 @@ struct menu_device {
 	unsigned int	exit_us;
 	unsigned int	bucket;
 	u64		correction_factor[BUCKETS];
+	u32		intervals[INTERVALS];
+	int		interval_ptr;
 };
 
 
@@ -175,6 +190,42 @@ static u64 div_round64(u64 dividend, u32 divisor)
 	return div_u64(dividend + (divisor / 2), divisor);
 }
 
+/*
+ * Try detecting repeating patterns by keeping track of the last 8
+ * intervals, and checking if the standard deviation of that set
+ * of points is below a threshold. If it is... then use the
+ * average of these 8 points as the estimated value.
+ */
+static void detect_repeating_patterns(struct menu_device *data)
+{
+	int i;
+	uint64_t avg = 0;
+	uint64_t stddev = 0; /* contains the square of the std deviation */
+
+	/* first calculate average and standard deviation of the past */
+	for (i = 0; i < INTERVALS; i++)
+		avg += data->intervals[i];
+
+	/* if the avg is beyond the known next tick, it's worthless */
+	if (avg > data->expected_us)
+		return;
+
+	avg = avg / INTERVALS;
+	for (i = 0; i < INTERVALS; i++)
+		stddev += (data->intervals[i] - avg) *
+			  (data->intervals[i] - avg);
+
+	stddev = stddev / INTERVALS;
+
+	/*
+	 * now.. if stddev is small.. then assume we have a
+	 * repeating pattern and predict we keep doing this.
+	 */
+
+	if (avg && stddev < STDDEV_THRESH)
+		data->predicted_us = avg;
+}
+
 /**
  * menu_select - selects the next idle state to enter
  * @dev: the CPU
@@ -218,6 +269,8 @@ static int menu_select(struct cpuidle_device *dev)
 	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
 					 RESOLUTION * DECAY);
 
+	detect_repeating_patterns(data);
+
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
 	 * unless the timer is happening really really soon.
@@ -310,6 +363,11 @@ static void menu_update(struct cpuidle_device *dev)
 		new_factor = 1;
 
 	data->correction_factor[data->bucket] = new_factor;
+
+	/* update the repeating-pattern data */
+	data->intervals[data->interval_ptr++] = last_idle_us;
+	if (data->interval_ptr >= INTERVALS)
+		data->interval_ptr = 0;
 }
 
 /**
-- 
1.6.2.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
