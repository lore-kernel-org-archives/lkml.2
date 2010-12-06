Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0LFSSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:18:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:48096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab0LFSSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:18:00 -0500
Date: Mon, 6 Dec 2010 18:17:32 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        jbeulich@novell.com, rostedt@goodmis.org, jbaron@redhat.com,
        tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, jbeulich@novell.com, tglx@linutronix.de,
        jbaron@redhat.com, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20101203095422.2961.51217.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095422.2961.51217.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Introduce text_poke_smp_batch() for batch-code modifying
Message-ID: <tip-7deb18dcf0478940ac979de002db1ed8ba6531dc@git.kernel.org>
Git-Commit-ID: 7deb18dcf0478940ac979de002db1ed8ba6531dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 18:17:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7deb18dcf0478940ac979de002db1ed8ba6531dc
Gitweb:     http://git.kernel.org/tip/7deb18dcf0478940ac979de002db1ed8ba6531dc
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 3 Dec 2010 18:54:22 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Dec 2010 17:59:31 +0100

x86: Introduce text_poke_smp_batch() for batch-code modifying

Introduce text_poke_smp_batch(). This function modifies several
text areas with one stop_machine() on SMP. Because calling
stop_machine() is heavy task, it is better to aggregate
text_poke requests.

( Note: I've talked with Rusty about this interface, and
  he would not like to expand stop_machine() interface, since
  it is not for generic use. )

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
LKML-Reference: <20101203095422.2961.51217.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/alternative.h |    7 +++++
 arch/x86/kernel/alternative.c      |   49 +++++++++++++++++++++++++++++------
 2 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 76561d2..4a2adaa 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -180,8 +180,15 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
  * On the local CPU you need to be protected again NMI or MCE handlers seeing an
  * inconsistent instruction while you patch.
  */
+struct text_poke_param {
+	void *addr;
+	const void *opcode;
+	size_t len;
+};
+
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
+extern void text_poke_smp_batch(struct text_poke_param *params, int n);
 
 #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
 #define IDEAL_NOP_SIZE_5 5
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 5079f24..553d0b0 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -591,17 +591,21 @@ static atomic_t stop_machine_first;
 static int wrote_text;
 
 struct text_poke_params {
-	void *addr;
-	const void *opcode;
-	size_t len;
+	struct text_poke_param *params;
+	int nparams;
 };
 
 static int __kprobes stop_machine_text_poke(void *data)
 {
 	struct text_poke_params *tpp = data;
+	struct text_poke_param *p;
+	int i;
 
 	if (atomic_dec_and_test(&stop_machine_first)) {
-		text_poke(tpp->addr, tpp->opcode, tpp->len);
+		for (i = 0; i < tpp->nparams; i++) {
+			p = &tpp->params[i];
+			text_poke(p->addr, p->opcode, p->len);
+		}
 		smp_wmb();	/* Make sure other cpus see that this has run */
 		wrote_text = 1;
 	} else {
@@ -610,8 +614,12 @@ static int __kprobes stop_machine_text_poke(void *data)
 		smp_mb();	/* Load wrote_text before following execution */
 	}
 
-	flush_icache_range((unsigned long)tpp->addr,
-			   (unsigned long)tpp->addr + tpp->len);
+	for (i = 0; i < tpp->nparams; i++) {
+		p = &tpp->params[i];
+		flush_icache_range((unsigned long)p->addr,
+				   (unsigned long)p->addr + p->len);
+	}
+
 	return 0;
 }
 
@@ -631,10 +639,13 @@ static int __kprobes stop_machine_text_poke(void *data)
 void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 {
 	struct text_poke_params tpp;
+	struct text_poke_param p;
 
-	tpp.addr = addr;
-	tpp.opcode = opcode;
-	tpp.len = len;
+	p.addr = addr;
+	p.opcode = opcode;
+	p.len = len;
+	tpp.params = &p;
+	tpp.nparams = 1;
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
 	/* Use __stop_machine() because the caller already got online_cpus. */
@@ -642,6 +653,26 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 	return addr;
 }
 
+/**
+ * text_poke_smp_batch - Update instructions on a live kernel on SMP
+ * @params: an array of text_poke parameters
+ * @n: the number of elements in params.
+ *
+ * Modify multi-byte instruction by using stop_machine() on SMP. Since the
+ * stop_machine() is heavy task, it is better to aggregate text_poke requests
+ * and do it once if possible.
+ *
+ * Note: Must be called under get_online_cpus() and text_mutex.
+ */
+void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
+{
+	struct text_poke_params tpp = {.params = params, .nparams = n};
+
+	atomic_set(&stop_machine_first, 1);
+	wrote_text = 0;
+	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+}
+
 #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
 
 #ifdef CONFIG_X86_64
