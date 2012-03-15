Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607Ab2COAJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:09:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55282 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355Ab2COAJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:09:45 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org, rob.lee@linaro.org, j-pihet@ti.com,
        khilman@ti.com, deepthi@linux.vnet.ibm.com, dan.carpenter@oracle.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        hughd@google.com, amit.kucheria@linaro.org
Subject: [PATCH] cpuidle : fix random hangs with intel_idle
Date: Thu, 15 Mar 2012 01:09:41 +0100
Message-Id: <1331770181-800-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils>
References: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuidle consolidation inverts the local_irq_enable for
the poll_idle function with CPU_RELAX.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reported-by: Hugh Dickins <hughd@google.com>
---
 drivers/cpuidle/cpuidle.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 56de5f7..4869b55 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -213,20 +213,25 @@ int cpuidle_wrap_enter(struct cpuidle_device *dev,
 }
 
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static inline int __poll_idle(struct cpuidle_device *dev,
+static int poll_idle(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index)
 {
+	ktime_t	t1, t2;
+	s64 diff;
+
+	t1 = ktime_get();
+	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
 
-	return index;
-}
+	t2 = ktime_get();
+	diff = ktime_to_us(ktime_sub(t2, t1));
+	if (diff > INT_MAX)
+		diff = INT_MAX;
 
-static int poll_idle(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int index)
-{
-	return cpuidle_wrap_enter(dev,	drv, index,
-				__poll_idle);
+	dev->last_residency = (int) diff;
+
+	return index;
 }
 
 static void poll_idle_init(struct cpuidle_driver *drv)
-- 
1.7.5.4

