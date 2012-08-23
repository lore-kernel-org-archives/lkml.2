Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505Ab2HWVNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:13:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934412Ab2HWVNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:13:46 -0400
Date: Thu, 23 Aug 2012 17:13:04 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ShuoX Liu <shuox.liu@intel.com>,
        mjg59@srcf.ucam.org, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [RFC][PATCH 2/3] cpuidle: find a typical recent sleep interval
Message-ID: <20120823171304.47554aea@cuia.bos.redhat.com>
In-Reply-To: <20120823171104.38574add@cuia.bos.redhat.com>
References: <20120823171104.38574add@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function detect_repeating_patterns was not very useful for
workloads with alternating long and short pauses, for example
virtual machines handling network requests for each other (say
a web and database server).

Instead, try to find a recent sleep interval that is somewhere
between the median and the mode sleep time, by discarding outliers
to the up side and recalculating the average and standard deviation
until that is no longer required.

This should do something sane with a sleep interval series like:

	200 180 210 10000 30 1000 170 200

The current code would simply discard such a series, while the
new code will guess a typical sleep interval just shy of 200.

Signed-off-by: Rik van Riel <riel@redhat.com>

... should we apply this idea to the bucket code instead,
keeping 8 intervals per bucket?
---
 drivers/cpuidle/governors/menu.c |   68 ++++++++++++++++++++++++-------------
 1 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f4fe5c3..87772bb 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -192,39 +192,59 @@ static u64 div_round64(u64 dividend, u32 divisor)
 }
 
 /*
- * Try detecting repeating patterns by keeping track of the last 8
- * intervals, and checking if the standard deviation of that set
- * of points is below a threshold. If it is... then use the
- * average of these 8 points as the estimated value.
+ * Try to find a typical sleep interval. By discarding the outliers
+ * on the up side only, we should arrive at a figure somewhere
+ * between the median and the mean sleep time.
  */
-static void detect_repeating_patterns(struct menu_device *data)
+static void get_typical_interval(struct menu_device *data)
 {
-	int i;
-	uint64_t avg = 0;
-	uint64_t stddev = 0; /* contains the square of the std deviation */
+	int i, divisor;
+	int64_t max, avg, stddev;
+	int64_t thresh = LLONG_MAX; /* Discard outliers above this value. */
 
+ again:
 	/* first calculate average and standard deviation of the past */
-	for (i = 0; i < INTERVALS; i++)
-		avg += data->intervals[i];
-	avg = avg / INTERVALS;
-
-	/* if the avg is beyond the known next tick, it's worthless */
-	if (avg > data->expected_us)
-		return;
-
+	max = avg = divisor = stddev = 0;
 	for (i = 0; i < INTERVALS; i++) {
-		int diff = (int)data->intervals[i] - avg;
-		stddev += diff * diff;
+		int64_t value = data->intervals[i];
+		if (value <= thresh) {
+			avg += value;
+			divisor++;
+			if (value > max)
+				max = value;
+		}
 	}
+	avg = avg / divisor;
 
-	stddev = stddev / INTERVALS;
+	for (i = 0; i < INTERVALS; i++) {
+		int64_t value = data->intervals[i];
+		if (value <= thresh) {
+			int64_t diff = value - avg;
+			stddev += diff * diff;
+		}
+	}
+	stddev = stddev / divisor;
+	stddev = int_sqrt(stddev);
 
 	/*
-	 * now.. if stddev is small.. then assume we have a
-	 * repeating pattern and predict we keep doing this.
+	 * If we have outliers to the upside in our distribution, discard
+	 * those by setting the threshold to exclude these outliers, then
+	 * calculate the average and standard deviation again. Once we get
+	 * down to the bottom 1/3 of our samples, stop excluding samples.
+	 *
+	 * This can deal with workloads that have long pauses interspersed
+	 * with sporadic activity with a bunch of short pauses.
 	 */
-
-	if (avg && stddev < STDDEV_THRESH)
+	if (avg && max > avg + (stddev * 2) && (divisor * 3) >= INTERVALS) {
+		thresh = avg + (stddev * 2);
+		goto again;
+	}
+		
+	/*
+	 * If the calculated interval is shorter than what the other code
+	 * expected, use it.
+	 */
+	if (avg && avg < data->expected_us)
 		data->predicted_us = avg;
 }
 
@@ -275,7 +295,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
 					 RESOLUTION * DECAY);
 
-	detect_repeating_patterns(data);
+	get_typical_interval(data);
 
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
