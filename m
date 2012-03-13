Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab2CMS4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:56:20 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:28911 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758657Ab2CMS4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:56:10 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0U79D-02-2HP-02
X-M-MSG: 
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
To: <x86@kernel.org>, <len.brown@intel.com>, <linux-acpi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH 1/2] x86: Allow off-lined CPU to enter deeper C states
Date: Tue, 13 Mar 2012 19:55:09 +0100
Message-ID: <1331664910-20095-2-git-send-email-boris.ostrovsky@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1331664910-20095-1-git-send-email-boris.ostrovsky@amd.com>
References: <1331664910-20095-1-git-send-email-boris.ostrovsky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when a CPU is off-lined it enters either MWAIT-based idle or,
if MWAIT is not desired or supported, HLT-based idle (which places the
processor in C1 state). This patch allows processors without MWAIT
support to stay in states deeper than C1.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 arch/x86/kernel/smpboot.c     |    4 +++-
 drivers/acpi/processor_idle.c |   31 +++++++++++++++++++++++++++++++
 drivers/cpuidle/cpuidle.c     |   28 ++++++++++++++++++++++++++++
 include/linux/cpuidle.h       |    4 ++++
 4 files changed, 66 insertions(+), 1 deletions(-)

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
index 59f4261..6979a4c 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -54,6 +54,34 @@ static void cpuidle_kick_cpus(void) {}
 static int __cpuidle_register_device(struct cpuidle_device *dev);
 
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
index 712abcc..2662493 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -49,6 +49,8 @@ struct cpuidle_state {
 	int (*enter)	(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index);
+
+	int (*enter_dead) (struct cpuidle_device *dev, int index);
 };
 
 /* Idle State Flags */
@@ -140,6 +142,7 @@ extern void cpuidle_pause_and_lock(void);
 extern void cpuidle_resume_and_unlock(void);
 extern int cpuidle_enable_device(struct cpuidle_device *dev);
 extern void cpuidle_disable_device(struct cpuidle_device *dev);
+extern int cpuidle_play_dead(void);
 
 #else
 static inline void disable_cpuidle(void) { }
@@ -157,6 +160,7 @@ static inline void cpuidle_resume_and_unlock(void) { }
 static inline int cpuidle_enable_device(struct cpuidle_device *dev)
 {return -ENODEV; }
 static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
+static inline int cpuidle_play_dead(void) {return -ENODEV; }
 
 #endif
 
-- 
1.7.7


