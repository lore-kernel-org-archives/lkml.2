Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1G0VwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:52:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:16747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779Ab1G0Vtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826617"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: segoon@openwall.com, torvalds@linux-foundation.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [96/99] proc: restrict access to /proc/PID/io
Message-Id: <20110727214936.0A8432403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

[ upstream commit 1d1221f375c94ef961ba8574ac4f85c8870ddd51 ]

/proc/PID/io may be used for gathering private information.  E.g.  for
openssh and vsftpd daemons wchars/rchars may be used to learn the
precise password length.  Restrict it to processes being able to ptrace
the target process.

ptrace_may_access() is needed to prevent keeping open file descriptor of
"io" file, executing setuid binary and gathering io information of the
setuid'ed process.

Said to be CVE-2011-2495

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/fs/proc/base.c
===================================================================
--- linux-2.6.35.y.orig/fs/proc/base.c
+++ linux-2.6.35.y/fs/proc/base.c
@@ -2514,6 +2514,9 @@ static int do_io_accounting(struct task_
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
 
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		return -EACCES;
+
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
 
@@ -2636,7 +2639,7 @@ static const struct pid_entry tgid_base_
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, proc_tgid_io_accounting),
+	INF("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 };
 
@@ -2972,7 +2975,7 @@ static const struct pid_entry tid_base_s
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, proc_tid_io_accounting),
+	INF("io",	S_IRUSR, proc_tid_io_accounting),
 #endif
 };
 
