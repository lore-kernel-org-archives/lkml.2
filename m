Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab0HYBeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:34:01 -0400
Received: from ozlabs.org ([203.10.76.45]:43610 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab0HYBd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:33:58 -0400
Date: Wed, 25 Aug 2010 11:32:38 +1000
From: Anton Blanchard <anton@samba.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing/trace_stack: Fix stack trace on ppc64
Message-ID: <20100825013238.GE28360@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


save_stack_trace() stores the instruction pointer, not the function
descriptor. On ppc64 the trace stack code currently dereferences the
instruction pointer and shows 8 bytes of instructions in our backtraces:

# cat /sys/kernel/debug/tracing/stack_trace
        Depth    Size   Location    (26 entries)
        -----    ----   --------
  0)     5424     112   0x6000000048000004
  1)     5312     160   0x60000000ebad01b0
  2)     5152     160   0x2c23000041c20030
  3)     4992     240   0x600000007c781b79
  4)     4752     160   0xe84100284800000c
  5)     4592     192   0x600000002fa30000
  6)     4400     256   0x7f1800347b7407e0
  7)     4144     208   0xe89f0108f87f0070
  8)     3936     272   0xe84100282fa30000

Since we aren't dealing with function descriptors, use %pS instead of %pF
to fix it:

# cat /sys/kernel/debug/tracing/stack_trace
        Depth    Size   Location    (26 entries)
        -----    ----   --------
  0)     5424     112   ftrace_call+0x4/0x8
  1)     5312     160   .current_io_context+0x28/0x74
  2)     5152     160   .get_io_context+0x48/0xa0
  3)     4992     240   .cfq_set_request+0x94/0x4c4
  4)     4752     160   .elv_set_request+0x60/0x84
  5)     4592     192   .get_request+0x2d4/0x468
  6)     4400     256   .get_request_wait+0x7c/0x258
  7)     4144     208   .__make_request+0x49c/0x610
  8)     3936     272   .generic_make_request+0x390/0x434

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: powerpc.git/kernel/trace/trace_stack.c
===================================================================
--- powerpc.git.orig/kernel/trace/trace_stack.c	2010-08-25 11:03:52.337982567 +1000
+++ powerpc.git/kernel/trace/trace_stack.c	2010-08-25 11:03:55.018371055 +1000
@@ -249,7 +249,7 @@ static int trace_lookup_stack(struct seq
 {
 	unsigned long addr = stack_dump_trace[i];
 
-	return seq_printf(m, "%pF\n", (void *)addr);
+	return seq_printf(m, "%pS\n", (void *)addr);
 }
 
 static void print_disabled(struct seq_file *m)
