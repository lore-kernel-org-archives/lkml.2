Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1AXXNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:13:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:33285 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab1AXXNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:13:12 -0500
Date: Mon, 24 Jan 2011 23:12:51 GMT
From: tip-bot for Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jj@chaosbits.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jj@chaosbits.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <alpine.LNX.2.00.1101242232590.10252@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101242232590.10252@swampdragon.chaosbits.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64: Don't use pointer to out-of-scope variable in dump_trace()
Message-ID: <tip-2e5aa6824d9e0248d734573dad8858a2cc279cfe@git.kernel.org>
Git-Commit-ID: 2e5aa6824d9e0248d734573dad8858a2cc279cfe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 24 Jan 2011 23:12:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e5aa6824d9e0248d734573dad8858a2cc279cfe
Gitweb:     http://git.kernel.org/tip/2e5aa6824d9e0248d734573dad8858a2cc279cfe
Author:     Jesper Juhl <jj@chaosbits.net>
AuthorDate: Mon, 24 Jan 2011 22:41:11 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 24 Jan 2011 13:46:15 -0800

x86-64: Don't use pointer to out-of-scope variable in dump_trace()

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
LKML-Reference: <alpine.LNX.2.00.1101242232590.10252@swampdragon.chaosbits.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/dumpstack_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
