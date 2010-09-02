Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab0IBPrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:47:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62983 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0IBPrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jhs5P/qZf4jngH13YtskO0dUsufVTpDU4TrCtT1ZXggMEjJrrQU3GUxfPZ4k7r39FL
         p/dN9qZSz3M8lE6mvQIKZipZJUEmX8J16VZ4fC1jMSn51/lqVk4SgdmQjOGAMzXpl64H
         s8zzwcZ/hpfRyucmMC8HMt+j8VWnjp2p9zG9c=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH v2 03/24] ptrace: change signature of arch_ptrace()
Date: Fri,  3 Sep 2010 00:46:10 +0900
Message-Id: <1283442391-23612-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the arguments to arch_ptrace() to take account of the fact that
@addr and @data are now unsigned long rather than long as of a preceding
patch in this series.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: linux-arch@vger.kernel.org
---
 arch/alpha/kernel/ptrace.c         |    7 ++++---
 arch/arm/kernel/ptrace.c           |    3 ++-
 arch/avr32/kernel/ptrace.c         |    3 ++-
 arch/blackfin/kernel/ptrace.c      |    3 ++-
 arch/cris/arch-v10/kernel/ptrace.c |    7 ++++---
 arch/cris/arch-v32/kernel/ptrace.c |    3 ++-
 arch/frv/kernel/ptrace.c           |    3 ++-
 arch/h8300/kernel/ptrace.c         |    7 ++++---
 arch/ia64/kernel/ptrace.c          |    3 ++-
 arch/m32r/kernel/ptrace.c          |    3 ++-
 arch/m68k/kernel/ptrace.c          |    9 +++++----
 arch/m68knommu/kernel/ptrace.c     |    9 +++++----
 arch/microblaze/kernel/ptrace.c    |    3 ++-
 arch/mips/kernel/ptrace.c          |    3 ++-
 arch/mn10300/kernel/ptrace.c       |    3 ++-
 arch/parisc/kernel/ptrace.c        |   11 ++++++-----
 arch/powerpc/kernel/ptrace.c       |   15 ++++++++-------
 arch/s390/kernel/ptrace.c          |    3 ++-
 arch/score/kernel/ptrace.c         |    3 ++-
 arch/sh/kernel/ptrace_32.c         |   25 +++++++++++++------------
 arch/sh/kernel/ptrace_64.c         |    6 ++++--
 arch/sparc/kernel/ptrace_32.c      |    3 ++-
 arch/sparc/kernel/ptrace_64.c      |    7 ++++---
 arch/tile/kernel/ptrace.c          |    7 ++++---
 arch/um/kernel/ptrace.c            |    5 +++--
 arch/um/sys-i386/ptrace.c          |    4 ++--
 arch/um/sys-x86_64/ptrace.c        |    4 ++--
 arch/x86/kernel/ptrace.c           |    7 ++++---
 arch/xtensa/kernel/ptrace.c        |    3 ++-
 include/linux/ptrace.h             |    3 ++-
 30 files changed, 102 insertions(+), 73 deletions(-)

diff --git a/arch/alpha/kernel/ptrace.c b/arch/alpha/kernel/ptrace.c
index baa9036..e2af5eb 100644
--- a/arch/alpha/kernel/ptrace.c
+++ b/arch/alpha/kernel/ptrace.c
@@ -269,7 +269,8 @@ void ptrace_disable(struct task_struct *child)
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	size_t copied;
@@ -292,7 +293,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_PEEKUSR:
 		force_successful_syscall_return();
 		ret = get_reg(child, addr);
-		DBG(DBG_MEM, ("peek $%ld->%#lx\n", addr, ret));
+		DBG(DBG_MEM, ("peek $%lu->%#lx\n", addr, ret));
 		break;
 
 	/* When I and D space are separate, this will have to be fixed.  */
