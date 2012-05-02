Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2EBTec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:34:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab2EBTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:32:38 -0400
X-Authority-Analysis: v=2.0 cv=N/Wr5hBB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=n2lABFMPQmYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=k3KHomK8etPYVlJQuPwA:9 a=ueEir-6bpuOCoeLlHv8A:7 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=y6P4t-jWjoR4jnPp:21 a=A1VhSQEaZUrhuXIX:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502193237.321234712@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 May 2012 15:24:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 6/9][RFC] kprobes: Allow probe on ftrace reserved text (but move it)
References: <20120502192418.024103772@goodmis.org>
Content-Disposition: inline; filename=0006-kprobes-Allow-probe-on-ftrace-reserved-text-but-move.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If a probe is placed on a ftrace nop (or ftrace_caller), simply move the
probe to the next instruction instead of rejecting it. This will allow
kprobes not to be affected by ftrace using the -mfentry gcc option which
will put the ftrace nop at the beginning of the function. As a very common
case for kprobes is to add a probe to the very beginning of a function
we need a way to handle the case when ftrace takes the first instruction.

Added KPROBE_FLAG_MOVED (as suggested by Masami) that is set when the address
is moved to get around an ftrace nop.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h  |    2 ++
 include/linux/kprobes.h |    1 +
 kernel/kprobes.c        |   13 ++++++++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9310993..211ae45 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -414,6 +414,8 @@ static inline int ftrace_text_reserved(void *start, void *end)
 #define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_free_filter(ops) do { } while (0)
 
+static inline unsigned long ftrace_location(unsigned long ip) { return 0; }
+
 static inline ssize_t ftrace_filter_write(struct file *file, const char __user *ubuf,
 			    size_t cnt, loff_t *ppos) { return -ENODEV; }
 static inline ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index b6e1f8c..23cf41e 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -128,6 +128,7 @@ struct kprobe {
 				   * NOTE:
 				   * this flag is only for optimized_kprobe.
 				   */
+#define KPROBE_FLAG_MOVED	8 /* probe was moved passed ftrace nop */
 
 /* Has this kprobe gone ? */
 static inline int kprobe_gone(struct kprobe *p)
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c62b854..952619b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1319,10 +1319,22 @@ int __kprobes register_kprobe(struct kprobe *p)
 	struct kprobe *old_p;
 	struct module *probed_mod;
 	kprobe_opcode_t *addr;
+	unsigned long ftrace_addr;
 
 	addr = kprobe_addr(p);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
+
+	/*
+	 * If the address is located on a ftrace nop, set the
+	 * breakpoint to the following instruction.
+	 */
+	ftrace_addr = ftrace_location((unsigned long)addr);
+	if (unlikely(ftrace_addr)) {
+		addr = (kprobe_opcode_t *)(ftrace_addr + MCOUNT_INSN_SIZE);
+		p->flags |= KPROBE_FLAG_MOVED;
+	}
+
 	p->addr = addr;
 
 	ret = check_kprobe_rereg(p);
@@ -1333,7 +1345,6 @@ int __kprobes register_kprobe(struct kprobe *p)
 	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
-	    ftrace_text_reserved(p->addr, p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr)) {
 		ret = -EINVAL;
 		goto cannot_probe;
-- 
1.7.9.5


