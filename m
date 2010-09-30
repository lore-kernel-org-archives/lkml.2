Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0I3J2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:28:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32949 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0I3J2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hSHmqA/EE/QMUjqlY0liM9z2hVNe19sBBH0J58sbhwa0RjldwdOIRH3ETvoDBzOX/K
         m93YyPfMOadtCLAzoX4gBBSxBOBdh1SWqKyG0PO2Zk/BaBuS4vZGobUYTaEi19Trmnq6
         PRp82HKXO4/uSNr7yXor2CGxcN77xbl8cB6P0=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH RESEND v3 09/24] ptrace: cleanup arch_ptrace() on frv
Date: Thu, 30 Sep 2010 18:27:44 +0900
Message-Id: <1285838880-4977-10-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'regno', 'datap' variables in order to remove duplicated
expressions and unnecessary castings. Alse remove checking @addr
less than 0 because addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/kernel/ptrace.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index e9dbfad..9d68f7f 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -259,19 +259,21 @@ long arch_ptrace(struct task_struct *child, long request,
 {
 	unsigned long tmp;
 	int ret;
+	int regno = addr >> 2;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 		/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
 		tmp = 0;
 		ret = -EIO;
-		if ((addr & 3) || addr < 0)
+		if (addr & 3)
 			break;
 
 		ret = 0;
-		switch (addr >> 2) {
+		switch (regno) {
 		case 0 ... PT__END - 1:
-			tmp = get_reg(child, addr >> 2);
+			tmp = get_reg(child, regno);
 			break;
 
 		case PT__END + 0:
@@ -300,23 +302,18 @@ long arch_ptrace(struct task_struct *child, long request,
 		}
 
 		if (ret == 0)
-			ret = put_user(tmp, (unsigned long *) data);
+			ret = put_user(tmp, datap);
 		break;
 	}
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
-		if ((addr & 3) || addr < 0)
+		if (addr & 3)
 			break;
 
-		ret = 0;
-		switch (addr >> 2) {
+		switch (regno) {
 		case 0 ... PT__END - 1:
-			ret = put_reg(child, addr >> 2, data);
-			break;
-
-		default:
-			ret = -EIO;
+			ret = put_reg(child, regno, data);
 			break;
 		}
 		break;
@@ -325,25 +322,25 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_to_user(child, &user_frv_native_view,
 					   REGSET_GENERAL,
 					   0, sizeof(child->thread.user->i),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETREGS:	/* Set all integer regs in the child. */
 		return copy_regset_from_user(child, &user_frv_native_view,
 					     REGSET_GENERAL,
 					     0, sizeof(child->thread.user->i),
-					     (const void __user *)data);
+					     datap);
 
 	case PTRACE_GETFPREGS:	/* Get the child FP/Media state. */
 		return copy_regset_to_user(child, &user_frv_native_view,
 					   REGSET_FPMEDIA,
 					   0, sizeof(child->thread.user->f),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETFPREGS:	/* Set the child FP/Media state. */
 		return copy_regset_from_user(child, &user_frv_native_view,
 					     REGSET_FPMEDIA,
 					     0, sizeof(child->thread.user->f),
-					     (const void __user *)data);
+					     datap);
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
-- 
1.7.2.2

