Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0EHWuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 18:50:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:60440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab0EHWuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 18:50:24 -0400
Date: Sat, 8 May 2010 15:52:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, czoccolo@gmail.com
Subject: [PATCH] cpuidle: Fix incorrect optimization
Message-ID: <20100508155256.0ff2d3bf@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 264ad94308de7c120a2c2b15acdb2973304c51c9 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 8 May 2010 15:47:37 -0700
Subject: [PATCH] cpuidle: Fix incorrect optimization

commit 672917dcc781ead7652a8b11b1fba14e38ac15b8 added an optimization,
where the analysis on the past idle period moved from the end of idle,
to the beginning of the new idle.

Unfortunately, this optimization had a bug where it zeroed one key variable
for new use, that is needed for the analysis. The fix is simple,
zero the variable after doing the work from the previous idle.

During the audit of the code that found this issue, another issue was
also found; the ->measured_us data structure member is never set,
a local variable is always used instead.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Cc: Corrado Zoccolo <czoccolo@gmail.com>
Cc: stable@kernel.org
---
 drivers/cpuidle/governors/menu.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 1aea715..f8e57c6 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -100,7 +100,6 @@ struct menu_device {
 	int             needs_update;
 
 	unsigned int	expected_us;
-	unsigned int	measured_us;
 	u64		predicted_us;
 	unsigned int	exit_us;
 	unsigned int	bucket;
@@ -187,14 +186,14 @@ static int menu_select(struct cpuidle_device *dev)
 	int i;
 	int multiplier;
 
-	data->last_state_idx = 0;
-	data->exit_us = 0;
-
 	if (data->needs_update) {
 		menu_update(dev);
 		data->needs_update = 0;
 	}
 
+	data->last_state_idx = 0;
+	data->exit_us = 0;
+
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0))
 		return 0;
@@ -294,7 +293,7 @@ static void menu_update(struct cpuidle_device *dev)
 	new_factor = data->correction_factor[data->bucket]
 			* (DECAY - 1) / DECAY;
 
-	if (data->expected_us > 0 && data->measured_us < MAX_INTERESTING)
+	if (data->expected_us > 0 && measured_us < MAX_INTERESTING)
 		new_factor += RESOLUTION * measured_us / data->expected_us;
 	else
 		/*
-- 
1.6.2.5

