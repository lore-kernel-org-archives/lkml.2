Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1AGX35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:29:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1AGX3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:29:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuidle: Make cpuidle_enable_device() call poll_idle_init()
Date: Sat, 8 Jan 2011 00:29:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101080029.20744.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The following scenario is possible with the current cpuidle code and
the ACPI cpuidle driver:
(1) acpi_processor_cst_has_changed() is called,
(2) cpuidle_disable_device() is called,
(3) cpuidle_remove_state_sysfs() is called to remove the (presumably
    outdated) states info from sysfs,
(3) acpi_processor_get_power_info() is called, the first entry in the
    pr->power.states[] table is filled with zeros,
(4) acpi_processor_setup_cpuidle() is called and it doesn't fill the
    first entry in pr->power.states[],
(5) cpuidle_enable_device() is called,
(6) __cpuidle_register_device() is _not_ called, since the device has
    already been registered,
(7) Consequently, poll_idle_init() is _not_ called either,
(8) cpuidle_add_state_sysfs() is called to create the sysfs attributes
    for the new states and it uses the bogus first table entry from
    acpi_processor_get_power_info() for creating state0.

This problem will be avoided if cpuidle_enable_device() calls
poll_idle_init() for dev->registered different from zero.

Reported-by: Len Brown <len.brown@intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/cpuidle/cpuidle.c |   80 +++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 39 deletions(-)

Index: linux-2.6/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.orig/drivers/cpuidle/cpuidle.c
+++ linux-2.6/drivers/cpuidle/cpuidle.c
@@ -154,6 +154,45 @@ void cpuidle_resume_and_unlock(void)
 
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
+#ifdef CONFIG_ARCH_HAS_CPU_RELAX
+static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
+{
+	ktime_t	t1, t2;
+	s64 diff;
+	int ret;
+
+	t1 = ktime_get();
+	local_irq_enable();
+	while (!need_resched())
+		cpu_relax();
+
+	t2 = ktime_get();
+	diff = ktime_to_us(ktime_sub(t2, t1));
+	if (diff > INT_MAX)
+		diff = INT_MAX;
+
+	ret = (int) diff;
+	return ret;
+}
+
+static void poll_idle_init(struct cpuidle_device *dev)
+{
+	struct cpuidle_state *state = &dev->states[0];
+
+	cpuidle_set_statedata(state, NULL);
+
+	snprintf(state->name, CPUIDLE_NAME_LEN, "C0");
+	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
+	state->exit_latency = 0;
+	state->target_residency = 0;
+	state->power_usage = -1;
+	state->flags = CPUIDLE_FLAG_POLL;
+	state->enter = poll_idle;
+}
+#else
+static void poll_idle_init(struct cpuidle_device *dev) {}
+#endif /* CONFIG_ARCH_HAS_CPU_RELAX */
+
 /**
  * cpuidle_enable_device - enables idle PM for a CPU
  * @dev: the CPU
@@ -176,6 +215,8 @@ int cpuidle_enable_device(struct cpuidle
 		ret = __cpuidle_register_device(dev);
 		if (ret)
 			return ret;
+	} else {
+		poll_idle_init(dev);
 	}
 
 	if ((ret = cpuidle_add_state_sysfs(dev)))
@@ -232,45 +273,6 @@ void cpuidle_disable_device(struct cpuid
 
 EXPORT_SYMBOL_GPL(cpuidle_disable_device);
 
-#ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
-{
-	ktime_t	t1, t2;
-	s64 diff;
-	int ret;
-
-	t1 = ktime_get();
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
-
-	t2 = ktime_get();
-	diff = ktime_to_us(ktime_sub(t2, t1));
-	if (diff > INT_MAX)
-		diff = INT_MAX;
-
-	ret = (int) diff;
-	return ret;
-}
-
-static void poll_idle_init(struct cpuidle_device *dev)
-{
-	struct cpuidle_state *state = &dev->states[0];
-
-	cpuidle_set_statedata(state, NULL);
-
-	snprintf(state->name, CPUIDLE_NAME_LEN, "C0");
-	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
-	state->exit_latency = 0;
-	state->target_residency = 0;
-	state->power_usage = -1;
-	state->flags = CPUIDLE_FLAG_POLL;
-	state->enter = poll_idle;
-}
-#else
-static void poll_idle_init(struct cpuidle_device *dev) {}
-#endif /* CONFIG_ARCH_HAS_CPU_RELAX */
-
 /**
  * __cpuidle_register_device - internal register function called before register
  * and enable routines
