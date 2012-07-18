Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2GRWfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:35:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27416 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab2GRWfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:35:32 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=l329ejTtuJUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=n8i27M1mAAAA:8 a=o8eAoyqBWrPcO1qUJOIA:9 a=PUjeQqilurYA:10 a=rXZLD9m7qZoA:10 a=jeBq3FmKZ4MA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342650928.11900.20.camel@gandalf.stny.rr.com>
Subject: [PATCH] powerpc/ftrace: Trace function graph entry before updating
 index
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Colin Cross <ccross@android.com>
Date: Wed, 18 Jul 2012 18:35:28 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Colin Cross ported my x86 change to ARM, he also pointed out that
powerpc is also behind in this fix.

The commit 722b3c746953 "ftrace/graph: Trace function entry before
updating index" fixes an issue with function graph tracing for x86,
where if the called entry function decides not to trace interrupts, it
can fail the check if an interrupt comes in just after the
curr_ret_stack is updated.

The solution is to call the entry function first, then update the
curr_ret_stack if the entry function wants to be traced.

Cc: Colin Cross <ccross@android.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 91b46b7..1fb7856 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -630,18 +630,17 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		return;
 	}
 
-	if (ftrace_push_return_trace(old, self_addr, &trace.depth, 0) == -EBUSY) {
-		*parent = old;
-		return;
-	}
-
 	trace.func = self_addr;
+	trace.depth = current->curr_ret_stack + 1;
 
 	/* Only trace if the calling function expects to */
 	if (!ftrace_graph_entry(&trace)) {
-		current->curr_ret_stack--;
 		*parent = old;
+		return;
 	}
+
+	if (ftrace_push_return_trace(old, self_addr, &trace.depth, 0) == -EBUSY)
+		*parent = old;
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 


