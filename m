Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1F2CNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 22:13:45 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:51384 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1F2CNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 22:13:42 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCHv4] ptrace: make former thread ID available via PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop
Date: Wed, 29 Jun 2011 04:13:39 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201106290413.39429.vda.linux@googlemail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

Please take a look at version 4 of this patch.

When multithreaded program execs under ptrace,
all traced threads report WIFEXITED status, except for
thread group leader and the thread which execs.

Unless tracer tracks thread group relationship between tracees,
which is a nontrivial task, it will not detect that
execed thread no longer exists.

This patch allows tracer to figure out which thread
performed this exec, by requesting PTRACE_GETEVENTMSG
in PTRACE_EVENT_EXEC stop.

Another, samller problem which is solved by this patch
is that tracer now can figure out which of the several
concurrent execs in multithreaded program succeeded.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

-- 
vda


diff --git a/fs/exec.c b/fs/exec.c
index 8dca45b..55819be 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1357,6 +1357,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	unsigned int depth = bprm->recursion_depth;
 	int try,retval;
 	struct linux_binfmt *fmt;
+	pid_t old_pid;
 
 	retval = security_bprm_check(bprm);
 	if (retval)
@@ -1370,6 +1371,11 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	if (retval)
 		return retval;
 
+	/* Need to fetch pid before load_binary changes it */
+	rcu_read_lock();
+	old_pid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
+	rcu_read_unlock();
+
 	retval = -ENOENT;
 	for (try=0; try<2; try++) {
 		read_lock(&binfmt_lock);
@@ -1389,7 +1395,8 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			bprm->recursion_depth = depth;
 			if (retval >= 0) {
 				if (depth == 0)
-					ptrace_event(PTRACE_EVENT_EXEC, 0);
+					ptrace_event(PTRACE_EVENT_EXEC,
+							old_pid);
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)

