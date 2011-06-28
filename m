Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab1F1AZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 20:25:38 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:34496 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab1F1AYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 20:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=iMo+UN2zfP1kCdp7n5GsDgIxbzMGUnyuVIPUJbCjo8HI8dGOivj/LrFs8hv9/X7dvM
         rwiV8LZLlN/WsAqIvcRA5LKM+7wrFUbONHIYwIK2ga4FAmJihE8PYaNsnQGv0ET+fPfN
         QXh5xOclie2ge6v6fivLSYmiKfgSqNfQMHItg=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] ptrace: make former thread ID available via PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.3)
Date: Tue, 28 Jun 2011 02:24:40 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106280224.40286.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

Please take a look at version 3 of this patch.

When multithreaded program execs under ptrace,
all traced threads report WIFEXITED status, except for
thread group leader and the thread which execs.

Unless tracer tracks thread group relationship between threads
(which is a nontrivial task), it may fail to detect that
execed thread no longer exists.

This patch allows tracer to figure out which thread
performed this exec, by requesting PTRACE_GETEVENTMSG
in PTRACE_EVENT_EXEC stop.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

-- 
vda

diff --git a/fs/exec.c b/fs/exec.c
index 8dca45b..5745add 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1357,6 +1357,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	unsigned int depth = bprm->recursion_depth;
 	int try,retval;
 	struct linux_binfmt *fmt;
+	pid_t uninitialized_var(old_pid);
 
 	retval = security_bprm_check(bprm);
 	if (retval)
@@ -1370,17 +1371,26 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	if (retval)
 		return retval;
 
+	if (ptrace_event_enabled(current, PTRACE_EVENT_EXEC)) {
+		/* Need to fetch pid before load_binary changes it */
+		rcu_read_lock();
+		old_pid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
+		rcu_read_unlock();
+	}
+
 	retval = -ENOENT;
 	for (try=0; try<2; try++) {
 		read_lock(&binfmt_lock);
 		list_for_each_entry(fmt, &formats, lh) {
-			int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
-			if (!fn)
+			int (*load_binary)(struct linux_binprm *, struct pt_regs *);
+
+			load_binary = fmt->load_binary;
+			if (!load_binary)
 				continue;
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
-			retval = fn(bprm, regs);
+			retval = load_binary(bprm, regs);
 			/*
 			 * Restore the depth counter to its starting value
 			 * in this call, so we don't have to rely on every
@@ -1389,7 +1399,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			bprm->recursion_depth = depth;
 			if (retval >= 0) {
 				if (depth == 0)
-					ptrace_event(PTRACE_EVENT_EXEC, 0);
+					ptrace_event(PTRACE_EVENT_EXEC, old_pid);
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)
