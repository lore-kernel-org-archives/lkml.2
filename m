Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0IBPrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:47:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64003 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab0IBPre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=R9Zrviz+2fHuHSZ/w215cnysqad9kKxX4WgchBR+qPhKWXNRiB2FT2pX8/s0YhZZjE
         yLHPVTJijd5vqnrknZ45eCI6er0R7SUWLDw6mIKBjBpaixKNlMeCm0OjIdp7wZtzKxt2
         Ue66QdoS57emU6E/Lyb/IZSJLw91PzhnCbqIc=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH v2 08/24] ptrace: cleanup arch_ptrace() on cris
Date: Fri,  3 Sep 2010 00:46:15 +0900
Message-Id: <1283442391-23612-9-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'regno' variable in order to remove redandunt expression and
remove checking @addr less than 0 because @addr is now unsigned.
Also update 'datap' on PTRACE_GET/SETREGS to fix a bug on arch-v10.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/kernel/ptrace.c |   17 ++++++++---------
 arch/cris/arch-v32/kernel/ptrace.c |   13 ++++++-------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/ptrace.c b/arch/cris/arch-v10/kernel/ptrace.c
index d411e02..320065f 100644
--- a/arch/cris/arch-v10/kernel/ptrace.c
+++ b/arch/cris/arch-v10/kernel/ptrace.c
@@ -80,6 +80,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned int regno = addr >> 2;
 	unsigned long __user *datap = (unsigned long __user *)data;
 
 	switch (request) {
@@ -94,10 +95,10 @@ long arch_ptrace(struct task_struct *child, long request,
 			unsigned long tmp;
 
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			tmp = get_reg(child, addr >> 2);
+			tmp = get_reg(child, regno);
 			ret = put_user(tmp, datap);
 			break;
 		}
@@ -111,19 +112,17 @@ long arch_ptrace(struct task_struct *child, long request,
  		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			addr >>= 2;
-
-			if (addr == PT_DCCR) {
+			if (regno == PT_DCCR) {
 				/* don't allow the tracing process to change stuff like
 				 * interrupt enable, kernel/user bit, dma enables etc.
 				 */
 				data &= DCCR_MASK;
 				data |= get_reg(child, PT_DCCR) & ~DCCR_MASK;
 			}
-			if (put_reg(child, addr, data))
+			if (put_reg(child, regno, data))
 				break;
 			ret = 0;
 			break;
@@ -142,7 +141,7 @@ long arch_ptrace(struct task_struct *child, long request,
 					break;
 				}
 				
-				data += sizeof(unsigned long);
+				datap++;
 			}
 
 			break;
@@ -166,7 +165,7 @@ long arch_ptrace(struct task_struct *child, long request,
 				}
 				
 				put_reg(child, i, tmp);
-				data += sizeof(unsigned long);
+				datap++;
 			}
 			
 			break;
diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index 3e058a1..511ece9 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -130,6 +130,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned int regno = addr >> 2;
 	unsigned long __user *datap = (unsigned long __user *)data;
 
 	switch (request) {
@@ -164,10 +165,10 @@ long arch_ptrace(struct task_struct *child, long request,
 			unsigned long tmp;
 
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			tmp = get_reg(child, addr >> 2);
+			tmp = get_reg(child, regno);
 			ret = put_user(tmp, datap);
 			break;
 		}
@@ -181,19 +182,17 @@ long arch_ptrace(struct task_struct *child, long request,
 		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			addr >>= 2;
-
-			if (addr == PT_CCS) {
+			if (regno == PT_CCS) {
 				/* don't allow the tracing process to change stuff like
 				 * interrupt enable, kernel/user bit, dma enables etc.
 				 */
 				data &= CCS_MASK;
 				data |= get_reg(child, PT_CCS) & ~CCS_MASK;
 			}
-			if (put_reg(child, addr, data))
+			if (put_reg(child, regno, data))
 				break;
 			ret = 0;
 			break;
-- 
1.7.2.2

