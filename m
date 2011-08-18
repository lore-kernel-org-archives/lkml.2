Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1HRTCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:02:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44254 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1HRTCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:02:30 -0400
Date: Thu, 18 Aug 2011 20:02:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 21/91] um: Get rid of UPT_SET/UPT_REG macros
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7rJ-0007Yr-9Y@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the only users are arch getreg()/putreg() and it's easier to handle
it there instead of playing with macros from hell

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/ptrace-generic.h      |    3 -
 arch/um/sys-i386/ptrace.c                 |   69 ++++++++++++++++----
 arch/um/sys-i386/shared/sysdep/ptrace.h   |   53 ---------------
 arch/um/sys-x86_64/ptrace.c               |  103 ++++++++++++++++++++++++----
 arch/um/sys-x86_64/shared/sysdep/ptrace.h |   75 ---------------------
 5 files changed, 145 insertions(+), 158 deletions(-)

diff --git a/arch/um/include/asm/ptrace-generic.h b/arch/um/include/asm/ptrace-generic.h
index ae084ad..d7c94e4 100644
--- a/arch/um/include/asm/ptrace-generic.h
+++ b/arch/um/include/asm/ptrace-generic.h
@@ -23,9 +23,6 @@ struct pt_regs {
 #define PT_REGS_IP(r) UPT_IP(&(r)->regs)
 #define PT_REGS_SP(r) UPT_SP(&(r)->regs)
 
-#define PT_REG(r, reg) UPT_REG(&(r)->regs, reg)
-#define PT_REGS_SET(r, reg, val) UPT_SET(&(r)->regs, reg, val)
-
 #define PT_REGS_SET_SYSCALL_RETURN(r, res) \
 	UPT_SET_SYSCALL_RETURN(&(r)->regs, res)
 #define PT_REGS_RESTART_SYSCALL(r) UPT_RESTART_SYSCALL(&(r)->regs)
diff --git a/arch/um/sys-i386/ptrace.c b/arch/um/sys-i386/ptrace.c
index 49fd25a..7725fc7 100644
--- a/arch/um/sys-i386/ptrace.c
+++ b/arch/um/sys-i386/ptrace.c
@@ -50,20 +50,47 @@ int is_syscall(unsigned long addr)
 /* 1 = access 0 = no access */
 #define FLAG_MASK 0x00044dd5
 
+static const int reg_offsets[] = {
+	[EBX] = HOST_EBX,
+	[ECX] = HOST_ECX,
+	[EDX] = HOST_EDX,
+	[ESI] = HOST_ESI,
+	[EDI] = HOST_EDI,
+	[EBP] = HOST_EBP,
+	[EAX] = HOST_EAX,
+	[DS] = HOST_DS,
+	[ES] = HOST_ES,
+	[FS] = HOST_FS,
+	[GS] = HOST_GS,
+	[EIP] = HOST_IP,
+	[CS] = HOST_CS,
+	[EFL] = HOST_EFLAGS,
+	[UESP] = HOST_SP,
+	[SS] = HOST_SS,
+};
+
 int putreg(struct task_struct *child, int regno, unsigned long value)
 {
 	regno >>= 2;
 	switch (regno) {
+	case EBX:
+	case ECX:
+	case EDX:
+	case ESI:
+	case EDI:
+	case EBP:
+	case EAX:
+	case EIP:
+	case UESP:
+		break;
 	case FS:
 		if (value && (value & 3) != 3)
 			return -EIO;
-		PT_REGS_FS(&child->thread.regs) = value;
-		return 0;
+		break;
 	case GS:
 		if (value && (value & 3) != 3)
 			return -EIO;
-		PT_REGS_GS(&child->thread.regs) = value;
-		return 0;
+		break;
 	case DS:
 	case ES:
 		if (value && (value & 3) != 3)
@@ -78,10 +105,15 @@ int putreg(struct task_struct *child, int regno, unsigned long value)
 		break;
 	case EFL:
 		value &= FLAG_MASK;
-		value |= PT_REGS_EFLAGS(&child->thread.regs);
-		break;
+		child->thread.regs.regs.gp[HOST_EFLAGS] |= value;
+		return 0;
+	case ORIG_EAX:
+		child->thread.regs.regs.syscall = value;
+		return 0;
+	default :
+		panic("Bad register in putreg() : %d\n", regno);
 	}
-	PT_REGS_SET(&child->thread.regs, regno, value);
+	child->thread.regs.regs.gp[reg_offsets[regno]] = value;
 	return 0;
 }
 
@@ -106,22 +138,35 @@ int poke_user(struct task_struct *child, long addr, long data)
 
 unsigned long getreg(struct task_struct *child, int regno)
 {
-	unsigned long retval = ~0UL;
+	unsigned long mask = ~0UL;
 
 	regno >>= 2;
 	switch (regno) {
+	case ORIG_EAX:
+		return child->thread.regs.regs.syscall;
 	case FS:
 	case GS:
 	case DS:
 	case ES:
 	case SS:
 	case CS:
-		retval = 0xffff;
-		/* fall through */
+		mask = 0xffff;
+		break;
+	case EIP:
+	case UESP:
+	case EAX:
+	case EBX:
+	case ECX:
+	case EDX:
+	case ESI:
+	case EDI:
+	case EBP:
+	case EFL:
+		break;
 	default:
-		retval &= PT_REG(&child->thread.regs, regno);
+		panic("Bad register in getreg() : %d\n", regno);
 	}
-	return retval;
+	return mask & child->thread.regs.regs.gp[reg_offsets[regno]];
 }
 
 /* read the word at location addr in the USER area. */
diff --git a/arch/um/sys-i386/shared/sysdep/ptrace.h b/arch/um/sys-i386/shared/sysdep/ptrace.h
index e4c1593..8e721ed8 100644
--- a/arch/um/sys-i386/shared/sysdep/ptrace.h
+++ b/arch/um/sys-i386/shared/sysdep/ptrace.h
@@ -99,59 +99,6 @@ struct syscall_args {
 				     UPT_SYSCALL_ARG5(r),	\
 				     UPT_SYSCALL_ARG6(r) } } )
 
