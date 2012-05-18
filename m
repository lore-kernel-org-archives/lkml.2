Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966441Ab2ERSM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:12:29 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:41223 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965672Ab2ERSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:12:28 -0400
From: Colin Cross <ccross@android.com>
To: Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Colin Cross <ccross@android.com>
Subject: [PATCH 2/2] cpuidle: coupled: fix decrementing ready count
Date: Fri, 18 May 2012 11:05:24 -0700
Message-Id: <1337364324-12171-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337364324-12171-1-git-send-email-ccross@android.com>
References: <1337364324-12171-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuidle_coupled_set_not_ready sometimes refuses to decrement the
ready count in order to prevent a race condition.  This makes it
unsuitable for use when finished with idle.  Add a new function
cpuidle_coupled_set_done that decrements both the ready count and
waiting count, and call it after idle is complete.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/cpuidle/coupled.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index b02810a..fc427fa 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -388,6 +388,21 @@ static void cpuidle_coupled_set_not_waiting(int cpu,
 }
 
 /**
+ * cpuidle_coupled_set_done - mark this cpu as leaving the ready loop
+ * @cpu: the current cpu
+ * @coupled: the struct coupled that contains the current cpu
+ *
+ * Marks this cpu as no longer in the ready and waiting loops.  Decrements
+ * the waiting count first to prevent another cpu looping back in and seeing
+ * this cpu as waiting just before it exits idle.
+ */
+static void cpuidle_coupled_set_done(int cpu, struct cpuidle_coupled *coupled)
+{
+	cpuidle_coupled_set_not_waiting(cpu, coupled);
+	atomic_sub(MAX_WAITING_CPUS, &coupled->ready_waiting_counts);
+}
+
+/**
  * cpuidle_coupled_clear_pokes - spin until the poke interrupt is processed
  * @cpu - this cpu
  *
@@ -501,8 +516,7 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
 
 	entered_state = cpuidle_enter_state(dev, drv, next_state);
 
-	cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
-	cpuidle_coupled_set_not_ready(coupled);
+	cpuidle_coupled_set_done(dev->cpu, coupled);
 
 out:
 	/*
-- 
1.7.7.3

