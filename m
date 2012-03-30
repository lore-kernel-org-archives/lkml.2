Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189Ab2C3LW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:22:26 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:51544 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933878Ab2C3LSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:18:42 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 58/76] idle, x86: Allow off-lined CPU to enter deeper C states
Date: Fri, 30 Mar 2012 06:14:01 -0400
Message-id: <1a022e3f1be11730bd8747b1af96a0274bf6356e.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

Currently when a CPU is off-lined it enters either MWAIT-based idle or,
if MWAIT is not desired or supported, HLT-based idle (which places the
processor in C1 state). This patch allows processors without MWAIT
support to stay in states deeper than C1.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/smpboot.c     |    4 +++-
 drivers/acpi/processor_idle.c |   31 +++++++++++++++++++++++++++++++
 drivers/cpuidle/cpuidle.c     |   28 ++++++++++++++++++++++++++++
 include/linux/cpuidle.h       |    5 +++++
 4 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..93a2a09 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -50,6 +50,7 @@
 #include <linux/tboot.h>
 #include <linux/stackprotector.h>
 #include <linux/gfp.h>
+#include <linux/cpuidle.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -1422,7 +1423,8 @@ void native_play_dead(void)
 	tboot_shutdown(TB_SHUTDOWN_WFS);
 
 	mwait_play_dead();	/* Only returns on failure */
-	hlt_play_dead();
+	if (cpuidle_play_dead())
+		hlt_play_dead();
 }
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0e8e2de..6b1d32a 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -770,6 +770,35 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 	return index;
 }
 
+
+/**
+ * acpi_idle_play_dead - enters an ACPI state for long-term idle (i.e. off-lining)
+ * @dev: the target CPU
+ * @index: the index of suggested state
+ */
+static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
+{
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
+	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
+
+	ACPI_FLUSH_CPU_CACHE();
+
+	while (1) {
+
+		if (cx->entry_method == ACPI_CSTATE_HALT)
+			halt();
+		else if (cx->entry_method == ACPI_CSTATE_SYSTEMIO) {
+			inb(cx->address);
+			/* See comment in acpi_idle_do_entry() */
+			inl(acpi_gbl_FADT.xpm_timer_block.address);
+		} else
+			return -ENODEV;
+	}
+
+	/* Never reached */
+	return 0;
+}
+
 /**
  * acpi_idle_enter_simple - enters an ACPI state without BM handling
  * @dev: the target CPU
@@ -1077,12 +1106,14 @@ static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
 				state->flags |= CPUIDLE_FLAG_TIME_VALID;
 
 			state->enter = acpi_idle_enter_c1;
+			state->enter_dead = acpi_idle_play_dead;
 			drv->safe_state_index = count;
 			break;
 
 			case ACPI_STATE_C2:
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
 			state->enter = acpi_idle_enter_simple;
+			state->enter_dead = acpi_idle_play_dead;
 			drv->safe_state_index = count;
 			break;
 
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index f7cab5e..3e146b2 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -72,6 +72,34 @@ typedef int (*cpuidle_enter_t)(struct cpuidle_device *dev,
 static cpuidle_enter_t cpuidle_enter_ops;
 
 /**
+ * cpuidle_play_dead - cpu off-lining
+ *
+ * Only returns in case of an error
+ */
+int cpuidle_play_dead(void)
+{
+	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
+	struct cpuidle_driver *drv = cpuidle_get_driver();
+	int i, dead_state = -1;
+	int power_usage = -1;
+
+	/* Find lowest-power state that supports long-term idle */
+	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
+		struct cpuidle_state *s = &drv->states[i];
+
+		if (s->power_usage < power_usage && s->enter_dead) {
+			power_usage = s->power_usage;
+			dead_state = i;
+		}
+	}
+
+	if (dead_state != -1)
+		return drv->states[dead_state].enter_dead(dev, dead_state);
+
+	return -ENODEV;
+}
+
+/**
  * cpuidle_idle_call - the main idle loop
  *
  * NOTE: no locks or semaphores should be used here
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index f3ebbba..d557bcd 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -51,6 +51,8 @@ struct cpuidle_state {
 	int (*enter)	(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index);
+
+	int (*enter_dead) (struct cpuidle_device *dev, int index);
 };
 
 /* Idle State Flags */
@@ -147,6 +149,8 @@ extern int cpuidle_wrap_enter(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv, int index,
 				int (*enter)(struct cpuidle_device *dev,
 					struct cpuidle_driver *drv, int index));
+extern int cpuidle_play_dead(void);
+
 #else
 static inline void disable_cpuidle(void) { }
 static inline int cpuidle_idle_call(void) { return -ENODEV; }
@@ -168,6 +172,7 @@ static inline int cpuidle_wrap_enter(struct cpuidle_device *dev,
 				int (*enter)(struct cpuidle_device *dev,
 					struct cpuidle_driver *drv, int index))
 { return -ENODEV; }
+static inline int cpuidle_play_dead(void) {return -ENODEV; }
 
 #endif
 
-- 
1.7.10.rc2.19.gfae9d

