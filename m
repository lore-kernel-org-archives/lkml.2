Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab1GBVRy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:17:54 -0400
Received: from mail.southpole.se ([193.12.106.18]:45878 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab1GBVQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:16:22 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v2 17/19] OpenRISC: Library routines
Date: Sat,  2 Jul 2011 23:15:50 +0200
Message-Id: <1309641352-18714-18-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309641352-18714-1-git-send-email-jonas@southpole.se>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/lib/delay.c  |   60 +++++++++++++
 arch/openrisc/lib/string.S |  204 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 264 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/lib/delay.c
 create mode 100644 arch/openrisc/lib/string.S

diff --git a/arch/openrisc/lib/delay.c b/arch/openrisc/lib/delay.c
new file mode 100644
index 0000000..01d9740
--- /dev/null
+++ b/arch/openrisc/lib/delay.c
@@ -0,0 +1,60 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      version 2 as published by the Free Software Foundation
+ *
+ * Precise Delay Loops
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <asm/delay.h>
+#include <asm/timex.h>
+#include <asm/processor.h>
+
+int __devinit read_current_timer(unsigned long *timer_value)
+{
+	*timer_value = mfspr(SPR_TTCR);
+	return 0;
+}
+
+void __delay(unsigned long cycles)
+{
+	cycles_t target = get_cycles() + cycles;
+
+	while (get_cycles() < target)
+		cpu_relax();
+}
+EXPORT_SYMBOL(__delay);
+
+inline void __const_udelay(unsigned long xloops)
+{
+	unsigned long long loops;
+
+	loops = xloops * loops_per_jiffy * HZ;
+
+	__delay(loops >> 32);
+}
+EXPORT_SYMBOL(__const_udelay);
+
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * 0x10C7UL); /* 2**32 / 1000000 (rounded up) */
+}
+EXPORT_SYMBOL(__udelay);
+
+void __ndelay(unsigned long nsecs)
+{
+	__const_udelay(nsecs * 0x5UL); /* 2**32 / 1000000000 (rounded up) */
+}
+EXPORT_SYMBOL(__ndelay);
diff --git a/arch/openrisc/lib/string.S b/arch/openrisc/lib/string.S
new file mode 100644
index 0000000..465f04b
--- /dev/null
+++ b/arch/openrisc/lib/string.S
@@ -0,0 +1,204 @@
+/*
+ * OpenRISC string.S
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+#include <asm/errno.h>
+
+	/*
+	 * this can be optimized by doing gcc inline assemlby with
+	 * proper constraints (no need to save args registers...)
+	 *
+	 */
+
+
+/*
+ *
+ * int __copy_tofrom_user(void *to, const void *from, unsigned long size);
+ *
+ * NOTE: it returns number of bytes NOT copied !!!
+ *
+ */
+	.global	__copy_tofrom_user
+__copy_tofrom_user:
+	l.addi  r1,r1,-12
+	l.sw    0(r1),r6
+	l.sw    4(r1),r4
+	l.sw    8(r1),r3
+
+	l.addi  r11,r5,0
+2:  	l.sfeq  r11,r0
+	l.bf    1f
+	l.addi  r11,r11,-1
+8:    	l.lbz   r6,0(r4)
+9:    	l.sb    0(r3),r6
+	l.addi  r3,r3,1
+	l.j     2b
+	l.addi  r4,r4,1
+1:
+	l.addi  r11,r11,1               // r11 holds the return value
+
+	l.lwz   r6,0(r1)
+	l.lwz   r4,4(r1)
+	l.lwz   r3,8(r1)
+	l.jr    r9
+	l.addi  r1,r1,12
+
+	.section .fixup, "ax"
+99:
+		l.j     1b
+		l.nop
+	.previous
+
+	.section __ex_table, "a"
+		.long 8b, 99b		// read fault
+		.long 9b, 99b		// write fault
+	.previous
+
+/*
+ * unsigned long clear_user(void *addr, unsigned long size) ;
+ *
+ * NOTE: it returns number of bytes NOT cleared !!!
+ */
+	.global	__clear_user
+__clear_user:
+	l.addi  r1,r1,-8
+	l.sw    0(r1),r4
+	l.sw    4(r1),r3
+
+2:	l.sfeq	r4,r0
+	l.bf	1f
+	l.addi	r4,r4,-1
+9:	l.sb	0(r3),r0
+	l.j	2b
+	l.addi  r3,r3,1
+
+1:
+	l.addi  r11,r4,1
+
+	l.lwz	r4,0(r1)
+	l.lwz	r3,4(r1)
+	l.jr	r9
+	l.addi	r1,r1,8
+
+	.section .fixup, "ax"
+99:
+		l.j     1b
+		l.nop
+	.previous
+
+	.section __ex_table, "a"
+		.long 9b, 99b		// write fault
+	.previous
+
+/*
+ * long strncpy_from_user(char *dst, const char *src, long count)
+ *
+ *
+ */
+	.global	__strncpy_from_user
+__strncpy_from_user:
+	l.addi  r1,r1,-16
+	l.sw    0(r1),r6
+	l.sw    4(r1),r5
+	l.sw    8(r1),r4
+	l.sw    12(r1),r3
+
+	l.addi  r11,r5,0
+2:  	l.sfeq  r5,r0
+	l.bf    1f
+	l.addi  r5,r5,-1
+8:    	l.lbz   r6,0(r4)
+	l.sfeq  r6,r0
+	l.bf    1f
+9:    	l.sb    0(r3),r6
+	l.addi  r3,r3,1
+	l.j     2b
+	l.addi  r4,r4,1
+1:
+	l.lwz   r6,0(r1)
+	l.addi  r5,r5,1
+	l.sub   r11,r11,r5              // r11 holds the return value
+
+	l.lwz   r6,0(r1)
+	l.lwz   r5,4(r1)
+	l.lwz   r4,8(r1)
+	l.lwz   r3,12(r1)
+	l.jr    r9
+	l.addi  r1,r1,16
+
+	.section .fixup, "ax"
+99:
+		l.movhi r11,hi(-EFAULT)
+		l.ori   r11,r11,lo(-EFAULT)
+
+		l.lwz   r6,0(r1)
+		l.lwz   r5,4(r1)
+		l.lwz   r4,8(r1)
+		l.lwz   r3,12(r1)
+		l.jr	r9
+		l.addi  r1,r1,16
+	.previous
+
+	.section __ex_table, "a"
+		.long 8b, 99b		// read fault
+	.previous
+
+/*
+ * extern int __strnlen_user(const char *str, long len, unsigned long top);
+ *
+ *
+ * RTRN: - length of a string including NUL termination character
+ *       - on page fault 0
+ */
+
+	.global __strnlen_user
+__strnlen_user:
+	l.addi  r1,r1,-8
+	l.sw    0(r1),r6
+	l.sw    4(r1),r3
+
+	l.addi  r11,r0,0
+2:  	l.sfeq  r11,r4
+	l.bf    1f
+	l.addi  r11,r11,1
+8:    	l.lbz   r6,0(r3)
+	l.sfeq  r6,r0
+	l.bf    1f
+	l.sfgeu r3,r5                  // are we over the top ?
+	l.bf    99f
+	l.j     2b
+	l.addi  r3,r3,1
+
+1:
+	l.lwz   r6,0(r1)
+	l.lwz	r3,4(r1)
+	l.jr    r9
+	l.addi  r1,r1,8
+
+	.section .fixup, "ax"
+99:
+		l.addi  r11,r0,0
+
+		l.lwz   r6,0(r1)
+		l.lwz	r3,4(r1)
+		l.jr	r9
+		l.addi  r1,r1,8
+	.previous
+
+	.section __ex_table, "a"
+		.long 8b, 99b		// read fault
+	.previous
-- 
1.7.4.1

