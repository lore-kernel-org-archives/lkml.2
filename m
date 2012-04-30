Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab2D3UJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:09:23 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41431 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab2D3UJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:09:20 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-pm@lists.linux-foundation.org,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>
Subject: [PATCHv3 4/5] cpuidle: coupled: add parallel barrier function
Date: Mon, 30 Apr 2012 13:09:10 -0700
Message-Id: <1335816551-27756-5-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1335816551-27756-1-git-send-email-ccross@android.com>
References: <1335816551-27756-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds cpuidle_coupled_parallel_barrier, which can be used by coupled
cpuidle state enter functions to handle resynchronization after
determining if any cpu needs to abort.  The normal use case will
be:

static bool abort_flag;
static atomic_t abort_barrier;

int arch_cpuidle_enter(struct cpuidle_device *dev, ...)
{
	if (arch_turn_off_irq_controller()) {
	   	/* returns an error if an irq is pending and would be lost
		   if idle continued and turned off power */
		abort_flag = true;
	}

	cpuidle_coupled_parallel_barrier(dev, &abort_barrier);

	if (abort_flag) {
	   	/* One of the cpus didn't turn off it's irq controller */
	   	arch_turn_on_irq_controller();
		return -EINTR;
	}

	/* continue with idle */
	...
}

This will cause all cpus to abort idle together if one of them needs
to abort.

Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Tested-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/cpuidle/coupled.c |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/cpuidle.h   |    4 ++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index d097826..242dc7c 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -134,6 +134,43 @@ struct cpuidle_coupled {
 static cpumask_t cpuidle_coupled_poked_mask;
 
 /**
+ * cpuidle_coupled_parallel_barrier - synchronize all online coupled cpus
+ * @dev: cpuidle_device of the calling cpu
+ * @a:   atomic variable to hold the barrier
+ *
+ * No caller to this function will return from this function until all online
+ * cpus in the same coupled group have called this function.  Once any caller
+ * has returned from this function, the barrier is immediately available for
+ * reuse.
+ *
+ * The atomic variable a must be initialized to 0 before any cpu calls
+ * this function, will be reset to 0 before any cpu returns from this function.
+ *
+ * Must only be called from within a coupled idle state handler
+ * (state.enter when state.flags has CPUIDLE_FLAG_COUPLED set).
+ *
+ * Provides full smp barrier semantics before and after calling.
+ */
+void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev, atomic_t *a)
+{
+	int n = atomic_read(&dev->coupled->alive_count);
+
+	smp_mb__before_atomic_inc();
+	atomic_inc(a);
+
+	while (atomic_read(a) < n)
+		cpu_relax();
+
+	if (atomic_inc_return(a) == n * 2) {
+		atomic_set(a, 0);
+		return;
+	}
+
+	while (atomic_read(a) > n)
+		cpu_relax();
+}
+
+/**
  * cpuidle_state_is_coupled - check if a state is part of a coupled set
  * @dev: struct cpuidle_device for the current cpu
  * @drv: struct cpuidle_driver for the platform
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 6038448..5ab7183 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -183,6 +183,10 @@ static inline int cpuidle_wrap_enter(struct cpuidle_device *dev,
 
 #endif
 
+#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
+void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev, atomic_t *a);
+#endif
+
 /******************************
  * CPUIDLE GOVERNOR INTERFACE *
  ******************************/
-- 
1.7.7.3

