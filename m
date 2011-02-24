Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1BXOSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:18:15 -0500
Received: from smtp.nokia.com ([147.243.128.24]:35729 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892Ab1BXOSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:18:12 -0500
From: Tero Kristo <tero.kristo@nokia.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] cpuidle: menu: fixed wrapping timers at 4.294 seconds
Date: Thu, 24 Feb 2011 17:19:23 +0200
Message-Id: <1298560763-441-1-git-send-email-tero.kristo@nokia.com>
X-Mailer: git-send-email 1.7.1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpuidle menu governor is using u32 as a temporary datatype for storing
nanosecond values which wrap around at 4.294 seconds. This causes errors
in predicted sleep times resulting in higher than should be C state
selection and increased power consumption. This also breaks cpuidle
state residency statistics.

Signed-off-by: Tero Kristo <tero.kristo@nokia.com>
---
 drivers/cpuidle/governors/menu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f508690..c47f3d0 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -237,6 +237,7 @@ static int menu_select(struct cpuidle_device *dev)
 	unsigned int power_usage = -1;
 	int i;
 	int multiplier;
+	struct timespec t;
 
 	if (data->needs_update) {
 		menu_update(dev);
@@ -251,8 +252,9 @@ static int menu_select(struct cpuidle_device *dev)
 		return 0;
 
 	/* determine the expected residency time, round up */
+	t = ktime_to_timespec(tick_nohz_get_sleep_length());
 	data->expected_us =
-	    DIV_ROUND_UP((u32)ktime_to_ns(tick_nohz_get_sleep_length()), 1000);
+		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
 
 
 	data->bucket = which_bucket(data->expected_us);
-- 
1.7.1

