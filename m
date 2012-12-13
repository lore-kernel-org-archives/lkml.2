Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2LMBnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:43:53 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36577 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755076Ab2LMBnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:43:50 -0500
Message-ID: <1355363029.2164.14.camel@joe-AO722>
Subject: [TRIVIAL PATCH V2 12/26] s390: Convert print_symbol to %pSR
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Dec 2012 17:43:49 -0800
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Signed-off-by: Joe Perches <joe@perches.com>
---

V2: Add missing parentheses, remove comma

 arch/s390/kernel/traps.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 70ecfc5..f718e12 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -91,8 +91,9 @@ __show_trace(unsigned long sp, unsigned long low, unsigned long high)
 		if (sp < low || sp > high - sizeof(*sf))
 			return sp;
 		sf = (struct stack_frame *) sp;
-		printk("([<%016lx>] ", sf->gprs[8] & PSW_ADDR_INSN);
-		print_symbol("%s)\n", sf->gprs[8] & PSW_ADDR_INSN);
+		printk("([<%016lx>] %pSR)\n",
+		       sf->gprs[8] & PSW_ADDR_INSN,
+		       (void *)(sf->gprs[8] & PSW_ADDR_INSN));
 		/* Follow the backchain. */
 		while (1) {
 			low = sp;
@@ -102,16 +103,18 @@ __show_trace(unsigned long sp, unsigned long low, unsigned long high)
 			if (sp <= low || sp > high - sizeof(*sf))
 				return sp;
 			sf = (struct stack_frame *) sp;
-			printk(" [<%016lx>] ", sf->gprs[8] & PSW_ADDR_INSN);
-			print_symbol("%s\n", sf->gprs[8] & PSW_ADDR_INSN);
+			printk(" [<%016lx>] %pSR\n",
+			       sf->gprs[8] & PSW_ADDR_INSN,
+			       (void *)(sf->gprs[8] & PSW_ADDR_INSN));
 		}
 		/* Zero backchain detected, check for interrupt frame. */
 		sp = (unsigned long) (sf + 1);
 		if (sp <= low || sp > high - sizeof(*regs))
 			return sp;
 		regs = (struct pt_regs *) sp;
-		printk(" [<%016lx>] ", regs->psw.addr & PSW_ADDR_INSN);
-		print_symbol("%s\n", regs->psw.addr & PSW_ADDR_INSN);
+		printk(" [<%016lx>] %pSR\n",
+		       regs->psw.addr & PSW_ADDR_INSN,
+		       (void *)(regs->psw.addr & PSW_ADDR_INSN));
 		low = sp;
 		sp = regs->gprs[15];
 	}
@@ -169,8 +172,9 @@ static void show_last_breaking_event(struct pt_regs *regs)
 {
 #ifdef CONFIG_64BIT
 	printk("Last Breaking-Event-Address:\n");
-	printk(" [<%016lx>] ", regs->args[0] & PSW_ADDR_INSN);
-	print_symbol("%s\n", regs->args[0] & PSW_ADDR_INSN);
+	printk(" [<%016lx>] %pSR\n",
+	       regs->args[0] & PSW_ADDR_INSN,
+	       (void *)(regs->args[0] & PSW_ADDR_INSN));
 #endif
 }
 
@@ -201,10 +205,10 @@ void show_registers(struct pt_regs *regs)
 	char *mode;
 
 	mode = user_mode(regs) ? "User" : "Krnl";
-	printk("%s PSW : %p %p",
-	       mode, (void *) regs->psw.mask,
-	       (void *) regs->psw.addr);
-	print_symbol(" (%s)\n", regs->psw.addr & PSW_ADDR_INSN);
+	printk("%s PSW : %p %p (%pSR)\n",
+	       mode, (void *)regs->psw.mask,
+	       (void *)regs->psw.addr,
+	       (void *)(regs->psw.addr & PSW_ADDR_INSN));
 	printk("           R:%x T:%x IO:%x EX:%x Key:%x M:%x W:%x "
 	       "P:%x AS:%x CC:%x PM:%x", mask_bits(regs, PSW_MASK_PER),
 	       mask_bits(regs, PSW_MASK_DAT), mask_bits(regs, PSW_MASK_IO),
-- 
1.7.8.112.g3fd21


