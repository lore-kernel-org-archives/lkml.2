Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab2GYDwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:52:08 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62253 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826Ab2GYDmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:36 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 18/52] cpuidle: coupled: add parallel barrier function
Date: Tue, 24 Jul 2012 23:41:14 -0400
Message-Id: <20ff51a36b2cd25ee7eb3216b6d02b68935435ba.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

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
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/cpuidle/coupled.c | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/cpuidle.h   |  4 ++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index aab6bba..2c9bf26 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -130,6 +130,43 @@ static DEFINE_PER_CPU(struct call_single_data, cpuidle_coupled_poke_cb);
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
+	int n = dev->coupled->online_count;
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
@@ -183,6 +183,10 @@ static inline int cpuidle_play_dead(void) {return -ENODEV; }
 
 #endif
 
+#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
+void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev, atomic_t *a);
+#endif
+
 /******************************
  * CPUIDLE GOVERNOR INTERFACE *
  ******************************/
-- 
1.7.12.rc0

