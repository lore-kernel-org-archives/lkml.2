Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0ICDUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 23:20:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46167 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab0ICDUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 23:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=l2DHtelp55N6N8rltiXCSaND8W+/mvB9F+9a90d2w6DfFFY45P7YRUwvOw9x2/cEwF
         SEGIcjQ0vjSlfCw4lJ2xm5NiwRyDxN1D3h7yf0T+ASgluk6IvbQ0sn+pvMYOf9sVGAKM
         y4U+ONlFl802P1c5QtXI4jXxUmGpQ7R9CTnm8=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/24] ptrace: cleanup ptrace_request()
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
	<1283442391-23612-3-git-send-email-namhyung@gmail.com>
	<20100902183210.0CA3C40465@magilla.sf.frob.com>
Date: Fri, 03 Sep 2010 12:19:48 +0900
In-Reply-To: <20100902183210.0CA3C40465@magilla.sf.frob.com> (Roland McGrath's
	message of "Thu, 2 Sep 2010 11:32:09 -0700 (PDT)")
Message-ID: <87mxrzh5t7.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:
> You've still changed put_user to copy_to_user here.
> I thought you'd agreed not to change that.
>

My bad. I just sent v1, sorry.
Here comes updated version.


>From 2e6543cdfb05c66dcb18ce5e8d941d835a4767af Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@gmail.com>
Date: Thu, 26 Aug 2010 01:46:52 +0900
Subject: [PATCH v2 02/24 UPDATED] ptrace: cleanup ptrace_request()

Use new 'datavp' and 'datalp' variables to remove unnecesary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
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

