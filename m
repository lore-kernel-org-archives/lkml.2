Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031333Ab2K3RMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:12:32 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:34935 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031315Ab2K3RM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:12:26 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "joe@perches.com" <joe@perches.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "jim.cromie@gmail.com" <jim.cromie@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH] Avoid dead lock of console related locks in panic case
Thread-Topic: [PATCH] Avoid dead lock of console related locks in panic case
Thread-Index: Ac3PHT6W8aSr96JsTimOsT6bVlOSHQ==
Date: Fri, 30 Nov 2012 17:11:07 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A02C44@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-30_15:2012-11-30,2012-11-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1211300152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Issue]

If one cpu ,which is taking a logbuf_lock or console_sem, 
receive IPI/NMI from a panicked cpu via smp_send_stop(),
the panicked cpu hangs up in subsequent kmsg_dump()/printk()
because logbuf_lock and console_sem are taken in the function calls.

This causes a console blank and users can't see panic messages.

[Solution]

this patch introduces a logic initializing logbuf_lock and console_sem
just after smp_send_stop() to avoid dead locks above.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 include/linux/printk.h |    5 +++++
 kernel/panic.c         |    1 +
 kernel/printk.c        |   17 +++++++++++++++++
 lib/bust_spinlocks.c   |   21 ++++++++++++++++++---
 4 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 9afc01e..ffd3e55 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -139,6 +139,7 @@ extern int kptr_restrict;
 
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
+void zap_locks_force(void);
 #else
 static inline __printf(1, 0)
 int vprintk(const char *s, va_list args)
@@ -172,6 +173,10 @@ static inline void log_buf_kexec_setup(void)
 static inline void setup_log_buf(int early)
 {
 }
+
+static inline void zap_locks_force(void)
+{
+}
 #endif
 
 extern void dump_stack(void) __cold;
diff --git a/kernel/panic.c b/kernel/panic.c
index e1b2822..c27e58e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -122,6 +122,7 @@ void panic(const char *fmt, ...)
 	 * situation.
 	 */
 	smp_send_stop();
+	bust_spinlocks(2);
 
 	kmsg_dump(KMSG_DUMP_PANIC);
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 2d607f4..a6fa638 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1278,6 +1278,23 @@ static void call_console_drivers(int level, const char *text, size_t len)
 }
 
 /*
+ * Zap console related locks in panic situation.
+ * It should be called by bust_spinlocks().
+ */
+void zap_locks_force(void)
+{
+	debug_locks_off();
+
+	/* If a crash is occurring, make sure we can't deadlock */
+	if (raw_spin_is_locked(&logbuf_lock))
+		raw_spin_lock_init(&logbuf_lock);
+
+	/* And make sure that we print immediately */
+	if (is_console_locked())
+		sema_init(&console_sem, 1);
+}
+
+/*
  * Zap console related locks when oopsing. Only zap at most once
  * every 10 seconds, to leave time for slow consoles to print a
  * full oops.
diff --git a/lib/bust_spinlocks.c b/lib/bust_spinlocks.c
index 9681d54..ffa1c64 100644
--- a/lib/bust_spinlocks.c
+++ b/lib/bust_spinlocks.c
@@ -13,19 +13,34 @@
 #include <linux/wait.h>
 #include <linux/vt_kern.h>
 #include <linux/console.h>
+#include <linux/printk.h>
 
 
+/*
+ * yes = 0: make sure that messages are printed to console immediately.
+ * yes = 1: avoid a recursive lock on a single cpu in a panic case.
+ * yes = 2: avoid a deadlock after stopping cpus by smp_send_stop()
+ *          in a panic case.
+ */
 void __attribute__((weak)) bust_spinlocks(int yes)
 {
-	if (yes) {
-		++oops_in_progress;
-	} else {
+	switch (yes) {
+	case 0:
 #ifdef CONFIG_VT
 		unblank_screen();
 #endif
 		console_unblank();
 		if (--oops_in_progress == 0)
 			wake_up_klogd();
+		break;
+	case 1:
+		++oops_in_progress;
+		break;
+	case 2:
+		zap_locks_force();
+		break;
+	default:
+		break;
 	}
 }
 
-- 
1.7.1

