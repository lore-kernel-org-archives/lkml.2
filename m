Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2KVVcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:32:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:49645 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab2KVSkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 73/83] s390/signal: set correct address space control
Date: Wed, 21 Nov 2012 16:42:35 -0800
Message-Id: <20121122004220.511698934@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/compat.h   |    2 +-
 arch/s390/include/asm/ptrace.h   |    4 ++--
 arch/s390/kernel/compat_signal.c |   14 ++++++++++++--
 arch/s390/kernel/signal.c        |   14 ++++++++++++--
 4 files changed, 27 insertions(+), 7 deletions(-)

--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -20,7 +20,7 @@
 #define PSW32_MASK_CC		0x00003000UL
 #define PSW32_MASK_PM		0x00000f00UL
 
-#define PSW32_MASK_USER		0x00003F00UL
+#define PSW32_MASK_USER		0x0000FF00UL
 
 #define PSW32_ADDR_AMODE	0x80000000UL
 #define PSW32_ADDR_INSN		0x7FFFFFFFUL
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -238,7 +238,7 @@ typedef struct
 #define PSW_MASK_EA		0x00000000UL
 #define PSW_MASK_BA		0x00000000UL
 
-#define PSW_MASK_USER		0x00003F00UL
+#define PSW_MASK_USER		0x0000FF00UL
 
 #define PSW_ADDR_AMODE		0x80000000UL
 #define PSW_ADDR_INSN		0x7FFFFFFFUL
@@ -267,7 +267,7 @@ typedef struct
 #define PSW_MASK_EA		0x0000000100000000UL
 #define PSW_MASK_BA		0x0000000080000000UL
 
-#define PSW_MASK_USER		0x00003F0180000000UL
+#define PSW_MASK_USER		0x0000FF0180000000UL
 
 #define PSW_ADDR_AMODE		0x0000000000000000UL
 #define PSW_ADDR_INSN		0xFFFFFFFFFFFFFFFFUL
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -309,6 +309,10 @@ static int restore_sigregs32(struct pt_r
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
@@ -481,7 +485,10 @@ static int setup_frame32(int sig, struct
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (__force __u64) frame;
-	regs->psw.mask |= PSW_MASK_BA;		/* force amode 31 */
+	/* Force 31 bit amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__force __u64) ka->sa.sa_handler;
 
 	regs->gprs[2] = map_signal(sig);
@@ -549,7 +556,10 @@ static int setup_rt_frame32(int sig, str
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (__force __u64) frame;
-	regs->psw.mask |= PSW_MASK_BA;		/* force amode 31 */
+	/* Force 31 bit amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__u64) ka->sa.sa_handler;
 
 	regs->gprs[2] = map_signal(sig);
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -136,6 +136,10 @@ static int restore_sigregs(struct pt_reg
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
@@ -273,7 +277,10 @@ static int setup_frame(int sig, struct k
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (unsigned long) frame;
-	regs->psw.mask |= PSW_MASK_EA | PSW_MASK_BA;	/* 64 bit amode */
+	/* Force default amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_EA | PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
 
 	regs->gprs[2] = map_signal(sig);
@@ -346,7 +353,10 @@ static int setup_rt_frame(int sig, struc
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (unsigned long) frame;
-	regs->psw.mask |= PSW_MASK_EA | PSW_MASK_BA;	/* 64 bit amode */
+	/* Force default amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_EA | PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
 
 	regs->gprs[2] = map_signal(sig);


