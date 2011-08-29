Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1H2QNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:13:55 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:52415 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab1H2QNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:13:52 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 7/9] um: PTRACE_[GS]ETFPXREGS had been wired on the wrong subarch
Date: Mon, 29 Aug 2011 18:13:37 +0200
Message-Id: <1314634419-24766-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314634419-24766-1-git-send-email-richard@nod.at>
References: <1314634419-24766-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

It's 32bit-only, not 64bit-only...  And while we are at it, it's
set_fpxregs(), not set_fpregs()...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/sys-i386/ptrace.c   |   14 +++++++++++++-
 arch/um/sys-x86_64/ptrace.c |   14 +-------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/um/sys-i386/ptrace.c b/arch/um/sys-i386/ptrace.c
index d23b2d3..49fd25a 100644
--- a/arch/um/sys-i386/ptrace.c
+++ b/arch/um/sys-i386/ptrace.c
@@ -206,5 +206,17 @@ int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 long subarch_ptrace(struct task_struct *child, long request,
 		    unsigned long addr, unsigned long data)
 {
-	return -EIO;
+	int ret = -EIO;
+	void __user *datap = (void __user *) data;
+
+	switch (request) {
+	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
+		ret = get_fpxregs(datap, child);
+		break;
+	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
+		ret = set_fpxregs(datap, child);
+		break;
+	}
+
+	return ret;
 }
diff --git a/arch/um/sys-x86_64/ptrace.c b/arch/um/sys-x86_64/ptrace.c
index f436136..7ed49ac 100644
--- a/arch/um/sys-x86_64/ptrace.c
+++ b/arch/um/sys-x86_64/ptrace.c
@@ -178,17 +178,5 @@ int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 long subarch_ptrace(struct task_struct *child, long request,
 		    unsigned long addr, unsigned long data)
 {
-	int ret = -EIO;
-	void __user *datap = (void __user *) data;
-
-	switch (request) {
-	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
-		ret = get_fpregs(datap, child);
-		break;
-	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
-		ret = set_fpregs(datap, child);
-		break;
-	}
-
-	return ret;
+	return -EIO;
 }
-- 
1.7.6.1

