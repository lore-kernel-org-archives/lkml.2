Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab2FEK2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:28:48 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60552 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933304Ab2FEK2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:28:39 -0400
X-AuditID: b753bd60-94dc9ba000002ea5-11-4fcddf550f79
X-AuditID: b753bd60-94dc9ba000002ea5-11-4fcddf550f79
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 9/9] kprobes/x86: ftrace based optimization for x86
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 05 Jun 2012 19:28:38 +0900
Message-ID: <20120605102838.27845.26317.stgit@localhost.localdomain>
In-Reply-To: <20120605102734.27845.43401.stgit@localhost.localdomain>
References: <20120605102734.27845.43401.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function tracer based kprobe optimization support
handlers on x86. This allows kprobes to use function
tracer for probing on mcount call.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 arch/x86/include/asm/kprobes.h |    1 +
 arch/x86/kernel/kprobes.c      |   48 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 5478825..d3ddd17 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -27,6 +27,7 @@
 #include <asm/insn.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
+#define  ARCH_SUPPORTS_KPROBES_ON_FTRACE
 
 struct pt_regs;
 struct kprobe;
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index e2f751e..4c46c55 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1052,6 +1052,54 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
+#ifdef KPROBES_CAN_USE_FTRACE
+/* Ftrace callback handler for kprobes */
+void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
+				     struct pt_regs *regs)
+{
+	struct kprobe *p;
+	struct kprobe_ctlblk *kcb;
+	unsigned long flags;
+
+	/* Disable irq for emulating a breakpoint and avoiding preempt */
+	local_irq_save(flags);
+
+	p = get_kprobe((kprobe_opcode_t *)ip);
+	if (unlikely(!p) || kprobe_disabled(p))
+		goto end;
+
+	kcb = get_kprobe_ctlblk();
+	if (kprobe_running()) {
+		kprobes_inc_nmissed_count(p);
+	} else {
+		regs->ip += sizeof(kprobe_opcode_t);
+
+		__this_cpu_write(current_kprobe, p);
+		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+		if (p->pre_handler)
+			p->pre_handler(p, regs);
+
+		if (unlikely(p->post_handler)) {
+			/* Emulate singlestep as if there is a 5byte nop */
+			regs->ip = ip + MCOUNT_INSN_SIZE;
+			kcb->kprobe_status = KPROBE_HIT_SSDONE;
+			p->post_handler(p, regs, 0);
+		}
+		__this_cpu_write(current_kprobe, NULL);
+		regs->ip = ip;	/* Recover for next callback */
+	}
+end:
+	local_irq_restore(flags);
+}
+
+int __kprobes arch_prepare_kprobe_ftrace(struct kprobe *p)
+{
+	p->ainsn.insn = NULL;
+	p->ainsn.boostable = -1;
+	return 0;
+}
+#endif
+
 int __init arch_init_kprobes(void)
 {
 	return arch_init_optprobes();

