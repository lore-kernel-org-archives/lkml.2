Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab1BPAuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:50:14 -0500
Received: from kroah.org ([198.145.64.141]:45852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933116Ab1BPAuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:09 2011
Message-Id: <20110216002109.488482993@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [patch 104/176] cpuidle: Make cpuidle_enable_device() call poll_idle_init()
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit d8c216cfa57e8a579f41729cbb88c97835d9ac8d upstream.

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

This problem is avoided if cpuidle_enable_device()
unconditionally calls poll_idle_init().

Reported-by: Len Brown <len.brown@intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpuidle/cpuidle.c |   82 +++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
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
@@ -178,6 +217,8 @@ int cpuidle_enable_device(struct cpuidle
 			return ret;
 	}
 
+	poll_idle_init(dev);
+
 	if ((ret = cpuidle_add_state_sysfs(dev)))
 		return ret;
 
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
@@ -291,8 +293,6 @@ static int __cpuidle_register_device(str
 
 	init_completion(&dev->kobj_unregister);
 
-	poll_idle_init(dev);
-
 	/*
 	 * cpuidle driver should set the dev->power_specified bit
 	 * before registering the device if the driver provides


