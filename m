Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab1HFAZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:25:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266Ab1HFAJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:09:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:53 2011
Message-Id: <20110806000253.887936230@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: [50/55] proc: restrict access to /proc/PID/io
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 1d1221f375c94ef961ba8574ac4f85c8870ddd51 upstream.

/proc/PID/io may be used for gathering private information.  E.g.  for
openssh and vsftpd daemons wchars/rchars may be used to learn the
precise password length.  Restrict it to processes being able to ptrace
the target process.

ptrace_may_access() is needed to prevent keeping open file descriptor of
"io" file, executing setuid binary and gathering io information of the
setuid'ed process.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2454,6 +2454,9 @@ static int do_io_accounting(struct task_
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
 
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		return -EACCES;
+
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
 
@@ -2575,7 +2578,7 @@ static const struct pid_entry tgid_base_
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, proc_tgid_io_accounting),
+	INF("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 };
 
@@ -2910,7 +2913,7 @@ static const struct pid_entry tid_base_s
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, proc_tid_io_accounting),
+	INF("io",	S_IRUSR, proc_tid_io_accounting),
 #endif
 };
 


