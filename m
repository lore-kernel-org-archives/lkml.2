Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2EYGYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:24:18 -0400
Received: from mail.southpole.se ([193.12.106.18]:48208 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab2EYGYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:24:16 -0400
From: Jonas Bonn <jonas@southpole.se>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 1/1] openrisc: use generic strncpy_from_user
Date: Fri, 25 May 2012 08:24:49 +0200
Message-Id: <1337927089-17836-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.0.4
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 27053-09925
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As per commits 2922585b93294d47172a765115e0dbc1bfe1be19
("lib: Sparc's strncpy_from_user is generic enough, move under lib/"),
92ae03f2ef99fbc23bfa9080d6b58f25227bd7ef ("x86: merge 32/64-bit versions
of 'strncpy_from_user()' and speed it up"), and corresponding
discussion on linux-arch.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---

Hi Linus,

Here's a single patch update to the OpenRISC arch to use the new
strncpy_from_user implementation.  Hope it's ok to send it as a
single patch and not as a pull request; let me know otherwise.

Thanks,
Jonas

 arch/openrisc/Kconfig               |    1 +
 arch/openrisc/include/asm/uaccess.h |   10 ++-----
 arch/openrisc/lib/string.S          |   52 -----------------------------------
 3 files changed, 4 insertions(+), 59 deletions(-)

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index da4ccd1..ee4d124 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -19,6 +19,7 @@ config OPENRISC
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_STRNCPY_FROM_USER
 
 config MMU
 	def_bool y
diff --git a/arch/openrisc/include/asm/uaccess.h b/arch/openrisc/include/asm/uaccess.h
index f5abaa0..04b93de 100644
--- a/arch/openrisc/include/asm/uaccess.h
+++ b/arch/openrisc/include/asm/uaccess.h
@@ -313,14 +313,10 @@ clear_user(void *addr, unsigned long size)
 	return size;
 }
 
-extern int __strncpy_from_user(char *dst, const char *src, long count);
+#define user_addr_max() \
+	(segment_eq(get_fs(), USER_DS) ? TASK_SIZE : ~0UL)
 
-static inline long strncpy_from_user(char *dst, const char *src, long count)
-{
-	if (access_ok(VERIFY_READ, src, 1))
-		return __strncpy_from_user(dst, src, count);
-	return -EFAULT;
-}
+extern long strncpy_from_user(char *dest, const char __user *src, long count);
 
 /*
  * Return the size of a string (including the ending 0)
diff --git a/arch/openrisc/lib/string.S b/arch/openrisc/lib/string.S
index 465f04b..8ceb11e 100644
--- a/arch/openrisc/lib/string.S
+++ b/arch/openrisc/lib/string.S
@@ -104,58 +104,6 @@ __clear_user:
 		.long 9b, 99b		// write fault
 	.previous
 
-/*
- * long strncpy_from_user(char *dst, const char *src, long count)
- *
- *
- */
-	.global	__strncpy_from_user
-__strncpy_from_user:
-	l.addi  r1,r1,-16
-	l.sw    0(r1),r6
-	l.sw    4(r1),r5
-	l.sw    8(r1),r4
-	l.sw    12(r1),r3
-
-	l.addi  r11,r5,0
-2:  	l.sfeq  r5,r0
-	l.bf    1f
-	l.addi  r5,r5,-1
-8:    	l.lbz   r6,0(r4)
-	l.sfeq  r6,r0
-	l.bf    1f
-9:    	l.sb    0(r3),r6
-	l.addi  r3,r3,1
-	l.j     2b
-	l.addi  r4,r4,1
-1:
-	l.lwz   r6,0(r1)
-	l.addi  r5,r5,1
-	l.sub   r11,r11,r5              // r11 holds the return value
-
-	l.lwz   r6,0(r1)
-	l.lwz   r5,4(r1)
-	l.lwz   r4,8(r1)
-	l.lwz   r3,12(r1)
-	l.jr    r9
-	l.addi  r1,r1,16
-
-	.section .fixup, "ax"
-99:
-		l.movhi r11,hi(-EFAULT)
-		l.ori   r11,r11,lo(-EFAULT)
-
-		l.lwz   r6,0(r1)
-		l.lwz   r5,4(r1)
-		l.lwz   r4,8(r1)
-		l.lwz   r3,12(r1)
-		l.jr	r9
-		l.addi  r1,r1,16
-	.previous
-
-	.section __ex_table, "a"
-		.long 8b, 99b		// read fault
-	.previous
 
 /*
  * extern int __strnlen_user(const char *str, long len, unsigned long top);
-- 
1.7.0.4

