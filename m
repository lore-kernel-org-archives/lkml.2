Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880Ab2FBWL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 18:11:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55336 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933650Ab2FBWL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 18:11:56 -0400
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH 1/2] x86: Introduce apic post-initialization callback
Date: Sun,  3 Jun 2012 01:11:34 +0300
Message-Id: <1338675095-27260-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20120509212117.GA32594@NoteStation.guest.lab126.com>
References: <20120509212117.GA32594@NoteStation.guest.lab126.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures (such as vSMP) need to slightly adjust the underlying
apic structure. Add an apic post-initialization to x86_platform_ops for
this purpose and use it for adjusting the apic structure on vSMP
systems.

Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/apic/probe_32.c |    3 +++
 arch/x86/kernel/apic/probe_64.c |   11 ++---------
 arch/x86/kernel/vsmp_64.c       |   13 +++++++++++++
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index c090af1..c377d9c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -164,6 +164,7 @@ struct x86_cpuinit_ops {
  * @i8042_detect		pre-detect if i8042 controller exists
  * @save_sched_clock_state:	save state for sched_clock() on suspend
  * @restore_sched_clock_state:	restore state for sched_clock() on resume
+ * @apic_post_init:		adjust apic if neeeded
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
@@ -177,6 +178,7 @@ struct x86_platform_ops {
 	int (*i8042_detect)(void);
 	void (*save_sched_clock_state)(void);
 	void (*restore_sched_clock_state)(void);
+	void (*apic_post_init)(void);
 };
 
 struct pci_dev;
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 1b291da..8616d51 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -208,6 +208,9 @@ void __init default_setup_apic_routing(void)
 
 	if (apic->setup_apic_routing)
 		apic->setup_apic_routing();
+
+	if (x86_platform.apic_post_init)
+		x86_platform.apic_post_init();
 }
 
 void __init generic_apic_probe(void)
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 3fe9866..1793dba 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -23,11 +23,6 @@
 #include <asm/ipi.h>
 #include <asm/setup.h>
 
-static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
-{
-	return hard_smp_processor_id() >> index_msb;
-}
-
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
@@ -48,10 +43,8 @@ void __init default_setup_apic_routing(void)
 		}
 	}
 
-	if (is_vsmp_box()) {
-		/* need to update phys_pkg_id */
-		apic->phys_pkg_id = apicid_phys_pkg_id;
-	}
+	if (x86_platform.apic_post_init)
+		x86_platform.apic_post_init();
 }
 
 /* Same for both flat and physical. */
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 8eeb55a..59eea85 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -187,12 +187,25 @@ static void __init vsmp_cap_cpus(void)
 #endif
 }
 
+static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
+{
+	return hard_smp_processor_id() >> index_msb;
+}
+
+static void vsmp_apic_post_init(void)
+{
+	/* need to update phys_pkg_id */
+	apic->phys_pkg_id = apicid_phys_pkg_id;
+}
+
 void __init vsmp_init(void)
 {
 	detect_vsmp_box();
 	if (!is_vsmp_box())
 		return;
 
+	x86_platform.apic_post_init = vsmp_apic_post_init;
+
 	vsmp_cap_cpus();
 
 	set_vsmp_pv_ops();
-- 
1.7.7.6