-#define UPT_REG(regs, reg) \
-	({	unsigned long val; \
-		switch(reg){ \
-		case EIP: val = UPT_IP(regs); break; \
-		case UESP: val = UPT_SP(regs); break; \
-		case EAX: val = UPT_EAX(regs); break; \
-		case EBX: val = UPT_EBX(regs); break; \
-		case ECX: val = UPT_ECX(regs); break; \
-		case EDX: val = UPT_EDX(regs); break; \
-		case ESI: val = UPT_ESI(regs); break; \
-		case EDI: val = UPT_EDI(regs); break; \
-		case EBP: val = UPT_EBP(regs); break; \
-		case ORIG_EAX: val = UPT_ORIG_EAX(regs); break; \
-		case CS: val = UPT_CS(regs); break; \
-		case SS: val = UPT_SS(regs); break; \
-		case DS: val = UPT_DS(regs); break; \
-		case ES: val = UPT_ES(regs); break; \
-		case FS: val = UPT_FS(regs); break; \
-		case GS: val = UPT_GS(regs); break; \
-		case EFL: val = UPT_EFLAGS(regs); break; \
-		default :  \
-			panic("Bad register in UPT_REG : %d\n", reg);  \
-			val = -1; \
-		} \
-	        val; \
-	})
-
-#define UPT_SET(regs, reg, val) \
-	do { \
-		switch(reg){ \
-		case EIP: UPT_IP(regs) = val; break; \
-		case UESP: UPT_SP(regs) = val; break; \
-		case EAX: UPT_EAX(regs) = val; break; \
-		case EBX: UPT_EBX(regs) = val; break; \
-		case ECX: UPT_ECX(regs) = val; break; \
-		case EDX: UPT_EDX(regs) = val; break; \
-		case ESI: UPT_ESI(regs) = val; break; \
-		case EDI: UPT_EDI(regs) = val; break; \
-		case EBP: UPT_EBP(regs) = val; break; \
-		case ORIG_EAX: UPT_ORIG_EAX(regs) = val; break; \
-		case CS: UPT_CS(regs) = val; break; \
-		case SS: UPT_SS(regs) = val; break; \
-		case DS: UPT_DS(regs) = val; break; \
-		case ES: UPT_ES(regs) = val; break; \
-		case FS: UPT_FS(regs) = val; break; \
-		case GS: UPT_GS(regs) = val; break; \
-		case EFL: UPT_EFLAGS(regs) = val; break; \
-		default :  \
-			panic("Bad register in UPT_SET : %d\n", reg);  \
-			break; \
-		} \
-	} while (0)
-
 #define UPT_SET_SYSCALL_RETURN(r, res) \
 	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
 
diff --git a/arch/um/sys-x86_64/ptrace.c b/arch/um/sys-x86_64/ptrace.c
index 7ed49ac..67fb771 100644
--- a/arch/um/sys-x86_64/ptrace.c
+++ b/arch/um/sys-x86_64/ptrace.c
@@ -18,10 +18,39 @@
  */
 #define FLAG_MASK 0x44dd5UL
 
