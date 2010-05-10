Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0EJRtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:49:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab0EJRs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:48:58 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/5] x86: Introduce text_poke_smp_batch() for batch-code
	modifying
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 10 May 2010 13:53:34 -0400
Message-ID: <20100510175333.27396.86238.stgit@localhost6.localdomain6>
In-Reply-To: <20100510175313.27396.34605.stgit@localhost6.localdomain6>
References: <20100510175313.27396.34605.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce text_poke_smp_batch(). This function modifies several
text areas with one stop_machine() on SMPr. Because calling
stop_machine() is heavy task, it is better to aggregate text_poke
requests.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---

 arch/x86/include/asm/alternative.h |    7 +++++
 arch/x86/kernel/alternative.c      |   49 +++++++++++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 03b6bb5..9a08773 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -176,7 +176,14 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
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
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 7023773..7256800 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -590,17 +590,21 @@ static atomic_t stop_machine_first;
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
@@ -609,8 +613,12 @@ static int __kprobes stop_machine_text_poke(void *data)
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
 
@@ -630,13 +638,36 @@ static int __kprobes stop_machine_text_poke(void *data)
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
 	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
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


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
