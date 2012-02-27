Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2B0Jjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:39:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2B0Jjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:39:33 -0500
Date: Mon, 27 Feb 2012 01:38:55 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-f0ba662a6e06f2fb58201800eff33dcad9246f97@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <4F478C010200007800074A3D@nat28.tlf.novell.com>
References: <4F478C010200007800074A3D@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Properly _init-annotate NMI selftest code
Git-Commit-ID: f0ba662a6e06f2fb58201800eff33dcad9246f97
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 01:39:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0ba662a6e06f2fb58201800eff33dcad9246f97
Gitweb:     http://git.kernel.org/tip/f0ba662a6e06f2fb58201800eff33dcad9246f97
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 24 Feb 2012 12:09:21 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 27 Feb 2012 08:43:37 +0100

x86: Properly _init-annotate NMI selftest code

After all, this code is being run once at boot only (if
configured in at all).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/4F478C010200007800074A3D@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/nmi_selftest.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 0d01a8e..2c39dcd 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -12,6 +12,7 @@
 #include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/delay.h>
+#include <linux/init.h>
 
 #include <asm/apic.h>
 #include <asm/nmi.h>
@@ -20,35 +21,35 @@
 #define FAILURE		1
 #define TIMEOUT		2
 
-static int nmi_fail;
+static int __initdata nmi_fail;
 
 /* check to see if NMI IPIs work on this machine */
-static DECLARE_BITMAP(nmi_ipi_mask, NR_CPUS) __read_mostly;
+static DECLARE_BITMAP(nmi_ipi_mask, NR_CPUS) __initdata;
 
-static int testcase_total;
-static int testcase_successes;
-static int expected_testcase_failures;
-static int unexpected_testcase_failures;
-static int unexpected_testcase_unknowns;
+static int __initdata testcase_total;
+static int __initdata testcase_successes;
+static int __initdata expected_testcase_failures;
+static int __initdata unexpected_testcase_failures;
+static int __initdata unexpected_testcase_unknowns;
 
-static int nmi_unk_cb(unsigned int val, struct pt_regs *regs)
+static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 {
 	unexpected_testcase_unknowns++;
 	return NMI_HANDLED;
 }
 
-static void init_nmi_testsuite(void)
+static void __init init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
 	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
 }
 
-static void cleanup_nmi_testsuite(void)
+static void __init cleanup_nmi_testsuite(void)
 {
 	unregister_nmi_handler(NMI_UNKNOWN, "nmi_selftest_unk");
 }
 
-static int test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
+static int __init test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
 {
         int cpu = raw_smp_processor_id();
 
@@ -58,7 +59,7 @@ static int test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
         return NMI_DONE;
 }
 
-static void test_nmi_ipi(struct cpumask *mask)
+static void __init test_nmi_ipi(struct cpumask *mask)
 {
 	unsigned long timeout;
 
@@ -86,7 +87,7 @@ static void test_nmi_ipi(struct cpumask *mask)
 	return;
 }
 
-static void remote_ipi(void)
+static void __init remote_ipi(void)
 {
 	cpumask_copy(to_cpumask(nmi_ipi_mask), cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
@@ -94,19 +95,19 @@ static void remote_ipi(void)
 		test_nmi_ipi(to_cpumask(nmi_ipi_mask));
 }
 
-static void local_ipi(void)
+static void __init local_ipi(void)
 {
 	cpumask_clear(to_cpumask(nmi_ipi_mask));
 	cpumask_set_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
 	test_nmi_ipi(to_cpumask(nmi_ipi_mask));
 }
 
-static void reset_nmi(void)
+static void __init reset_nmi(void)
 {
 	nmi_fail = 0;
 }
 
-static void dotest(void (*testcase_fn)(void), int expected)
+static void __init dotest(void (*testcase_fn)(void), int expected)
 {
 	testcase_fn();
 	/*
@@ -131,12 +132,12 @@ static void dotest(void (*testcase_fn)(void), int expected)
 	reset_nmi();
 }
 
-static inline void print_testname(const char *testname)
+static inline void __init print_testname(const char *testname)
 {
 	printk("%12s:", testname);
 }
 
-void nmi_selftest(void)
+void __init nmi_selftest(void)
 {
 	init_nmi_testsuite();
 
