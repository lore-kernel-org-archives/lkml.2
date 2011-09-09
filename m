Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab1IIGYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:24:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41613 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab1IIGYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:24:40 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/2] ptrace: don't modify flags on PTRACE_SETOPTIONS failure
Date: Fri, 9 Sep 2011 08:24:37 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
References: <201109090822.30063.vda.linux@googlemail.com>
In-Reply-To: <201109090822.30063.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109090824.37366.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace: don't modify flags on PTRACE_SETOPTIONS failure

On ptrace(PTRACE_SETOPTIONS, pid, 0, <opts>), we used to set
those option bits which are known, and then fail with -EINVAL
if there are some unknown bits in <opts>.

This in inconsistent with typical error handling, which
does not change any state if input is invalid.

This patch changes PTRACE_SETOPTIONS behavior so that
in this case, we return -EINVAL and don't change any bits
in task->ptrace.

It's very unlikely that there is userspace code in the wild which
will be affected by this change: it should have the form

    ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_BOGUSOPT)

where PTRACE_O_BOGUSOPT is a constant unknown to the kernel.
But kernel headers, naturally, don't contain any
PTRACE_O_BOGUSOPTs, thus the only way userspace can use one
if it defines one itself. I can't see why anyone would do such
a thing deliberately.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 9de3ecf..02df3c1 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -509,6 +509,9 @@ int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long ds
 
 static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 {
+	if (data & ~(unsigned long)PTRACE_O_MASK)
+		return -EINVAL;
+
 	child->ptrace &= ~PT_TRACE_MASK;
 
 	if (data & PTRACE_O_TRACESYSGOOD)
@@ -532,7 +535,7 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 	if (data & PTRACE_O_TRACEEXIT)
 		child->ptrace |= PT_TRACE_EXIT;
 
-	return (data & ~PTRACE_O_MASK) ? -EINVAL : 0;
+	return 0;
 }
 
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