-int putreg(struct task_struct *child, int regno, unsigned long value)
+static const int reg_offsets[] =
 {
-	unsigned long tmp;
+	[R8 >> 3] = HOST_R8,
+	[R9 >> 3] = HOST_R9,
+	[R10 >> 3] = HOST_R10,
+	[R11 >> 3] = HOST_R11,
+	[R12 >> 3] = HOST_R12,
+	[R13 >> 3] = HOST_R13,
+	[R14 >> 3] = HOST_R14,
+	[R15 >> 3] = HOST_R15,
+	[RIP >> 3] = HOST_IP,
+	[RSP >> 3] = HOST_SP,
+	[RAX >> 3] = HOST_RAX,
+	[RBX >> 3] = HOST_RBX,
+	[RCX >> 3] = HOST_RCX,
+	[RDX >> 3] = HOST_RDX,
+	[RSI >> 3] = HOST_RSI,
+	[RDI >> 3] = HOST_RDI,
+	[RBP >> 3] = HOST_RBP,
+	[CS >> 3] = HOST_CS,
+	[SS >> 3] = HOST_SS,
+	[FS_BASE >> 3] = HOST_FS_BASE,
+	[GS_BASE >> 3] = HOST_GS_BASE,
+	[DS >> 3] = HOST_DS,
+	[ES >> 3] = HOST_ES,
+	[FS >> 3] = HOST_FS,
+	[GS >> 3] = HOST_GS,
+	[EFLAGS >> 3] = HOST_EFLAGS,
+	[ORIG_RAX >> 3] = HOST_ORIG_RAX,
+};
 
+int putreg(struct task_struct *child, int regno, unsigned long value)
+{
 #ifdef TIF_IA32
 	/*
 	 * Some code in the 64bit emulation may not be 64bit clean.
@@ -31,6 +60,26 @@ int putreg(struct task_struct *child, int regno, unsigned long value)
 		value &= 0xffffffff;
 #endif
 	switch (regno) {
+	case R8:
+	case R9:
+	case R10:
+	case R11:
+	case R12:
+	case R13:
+	case R14:
+	case R15:
+	case RIP:
+	case RSP:
+	case RAX:
+	case RBX:
+	case RCX:
+	case RDX:
+	case RSI:
+	case RDI:
+	case RBP:
+	case ORIG_RAX:
+		break;
+
 	case FS:
 	case GS:
 	case DS:
@@ -50,12 +99,14 @@ int putreg(struct task_struct *child, int regno, unsigned long value)
 
 	case EFLAGS:
 		value &= FLAG_MASK;
-		tmp = PT_REGS_EFLAGS(&child->thread.regs) & ~FLAG_MASK;
-		value |= tmp;
-		break;
+		child->thread.regs.regs.gp[HOST_EFLAGS] |= value;
+		return 0;
+
+	default:
+		panic("Bad register in putreg(): %d\n", regno);
 	}
 
-	PT_REGS_SET(&child->thread.regs, regno, value);
+	child->thread.regs.regs.gp[reg_offsets[regno >> 3]] = value;
 	return 0;
 }
 
@@ -80,24 +131,46 @@ int poke_user(struct task_struct *child, long addr, long data)
 
 unsigned long getreg(struct task_struct *child, int regno)
 {
-	unsigned long retval = ~0UL;
+	unsigned long mask = ~0UL;
+#ifdef TIF_IA32
+	if (test_tsk_thread_flag(child, TIF_IA32))
+		mask = 0xffffffff;
+#endif
 	switch (regno) {
+	case R8:
+	case R9:
+	case R10:
+	case R11:
+	case R12:
+	case R13:
+	case R14:
+	case R15:
+	case RIP:
+	case RSP:
+	case RAX:
+	case RBX:
+	case RCX:
+	case RDX:
+	case RSI:
+	case RDI:
+	case RBP:
+	case ORIG_RAX:
+	case EFLAGS:
+	case FS_BASE:
+	case GS_BASE:
+		break;
 	case FS:
 	case GS:
 	case DS:
 	case ES:
 	case SS:
 	case CS:
-		retval = 0xffff;
-		/* fall through */
+		mask = 0xffff;
+		break;
 	default:
-		retval &= PT_REG(&child->thread.regs, regno);
-#ifdef TIF_IA32
-		if (test_tsk_thread_flag(child, TIF_IA32))
-			retval &= 0xffffffff;
-#endif
+		panic("Bad register in getreg: %d\n", regno);
 	}
-	return retval;
+	return mask & child->thread.regs.regs.gp[reg_offsets[regno >> 3]];
 }
 
 int peek_user(struct task_struct *child, long addr, long data)
