Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1G0Vsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:17376 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab1G0VsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="32274613"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: tero.kristo@nokia.com, len.brown@intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [26/99] cpuidle: menu: fixed wrapping timers at 4.294 seconds
Message-Id: <20110727214824.C36E82403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tero Kristo <tero.kristo@nokia.com>

commit 7467571f4480b273007517b26297c07154c73924 upstream.

Cpuidle menu governor is using u32 as a temporary datatype for storing
nanosecond values which wrap around at 4.294 seconds. This causes errors
in predicted sleep times resulting in higher than should be C state
selection and increased power consumption. This also breaks cpuidle
state residency statistics.

Signed-off-by: Tero Kristo <tero.kristo@nokia.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/cpuidle/governors/menu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/cpuidle/governors/menu.c
===================================================================
--- linux-2.6.35.y.orig/drivers/cpuidle/governors/menu.c
+++ linux-2.6.35.y/drivers/cpuidle/governors/menu.c
@@ -236,6 +236,7 @@ static int menu_select(struct cpuidle_de
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	int multiplier;
+	struct timespec t;
 
 	if (data->needs_update) {
 		menu_update(dev);
@@ -250,8 +251,9 @@ static int menu_select(struct cpuidle_de
 		return 0;
 
 	/* determine the expected residency time, round up */
+	t = ktime_to_timespec(tick_nohz_get_sleep_length());
 	data->expected_us =
-	    DIV_ROUND_UP((u32)ktime_to_ns(tick_nohz_get_sleep_length()), 1000);
+		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
 
 
 	data->bucket = which_bucket(data->expected_us);
