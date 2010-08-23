Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0HWQG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:06:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35568 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0HWQGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DsivMpqRCm0NXzvr2fkr37u1BiLSjgNtBupnvdmYIXNIi0LFgtrVDZbys1XX7+OE1R
         +sfAtPujgK/NSlfDtbuTXUGchqI6mWYsfmEXp5yGwRQynu9E18l+wJgEygMDV4/LaUCN
         HMF691NxAvbuWao7M+ql0LarCImVErF3VKa7w=
From: Namhyung Kim <namhyung@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3 RESEND] ptrace: cleanup address space conversion on ptrace_request()
Date: Tue, 24 Aug 2010 01:06:15 +0900
Message-Id: <1282579575-9189-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <201008222206.18523.arnd@arndb.de>
References: <201008222206.18523.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases 'data' should be considered as a user pointer but it requires
cast with additional __force markup which was missing. Rather than add the
markups wherever needed, make use of a temporary variable of user pointer.
This patch is based on compat_ptrace_request() implementation.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/ptrace.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 4afd9b8..7547b1c 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -564,6 +564,7 @@ int ptrace_request(struct task_struct *child, long request,
 {
 	int ret = -EIO;
 	siginfo_t siginfo;
+	unsigned long __user *datap = (unsigned long __user __force *) data;
 
 	switch (request) {
 	case PTRACE_PEEKTEXT:
@@ -580,18 +581,18 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = ptrace_setoptions(child, data);
 		break;
 	case PTRACE_GETEVENTMSG:
-		ret = put_user(child->ptrace_message, (unsigned long __user *) data);
+		ret = put_user(child->ptrace_message, datap);
 		break;
 
 	case PTRACE_GETSIGINFO:
 		ret = ptrace_getsiginfo(child, &siginfo);
 		if (!ret)
-			ret = copy_siginfo_to_user((siginfo_t __user *) data,
+			ret = copy_siginfo_to_user((siginfo_t __user *) datap,
 						   &siginfo);
 		break;
 
 	case PTRACE_SETSIGINFO:
-		if (copy_from_user(&siginfo, (siginfo_t __user *) data,
+		if (copy_from_user(&siginfo, (siginfo_t __user *) datap,
 				   sizeof siginfo))
 			ret = -EFAULT;
 		else
@@ -623,7 +624,7 @@ int ptrace_request(struct task_struct *child, long request,
 		}
 		mmput(mm);
 
-		ret = put_user(tmp, (unsigned long __user *) data);
+		ret = put_user(tmp, datap);
 		break;
 	}
 #endif
@@ -652,7 +653,7 @@ int ptrace_request(struct task_struct *child, long request,
 	case PTRACE_SETREGSET:
 	{
 		struct iovec kiov;
-		struct iovec __user *uiov = (struct iovec __user *) data;
+		struct iovec __user *uiov = (struct iovec __user *) datap;
 
 		if (!access_ok(VERIFY_WRITE, uiov, sizeof(*uiov)))
 			return -EFAULT;
@@ -742,7 +743,7 @@ int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
 	copied = access_process_vm(tsk, addr, &tmp, sizeof(tmp), 0);
 	if (copied != sizeof(tmp))
 		return -EIO;
-	return put_user(tmp, (unsigned long __user *)data);
+	return put_user(tmp, (unsigned long __user __force *)data);
 }
 
 int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
-- 
1.7.0.4

