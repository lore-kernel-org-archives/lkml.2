Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab1BPAmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:42:21 -0500
Received: from kroah.org ([198.145.64.141]:49426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626Ab1BPAX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:44 2011
Message-Id: <20110216001444.122941207@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [190/272] powerpc: Fix hcall tracepoint recursion
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 57cdfdf829a850a317425ed93c6a576c9ee6329c upstream.

Spinlocks on shared processor partitions use H_YIELD to notify the
hypervisor we are waiting on another virtual CPU. Unfortunately this means
the hcall tracepoints can recurse.

The patch below adds a percpu depth and checks it on both the entry and
exit hcall tracepoints.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/lpar.c |   37 ++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -701,6 +701,13 @@ EXPORT_SYMBOL(arch_free_page);
 /* NB: reg/unreg are called while guarded with the tracepoints_mutex */
 extern long hcall_tracepoint_refcount;
 
+/*
+ * Since the tracing code might execute hcalls we need to guard against
+ * recursion. One example of this are spinlocks calling H_YIELD on
+ * shared processor partitions.
+ */
+static DEFINE_PER_CPU(unsigned int, hcall_trace_depth);
+
 void hcall_tracepoint_regfunc(void)
 {
 	hcall_tracepoint_refcount++;
@@ -713,12 +720,42 @@ void hcall_tracepoint_unregfunc(void)
 
 void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
 {
+	unsigned long flags;
+	unsigned int *depth;
+
+	local_irq_save(flags);
+
+	depth = &__get_cpu_var(hcall_trace_depth);
+
+	if (*depth)
+		goto out;
+
+	(*depth)++;
 	trace_hcall_entry(opcode, args);
+	(*depth)--;
+
+out:
+	local_irq_restore(flags);
 }
 
 void __trace_hcall_exit(long opcode, unsigned long retval,
 			unsigned long *retbuf)
 {
+	unsigned long flags;
+	unsigned int *depth;
+
+	local_irq_save(flags);
+
+	depth = &__get_cpu_var(hcall_trace_depth);
+
+	if (*depth)
+		goto out;
+
+	(*depth)++;
 	trace_hcall_exit(opcode, retval, retbuf);
+	(*depth)--;
+
+out:
+	local_irq_restore(flags);
 }
 #endif


