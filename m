Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1GHSqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:46:39 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:34699 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GHSqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:46:38 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, mingo@elte.hu,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Message-Id: <20110708184557.2734.61830.sendpatchset@nchumbalkar.americas.cpqcorp.net>
Subject: [PATCH 1/2] x86: Format clean up for IOAPIC output
Date: Fri,  8 Jul 2011 18:46:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When IOAPIC data is displayed in "dmesg" with the help of the boot parameter
"apic=debug" certain values are not formatted correctly wrt their size.

In the "dmesg" snippet below, note that the output for "max redirection entries",
and "IO APIC version" which are each defined to be just 8-bits long are displayed
as 2 bytes in length. Similarly, "Dst" under the "IRQ redirection table"
should only be 8-bits long.

IO APIC #0......
...
...
.... register #01: 00170020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0020
...
...
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 000 1    0    0   0   0    0    0    00
 01 000 0    0    0   0   0    0    0    31
 02 000 0    0    0   0   0    0    0    30
 03 000 1    0    0   0   0    0    0    33
...
...

Do some formatting clean up, so you will see output like below:

IO APIC #0......
...
...
.... register #01: 00170020
.......     : max redirection entries: 17
.......     : PRQ implemented: 0
.......     : IO APIC version: 20
...
...
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 00  1    0    0   0   0    0    0    00
 01 00  0    0    0   0   0    0    0    31
 02 00  0    0    0   0   0    0    0    30
 03 00  1    0    0   0   0    0    0    33
...
...

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

---
 arch/x86/kernel/apic/io_apic.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 98c8d7e..ed4abaa 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1522,10 +1522,12 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG ".......    : LTS          : %X\n", reg_00.bits.LTS);
 
 	printk(KERN_DEBUG ".... register #01: %08X\n", *(int *)&reg_01);
-	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
+	printk(KERN_DEBUG ".......     : max redirection entries: %02X\n",
+		reg_01.bits.entries);
 
 	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
-	printk(KERN_DEBUG ".......     : IO APIC version: %04X\n", reg_01.bits.version);
+	printk(KERN_DEBUG ".......     : IO APIC version: %02X\n",
+		reg_01.bits.version);
 
 	/*
 	 * Some Intel chipsets with IO APIC VERSION of 0x1? don't have reg_02,
@@ -1558,7 +1560,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 
 		entry = ioapic_read_entry(apic, i);
 
-		printk(KERN_DEBUG " %02x %03X ",
+		printk(KERN_DEBUG " %02x %02X  ",
 			i,
 			entry.dest
 		);
-- 
1.7.1

