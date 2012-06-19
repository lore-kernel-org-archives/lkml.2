Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2FSNna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 09:43:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59561 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2FSNnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 09:43:25 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/4] cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING
Date: Tue, 19 Jun 2012 15:43:08 +0200
Message-Id: <1340113391-1896-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S390, ia64 and powerpc all define their own version
of CONFIG_VIRT_CPU_ACCOUNTING. Generalize the config
and its description to a single place to avoid
duplication.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/Kconfig                           |    3 +++
 arch/ia64/Kconfig                      |   12 +-----------
 arch/powerpc/platforms/Kconfig.cputype |   16 +---------------
 arch/s390/Kconfig                      |    5 ++---
 init/Kconfig                           |   13 +++++++++++++
 5 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8c3d957..ff712af 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -274,4 +274,7 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_VIRT_CPU_ACCOUNTING
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 8186ec5..509af14 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -25,6 +25,7 @@ config IA64
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
+	select HAVE_VIRT_CPU_ACCOUNTING
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
@@ -341,17 +342,6 @@ config FORCE_MAX_ZONEORDER
 	default "17" if HUGETLB_PAGE
 	default "11"
 
-config VIRT_CPU_ACCOUNTING
-	bool "Deterministic task and CPU time accounting"
-	default n
-	help
-	  Select this option to enable more accurate task and CPU time
-	  accounting.  This is done by reading a CPU counter on each
-	  kernel entry and exit and on transitions within the kernel
-	  between system, softirq and hardirq state, so there is a
-	  small performance impact.
-	  If in doubt, say N here.
-
 config SMP
 	bool "Symmetric multi-processing support"
 	select USE_GENERIC_SMP_HELPERS
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 61c9550..2a896de 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -1,6 +1,7 @@
 config PPC64
 	bool "64-bit kernel"
 	default n
+	select HAVE_VIRT_CPU_ACCOUNTING
 	help
 	  This option selects whether a 32-bit or a 64-bit kernel
 	  will be built.
@@ -333,21 +334,6 @@ config PPC_MM_SLICES
 	default y if (!PPC_FSL_BOOK3E && PPC64 && HUGETLB_PAGE) || (PPC_STD_MMU_64 && PPC_64K_PAGES)
 	default n
 
-config VIRT_CPU_ACCOUNTING
-	bool "Deterministic task and CPU time accounting"
-	depends on PPC64
-	default y
-	help
-	  Select this option to enable more accurate task and CPU time
-	  accounting.  This is done by reading a CPU counter on each
-	  kernel entry and exit and on transitions within the kernel
-	  between system, softirq and hardirq state, so there is a
-	  small performance impact.  This also enables accounting of
-	  stolen time on logically-partitioned systems running on
-	  IBM POWER5-based machines.
-
-	  If in doubt, say Y here.
-
 config PPC_HAVE_PMU_SUPPORT
        bool
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index a39b469..351aa40 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -49,9 +49,6 @@ config GENERIC_LOCKBREAK
 config PGSTE
 	def_bool y if KVM
 
-config VIRT_CPU_ACCOUNTING
-	def_bool y
-
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
@@ -88,6 +85,8 @@ config S390
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_CMPXCHG_LOCAL
+	select HAVE_VIRT_CPU_ACCOUNTING
+	select VIRT_CPU_ACCOUNTING
 	select ARCH_DISCARD_MEMBLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
diff --git a/init/Kconfig b/init/Kconfig
index d07dcf9..d3f04e1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -267,6 +267,19 @@ config POSIX_MQUEUE_SYSCTL
 	depends on SYSCTL
 	default y
 
+config VIRT_CPU_ACCOUNTING
+	bool "Deterministic task and CPU time accounting"
+	depends on HAVE_VIRT_CPU_ACCOUNTING
+	default y if PPC64
+	help
+	  Select this option to enable more accurate task and CPU time
+	  accounting.  This is done by reading a CPU counter on each
+	  kernel entry and exit and on transitions within the kernel
+	  between system, softirq and hardirq state, so there is a
+	  small performance impact.  This also enables accounting of
+	  stolen time on logically-partitioned systems running on
+	  IBM POWER5-based machines.
+
 config BSD_PROCESS_ACCT
 	bool "BSD Process Accounting"
 	help
-- 
1.7.5.4

