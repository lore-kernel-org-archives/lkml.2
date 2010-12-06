Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0LFSRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:17:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:48042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab0LFSRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:17:05 -0500
Date: Mon, 6 Dec 2010 18:16:31 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        jbaron@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101203095403.2961.91201.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095403.2961.91201.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Separate kprobe optimizing code from optimizer
Message-ID: <tip-61f4e13ffd85c037a942c5b7fd13f2b0c3162862@git.kernel.org>
Git-Commit-ID: 61f4e13ffd85c037a942c5b7fd13f2b0c3162862
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 18:16:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61f4e13ffd85c037a942c5b7fd13f2b0c3162862
Gitweb:     http://git.kernel.org/tip/61f4e13ffd85c037a942c5b7fd13f2b0c3162862
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 3 Dec 2010 18:54:03 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Dec 2010 17:59:30 +0100

kprobes: Separate kprobe optimizing code from optimizer

Separate kprobe optimizing code from optimizer, this
will make easy to introducing unoptimizing code in
optimizer.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
LKML-Reference: <20101203095403.2961.91201.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ab99caf..1f4f9b9 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -427,26 +427,14 @@ static void kprobe_optimizer(struct work_struct *work);
 static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
 #define OPTIMIZE_DELAY 5
 
-/* Kprobe jump optimizer */
-static __kprobes void kprobe_optimizer(struct work_struct *work)
+/*
+ * Optimize (replace a breakpoint with a jump) kprobes listed on
+ * optimizing_list.
+ */
+static __kprobes void do_optimize_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
-	/* Lock modules while optimizing kprobes */
-	mutex_lock(&module_mutex);
-	mutex_lock(&kprobe_mutex);
-	if (kprobes_all_disarmed || !kprobes_allow_optimization)
-		goto end;
-
-	/*
-	 * Wait for quiesence period to ensure all running interrupts
-	 * are done. Because optprobe may modify multiple instructions
-	 * there is a chance that Nth instruction is interrupted. In that
-	 * case, running interrupt can return to 2nd-Nth byte of jump
-	 * instruction. This wait is for avoiding it.
-	 */
-	synchronize_sched();
-
 	/*
 	 * The optimization/unoptimization refers online_cpus via
 	 * stop_machine() and cpu-hotplug modifies online_cpus.
@@ -467,6 +455,27 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	}
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
+}
+
+/* Kprobe jump optimizer */
+static __kprobes void kprobe_optimizer(struct work_struct *work)
+{
+	/* Lock modules while optimizing kprobes */
+	mutex_lock(&module_mutex);
+	mutex_lock(&kprobe_mutex);
+	if (kprobes_all_disarmed || !kprobes_allow_optimization)
+		goto end;
+
+	/*
+	 * Wait for quiesence period to ensure all running interrupts
+	 * are done. Because optprobe may modify multiple instructions
+	 * there is a chance that Nth instruction is interrupted. In that
+	 * case, running interrupt can return to 2nd-Nth byte of jump
+	 * instruction. This wait is for avoiding it.
+	 */
+	synchronize_sched();
+
+	do_optimize_kprobes();
 end:
 	mutex_unlock(&kprobe_mutex);
 	mutex_unlock(&module_mutex);
