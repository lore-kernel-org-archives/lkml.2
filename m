Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0H0JtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:49:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab0H0Jnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nZ2PcSFzPO7EuG5mSGlYwKJ7Iax97LsNuHLGCzVqCLpnQJ1J8VBzhnCtk2OFqlSXh3
         NdvKxj0muey1ME/BA3YQ4DeZ96briwAe/B7YyXO3Hd2DvP2WmeB+H2C8kZLMRfrWOz/k
         w2nHhiwEQ5UFgL99UAmKOYRwl3eo2O8zDGuBc=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [RFC PATCH 17/43] ptrace, h8300: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:03 +0900
Message-Id: <1282902149-12991-18-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new regno, datap variables in order to remove duplicated expressions and
unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/kernel/ptrace.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/h8300/kernel/ptrace.c b/arch/h8300/kernel/ptrace.c
index 23a95f84..00ddc9c 100644
--- a/arch/h8300/kernel/ptrace.c
+++ b/arch/h8300/kernel/ptrace.c
@@ -54,6 +54,8 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	int regno = addr >> 2; /* temporary hack. */
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
@@ -66,12 +68,11 @@ long arch_ptrace(struct task_struct *child, long request,
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
@@ -89,7 +90,7 @@ long arch_ptrace(struct task_struct *child, long request,
 				}
 			}
 			if (!ret)
-				ret = put_user(tmp,(unsigned long *) data);
+				ret = put_user(tmp, datap);
 			break ;
 		}
 
@@ -99,14 +100,13 @@ long arch_ptrace(struct task_struct *child, long request,
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

