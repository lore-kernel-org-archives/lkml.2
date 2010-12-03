Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0LCJ5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:57:44 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41792 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab0LCJ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:57:41 -0500
X-AuditID: b753bd60-a62feba000000f8d-77-4cf8bf12775b
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v5 3/8] [CLEANUP]kprobes: Separate kprobe optimizing code
	from optimizer
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Dec 2010 18:54:03 +0900
Message-ID: <20101203095403.2961.91201.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101203095325.2961.75137.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095325.2961.75137.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate kprobe optimizing code from optimizer, this
will make easy to introducing unoptimizing code in
optimizer.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
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

