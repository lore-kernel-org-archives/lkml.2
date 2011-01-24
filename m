Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1AXVkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:40:31 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16274 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1AXVk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:40:29 -0500
Date: Mon, 24 Jan 2011 22:41:11 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: x86@kernel.org
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Soren Sandmann <ssp@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] X86-64: Don't use pointer to out-of-scope variable in
 dump_trace()
Message-ID: <alpine.LNX.2.00.1101242232590.10252@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/x86/kernel/dumpstack_64.c::dump_trace() we have this code:

...
  		if (!stack) {
  			unsigned long dummy;
  			stack = &dummy;
  			if (task && task != current)
  				stack = (unsigned long *)task->thread.sp;
  		}
  	
  		bp = stack_frame(task, regs);
  		/*
  		 * Print function call entries in all stacks, starting at the
  		 * current stack address. If the stacks consist of nested
  		 * exceptions
  		 */
  		tinfo = task_thread_info(task);

  		for (;;) {
  			char *id;
  			unsigned long *estack_end;
  			estack_end = in_exception_stack(cpu, (unsigned long)stack,
  							&used, &id);
...

You'll notice that we assign to 'stack' the address of the variable 
'dummy' which is only in-scope inside the 'if (!stack)'. So when we later 
access stack (at the end of the above, and assuming we did not take the 
'if (task && task != current)' branch) we'll be using the address of a 
variable that is no longer in scope. I believe this patch is the proper 
fix, but I freely admit that I'm not 100% certain.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 dumpstack_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

  compile tested only.

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6410133..a6b6fcf 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -149,13 +149,13 @@ void dump_trace(struct task_struct *task,
 	unsigned used = 0;
 	struct thread_info *tinfo;
 	int graph = 0;
+	unsigned long dummy;
 	unsigned long bp;
 
 	if (!task)
 		task = current;
 
 	if (!stack) {
-		unsigned long dummy;
 		stack = &dummy;
 		if (task && task != current)
 			stack = (unsigned long *)task->thread.sp;


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

