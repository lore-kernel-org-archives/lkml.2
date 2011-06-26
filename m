Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1FZTJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 15:09:00 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57148 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab1FZTIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 15:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=b9RguRapbhsvsa1KBiHqGM9erOOhtXhJKgvfG/HlGnOd2wpvnr78/+Y9chKtabiMFN
         0XJc9Mx1LewlSwAb+dxsvEEL50RZVbY3YDgDStMmngkQUlCVGMWP1f+q0h2YsqV+6Wsp
         M2/C6+Vl5k2eA+g3tC2CS1lRhp3EpmPUqDk5A=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: make former thread ID available via PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
Date: Sun, 26 Jun 2011 21:08:42 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106262108.43011.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows tracer to figure out which of its potentially many
tracees performed the execve.

Run-tested.
Below is the output of a test program which creates two additional threads,
and one of them execs. PTRACE_O_TRACECLONE, PTRACE_O_TRACEEXIT and
PTRACE_O_TRACEEXEC are in effect:

4857: thread leader
4857: status:0003057f WIFSTOPPED sig:5 (TRAP) event:CLONE eventdata:0x12fa (4858)
4858: status:0000137f WIFSTOPPED sig:19 (STOP) event:none eventdata:0x0 (0)
4857: status:0003057f WIFSTOPPED sig:5 (TRAP) event:CLONE eventdata:0x12fb (4859)
4859: status:0000137f WIFSTOPPED sig:19 (STOP) event:none eventdata:0x12fa (4858)
4858: status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT eventdata:0x0 (0)
4857: status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT eventdata:0x0 (0)
4858: status:00000000 WIFEXITED exitcode:0
4857: status:0004057f WIFSTOPPED sig:5 (TRAP) event:EXEC eventdata:0x12fb (4859)

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

diff --git a/fs/exec.c b/fs/exec.c
index 6075a1e..edf9ed2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1366,13 +1366,22 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	for (try=0; try<2; try++) {
 		read_lock(&binfmt_lock);
 		list_for_each_entry(fmt, &formats, lh) {
-			int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
-			if (!fn)
+			int (*load_binary)(struct linux_binprm *, struct pt_regs *);
+			pid_t old_pid = old_pid; /* for compiler */
+
+			load_binary = fmt->load_binary;
+			if (!load_binary)
 				continue;
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
-			retval = fn(bprm, regs);
+			if (task_ptrace(current) & PT_PTRACED) {
+				/* Need to fetch pid before load_binary changes it */
+				rcu_read_lock();
+				old_pid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
+				rcu_read_unlock();
+			}
+			retval = load_binary(bprm, regs);
 			/*
 			 * Restore the depth counter to its starting value
 			 * in this call, so we don't have to rely on every
@@ -1381,7 +1390,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			bprm->recursion_depth = depth;
 			if (retval >= 0) {
 				if (depth == 0)
-					tracehook_report_exec(fmt, bprm, regs);
+					tracehook_report_exec(fmt, bprm, regs, old_pid);
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index e95f523..c87866d 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -199,9 +199,10 @@ static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
  */
 static inline void tracehook_report_exec(struct linux_binfmt *fmt,
 					 struct linux_binprm *bprm,
-					 struct pt_regs *regs)
+					 struct pt_regs *regs,
+					 pid_t old_pid)
 {
-	if (!ptrace_event(PT_TRACE_EXEC, PTRACE_EVENT_EXEC, 0) &&
+	if (!ptrace_event(PT_TRACE_EXEC, PTRACE_EVENT_EXEC, old_pid) &&
 	    unlikely(task_ptrace(current) & PT_PTRACED))
 		send_sig(SIGTRAP, current, 0);
 }
