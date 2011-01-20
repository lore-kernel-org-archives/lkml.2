Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1ATOk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:40:56 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42300 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab1ATOkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:40:55 -0500
From: Borislav Petkov <bp@amd64.org>
To: <x86@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.hl>
Subject: [PATCH] x86, hotplug: Fix powersavings with offlined cores on AMD
Date: Thu, 20 Jan 2011 15:42:52 +0100
Message-Id: <1295534572-10730-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

ea53069231f9317062910d6e772cca4ce93de8c8 made a CPU use monitor/mwait
when offline. This is not the optimal choice for AMD wrt to powersavings
and we'd prefer our cores to halt (i.e. enter C1) instead. For this, the
same selection whether to use monitor/mwait has to be used as when we
select the idle routine for the machine.

With this patch, offlining cores 1-5 on a X6 machine allows core0 to
boost again.

Reported-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: stable@kernel.org # 37.x
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.hl>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/cpu.h |    1 +
 arch/x86/kernel/process.c  |    3 ++-
 arch/x86/kernel/smpboot.c  |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 4fab24d..6e6e755 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,5 +32,6 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
+int __cpuinit mwait_usable(const struct cpuinfo_x86 *);
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index d8286ed..e764fc0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -14,6 +14,7 @@
 #include <linux/utsname.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
+#include <asm/cpu.h>
 #include <asm/system.h>
 #include <asm/apic.h>
 #include <asm/syscalls.h>
@@ -505,7 +506,7 @@ static void poll_idle(void)
 #define MWAIT_ECX_EXTENDED_INFO		0x01
 #define MWAIT_EDX_C1			0xf0
 
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 763df77..0cbe8c0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1402,8 +1402,9 @@ static inline void mwait_play_dead(void)
 	unsigned int highest_subcstate = 0;
 	int i;
 	void *mwait_ptr;
+	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
 
-	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_MWAIT))
+	if (!(cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)))
 		return;
 	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLSH))
 		return;
-- 
1.7.4.rc2

