Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1LSVIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:08:24 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46862 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab1LSVIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:08:21 -0500
X-Sasl-enc: wRsJ/tTY7vtYzcIOKH6ct51KJSfTQKM2QDMAipK2K67O 1324328900
Message-ID: <4EEFA7AE.9020407@ladisch.de>
Date: Mon, 19 Dec 2011 22:07:58 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, dumpstack: fix code bytes breakage due to missing KERN_CONT
References: <4EEF9526.5010703@ladisch.de>
In-Reply-To: <4EEF9526.5010703@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When printing the code bytes in show_registers(), the markers around the
byte at the fault address could make the printk() format string look
like a valid log level and facility code.  This would prevent this byte
from being printed and result in a spurious newline:

[ 7555.765589] Code: 8b 32 e9 94 00 00 00 81 7d 00 ff 00 00 00 0f 87 96 00 00 00 48 8b 83 c0 00 00 00 44 89 e2 44 89 e6 48 89 df 48 8b 80 d8 02 00 00
[ 7555.765683]  8b 48 28 48 89 d0 81 e2 ff 0f 00 00 48 c1 e8 0c 48 c1 e0 04

Add KERN_CONT where needed, and elsewhere in show_registers() for
consistency.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 arch/x86/kernel/dumpstack_32.c |    8 ++++----
 arch/x86/kernel/dumpstack_64.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

Now with a corrected mail address; sorry for the mixup.

--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -116,16 +116,16 @@ void show_registers(struct pt_regs *regs)
 		for (i = 0; i < code_len; i++, ip++) {
 			if (ip < (u8 *)PAGE_OFFSET ||
 					probe_kernel_address(ip, c)) {
-				printk(" Bad EIP value.");
+				printk(KERN_CONT " Bad EIP value.");
 				break;
 			}
 			if (ip == (u8 *)regs->ip)
-				printk("<%02x> ", c);
+				printk(KERN_CONT "<%02x> ", c);
 			else
-				printk("%02x ", c);
+				printk(KERN_CONT "%02x ", c);
 		}
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }

 int is_valid_bugaddr(unsigned long ip)
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -284,16 +284,16 @@ void show_registers(struct pt_regs *regs)
 		for (i = 0; i < code_len; i++, ip++) {
 			if (ip < (u8 *)PAGE_OFFSET ||
 					probe_kernel_address(ip, c)) {
-				printk(" Bad RIP value.");
+				printk(KERN_CONT " Bad RIP value.");
 				break;
 			}
 			if (ip == (u8 *)regs->ip)
-				printk("<%02x> ", c);
+				printk(KERN_CONT "<%02x> ", c);
 			else
-				printk("%02x ", c);
+				printk(KERN_CONT "%02x ", c);
 		}
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }

 int is_valid_bugaddr(unsigned long ip)
