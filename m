Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0KSKNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 05:13:09 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54726 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab0KSKNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:13:06 -0500
X-AuditID: b753bd60-a87a8ba000003e7d-d5-4ce64dae4443
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v4 1/3] x86: Introduce text_poke_smp_batch() for
	batch-code modifying
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jan Beulich <jbeulich@novell.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 19 Nov 2010 19:09:33 +0900
Message-ID: <20101119100933.16882.53671.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101119100925.16882.34772.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101119100925.16882.34772.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce text_poke_smp_batch(). This function modifies several
text areas with one stop_machine() on SMP. Because calling
stop_machine() is heavy task, it is better to aggregate text_poke
requests.

Frederic, I've talked with Rusty about this interface, and
he would not like to expand stop_machine() interface, since
it is not for generic use.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 arch/x86/include/asm/alternative.h |    7 +++++
 arch/x86/kernel/alternative.c      |   49 +++++++++++++++++++++++++++++-------
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

