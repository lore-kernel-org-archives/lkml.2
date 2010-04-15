Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab0DOLIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:08:53 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48834 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0DOLIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:08:52 -0400
Date: Thu, 15 Apr 2010 16:38:45 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [v12 PATCH 4/8]: POWER: enable cpuidle for POWER.
Message-ID: <20100415110845.GE16760@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20100415110046.GA16760@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100415110046.GA16760@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2010-04-15 16:30:46]:

This patch enables the cpuidle option in Kconfig for pSeries.

Currently cpuidle infrastructure is enabled only for x86 and ARM.
This code is almost completely borrowed from x86 to enable
cpuidle for pSeries.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/Kconfig              |    9 +++++++++
 arch/powerpc/include/asm/system.h |    2 ++
 arch/powerpc/kernel/idle.c        |   19 +++++++++++++++++++
 3 files changed, 30 insertions(+)

Index: linux.trees.git/arch/powerpc/Kconfig
===================================================================
--- linux.trees.git.orig/arch/powerpc/Kconfig
+++ linux.trees.git/arch/powerpc/Kconfig
@@ -101,6 +101,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y if 64BIT
 
+config ARCH_HAS_CPU_IDLE_WAIT
+	def_bool y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
@@ -275,6 +278,12 @@ source "kernel/Kconfig.freezer"
 source "arch/powerpc/sysdev/Kconfig"
 source "arch/powerpc/platforms/Kconfig"
 
+menu "Power management options"
+
+source "drivers/cpuidle/Kconfig"
+
+endmenu
+
 menu "Kernel options"
 
 config HIGHMEM
Index: linux.trees.git/arch/powerpc/include/asm/system.h
===================================================================
--- linux.trees.git.orig/arch/powerpc/include/asm/system.h
+++ linux.trees.git/arch/powerpc/include/asm/system.h
@@ -551,5 +551,7 @@ extern void account_system_vtime(struct 
 
 extern struct dentry *powerpc_debugfs_root;
 
+void cpu_idle_wait(void);
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_SYSTEM_H */
Index: linux.trees.git/arch/powerpc/kernel/idle.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/idle.c
+++ linux.trees.git/arch/powerpc/kernel/idle.c
@@ -102,6 +102,25 @@ void cpu_idle(void)
 	}
 }
 
+static void do_nothing(void *unused)
+{
+}
+
+/*
+ * cpu_idle_wait - Used to ensure that all the CPUs come out of the old
+ * idle loop and start using the new idle loop.
+ * Required while changing idle handler on SMP systems.
+ * Caller must have changed idle handler to the new value before the call.
+ */
+void cpu_idle_wait(void)
+{
+	/* Ensure that new value of idle is set */
+	smp_mb();
+	/* kick all the CPUs so that they exit out of old idle routine */
+	smp_call_function(do_nothing, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(cpu_idle_wait);
+
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL
