Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab0HTCNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 22:13:17 -0400
Received: from ozlabs.org ([203.10.76.45]:52931 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab0HTCNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 22:13:14 -0400
From: Michael Neuling <mikey@neuling.org>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
cc: anton@samba.org
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: [PATCH] audit: speedup for syscalls when auditing is disabled
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 20 Aug 2010 12:13:13 +1000
Message-ID: <29151.1282270393@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found that when auditing is disabled using "auditctl -D", that
there's still a significant overhead when doing syscalls.  This overhead
is not present when a single never rule is inserted using "auditctl -a
task,never".  

Using Anton's null syscall microbenchmark from
http://ozlabs.org/~anton/junkcode/null_syscall.c we currently have on a
powerpc machine:

  # auditctl -D
  No rules
  # ./null_syscall
	  null_syscall:     739.03 cycles     100.00%
  # auditctl -a task,never
  # ./null_syscall
	  null_syscall:     204.63 cycles     100.00%

This doesn't seem right, as we'd hope that auditing would have the same
minimal impact when disabled via -D as when we have a single never rule.

The patch below creates a fast path when initialising a task.  If the
rules list for tasks is empty (the disabled -D option), we mark auditing
as disabled for this task.  

When this is applied, our null syscall benchmark improves in the
disabled case to match the single never rule case.

  # auditctl -D
  No rules
  # ./null_syscall
	  null_syscall:     204.62 cycles     100.00%
  # auditctl -a task,never
  # ./null_syscall
	  null_syscall:     204.63 cycles     100.00%

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
I'm not familiar with the auditing code/infrastructure so I may have
misunderstood something here

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 1b31c13..1cd6ec7 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -666,6 +666,11 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
 	enum audit_state   state;
 
 	rcu_read_lock();
+	/* Fast path.  If the list is empty, disable auditing */
+	if (list_empty(&audit_filter_list[AUDIT_FILTER_TASK])) {
+		rcu_read_unlock();
+		return AUDIT_DISABLED;
+	}
 	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_TASK], list) {
 		if (audit_filter_rules(tsk, &e->rule, NULL, NULL, &state)) {
 			if (state == AUDIT_RECORD_CONTEXT)
