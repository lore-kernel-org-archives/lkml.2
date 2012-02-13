Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab2BMP7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:59:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58701 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2BMP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:59:14 -0500
Date: Mon, 13 Feb 2012 07:58:31 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-21c3fcf3e39353d4f21d50e257cc74f3204b1988@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, travis@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, travis@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1329069237-11483-1-git-send-email-yinghai@kernel.org>
References: <1329069237-11483-1-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/debug: Fix/improve the show_msr=<cpus>
  debug print out
Git-Commit-ID: 21c3fcf3e39353d4f21d50e257cc74f3204b1988
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Feb 2012 07:58:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21c3fcf3e39353d4f21d50e257cc74f3204b1988
Gitweb:     http://git.kernel.org/tip/21c3fcf3e39353d4f21d50e257cc74f3204b1988
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 12 Feb 2012 09:53:57 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Feb 2012 19:12:21 +0100

x86/debug: Fix/improve the show_msr=<cpus> debug print out

Found out that show_msr=<cpus> is broken, when I asked a
user to use it to capture debug info about broken MTRR's
whose MTRR settings are probably different between CPUs.

Only the first CPUs MSRs are printed, but that is not
enough to track down the suspected bug.

For years we called print_cpu_msr from print_cpu_info(),
but this commit:

| commit 2eaad1fddd7450a48ad464229775f97fbfe8af36
| Author: Mike Travis <travis@sgi.com>
| Date:   Thu Dec 10 17:19:36 2009 -0800
|
|    x86: Limit the number of processor bootup messages

removed the print_cpu_info() call from all APs.

Put it back - it will only print MSRs when the user
specifically requests them via show_msr=<cpus>.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Mike Travis <travis@sgi.com>
Link: http://lkml.kernel.org/r/1329069237-11483-1-git-send-email-yinghai@kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/common.c     |   14 +++++++-------
 arch/x86/kernel/smpboot.c        |    5 +++--
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index aa9088c..8bb062b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -162,6 +162,7 @@ extern void early_cpu_init(void);
 extern void identify_boot_cpu(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
+void print_cpu_msr(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d43cad7..8b6a3bb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -933,7 +933,7 @@ static const struct msr_range msr_range_array[] __cpuinitconst = {
 	{ 0xc0011000, 0xc001103b},
 };
 
-static void __cpuinit print_cpu_msr(void)
+static void __cpuinit __print_cpu_msr(void)
 {
 	unsigned index_min, index_max;
 	unsigned index;
@@ -997,13 +997,13 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 	else
 		printk(KERN_CONT "\n");
 
-#ifdef CONFIG_SMP
+	__print_cpu_msr();
+}
+
+void __cpuinit print_cpu_msr(struct cpuinfo_x86 *c)
+{
 	if (c->cpu_index < show_msr)
-		print_cpu_msr();
-#else
-	if (show_msr)
-		print_cpu_msr();
-#endif
+		__print_cpu_msr();
 }
 
 static __init int setup_disablecpuid(char *arg)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..257049d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -791,9 +791,10 @@ do_rest:
 			schedule();
 		}
 
-		if (cpumask_test_cpu(cpu, cpu_callin_mask))
+		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
+			print_cpu_msr(&cpu_data(cpu));
 			pr_debug("CPU%d: has booted.\n", cpu);
-		else {
+		} else {
 			boot_error = 1;
 			if (*(volatile u32 *)TRAMPOLINE_SYM(trampoline_status)
 			    == 0xA5A5A5A5)
