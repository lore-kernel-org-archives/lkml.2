Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2JPNCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:02:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:24835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab2JPNBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:01:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235733989"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org
Cc: Rik van Riel <riel@redhat.com>,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 5/5] x86,idle: Get typical recent sleep interval
Date: Tue, 16 Oct 2012 21:04:40 -0400
Message-Id: <1350435880-19143-6-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1350435880-19143-5-git-send-email-youquan.song@intel.com>
References: <1350435880-19143-1-git-send-email-youquan.song@intel.com>
 <1350435880-19143-2-git-send-email-youquan.song@intel.com>
 <1350435880-19143-3-git-send-email-youquan.song@intel.com>
 <1350435880-19143-4-git-send-email-youquan.song@intel.com>
 <1350435880-19143-5-git-send-email-youquan.song@intel.com>
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

The original patch come from Rik van Riel <riel@redhat.com>.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 drivers/cpuidle/governors/menu.c |   69 +++++++++++++++++++++++++------------
 1 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 7dbac97..dbb9e1c 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -237,36 +237,59 @@ static enum hrtimer_restart menu_hrtimer_notify(struct hrtimer *hrtimer)
  * of points is below a threshold. If it is... then use the
  * average of these 8 points as the estimated value.
  */
-static int detect_repeating_patterns(struct menu_device *data)
+static u32 get_typical_interval(struct menu_device *data)
 {
-	int i;
-	uint64_t avg = 0;
-	uint64_t stddev = 0; /* contains the square of the std deviation */
-	int ret = 0;
-
-	/* first calculate average and standard deviation of the past */
-	for (i = 0; i < INTERVALS; i++)
-		avg += data->intervals[i];
-	avg = avg / INTERVALS;
+	int i = 0, divisor = 0;
+	int64_t max = 0, avg = 0, stddev = 0;
+	int64_t thresh = LLONG_MAX; /* Discard outliers above this value. */
+	unsigned int ret = 0;
 
-	/* if the avg is beyond the known next tick, it's worthless */
-	if (avg > data->expected_us)
-		return 0;
-
-	for (i = 0; i < INTERVALS; i++)
-		stddev += (data->intervals[i] - avg) *
-			  (data->intervals[i] - avg);
+again:
 
-	stddev = stddev / INTERVALS;
+	/* first calculate average and standard deviation of the past */
+	max = avg = divisor = stddev = 0;
+	for (i = 0; i < INTERVALS; i++) {
+		int64_t value = data->intervals[i];
+		if (value <= thresh) {
+			avg += value;
+			divisor++;
+			if (value > max)
+				max = value;
+		}
+	}
+	do_div(avg, divisor);
 
+	for (i = 0; i < INTERVALS; i++) {
+		int64_t value = data->intervals[i];
+		if (value <= thresh) {
+			int64_t diff = value - avg;
+			stddev += diff * diff;
+		}
+	}
+	do_div(stddev, divisor);
+	stddev = int_sqrt(stddev);
 	/*
-	 * now.. if stddev is small.. then assume we have a
-	 * repeating pattern and predict we keep doing this.
+	 * If we have outliers to the upside in our distribution, discard
+	 * those by setting the threshold to exclude these outliers, then
+	 * calculate the average and standard deviation again. Once we get
+	 * down to the bottom 3/4 of our samples, stop excluding samples.
+	 *
+	 * This can deal with workloads that have long pauses interspersed
+	 * with sporadic activity with a bunch of short pauses.
+	 *
+	 * The typical interval is obtained when standard deviation is small
+	 * or standard deviation is small compared to the average interval.
 	 */
-
-	if (avg && stddev < STDDEV_THRESH) {
+	if (((avg > stddev * 6) && (divisor * 4 >= INTERVALS * 3))
+							|| stddev <= 20) {
 		data->predicted_us = avg;
 		ret = 1;
+		return ret;
+
+	} else if ((divisor * 4) > INTERVALS * 3) {
+		/* Exclude the max interval */
+		thresh = max - 1;
+		goto again;
 	}
 
 	return ret;
@@ -322,7 +345,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
 					 RESOLUTION * DECAY);
 
-	repeat = detect_repeating_patterns(data);
+	repeat = get_typical_interval(data);
 
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
-- 
1.7.7.4

