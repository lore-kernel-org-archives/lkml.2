Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0I3J2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:28:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40807 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab0I3J2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T6jN9bldxfeM6gJ8z6eiQGVFsIFz2FjzoXaTKizxMhNe3LooAXyrg2OlCvCQSs11V6
         n7ljvos2qLremld3C4G0+snw24qXiM42yz6LmA51wstoc/EbRZ7uglf3fHZY9WxwYw6p
         Qkg96Ejst7jQUlWNTd1sqFNQh2glVPzX/KVzo=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v3 02/24] ptrace: cleanup ptrace_request()
Date: Thu, 30 Sep 2010 18:27:37 +0900
Message-Id: <1285838880-4977-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'datavp' and 'datalp' variables to remove unnecesary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index f838afe..dded1d6 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -563,6 +563,8 @@ int ptrace_request(struct task_struct *child, long request,
 {
 	int ret = -EIO;
 	siginfo_t siginfo;
+	void __user *datavp = (void __user *) data;
+	unsigned long __user *datalp = datavp;
 
 	switch (request) {
 	case PTRACE_PEEKTEXT:
@@ -579,19 +581,17 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = ptrace_setoptions(child, data);
 		break;
 	case PTRACE_GETEVENTMSG:
-		ret = put_user(child->ptrace_message, (unsigned long __user *) data);
+		ret = put_user(child->ptrace_message, datalp);
 		break;
 
 	case PTRACE_GETSIGINFO:
 		ret = ptrace_getsiginfo(child, &siginfo);
 		if (!ret)
-			ret = copy_siginfo_to_user((siginfo_t __user *) data,
-						   &siginfo);
+			ret = copy_siginfo_to_user(datavp, &siginfo);
 		break;
 
 	case PTRACE_SETSIGINFO:
-		if (copy_from_user(&siginfo, (siginfo_t __user *) data,
-				   sizeof siginfo))
+		if (copy_from_user(&siginfo, datavp, sizeof siginfo))
 			ret = -EFAULT;
 		else
 			ret = ptrace_setsiginfo(child, &siginfo);
@@ -622,7 +622,7 @@ int ptrace_request(struct task_struct *child, long request,
 		}
 		mmput(mm);
 
-		ret = put_user(tmp, (unsigned long __user *) data);
+		ret = put_user(tmp, datalp);
 		break;
 	}
 #endif
@@ -651,7 +651,7 @@ int ptrace_request(struct task_struct *child, long request,
 	case PTRACE_SETREGSET:
 	{
 		struct iovec kiov;
-		struct iovec __user *uiov = (struct iovec __user *) data;
+		struct iovec __user *uiov = datavp;
 
 		if (!access_ok(VERIFY_WRITE, uiov, sizeof(*uiov)))
 			return -EFAULT;
-- 
1.7.2.2

