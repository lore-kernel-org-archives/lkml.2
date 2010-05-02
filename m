Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab0EBVxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 17:53:44 -0400
Received: from [69.28.251.93] ([69.28.251.93]:34534 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756987Ab0EBVxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 17:53:43 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Date: Sun, 2 May 2010 14:43:52 -0700
Subject: [PATCH] MIPS: nofpu and nodsp only affect CPU0
Message-Id: <0b6db1ee1efbe0daa1320b59ab5093ba5af377b8@localhost.localdomain>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "nofpu" and "nodsp" kernel command line options currently do not
affect CPUs that are brought online later in the boot process or
hotplugged at runtime.  It is desirable to apply the nofpu/nodsp options
to all CPUs in the system, so that surprising results are not seen when
a process migrates from one CPU to another.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/cpu-info.h |    2 ++
 arch/mips/kernel/cpu-probe.c     |    6 ++++++
 arch/mips/kernel/setup.c         |   11 +++++++----
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/mips/include/asm/cpu-info.h b/arch/mips/include/asm/cpu-info.h
index b39def3..55b156b 100644
--- a/arch/mips/include/asm/cpu-info.h
+++ b/arch/mips/include/asm/cpu-info.h
@@ -84,6 +84,8 @@ extern struct cpuinfo_mips cpu_data[];
 #define current_cpu_data cpu_data[smp_processor_id()]
 #define raw_current_cpu_data cpu_data[raw_smp_processor_id()]
 
+extern int mips_fpu_disabled, mips_dsp_disabled;
+
 extern void cpu_probe(void);
 extern void cpu_report(void);
 
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index be5bb16..baba603 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -982,6 +982,12 @@ __cpuinit void cpu_probe(void)
 	 */
 	BUG_ON(current_cpu_type() != c->cputype);
 
+	if (mips_fpu_disabled)
+		c->options &= ~MIPS_CPU_FPU;
+
+	if (mips_dsp_disabled)
+		c->ases &= ~MIPS_ASE_DSP;
+
 	if (c->options & MIPS_CPU_FPU) {
 		c->fpu_id = cpu_get_fpu_id();
 
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index f9513f9..1664dc2 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -569,21 +569,24 @@ void __init setup_arch(char **cmdline_p)
 	plat_smp_setup();
 }
 
+int __cpuinitdata mips_fpu_disabled;
+
 static int __init fpu_disable(char *s)
 {
-	int i;
-
-	for (i = 0; i < NR_CPUS; i++)
-		cpu_data[i].options &= ~MIPS_CPU_FPU;
+	cpu_data[0].options &= ~MIPS_CPU_FPU;
+	mips_fpu_disabled = 1;
 
 	return 1;
 }
 
 __setup("nofpu", fpu_disable);
 
+int __cpuinitdata mips_dsp_disabled;
+
 static int __init dsp_disable(char *s)
 {
 	cpu_data[0].ases &= ~MIPS_ASE_DSP;
+	mips_dsp_disabled = 1;
 
 	return 1;
 }
-- 
1.6.3.1

