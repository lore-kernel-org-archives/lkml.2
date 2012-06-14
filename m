Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2FNOpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:45:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35403 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2FNOpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:45:01 -0400
Date: Thu, 14 Jun 2012 07:44:46 -0700
From: tip-bot for Vlad Zolotarov <vlad@scalemp.com>
Message-ID: <tip-0816b0f0365539c8f6280634d2c1778d0108d8f5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        Shai@scalemp.com, vlad@scalemp.com, shai@scalemp.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        Shai@scalemp.com, vlad@scalemp.com, shai@scalemp.com,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1719258.EYKzE4Zbq5@vlad>
References: <1719258.EYKzE4Zbq5@vlad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Add read_mostly declaration/
 definition to variables from smp.h
Git-Commit-ID: 0816b0f0365539c8f6280634d2c1778d0108d8f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 07:44:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0816b0f0365539c8f6280634d2c1778d0108d8f5
Gitweb:     http://git.kernel.org/tip/0816b0f0365539c8f6280634d2c1778d0108d8f5
Author:     Vlad Zolotarov <vlad@scalemp.com>
AuthorDate: Mon, 11 Jun 2012 12:56:52 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Jun 2012 12:42:11 +0200

x86: Add read_mostly declaration/definition to variables from smp.h

Add "read-mostly" qualifier to the following variables in
smp.h:

 - cpu_sibling_map
 - cpu_core_map
 - cpu_llc_shared_map
 - cpu_llc_id
 - cpu_number
 - x86_cpu_to_apicid
 - x86_bios_cpu_apicid
 - x86_cpu_to_logical_apicid

As long as all the variables above are only written during the
initialization, this change is meant to prevent the false
sharing. More specifically, on vSMP Foundation platform
x86_cpu_to_apicid shared the same internode_cache_line with
frequently written lapic_events.

>From the analysis of the first 33 per_cpu variables out of 219
(memories they describe, to be more specific) the 8 have read_mostly
nature (tlb_vector_offset, cpu_loops_per_jiffy, xen_debug_irq, etc.)
and 25 are frequently written (irq_stack_union, gdt_page,
exception_stacks, idt_desc, etc.).

Assuming that the spread of the rest of the per_cpu variables is
similar, identifying the read mostly memories will make more sense
in terms of long-term code maintenance comparing to identifying
frequently written memories.

Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
Cc: Shai Fultheim (Shai@ScaleMP.com) <Shai@scalemp.com>
Cc: ido@wizery.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1719258.EYKzE4Zbq5@vlad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h    |    2 +-
 arch/x86/include/asm/smp.h     |   16 ++++++++--------
 arch/x86/kernel/apic/apic.c    |    6 +++---
 arch/x86/kernel/setup_percpu.c |    2 +-
 arch/x86/kernel/smpboot.c      |    8 ++++----
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index eaff479..a907d4d 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -537,7 +537,7 @@ static inline const struct cpumask *default_target_cpus(void)
 #endif
 }
 
-DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
+DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid);
 
 
 static inline unsigned int read_apic_id(void)
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index f483945..cc1df2b 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -31,12 +31,12 @@ static inline bool cpu_has_ht_siblings(void)
 	return has_siblings;
 }
 
-DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
-DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
+DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_sibling_map);
+DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_core_map);
 /* cpus sharing the last level cache: */
-DECLARE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
-DECLARE_PER_CPU(u16, cpu_llc_id);
-DECLARE_PER_CPU(int, cpu_number);
+DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
+DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_llc_id);
+DECLARE_PER_CPU_READ_MOSTLY(int, cpu_number);
 
 static inline struct cpumask *cpu_sibling_mask(int cpu)
 {
@@ -53,10 +53,10 @@ static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 	return per_cpu(cpu_llc_shared_map, cpu);
 }
 
-DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
-DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
+DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid);
+DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
-DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
+DECLARE_EARLY_PER_CPU_READ_MOSTLY(int, x86_cpu_to_logical_apicid);
 #endif
 
 /* Static state in head.S used to set up a CPU */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 39a222e..0443b64 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -75,8 +75,8 @@ physid_mask_t phys_cpu_present_map;
 /*
  * Map cpu index to physical APIC ID
  */
-DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
-DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
+DEFINE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid, BAD_APICID);
+DEFINE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid, BAD_APICID);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
@@ -88,7 +88,7 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
  * used for the mapping.  This is where the behaviors of x86_64 and 32
  * actually diverge.  Let's keep it ugly for now.
  */
-DEFINE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid, BAD_APICID);
+DEFINE_EARLY_PER_CPU_READ_MOSTLY(int, x86_cpu_to_logical_apicid, BAD_APICID);
 
 /*
  * Knob to control our willingness to enable the local APIC.
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 5a98aa2..5cdff03 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -21,7 +21,7 @@
 #include <asm/cpu.h>
 #include <asm/stackprotector.h>
 
-DEFINE_PER_CPU(int, cpu_number);
+DEFINE_PER_CPU_READ_MOSTLY(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3fab55b..e61110e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -104,17 +104,17 @@ int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
 
 /* Last level cache ID of each logical CPU */
-DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
+DEFINE_PER_CPU_READ_MOSTLY(u16, cpu_llc_id) = BAD_APICID;
 
 /* representing HT siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_var_t, cpu_sibling_map);
+DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_sibling_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 
 /* representing HT and core siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
+DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
-DEFINE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
+DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
