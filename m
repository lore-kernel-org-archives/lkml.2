Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0IBPrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:47:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53807 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab0IBPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sEypbEDptruVwk5M9YC3D+NreMuHioB6N7pnLhpaSbMF5VC5HVF412A7q7OpFw+9Fr
         N8/2YvyrraqCVYk8FpmeJzhOidLttw39Pbj6OenWy07fc8qTGTYRdljvbvAH8plyLMiU
         Jl0d5Yp90/sZVBfM5BXjCimTApsO2DKjJ2AXU=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH v2 10/24] ptrace: cleanup arch_ptrace() on h8300
Date: Fri,  3 Sep 2010 00:46:17 +0900
Message-Id: <1283442391-23612-11-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'regno', 'datap' variables in order to remove duplicated
expressions and unnecessary castings. Alse remove checking @addr
less than 0 because addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/kernel/ptrace.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/h8300/kernel/ptrace.c b/arch/h8300/kernel/ptrace.c
index ef1aa0b..7388697 100644
--- a/arch/h8300/kernel/ptrace.c
+++ b/arch/h8300/kernel/ptrace.c
@@ -54,24 +54,25 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	int regno = addr >> 2;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
 		case PTRACE_PEEKUSR: {
 			unsigned long tmp = 0;
 			
-			if ((addr & 3) || addr < 0 || addr >= sizeof(struct user)) {
+			if ((addr & 3) || addr >= sizeof(struct user)) {
 				ret = -EIO;
 				break ;
 			}
 			
 		        ret = 0;  /* Default return condition */
-			addr = addr >> 2; /* temporary hack. */
 
-			if (addr < H8300_REGS_NO)
-				tmp = h8300_get_reg(child, addr);
+			if (regno < H8300_REGS_NO)
+				tmp = h8300_get_reg(child, regno);
 			else {
-				switch(addr) {
+				switch(regno) {
 				case 49:
 					tmp = child->mm->start_code;
 					break ;
@@ -89,24 +90,23 @@ long arch_ptrace(struct task_struct *child, long request,
 				}
 			}
 			if (!ret)
-				ret = put_user(tmp,(unsigned long *) data);
+				ret = put_user(tmp, datap);
 			break ;
 		}
 
       /* when I and D space are separate, this will have to be fixed. */
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
-			if ((addr & 3) || addr < 0 || addr >= sizeof(struct user)) {
+			if ((addr & 3) || addr >= sizeof(struct user)) {
 				ret = -EIO;
 				break ;
 			}
-			addr = addr >> 2; /* temporary hack. */
 			    
-			if (addr == PT_ORIG_ER0) {
+			if (regno == PT_ORIG_ER0) {
 				ret = -EIO;
 				break ;
 			}
-			if (addr < H8300_REGS_NO) {
-				ret = h8300_put_reg(child, addr, data);
+			if (regno < H8300_REGS_NO) {
+				ret = h8300_put_reg(child, regno, data);
 				break ;
 			}
 			ret = -EIO;
@@ -117,11 +117,11 @@ long arch_ptrace(struct task_struct *child, long request,
 			unsigned long tmp;
 			for (i = 0; i < H8300_REGS_NO; i++) {
 			    tmp = h8300_get_reg(child, i);
-			    if (put_user(tmp, (unsigned long *) data)) {
+			    if (put_user(tmp, datap)) {
 				ret = -EFAULT;
 				break;
 			    }
-			    data += sizeof(unsigned long);
+			    datap++;
 			}
 			ret = 0;
 			break;
@@ -131,12 +131,12 @@ long arch_ptrace(struct task_struct *child, long request,
 			int i;
 			unsigned long tmp;
 			for (i = 0; i < H8300_REGS_NO; i++) {
-			    if (get_user(tmp, (unsigned long *) data)) {
+			    if (get_user(tmp, datap)) {
 				ret = -EFAULT;
 				break;
 			    }
 			    h8300_put_reg(child, i, tmp);
-			    data += sizeof(unsigned long);
+			    datap++;
 			}
 			ret = 0;
 			break;
-- 
1.7.2.2

