Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1AVCTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 21:19:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:41573 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab1AVCTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 21:19:18 -0500
Date: Sat, 22 Jan 2011 02:18:57 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, andreas.herrmann3@amd.com,
        a.p.zijlstra@chello.hl, lenb@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, borislav.petkov@amd.com, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, arjan@linux.intel.com,
        a.p.zijlstra@chello.hl, lenb@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, venki@google.com, borislav.petkov@amd.com
In-Reply-To: <1295534572-10730-1-git-send-email-bp@amd64.org>
References: <1295534572-10730-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, hotplug: Fix powersavings with offlined cores on AMD
Message-ID: <tip-93789b32dbf355e70f18b17a82e8661677a7f7fb@git.kernel.org>
Git-Commit-ID: 93789b32dbf355e70f18b17a82e8661677a7f7fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 02:18:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93789b32dbf355e70f18b17a82e8661677a7f7fb
Gitweb:     http://git.kernel.org/tip/93789b32dbf355e70f18b17a82e8661677a7f7fb
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 20 Jan 2011 15:42:52 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Jan 2011 18:14:54 -0800

x86, hotplug: Fix powersavings with offlined cores on AMD

ea53069231f9317062910d6e772cca4ce93de8c8 made a CPU use monitor/mwait
when offline. This is not the optimal choice for AMD wrt to powersavings
and we'd prefer our cores to halt (i.e. enter C1) instead. For this, the
same selection whether to use monitor/mwait has to be used as when we
select the idle routine for the machine.

With this patch, offlining cores 1-5 on a X6 machine allows core0 to
boost again.

[ hpa: putting this in urgent since it is a (power) regression fix ]

Reported-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: stable@kernel.org # 37.x
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.hl>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1295534572-10730-1-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
