Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2FNWsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:48:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:33701 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab2FNWrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:47:48 -0400
Date: Fri, 15 Jun 2012 00:47:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] tracing: Fix the outmost stupidity of tracing_off()
Message-ID: <alpine.LFD.2.02.1206142345100.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I lost another day of waiting for a complex bug to trigger and turn
off tracing, which did not happen due to:

 commit 499e54705(tracing/ring-buffer: Only have tracing_on disable
 tracing buffers)

The subject line itself is supsicious itself:

  Only have tracing_on disable tracing buffers

tracing_on as far as I'm concerned is supposed to start tracing. So
disabling trace buffers on tracing_on is counterproductive.

The patch description is not really a better source of enlightment:

  As the ring-buffer code is being used by other facilities in the
  kernel, having tracing_on file disable *all* buffers is not a desired
  affect. It should only disable the ftrace buffers that are being used.
    
  Move the code into the trace.c file and use the buffer disabling
  for tracing_on() and tracing_off(). This way only the ftrace buffers
  will be affected by them and other kernel utilities will not be
  confused to why their output suddenly stopped.

How should the casual reader of this commit message figure out that
tracing_on is a debugfs file which accepts 0 resp. 1 to it, where 0
causes the buffers to be disabled?

Yes, it's obvious to the patch author, but ....

While I account that to the usual inability to write proper
changelogs, I'm amazed about the following parts of the patch

-void tracing_off(void)
-{
-       clear_bit(RB_BUFFERS_ON_BIT, &ring_buffer_flags);
-}

...

+void tracing_off(void)
+{
+       if (global_trace.buffer)
+               ring_buffer_record_on(global_trace.buffer);

This is so amazingly stupid, that it's not even funny anymore.

Is it really too much to expect that a patch of the size

 4 files changed, 171 insertions(+), 97 deletions(-)

which touches fundamental functionality of a subsystem is at least
tested to maintain the previous functionality?

Signed-off-by: Thomas [royally annoyed] Gleixner <tglx@linutronix.de>

---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/trace/trace.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace.c
+++ linux-2.6/kernel/trace/trace.c
@@ -371,7 +371,7 @@ EXPORT_SYMBOL_GPL(tracing_on);
 void tracing_off(void)
 {
 	if (global_trace.buffer)
-		ring_buffer_record_on(global_trace.buffer);
+		ring_buffer_record_off(global_trace.buffer);
 	/*
 	 * This flag is only looked at when buffers haven't been
 	 * allocated yet. We don't really care about the race
