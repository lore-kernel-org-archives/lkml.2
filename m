Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab0I3J2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:28:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32949 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab0I3J2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T2/VJSXF44BKKnR5U8EK7HnBm3pv+pr8adnEzu4feyQkO52nHp12ttwEKCNbaH16Vf
         Mx16dP7stax/yrlFwtLft8sIHdIkvUcDAV1wn/335xB8772O1rLKFlCQxjJpEA5Ylhhv
         C5VnMw9dhkhJSahLtVqWtMD4a55xP7GLTQKmc=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RESEND v3 04/24] ptrace: cleanup arch_ptrace() on x86
Date: Thu, 30 Sep 2010 18:27:39 +0900
Message-Id: <1285838880-4977-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
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

