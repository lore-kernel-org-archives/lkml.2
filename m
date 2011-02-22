Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1BVWVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:52 -0500
Received: from kroah.org ([198.145.64.141]:46738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab1BVWVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:40 2011
Message-Id: <20110222221840.344505929@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "venki@google.com" <venki@google.com>,
        "a.p.zijlstra@chello.hl" <a.p.zijlstra@chello.hl>,
        <Andreas.Herrmann3@amd.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [33/70] x86, hotplug: Fix powersavings with offlined cores on AMD
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Borislav Petkov <borislav.petkov@amd.com>

Upstream commits: 93789b32dbf355e70f18b17a82e8661677a7f7fb,
	 1c9d16e35911090dee3f9313e6af13af623d66ee

ea53069231f9317062910d6e772cca4ce93de8c8 made a CPU use monitor/mwait
when offline. This is not the optimal choice for AMD wrt to powersavings
and we'd prefer our cores to halt (i.e. enter C1) instead. For this, the
same selection whether to use monitor/mwait has to be used as when we
select the idle routine for the machine.

With this patch, offlining cores 1-5 on a X6 machine allows core0 to
boost again.

[ hpa: putting this in urgent since it is a (power) regression fix ]

Reported-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.hl>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1295534572-10730-1-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/cpu.h |    1 +
 arch/x86/kernel/process.c  |    5 +++--
 arch/x86/kernel/smpboot.c  |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,5 +32,6 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
+int mwait_usable(const struct cpuinfo_x86 *);
 
 #endif /* _ASM_X86_CPU_H */
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
@@ -509,13 +510,13 @@ static void poll_idle(void)
  *
  * idle=mwait overrides this decision and forces the usage of mwait.
  */
-static int __cpuinitdata force_mwait;
+static int force_mwait;
 
 #define MWAIT_INFO			0x05
 #define MWAIT_ECX_EXTENDED_INFO		0x01
 #define MWAIT_EDX_C1			0xf0
 
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+int mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1396,8 +1396,9 @@ static inline void mwait_play_dead(void)
 	unsigned int highest_subcstate = 0;
 	int i;
 	void *mwait_ptr;
+	struct cpuinfo_x86 *c = &current_cpu_data;
 
-	if (!cpu_has(&current_cpu_data, X86_FEATURE_MWAIT))
+	if (!(cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)))
 		return;
 	if (!cpu_has(&current_cpu_data, X86_FEATURE_CLFLSH))
 		return;


