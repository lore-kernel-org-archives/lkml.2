Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1GHIgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:36:53 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:29029 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab1GHIgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:36:51 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, mingo@elte.hu,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Message-Id: <20110708083555.2598.42216.sendpatchset@nchumbalkar.americas.hpqcorp.net>
Subject: [PATCH]: x86: print APIC data a little later during boot
Date: Fri,  8 Jul 2011 08:36:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To view IOAPIC data you could boot with "apic=debug".
For example:

NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 000 1    0    0   0   0    0    0    00
 01 000 0    0    0   0   0    0    0    31
 02 000 0    0    0   0   0    0    0    30
 03 000 0    0    0   0   0    0    0    33
 04 000 0    0    0   0   0    0    0    34
 05 000 0    0    0   0   0    0    0    35
 06 000 0    0    0   0   0    0    0    36
 07 000 0    0    0   0   0    0    0    37
 08 000 0    0    0   0   0    0    0    38
 09 000 0    1    0   0   0    0    0    39
 0a 000 0    0    0   0   0    0    0    3A
 0b 000 0    0    0   0   0    0    0    3B
 0c 000 0    0    0   0   0    0    0    3C
 0d 000 0    0    0   0   0    0    0    3D
 0e 000 0    0    0   0   0    0    0    3E
 0f 000 0    0    0   0   0    0    0    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00

Delaying the call to print APIC data gives better results:

NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 000 1    0    0   0   0    0    0    00
 01 000 0    0    0   0   0    0    0    31
 02 000 0    0    0   0   0    0    0    30
 03 000 1    0    0   0   0    0    0    33
 04 000 1    0    0   0   0    0    0    34
 05 000 1    0    0   0   0    0    0    35
 06 000 1    0    0   0   0    0    0    36
 07 000 1    0    0   0   0    0    0    37
 08 000 0    0    0   0   0    0    0    38
 09 000 0    1    0   0   0    0    0    39
 0a 000 1    0    0   0   0    0    0    3A
 0b 000 1    0    0   0   0    0    0    3B
 0c 000 0    0    0   0   0    0    0    3C
 0d 000 1    0    0   0   0    0    0    3D
 0e 000 1    0    0   0   0    0    0    3E
 0f 000 1    0    0   0   0    0    0    3F
 10 000 1    1    0   1   0    0    0    29
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 0    1    0   1   0    0    0    51
 15 000 1    0    0   0   0    0    0    00
 16 000 0    1    0   1   0    0    0    61
 17 000 0    1    0   1   0    0    0    59

Notice that the entries beyond interrupt input signal 0x0f also
get populated.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e529339..98c8d7e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1792,7 +1792,7 @@ __apicdebuginit(int) print_ICs(void)
 	return 0;
 }
 
-fs_initcall(print_ICs);
+late_initcall(print_ICs);
 
 
 /* Where if anywhere is the i8259 connect in external int mode */
