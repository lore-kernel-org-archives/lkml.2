Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab0IQXq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:46:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:48385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab0IQXq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:46:57 -0400
Date: Fri, 17 Sep 2010 23:46:33 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        lenb@kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <tip-*@git.kernel.org>
References: <tip-*@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/idle] x86, mwait: Move mwait constants to a common header file
Message-ID: <tip-bc83cccc761953f878088cdfa682de0970b5561f@git.kernel.org>
Git-Commit-ID: bc83cccc761953f878088cdfa682de0970b5561f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 23:46:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc83cccc761953f878088cdfa682de0970b5561f
Gitweb:     http://git.kernel.org/tip/bc83cccc761953f878088cdfa682de0970b5561f
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 17 Sep 2010 15:36:40 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Sep 2010 15:36:40 -0700

x86, mwait: Move mwait constants to a common header file

We have MWAIT constants spread across three different .c files, for no
good reason.  Move them all into a common header file.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <tip-*@git.kernel.org>
---
 arch/x86/include/asm/mwait.h  |   15 +++++++++++++++
 arch/x86/kernel/acpi/cstate.c |   11 +----------
 drivers/acpi/acpi_pad.c       |    7 +------
 drivers/idle/intel_idle.c     |    9 +--------
 4 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
new file mode 100644
index 0000000..bcdff99
--- /dev/null
+++ b/arch/x86/include/asm/mwait.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_X86_MWAIT_H
+#define _ASM_X86_MWAIT_H
+
+#define MWAIT_SUBSTATE_MASK		0xf
+#define MWAIT_CSTATE_MASK		0xf
+#define MWAIT_SUBSTATE_SIZE		4
+#define MWAIT_MAX_NUM_CSTATES		8
+
+#define CPUID_MWAIT_LEAF		5
+#define CPUID5_ECX_EXTENSIONS_SUPPORTED 0x1
+#define CPUID5_ECX_INTERRUPT_BREAK	0x2
+
+#define MWAIT_ECX_INTERRUPT_BREAK	0x1
+
+#endif /* _ASM_X86_MWAIT_H */
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index fb7a5f0..bcc4add 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -13,6 +13,7 @@
 
 #include <acpi/processor.h>
 #include <asm/acpi.h>
+#include <asm/mwait.h>
 
 /*
  * Initialize bm_flags based on the CPU cache properties
@@ -65,16 +66,6 @@ static struct cstate_entry *cpu_cstate_entry;	/* per CPU ptr */
 
 static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
-#define MWAIT_SUBSTATE_MASK	(0xf)
-#define MWAIT_CSTATE_MASK	(0xf)
-#define MWAIT_SUBSTATE_SIZE	(4)
-
-#define CPUID_MWAIT_LEAF (5)
-#define CPUID5_ECX_EXTENSIONS_SUPPORTED (0x1)
-#define CPUID5_ECX_INTERRUPT_BREAK	(0x2)
-
-#define MWAIT_ECX_INTERRUPT_BREAK	(0x1)
-
 #define NATIVE_CSTATE_BEYOND_HALT	(2)
 
 static long acpi_processor_ffh_cstate_probe_cpu(void *_cx)
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index b76848c..ca2694d 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -30,18 +30,13 @@
 #include <linux/slab.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
+#include <asm/mwait.h>
 
 #define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
 #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
 
-#define MWAIT_SUBSTATE_MASK	(0xf)
-#define MWAIT_CSTATE_MASK	(0xf)
-#define MWAIT_SUBSTATE_SIZE	(4)
-#define CPUID_MWAIT_LEAF (5)
-#define CPUID5_ECX_EXTENSIONS_SUPPORTED (0x1)
-#define CPUID5_ECX_INTERRUPT_BREAK	(0x2)
 static unsigned long power_saving_mwait_eax;
 
 static unsigned char tsc_detected_unstable;
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index a10152b..065c804 100755
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -59,18 +59,11 @@
 #include <linux/hrtimer.h>	/* ktime_get_real() */
 #include <trace/events/power.h>
 #include <linux/sched.h>
+#include <asm/mwait.h>
 
 #define INTEL_IDLE_VERSION "0.4"
 #define PREFIX "intel_idle: "
 
-#define MWAIT_SUBSTATE_MASK	(0xf)
-#define MWAIT_CSTATE_MASK	(0xf)
-#define MWAIT_SUBSTATE_SIZE	(4)
-#define MWAIT_MAX_NUM_CSTATES	8
-#define CPUID_MWAIT_LEAF (5)
-#define CPUID5_ECX_EXTENSIONS_SUPPORTED (0x1)
-#define CPUID5_ECX_INTERRUPT_BREAK	(0x2)
-
 static struct cpuidle_driver intel_idle_driver = {
 	.name = "intel_idle",
 	.owner = THIS_MODULE,
