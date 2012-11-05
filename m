Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2KEQiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:38:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab2KEQiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:38:15 -0500
Date: Mon, 5 Nov 2012 11:38:11 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] coredump: run the coredump helper using the same namespace
 as the dead process
Message-ID: <20121105163810.GJ14789@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/sys/kernel/core_pattern can be used to specify a userspace helper
to handle core files and it currently runs in the root namespace.
This patch allows the helper to run in the same namespace in a step
towards letting containers setting their own helpers.

Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

diff --git a/fs/coredump.c b/fs/coredump.c
index ce47379..fa14ea1 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -455,6 +455,19 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	/* and disallow core files too */
 	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
 
+	/*
+	 * We want to run the helper within the same namespace. Since we
+	 * already forked, current here is using init_nsproxy and the usage
+	 * was already accounted. switch_task_namespace() will revert that
+	 * but we need to bump the dead process' nsproxy before calling the
+	 * the helper. Once it exits, the dead process' nsproxy usage will be
+	 * decremented as part of normal process exit.
+	 */
+	if (current->nsproxy != cp->nsproxy) {
+		get_nsproxy(cp->nsproxy);
+		switch_task_namespaces(current, cp->nsproxy);
+	}
+
 	return err;
 }
 
@@ -482,6 +495,8 @@ void do_coredump(siginfo_t *siginfo, struct pt_regs *regs)
 		 * by any locks.
 		 */
 		.mm_flags = mm->flags,
+		/* we run the helper in the same namespace */
+		.nsproxy = current->nsproxy,
 	};
 
 	audit_core_dumps(siginfo->si_signo);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index cfcc6bf..45113e6 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -63,6 +63,7 @@ struct coredump_params {
 	struct file *file;
 	unsigned long limit;
 	unsigned long mm_flags;
+	struct nsproxy *nsproxy;
 };
 
 /*
