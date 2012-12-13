Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab2LMOGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:06:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44375 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab2LMOGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 087/241] s390/signal: set correct address space control
Date: Thu, 13 Dec 2012 11:57:32 -0200
Message-Id: <1355407206-17100-88-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit fa968ee215c0ca91e4a9c3a69ac2405aae6e5d2f upstream.

If user space is running in primary mode it can switch to secondary
or access register mode, this is used e.g. in the clock_gettime code
of the vdso. If a signal is delivered to the user space process while
it has been running in access register mode the signal handler is
executed in access register mode as well which will result in a crash
most of the time.

Set the address space control bits in the PSW to the default for the
execution of the signal handler and make sure that the previous
address space control is restored on signal return. Take care
that user space can not switch to the kernel address space by
modifying the registers in the signal frame.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[ herton: use backported version for kernel <= 3.6 provided by Martin
  Schwidefsky ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/s390/include/asm/compat.h   |    2 +-
 arch/s390/include/asm/ptrace.h   |    4 ++--
 arch/s390/kernel/compat_signal.c |   14 ++++++++++++--
 arch/s390/kernel/signal.c        |   14 ++++++++++++--
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index 234f1d8..2e0a15b 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -20,7 +20,7 @@
 #define PSW32_MASK_CC		0x00003000UL
 #define PSW32_MASK_PM		0x00000f00UL
 
-#define PSW32_MASK_USER		0x00003F00UL
+#define PSW32_MASK_USER		0x0000FF00UL
 
 #define PSW32_ADDR_AMODE	0x80000000UL
 #define PSW32_ADDR_INSN		0x7FFFFFFFUL
diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index aeb77f0..d3750e7 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -240,7 +240,7 @@ typedef struct
 #define PSW_MASK_EA		0x00000000UL
 #define PSW_MASK_BA		0x00000000UL
 
-#define PSW_MASK_USER		0x00003F00UL
+#define PSW_MASK_USER		0x0000FF00UL
 
 #define PSW_ADDR_AMODE		0x80000000UL
 #define PSW_ADDR_INSN		0x7FFFFFFFUL
@@ -269,7 +269,7 @@ typedef struct
 #define PSW_MASK_EA		0x0000000100000000UL
 #define PSW_MASK_BA		0x0000000080000000UL
 
-#define PSW_MASK_USER		0x00003F0180000000UL
+#define PSW_MASK_USER		0x0000FF0180000000UL
 
 #define PSW_ADDR_AMODE		0x0000000000000000UL
 #define PSW_ADDR_INSN		0xFFFFFFFFFFFFFFFFUL
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index 3c0c198..3901276 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -311,6 +311,10 @@ static int restore_sigregs32(struct pt_regs *regs,_sigregs32 __user *sregs)
 	regs->psw.mask = (regs->psw.mask & ~PSW_MASK_USER) |
 		(__u64)(regs32.psw.mask & PSW32_MASK_USER) << 32 |
 		(__u64)(regs32.psw.addr & PSW32_ADDR_AMODE);
+	/* Check for invalid user address space control. */
+	if ((regs->psw.mask & PSW_MASK_ASC) >= (psw_kernel_bits & PSW_MASK_ASC))
+		regs->psw.mask = (psw_user_bits & PSW_MASK_ASC) |
+			(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__u64)(regs32.psw.addr & PSW32_ADDR_INSN);
 	for (i = 0; i < NUM_GPRS; i++)
 		regs->gprs[i] = (__u64) regs32.gprs[i];
@@ -483,7 +487,10 @@ static int setup_frame32(int sig, struct k_sigaction *ka,
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (__force __u64) frame;
-	regs->psw.mask |= PSW_MASK_BA;		/* force amode 31 */
+	/* Force 31 bit amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__force __u64) ka->sa.sa_handler;
 
 	regs->gprs[2] = map_signal(sig);
@@ -551,7 +558,10 @@ static int setup_rt_frame32(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (__force __u64) frame;
-	regs->psw.mask |= PSW_MASK_BA;		/* force amode 31 */
+	/* Force 31 bit amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__u64) ka->sa.sa_handler;
 
 	regs->gprs[2] = map_signal(sig);
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index ac565b4..ddddb80 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -138,6 +138,10 @@ static int restore_sigregs(struct pt_regs *regs, _sigregs __user *sregs)
 	/* Use regs->psw.mask instead of psw_user_bits to preserve PER bit. */
 	regs->psw.mask = (regs->psw.mask & ~PSW_MASK_USER) |
 		(user_sregs.regs.psw.mask & PSW_MASK_USER);
+	/* Check for invalid user address space control. */
+	if ((regs->psw.mask & PSW_MASK_ASC) >= (psw_kernel_bits & PSW_MASK_ASC))
+		regs->psw.mask = (psw_user_bits & PSW_MASK_ASC) |
+			(regs->psw.mask & ~PSW_MASK_ASC);
 	/* Check for invalid amode */
 	if (regs->psw.mask & PSW_MASK_EA)
 		regs->psw.mask |= PSW_MASK_BA;
@@ -275,7 +279,10 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (unsigned long) frame;
-	regs->psw.mask |= PSW_MASK_EA | PSW_MASK_BA;	/* 64 bit amode */
+	/* Force default amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_EA | PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
 
 	regs->gprs[2] = map_signal(sig);
@@ -348,7 +355,10 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (unsigned long) frame;
-	regs->psw.mask |= PSW_MASK_EA | PSW_MASK_BA;	/* 64 bit amode */
+	/* Force default amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_EA | PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
 
 	regs->gprs[2] = map_signal(sig);
-- 
1.7.9.5

