Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0H0Jms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:42:48 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42732 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab0H0Jmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P0PRwbonjjmEdFb2aIjVSumCndx46MAGiy83jg1S1YsfNCNwLUaifzyDUFraoC2q5/
         O6xr9EjeIUdd1tLqRlbdO4jfAEinjSbnrFKIGpSeXjX6kpS7KtGzW7Hjl06H/I9ptF6V
         xQK+Udrd0q536UAI9nUHFZjg9mqFTnP62IzOw=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 02/43] ptrace: cleanup ptrace_request()
Date: Fri, 27 Aug 2010 18:41:48 +0900
Message-Id: <1282902149-12991-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new local variable to remove unnecesary casting, but it requires
put_user() to be changed to copy_to_user().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/ptrace.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index f838afe..1084bef 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -563,6 +563,7 @@ int ptrace_request(struct task_struct *child, long request,
 {
 	int ret = -EIO;
 	siginfo_t siginfo;
+	void __user *datap = (void __user *) data;
 
 	switch (request) {
 	case PTRACE_PEEKTEXT:
@@ -579,19 +580,19 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = ptrace_setoptions(child, data);
 		break;
 	case PTRACE_GETEVENTMSG:
-		ret = put_user(child->ptrace_message, (unsigned long __user *) data);
+		ret = copy_to_user(datap, &child->ptrace_message,
+				   sizeof (child->ptrace_message)) ?
+			-EFAULT : 0;
 		break;
 
 	case PTRACE_GETSIGINFO:
 		ret = ptrace_getsiginfo(child, &siginfo);
 		if (!ret)
-			ret = copy_siginfo_to_user((siginfo_t __user *) data,
-						   &siginfo);
+			ret = copy_siginfo_to_user(datap, &siginfo);
 		break;
 
 	case PTRACE_SETSIGINFO:
-		if (copy_from_user(&siginfo, (siginfo_t __user *) data,
-				   sizeof siginfo))
+		if (copy_from_user(&siginfo, datap, sizeof siginfo))
 			ret = -EFAULT;
 		else
 			ret = ptrace_setsiginfo(child, &siginfo);
@@ -622,7 +623,7 @@ int ptrace_request(struct task_struct *child, long request,
 		}
 		mmput(mm);
 
-		ret = put_user(tmp, (unsigned long __user *) data);
+		ret = copy_to_user(datap, &tmp, sizeof tmp) ? -EFAULT : 0;
 		break;
 	}
 #endif
-- 
1.7.2.2

