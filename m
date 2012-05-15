Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965435Ab2EOCR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53003 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964893Ab2EOCQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 036/179] cpuidle: menu: fixed wrapping timers at 4.294 seconds
Date: Mon, 14 May 2012 22:12:12 -0400
Message-ID: <1337048075-6132-37-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tero Kristo <tero.kristo@nokia.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7467571f4480b273007517b26297c07154c73924 upstream.

Cpuidle menu governor is using u32 as a temporary datatype for storing
nanosecond values which wrap around at 4.294 seconds. This causes errors
in predicted sleep times resulting in higher than should be C state
selection and increased power consumption. This also breaks cpuidle
state residency statistics.

cc: stable@kernel.org # .32.x through .39.x
Signed-off-by: Tero Kristo <tero.kristo@nokia.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/cpuidle/governors/menu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f8e57c6..0537437 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -185,6 +185,7 @@ static int menu_select(struct cpuidle_device *dev)
 	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	int multiplier;
+	struct timespec t;
 
 	if (data->needs_update) {
 		menu_update(dev);
@@ -199,8 +200,9 @@ static int menu_select(struct cpuidle_device *dev)
 		return 0;
 
 	/* determine the expected residency time, round up */
+	t = ktime_to_timespec(tick_nohz_get_sleep_length());
 	data->expected_us =
-	    DIV_ROUND_UP((u32)ktime_to_ns(tick_nohz_get_sleep_length()), 1000);
+		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
 
 
 	data->bucket = which_bucket(data->expected_us);
-- 
1.7.9.6

