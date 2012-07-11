Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab2GKT5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:57:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab2GKT5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:57:47 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=0DaC3IvP6dkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Lm24_h4V80gCOuCgAoYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120711195048.885039013@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Jul 2012 15:50:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC][PATCH 0/4 v4] ftrace/kprobes: Setting up ftrace for kprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm only posting patches that changed from v3. Those changes include:

Saving the flags after MCOUNT_RESTORE_FRAME (suggested by Masami)
I decided to restore flags from the pt_regs, such that a kprobe
could change the flags register.

I added the offset fix for function parent pointer (pointed out by
 Alexander van Heukelum).

I fixed the i386 version of "save regs" to restore flags correctly
(as pointed out by Masami Hiramatsu).

I also added two new patches.

1) I removed the double check to function_trace_stop variable that
   the function graph tracer was doing (it tested it in the function
   tracer trampoline, and again in the function graph trampoline).

2) I added internal recursion protection, that I found kprobes was
  triggering. This was long overdue anyway.

Masami,

Could you give your reviewed by tags for the first two patches, at least.

Thanks,

-- Steve

Steven Rostedt (4):
      ftrace/x86: Add separate function to save regs
      ftrace/x86: Add save_regs for i386 function calls
      ftrace/x86: Remove function_trace_stop check from graph caller
      ftrace/x86_64: Add recursion protection inside mcount caller

----
 arch/x86/include/asm/ftrace.h |   47 +++++++++-------
 arch/x86/kernel/entry_32.S    |   93 ++++++++++++++++++++++++++++--
 arch/x86/kernel/entry_64.S    |  125 ++++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/ftrace.c      |   80 ++++++++++++++++++++++++--
 include/linux/ftrace.h        |  109 ++++++++++++++++++++++++++++++++---
 kernel/trace/ftrace.c         |   91 +++++++++++++++++++++++++++---
 6 files changed, 485 insertions(+), 60 deletions(-)
