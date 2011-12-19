Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1LSVRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:17:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48219 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1LSVQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:16:59 -0500
Date: Mon, 19 Dec 2011 13:16:44 -0800
From: tip-bot for Clemens Ladisch <clemens@ladisch.de>
Message-ID: <tip-13f541c10b30fc6529200d7f9a0073217709622f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, clemens@ladisch.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, clemens@ladisch.de
In-Reply-To: <4EEFA7AE.9020407@ladisch.de>
References: <4EEFA7AE.9020407@ladisch.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, dumpstack:
  Fix code bytes breakage due to missing KERN_CONT
Git-Commit-ID: 13f541c10b30fc6529200d7f9a0073217709622f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Dec 2011 13:16:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13f541c10b30fc6529200d7f9a0073217709622f
Gitweb:     http://git.kernel.org/tip/13f541c10b30fc6529200d7f9a0073217709622f
Author:     Clemens Ladisch <clemens@ladisch.de>
AuthorDate: Mon, 19 Dec 2011 22:07:58 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Dec 2011 13:09:56 -0800

x86, dumpstack: Fix code bytes breakage due to missing KERN_CONT

When printing the code bytes in show_registers(), the markers around the
byte at the fault address could make the printk() format string look
like a valid log level and facility code.  This would prevent this byte
from being printed and result in a spurious newline:

[ 7555.765589] Code: 8b 32 e9 94 00 00 00 81 7d 00 ff 00 00 00 0f 87 96 00 00 00 48 8b 83 c0 00 00 00 44 89 e2 44 89 e6 48 89 df 48 8b 80 d8 02 00 00
[ 7555.765683]  8b 48 28 48 89 d0 81 e2 ff 0f 00 00 48 c1 e8 0c 48 c1 e0 04

Add KERN_CONT where needed, and elsewhere in show_registers() for
consistency.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Link: http://lkml.kernel.org/r/4EEFA7AE.9020407@ladisch.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/dumpstack_32.c |    8 ++++----
 arch/x86/kernel/dumpstack_64.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 3b97a80..c99f9ed 100644
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
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 19853ad..6d728d9 100644
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
