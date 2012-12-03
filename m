Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab2LCOf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:35:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43545 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932072Ab2LCOfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:45 -0500
Message-Id: <20121203143147.958434844@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:31:54 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 08/89] s390/signal: set correct address space control
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust filename
 - The RI bit is not included in PSW_MASK_USER]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/include/asm/compat.h      |    2 +-
 arch/s390/include/asm/ptrace.h |    4 ++--
 arch/s390/kernel/compat_signal.c    |   14 ++++++++++++--
 arch/s390/kernel/signal.c           |   14 ++++++++++++--
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
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -312,6 +312,10 @@ static int restore_sigregs32(struct pt_r
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
@@ -493,7 +497,10 @@ static int setup_frame32(int sig, struct
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (__force __u64) frame;
-	regs->psw.mask |= PSW_MASK_BA;		/* force amode 31 */
+	/* Force 31 bit amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__force __u64) ka->sa.sa_handler;
 
 	regs->gprs[2] = map_signal(sig);
@@ -557,7 +564,10 @@ static int setup_rt_frame32(int sig, str
 
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
@@ -147,6 +147,10 @@ static int restore_sigregs(struct pt_reg
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
@@ -293,7 +297,10 @@ static int setup_frame(int sig, struct k
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (unsigned long) frame;
-	regs->psw.mask |= PSW_MASK_EA | PSW_MASK_BA;	/* 64 bit amode */
+	/* Force default amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_EA | PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
 
 	regs->gprs[2] = map_signal(sig);
@@ -362,7 +369,10 @@ static int setup_rt_frame(int sig, struc
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (unsigned long) frame;
-	regs->psw.mask |= PSW_MASK_EA | PSW_MASK_BA;	/* 64 bit amode */
+	/* Force default amode and default user address space control. */
+	regs->psw.mask = PSW_MASK_EA | PSW_MASK_BA |
+		(psw_user_bits & PSW_MASK_ASC) |
+		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
 
 	regs->gprs[2] = map_signal(sig);