@@ -302,7 +303,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	case PTRACE_POKEUSR: /* write the specified register */
-		DBG(DBG_MEM, ("poke $%ld<-%#lx\n", addr, data));
+		DBG(DBG_MEM, ("poke $%lu<-%#lx\n", addr, data));
 		ret = put_reg(child, addr, data);
 		break;
 	default:
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index f99d489..87ca2c7 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -847,7 +847,8 @@ static int ptrace_setvfpregs(struct task_struct *tsk, void __user *data)
 }
 #endif
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
diff --git a/arch/avr32/kernel/ptrace.c b/arch/avr32/kernel/ptrace.c
index 5e73c25..ecea9b6 100644
--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -146,7 +146,8 @@ static int ptrace_setregs(struct task_struct *tsk, const void __user *uregs)
 	return ret;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 6ec7768..fb81620 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -232,7 +232,8 @@ void user_disable_single_step(struct task_struct *child)
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
diff --git a/arch/cris/arch-v10/kernel/ptrace.c b/arch/cris/arch-v10/kernel/ptrace.c
index e70c804..d411e02 100644
--- a/arch/cris/arch-v10/kernel/ptrace.c
+++ b/arch/cris/arch-v10/kernel/ptrace.c
@@ -76,7 +76,8 @@ ptrace_disable(struct task_struct *child)
  * (in user space) where the result of the ptrace call is written (instead of
  * being returned).
  */
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -141,7 +142,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					break;
 				}
 				
-				data += sizeof(long);
+				data += sizeof(unsigned long);
 			}
 
 			break;
@@ -165,7 +166,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				}
 				
 				put_reg(child, i, tmp);
-				data += sizeof(long);
+				data += sizeof(unsigned long);
 			}
 			
 			break;
diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index f4ebd1e..3e058a1 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -126,7 +126,8 @@ ptrace_disable(struct task_struct *child)
 }
 
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index fac0289..e9dbfad 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -254,7 +254,8 @@ void ptrace_disable(struct task_struct *child)
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	int ret;
diff --git a/arch/h8300/kernel/ptrace.c b/arch/h8300/kernel/ptrace.c
index df11412..ef1aa0b 100644
--- a/arch/h8300/kernel/ptrace.c
+++ b/arch/h8300/kernel/ptrace.c
@@ -50,7 +50,8 @@ void ptrace_disable(struct task_struct *child)
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
@@ -120,7 +121,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				ret = -EFAULT;
 				break;
 			    }
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
@@ -135,7 +136,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				break;
 			    }
 			    h8300_put_reg(child, i, tmp);
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
index 7c7909f..8848f43 100644
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -1177,7 +1177,8 @@ ptrace_disable (struct task_struct *child)
 }
 
 long
-arch_ptrace (struct task_struct *child, long request, long addr, long data)
+arch_ptrace (struct task_struct *child, long request,
+	     unsigned long addr, unsigned long data)
 {
 	switch (request) {
 	case PTRACE_PEEKTEXT:
diff --git a/arch/m32r/kernel/ptrace.c b/arch/m32r/kernel/ptrace.c
index e555091..69bbf7a 100644
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -621,7 +621,8 @@ void ptrace_disable(struct task_struct *child)
 }
 
 long
-arch_ptrace(struct task_struct *child, long request, long addr, long data)
+arch_ptrace(struct task_struct *child, long request,
+	    unsigned long addr, unsigned long data)
 {
 	int ret;
 
diff --git a/arch/m68k/kernel/ptrace.c b/arch/m68k/kernel/ptrace.c
index 616e597..583f59f 100644
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -156,7 +156,8 @@ void user_disable_single_step(struct task_struct *child)
 	singlestep_disable(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	int i, ret = 0;
@@ -200,7 +201,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			 * into internal fpu reg representation
 			 */
 			if (FPU_IS_EMU && (addr < 45) && !(addr % 3)) {
-				data = (unsigned long)data << 15;
+				data <<= 15;
 				data = (data & 0xffff0000) |
 				       ((data & 0x0000ffff) >> 1);
 			}
@@ -215,7 +216,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			ret = put_user(tmp, (unsigned long *)data);
 			if (ret)
 				break;
-			data += sizeof(long);
+			data += sizeof(unsigned long);
 		}
 		break;
 
@@ -229,7 +230,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				tmp |= get_reg(child, PT_SR) & ~SR_MASK;
 			}
 			put_reg(child, i, tmp);
-			data += sizeof(long);
+			data += sizeof(unsigned long);
 		}
 		break;
 
diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
index f6be124..4ab9448 100644
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
 
