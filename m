Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0H0Juu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:50:50 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42732 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab0H0JnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xZA1rgqYgMkXiMVeJSGoL5g6tNeSekdZdYeDpNM6+scSmh4YBiwgH4s03BjO+1VxJm
         jWNg+wx1npKZ7Ba2z/J5KAakA12efVkC8xd/jB4V6qocatWyWuNLDijsLqN5XYX4AjNJ
         tOKbZwWVPX0CBjnNaKfAJyP+LBrtu24ZOHp1Y=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 05/43] ptrace, x86: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:41:51 +0900
Message-Id: <1282902149-12991-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of 'datap' variable into void pointer in order to remove
unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/ptrace.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index ea7766a..29c17610 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -805,7 +805,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
-	unsigned long __user *datap = (unsigned long __user *)data;
+	void __user *datap = (void __user *)data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
@@ -824,7 +824,7 @@ long arch_ptrace(struct task_struct *child, long request,
 			addr -= offsetof(struct user, u_debugreg[0]);
 			tmp = ptrace_get_debugreg(child, addr / sizeof(data));
 		}
-		ret = put_user(tmp, datap);
+		ret = copy_to_user(datap, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 		break;
 	}
 
@@ -889,15 +889,13 @@ long arch_ptrace(struct task_struct *child, long request,
 	case PTRACE_GET_THREAD_AREA:
 		if ((int) addr < 0)
 			return -EIO;
-		ret = do_get_thread_area(child, addr,
-					 (struct user_desc __user *) data);
+		ret = do_get_thread_area(child, addr, datap);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
 		if ((int) addr < 0)
 			return -EIO;
-		ret = do_set_thread_area(child, addr,
-					 (struct user_desc __user *) data, 0);
+		ret = do_set_thread_area(child, addr, datap, 0);
 		break;
 #endif
 
-- 
1.7.2.2

