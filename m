Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0IBPrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:47:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64924 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab0IBPrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AjE8cr7NwF8H6fypF8tf/0eq1/kWl4/jJ1kAmSnWaU816NrWbanPhkmC+Nr05gsEPO
         q/nJti7jK1hKN0J+KhKguBxz0HqQMBsnA0i69w1uG5LPAj3uMvIDdWTCwqQ8W/Qe0HK8
         AV3GjhdkWYKTSgDEptfEEOUFfMG33WW0Mf6oo=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 04/24] ptrace: cleanup arch_ptrace() on x86
Date: Fri,  3 Sep 2010 00:46:11 +0900
Message-Id: <1283442391-23612-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove checking @addr less than 0 because @addr is now unsigned and
use new udescp variable in order to remove unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/ptrace.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 1a7ca04..6167a0c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -806,6 +806,7 @@ long arch_ptrace(struct task_struct *child, long request,
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
+	struct user_desc __user *udescp = (struct user_desc __user *)data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
@@ -813,8 +814,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		unsigned long tmp;
 
 		ret = -EIO;
-		if ((addr & (sizeof(data) - 1)) || addr < 0 ||
-		    addr >= sizeof(struct user))
+		if ((addr & (sizeof(data) - 1)) || addr >= sizeof(struct user))
 			break;
 
 		tmp = 0;  /* Default return condition */
@@ -831,8 +831,7 @@ long arch_ptrace(struct task_struct *child, long request,
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
-		if ((addr & (sizeof(data) - 1)) || addr < 0 ||
-		    addr >= sizeof(struct user))
+		if ((addr & (sizeof(data) - 1)) || addr >= sizeof(struct user))
 			break;
 
 		if (addr < sizeof(struct user_regs_struct))
@@ -891,15 +890,13 @@ long arch_ptrace(struct task_struct *child, long request,
 	case PTRACE_GET_THREAD_AREA:
 		if ((int) addr < 0)
 			return -EIO;
-		ret = do_get_thread_area(child, addr,
-					 (struct user_desc __user *) data);
+		ret = do_get_thread_area(child, addr, udescp);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
 		if ((int) addr < 0)
 			return -EIO;
-		ret = do_set_thread_area(child, addr,
-					 (struct user_desc __user *) data, 0);
+		ret = do_set_thread_area(child, addr, udescp, 0);
 		break;
 #endif
 
-- 
1.7.2.2

