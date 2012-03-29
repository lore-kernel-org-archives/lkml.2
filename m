Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303Ab2C2Wua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:50:30 -0400
Received: from mail1.windriver.com ([147.11.146.13]:56159 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760229Ab2C2WtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:49:14 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>
Subject: [PATCH 2/6] kgdbts: Fix kernel oops with CONFIG_DEBUG_RODATA
Date: Thu, 29 Mar 2012 17:48:58 -0500
Message-ID: <1333061342-10132-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <1333061342-10132-1-git-send-email-jason.wessel@windriver.com>
References: <1333061342-10132-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 the kgdb test suite will oops when the kernel is compiled with
CONFIG_DEBUG_RODATA and you run the tests after boot time. This is
regression has existed since 2.6.26 by commit: b33cb815 (kgdbts: Use
HW breakpoints with CONFIG_DEBUG_RODATA).

The test suite can use hw breakpoints for all the tests, but it has to
execute the hardware breakpoint specific tests first in order to
determine that the hw breakpoints actually work.  Specifically the
very first test causes an oops:

# echo V1I1 > /sys/module/kgdbts/parameters/kgdbts
kgdb: Registered I/O driver kgdbts.
kgdbts:RUN plant and detach test

Entering kdb (current=0xffff880017aa9320, pid 1078) on processor 0 due to Keyboard Entry
[0]kdb> kgdbts: ERROR PUT: end of test buffer on 'plant_and_detach_test' line 1 expected OK got $E14#aa
WARNING: at drivers/misc/kgdbts.c:730 run_simple_test+0x151/0x2c0()
[...oops clipped...]

This commit re-orders the running of the tests and puts the RODATA
check into its own function so as to correctly avoid the kernel oops
by detecting and using the hw breakpoints.

Cc: <stable@vger.kernel.org> # >= 2.6.26
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/misc/kgdbts.c |   52 ++++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 3f7ad83..997e94d 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -885,6 +885,22 @@ static void run_singlestep_break_test(void)
 	kgdbts_break_test();
 }
 
+static void test_debug_rodata(void)
+{
+#ifdef CONFIG_DEBUG_RODATA
+	/* Until there is an api to write to read-only text segments, use
+	 * HW breakpoints for the remainder of any tests, else print a
+	 * failure message if hw breakpoints do not work.
+	 */
+	if (!(arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT && hwbreaks_ok)) {
+		eprintk("kgdbts: HW breakpoints BROKEN, ending tests\n");
+		return;
+	}
+	force_hwbrks = 1;
+	v1printk("kgdbts:Using HW breakpoints for SW breakpoint tests\n");
+#endif /* CONFIG_DEBUG_RODATA */
+}
+
 static void kgdbts_run_tests(void)
 {
 	char *ptr;
@@ -907,6 +923,18 @@ static void kgdbts_run_tests(void)
 	if (ptr)
 		sstep_test = simple_strtol(ptr+1, NULL, 10);
 
+	/* All HW break point tests */
+	if (arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT) {
+		hwbreaks_ok = 1;
+		v1printk("kgdbts:RUN hw breakpoint test\n");
+		run_breakpoint_test(1);
+		v1printk("kgdbts:RUN hw write breakpoint test\n");
+		run_hw_break_test(1);
+		v1printk("kgdbts:RUN access write breakpoint test\n");
+		run_hw_break_test(0);
+	}
+	test_debug_rodata();
+
 	/* required internal KGDB tests */
 	v1printk("kgdbts:RUN plant and detach test\n");
 	run_plant_and_detach_test(0);
@@ -924,35 +952,11 @@ static void kgdbts_run_tests(void)
 
 	/* ===Optional tests=== */
 
-	/* All HW break point tests */
-	if (arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT) {
-		hwbreaks_ok = 1;
-		v1printk("kgdbts:RUN hw breakpoint test\n");
-		run_breakpoint_test(1);
-		v1printk("kgdbts:RUN hw write breakpoint test\n");
-		run_hw_break_test(1);
-		v1printk("kgdbts:RUN access write breakpoint test\n");
-		run_hw_break_test(0);
-	}
-
 	if (nmi_sleep) {
 		v1printk("kgdbts:RUN NMI sleep %i seconds test\n", nmi_sleep);
 		run_nmi_sleep_test(nmi_sleep);
 	}
 
-#ifdef CONFIG_DEBUG_RODATA
-	/* Until there is an api to write to read-only text segments, use
-	 * HW breakpoints for the remainder of any tests, else print a
-	 * failure message if hw breakpoints do not work.
-	 */
-	if (!(arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT && hwbreaks_ok)) {
-		eprintk("kgdbts: HW breakpoints do not work,"
-			"skipping remaining tests\n");
-		return;
-	}
-	force_hwbrks = 1;
-#endif /* CONFIG_DEBUG_RODATA */
-
 	/* If the do_fork test is run it will be the last test that is
 	 * executed because a kernel thread will be spawned at the very
 	 * end to unregister the debug hooks.
-- 
1.7.9.4

