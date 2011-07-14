Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1GNPEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:04:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38328 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab1GNPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:04:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 1/6] hw_breakpoints: Split hardware breakpoints config
Date: Thu, 14 Jul 2011 17:03:52 +0200
Message-Id: <1310655837-328-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
References: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware breakpoint config is only made of an ability. An
arch that support this feature selects HAVE_HW_BREAKPOINT. If so,
the feature is definetly built-in, the user can't decide to turn
it off. As hw_breakpoints depend on perf, it also makes perf
a mandatory feature. The whole is quite a piece of code and
may not be desired on some embedded systems.

In order to prepare to make this optable by the user, split the
config into the more traditional couple (ability, user choice) by
providing a new HW_BREAKPOINT config. It is default on and depends
on CONFIG_EXPERT because breakpoint ptrace requests are part of the
usual user ABI. The user must know what he's doing before turning
that off.

For now, only the archs that already implemented a conditional
HAVE_HW_BREAKPOINT can turn off HW_BREAKPOINT. x86 and sh have it
always selected because they need more background work to support
this new modularity.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 arch/sh/Kconfig  |    1 +
 arch/x86/Kconfig |    1 +
 init/Kconfig     |   10 ++++++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index f03338c..0a59a82 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -44,6 +44,7 @@ config SUPERH32
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_ARCH_KGDB
 	select HAVE_HW_BREAKPOINT
+	select HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
 	select ARCH_HIBERNATION_POSSIBLE if MMU
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..ef3effd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -53,6 +53,7 @@ config X86
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
+	select HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
diff --git a/init/Kconfig b/init/Kconfig
index 412c21b..9eec0df 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -923,6 +923,16 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+config HW_BREAKPOINT
+	bool "Hardware breakpoints" if EXPERT
+	depends on HAVE_HW_BREAKPOINT
+	default y
+	help
+	  Hardware breakpoints are a feature implemented by most CPUs
+	  to trigger an event when an instruction or data fetch
+	  matches a given pattern. This is typically used by ptrace
+	  and perf events.
+
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
-- 
1.7.5.4