@@ -180,7 +181,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				 * into internal fpu reg representation
 				 */
 				if (FPU_IS_EMU && (addr < 45) && !(addr % 3)) {
-					data = (unsigned long)data << 15;
+					data <<= 15;
 					data = (data & 0xffff0000) |
 					       ((data & 0x0000ffff) >> 1);
 				}
@@ -201,7 +202,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				ret = -EFAULT;
 				break;
 			    }
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
@@ -221,7 +222,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				tmp |= get_reg(child, PT_SR) & ~(SR_MASK << 16);
 			    }
 			    put_reg(child, i, tmp);
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
index dc03ffc..3544bc1 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -73,7 +73,8 @@ static microblaze_reg_t *reg_save_addr(unsigned reg_offs,
 	return (microblaze_reg_t *)((char *)regs + reg_offs);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int rval;
 	unsigned long val = 0;
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index c51b95f..26c29dd 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -255,7 +255,8 @@ int ptrace_set_watch_regs(struct task_struct *child,
 	return 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
diff --git a/arch/mn10300/kernel/ptrace.c b/arch/mn10300/kernel/ptrace.c
index cf847da..ec4b414 100644
--- a/arch/mn10300/kernel/ptrace.c
+++ b/arch/mn10300/kernel/ptrace.c
@@ -295,7 +295,8 @@ void ptrace_disable(struct task_struct *child)
 /*
  * handle the arch-specific side of process tracing
  */
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	int ret;
diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index c4f49e4..03920db 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -110,7 +110,8 @@ void user_enable_block_step(struct task_struct *task)
 	pa_psw(task)->l = 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	long ret = -EIO;
@@ -120,8 +121,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* Read the word at location addr in the USER area.  For ptraced
 	   processes, the kernel saves all regs on a syscall. */
 	case PTRACE_PEEKUSR:
-		if ((addr & (sizeof(long)-1)) ||
-		    (unsigned long) addr >= sizeof(struct pt_regs))
+		if ((addr & (sizeof(unsigned long)-1)) ||
+		     addr >= sizeof(struct pt_regs))
 			break;
 		tmp = *(unsigned long *) ((char *) task_regs(child) + addr);
 		ret = put_user(tmp, (unsigned long *) data);
@@ -151,8 +152,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			break;
 		}
 
-		if ((addr & (sizeof(long)-1)) ||
-		    (unsigned long) addr >= sizeof(struct pt_regs))
+		if ((addr & (sizeof(unsigned long)-1)) ||
+		     addr >= sizeof(struct pt_regs))
 			break;
 		if ((addr >= PT_GR1 && addr <= PT_GR31) ||
 				addr == PT_IAOQ0 || addr == PT_IAOQ1 ||
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 11f3cd9..e4b6d75 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1406,8 +1406,8 @@ static long ppc_del_hwdebug(struct task_struct *child, long addr, long data)
  * Here are the old "legacy" powerpc specific getregs/setregs ptrace calls,
  * we mark them as obsolete now, they will be removed in a future version
  */
-static long arch_ptrace_old(struct task_struct *child, long request, long addr,
-			    long data)
+static long arch_ptrace_old(struct task_struct *child, long request,
+			    unsigned long addr, unsigned long data)
 {
 	switch (request) {
 	case PPC_PTRACE_GETREGS:	/* Get GPRs 0 - 31. */
@@ -1434,7 +1434,8 @@ static long arch_ptrace_old(struct task_struct *child, long request, long addr,
 	return -EPERM;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret = -EPERM;
 
@@ -1446,11 +1447,11 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = -EIO;
 		/* convert to index and check */
 #ifdef CONFIG_PPC32
-		index = (unsigned long) addr >> 2;
+		index = addr >> 2;
 		if ((addr & 3) || (index > PT_FPSCR)
 		    || (child->thread.regs == NULL))
 #else
-		index = (unsigned long) addr >> 3;
+		index = addr >> 3;
 		if ((addr & 7) || (index > PT_FPSCR))
 #endif
 			break;
@@ -1474,11 +1475,11 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = -EIO;
 		/* convert to index and check */
 #ifdef CONFIG_PPC32
-		index = (unsigned long) addr >> 2;
+		index = addr >> 2;
 		if ((addr & 3) || (index > PT_FPSCR)
 		    || (child->thread.regs == NULL))
 #else
-		index = (unsigned long) addr >> 3;
+		index = addr >> 3;
 		if ((addr & 7) || (index > PT_FPSCR))
 #endif
 			break;
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 83339d3..019bb71 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -343,7 +343,8 @@ poke_user(struct task_struct *child, addr_t addr, addr_t data)
 	return __poke_user(child, addr, data);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	ptrace_area parea; 
 	int copied, ret;
diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
index 174c642..894dcbf 100644
--- a/arch/score/kernel/ptrace.c
+++ b/arch/score/kernel/ptrace.c
@@ -325,7 +325,8 @@ void ptrace_disable(struct task_struct *child)
 }
 
 long
-arch_ptrace(struct task_struct *child, long request, long addr, long data)
+arch_ptrace(struct task_struct *child, long request,
+	    unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (void __user *)data;
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 6c4bbba..7464607 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -338,7 +338,8 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 	return &user_sh_native_view;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	struct user * dummy = NULL;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -356,17 +357,17 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 		if (addr < sizeof(struct pt_regs))
 			tmp = get_stack_long(child, addr);
-		else if (addr >= (long) &dummy->fpu &&
-			 addr < (long) &dummy->u_fpvalid) {
+		else if (addr >= (unsigned long) &dummy->fpu &&
+			 addr < (unsigned long) &dummy->u_fpvalid) {
 			if (!tsk_used_math(child)) {
-				if (addr == (long)&dummy->fpu.fpscr)
+				if (addr == (unsigned long)&dummy->fpu.fpscr)
 					tmp = FPSCR_INIT;
 				else
 					tmp = 0;
 			} else
-				tmp = ((long *)child->thread.xstate)
-					[(addr - (long)&dummy->fpu) >> 2];
-		} else if (addr == (long) &dummy->u_fpvalid)
+				tmp = ((unsigned long *)child->thread.xstate)
+					[(addr - (unsigned long)&dummy->fpu) >> 2];
+		} else if (addr == (unsigned long) &dummy->u_fpvalid)
 			tmp = !!tsk_used_math(child);
 		else if (addr == PT_TEXT_ADDR)
 			tmp = child->mm->start_code;
@@ -390,13 +391,13 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 		if (addr < sizeof(struct pt_regs))
 			ret = put_stack_long(child, addr, data);
-		else if (addr >= (long) &dummy->fpu &&
-			 addr < (long) &dummy->u_fpvalid) {
+		else if (addr >= (unsigned long) &dummy->fpu &&
+			 addr < (unsigned long) &dummy->u_fpvalid) {
 			set_stopped_child_used_math(child);
-			((long *)child->thread.xstate)
-				[(addr - (long)&dummy->fpu) >> 2] = data;
+			((unsigned long *)child->thread.xstate)
+				[(addr - (unsigned long)&dummy->fpu) >> 2] = data;
 			ret = 0;
-		} else if (addr == (long) &dummy->u_fpvalid) {
+		} else if (addr == (unsigned long) &dummy->u_fpvalid) {
 			conditional_stopped_child_used_math(data, child);
 			ret = 0;
 		}
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index 5fd644d..1367134 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -304,7 +304,8 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 	return &user_sh64_native_view;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
@@ -392,7 +393,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	return ret;
 }
 
-asmlinkage int sh64_ptrace(long request, long pid, long addr, long data)
+asmlinkage int sh64_ptrace(long request, long pid,
+			   unsigned long addr, unsigned long data)
 {
 #define WPC_DBRMODE 0x0d104008
 	static int first_call = 1;
diff --git a/arch/sparc/kernel/ptrace_32.c b/arch/sparc/kernel/ptrace_32.c
index e608f39..e08ba4a 100644
--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -323,7 +323,8 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 	return &user_sparc32_view;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long addr2 = current->thread.kregs->u_regs[UREG_I4];
 	const struct user_regset_view *view;
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index aa90da0..d9db5a4 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -969,7 +969,8 @@ struct fps {
 	unsigned long fsr;
 };
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	const struct user_regset_view *view = task_user_regset_view(current);
 	unsigned long addr2 = task_pt_regs(current)->u_regs[UREG_I4];
@@ -977,8 +978,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	struct fps __user *fps;
 	int ret;
 
-	pregs = (struct pt_regs __user *) (unsigned long) addr;
-	fps = (struct fps __user *) (unsigned long) addr;
+	pregs = (struct pt_regs __user *) addr;
+	fps = (struct fps __user *) addr;
 
 	switch (request) {
 	case PTRACE_PEEKUSR:
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 7161bd0..aed9256 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -64,7 +64,8 @@ void ptrace_disable(struct task_struct *child)
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long __user *datap;
 	unsigned long tmp;
@@ -102,7 +103,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_GETREGS:  /* Get all registers from the child. */
 		if (!access_ok(VERIFY_WRITE, datap, PTREGS_SIZE))
 			break;
-		for (i = 0; i < PTREGS_SIZE; i += sizeof(long)) {
+		for (i = 0; i < PTREGS_SIZE; i += sizeof(unsigned long)) {
 			ret = __put_user(getreg(child, i), datap);
 			if (ret != 0)
 				break;
@@ -113,7 +114,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_SETREGS:  /* Set all registers in the child. */
 		if (!access_ok(VERIFY_READ, datap, PTREGS_SIZE))
 			break;
-		for (i = 0; i < PTREGS_SIZE; i += sizeof(long)) {
+		for (i = 0; i < PTREGS_SIZE; i += sizeof(unsigned long)) {
 			ret = __get_user(tmp, datap);
 			if (ret != 0)
 				break;
diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index e051049..963d82b 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -42,10 +42,11 @@ void ptrace_disable(struct task_struct *child)
 extern int peek_user(struct task_struct * child, long addr, long data);
 extern int poke_user(struct task_struct * child, long addr, long data);
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int i, ret;
-	unsigned long __user *p = (void __user *)(unsigned long)data;
+	unsigned long __user *p = (void __user *)data;
 
 	switch (request) {
 	/* read word at location addr. */
diff --git a/arch/um/sys-i386/ptrace.c b/arch/um/sys-i386/ptrace.c
index c9b1765..d23b2d3 100644
--- a/arch/um/sys-i386/ptrace.c
+++ b/arch/um/sys-i386/ptrace.c
@@ -203,8 +203,8 @@ int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 				     (unsigned long *) &fpregs);
 }
 
-long subarch_ptrace(struct task_struct *child, long request, long addr,
-		    long data)
+long subarch_ptrace(struct task_struct *child, long request,
+		    unsigned long addr, unsigned long data)
 {
 	return -EIO;
 }
diff --git a/arch/um/sys-x86_64/ptrace.c b/arch/um/sys-x86_64/ptrace.c
index f3458d7..67e6368 100644
--- a/arch/um/sys-x86_64/ptrace.c
+++ b/arch/um/sys-x86_64/ptrace.c
@@ -175,8 +175,8 @@ int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 	return restore_fp_registers(userspace_pid[cpu], fpregs);
 }
 
-long subarch_ptrace(struct task_struct *child, long request, long addr,
-		    long data)
+long subarch_ptrace(struct task_struct *child, long request,
+		    unsigned long addr, unsigned long data)
 {
 	int ret = -EIO;
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 70c4872..1a7ca04 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -801,7 +801,8 @@ void ptrace_disable(struct task_struct *child)
 static const struct user_regset_view user_x86_32_view; /* Initialized below. */
 #endif
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -888,14 +889,14 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
 	case PTRACE_GET_THREAD_AREA:
-		if (addr < 0)
+		if ((int) addr < 0)
 			return -EIO;
 		ret = do_get_thread_area(child, addr,
 					 (struct user_desc __user *) data);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
-		if (addr < 0)
+		if ((int) addr < 0)
 			return -EIO;
 		ret = do_set_thread_area(child, addr,
 					 (struct user_desc __user *) data, 0);
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 9d4e1ce..af9ba80 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -256,7 +256,8 @@ int ptrace_pokeusr(struct task_struct *child, long regno, long val)
 	return 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret = -EPERM;
 
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 67a4cd7..092a04f 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -100,7 +100,8 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 
-extern long arch_ptrace(struct task_struct *child, long request, long addr, long data);
+extern long arch_ptrace(struct task_struct *child, long request,
+			unsigned long addr, unsigned long data);
 extern int ptrace_traceme(void);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
-- 
1.7.2.2

