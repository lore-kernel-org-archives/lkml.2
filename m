Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0H0JoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:44:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57960 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0H0JoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=n/q/yH5Za0q6JJGvJs7zqwbnQF/ijo8ue7djJBb2EGcXJWpw27P0R/kRzdpSKPeULq
         4c3ea0+6GIAZRBUoGZrj5MZ+ajl4wbETGpjUapxbplnn9BDF6Jk7C8Yn8B8tNmMFcVSt
         UdwNYP/7CL5t2bhtUwE48eeT+y4b9P2chUAc0=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Subject: [RFC PATCH 23/43] ptrace, m68knommu: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:09 +0900
Message-Id: <1282902149-12991-24-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68knommu/kernel/ptrace.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
index f6be124..835a3ed 100644
--- a/arch/m68knommu/kernel/ptrace.c
+++ b/arch/m68knommu/kernel/ptrace.c
@@ -111,7 +111,8 @@ void ptrace_disable(struct task_struct *child)
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
@@ -121,8 +122,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			unsigned long tmp;
 			
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 ||
-			    addr > sizeof(struct user) - 3)
+			if ((addr & 3) || addr > sizeof(struct user) - 3)
 				break;
 			
 			tmp = 0;  /* Default return condition */
@@ -156,8 +156,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 ||
-			    addr > sizeof(struct user) - 3)
+			if ((addr & 3) || addr > sizeof(struct user) - 3)
 				break;
 
 			addr = addr >> 2; /* temporary hack. */
@@ -180,7 +179,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				 * into internal fpu reg representation
 				 */
 				if (FPU_IS_EMU && (addr < 45) && !(addr % 3)) {
-					data = (unsigned long)data << 15;
+					data <<= 15;
 					data = (data & 0xffff0000) |
 					       ((data & 0x0000ffff) >> 1);
 				}
@@ -201,7 +200,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				ret = -EFAULT;
 				break;
 			    }
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
@@ -221,7 +220,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				tmp |= get_reg(child, PT_SR) & ~(SR_MASK << 16);
 			    }
 			    put_reg(child, i, tmp);
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
-- 
1.7.2.2