diff --git a/arch/um/sys-x86_64/shared/sysdep/ptrace.h b/arch/um/sys-x86_64/shared/sysdep/ptrace.h
index 8d06d0a..2d4b223 100644
--- a/arch/um/sys-x86_64/shared/sysdep/ptrace.h
+++ b/arch/um/sys-x86_64/shared/sysdep/ptrace.h
@@ -146,81 +146,6 @@ struct syscall_args {
 				     UPT_SYSCALL_ARG5(r),	 \
 				     UPT_SYSCALL_ARG6(r) } } )
 
-#define UPT_REG(regs, reg) \
-	({      unsigned long val;		\
-		switch(reg){						\
-		case R8: val = UPT_R8(regs); break;			\
-		case R9: val = UPT_R9(regs); break;			\
-		case R10: val = UPT_R10(regs); break;			\
-		case R11: val = UPT_R11(regs); break;			\
-		case R12: val = UPT_R12(regs); break;			\
-		case R13: val = UPT_R13(regs); break;			\
-		case R14: val = UPT_R14(regs); break;			\
-		case R15: val = UPT_R15(regs); break;			\
-		case RIP: val = UPT_IP(regs); break;			\
-		case RSP: val = UPT_SP(regs); break;			\
-		case RAX: val = UPT_RAX(regs); break;			\
-		case RBX: val = UPT_RBX(regs); break;			\
-		case RCX: val = UPT_RCX(regs); break;			\
-		case RDX: val = UPT_RDX(regs); break;			\
-		case RSI: val = UPT_RSI(regs); break;			\
-		case RDI: val = UPT_RDI(regs); break;			\
-		case RBP: val = UPT_RBP(regs); break;			\
-		case ORIG_RAX: val = UPT_ORIG_RAX(regs); break;		\
-		case CS: val = UPT_CS(regs); break;			\
-		case SS: val = UPT_SS(regs); break;			\
-		case FS_BASE: val = UPT_FS_BASE(regs); break;		\
-		case GS_BASE: val = UPT_GS_BASE(regs); break;		\
-		case DS: val = UPT_DS(regs); break;			\
-		case ES: val = UPT_ES(regs); break;			\
-		case FS : val = UPT_FS (regs); break;			\
-		case GS: val = UPT_GS(regs); break;			\
-		case EFLAGS: val = UPT_EFLAGS(regs); break;		\
-		default :						\
-			panic("Bad register in UPT_REG : %d\n", reg);	\
-			val = -1;					\
-		}							\
-		val;							\
-	})
-
-
-#define UPT_SET(regs, reg, val) \
-	({      unsigned long __upt_val = val;	\
-		switch(reg){						\
-		case R8: UPT_R8(regs) = __upt_val; break;		\
-		case R9: UPT_R9(regs) = __upt_val; break;		\
-		case R10: UPT_R10(regs) = __upt_val; break;		\
-		case R11: UPT_R11(regs) = __upt_val; break;		\
-		case R12: UPT_R12(regs) = __upt_val; break;		\
-		case R13: UPT_R13(regs) = __upt_val; break;		\
-		case R14: UPT_R14(regs) = __upt_val; break;		\
-		case R15: UPT_R15(regs) = __upt_val; break;		\
-		case RIP: UPT_IP(regs) = __upt_val; break;		\
-		case RSP: UPT_SP(regs) = __upt_val; break;		\
-		case RAX: UPT_RAX(regs) = __upt_val; break;		\
-		case RBX: UPT_RBX(regs) = __upt_val; break;		\
-		case RCX: UPT_RCX(regs) = __upt_val; break;		\
-		case RDX: UPT_RDX(regs) = __upt_val; break;		\
-		case RSI: UPT_RSI(regs) = __upt_val; break;		\
-		case RDI: UPT_RDI(regs) = __upt_val; break;		\
-		case RBP: UPT_RBP(regs) = __upt_val; break;		\
-		case ORIG_RAX: UPT_ORIG_RAX(regs) = __upt_val; break;	\
-		case CS: UPT_CS(regs) = __upt_val; break;		\
-		case SS: UPT_SS(regs) = __upt_val; break;		\
-		case FS_BASE: UPT_FS_BASE(regs) = __upt_val; break;	\
-		case GS_BASE: UPT_GS_BASE(regs) = __upt_val; break;	\
-		case DS: UPT_DS(regs) = __upt_val; break;		\
-		case ES: UPT_ES(regs) = __upt_val; break;		\
-		case FS: UPT_FS(regs) = __upt_val; break;		\
-		case GS: UPT_GS(regs) = __upt_val; break;		\
-		case EFLAGS: UPT_EFLAGS(regs) = __upt_val; break;	\
-		default :						\
-			panic("Bad register in UPT_SET : %d\n", reg);	\
-			break;						\
-		}							\
-		__upt_val;						\
-	})
-
 #define UPT_SET_SYSCALL_RETURN(r, res) \
 	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
 
-- 
1.7.2.5


