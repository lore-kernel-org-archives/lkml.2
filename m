Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab1BJSUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:20:43 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:9316 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1BJSUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:20:40 -0500
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Feb 2011 13:20:40 EST
X-Spam-Processed: mail.digidescorp.com, Thu, 10 Feb 2011 12:12:44 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1022247c17=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
        "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] microblaze: fix /dev/zero corruption from __clear_user()
Date: Thu, 10 Feb 2011 12:12:13 -0600
Message-Id: <1297361533-24627-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A userland read of more than PAGE_SIZE bytes from /dev/zero results in
(a) not all of the bytes returned being zero, and
(b) memory corruption due to zeroing of bytes beyond the user buffer.

This is caused by improper constraints on the assembly __clear_user function.
The constrints don't indicate to the compiler that the pointer argument is
modified. Since the function is inline, this results in double-incrementing
of the pointer when __clear_user() is invoked through a multi-page read() of
/dev/zero. 

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
--- a/arch/microblaze/include/asm/uaccess.h	2011-02-10 11:51:52.319226513 -0600
+++ b/arch/microblaze/include/asm/uaccess.h	2011-02-10 11:53:01.064857179 -0600
@@ -120,16 +120,16 @@ static inline unsigned long __must_check
 {
 	/* normal memset with two words to __ex_table */
 	__asm__ __volatile__ (				\
-			"1:	sb	r0, %2, r0;"	\
+			"1:	sb	r0, %1, r0;"	\
 			"	addik	%0, %0, -1;"	\
 			"	bneid	%0, 1b;"	\
-			"	addik	%2, %2, 1;"	\
+			"	addik	%1, %1, 1;"	\
 			"2:			"	\
 			__EX_TABLE_SECTION		\
 			".word	1b,2b;"			\
 			".previous;"			\
-		: "=r"(n)				\
-		: "0"(n), "r"(to)
+		: "=r"(n), "=r"(to)			\
+		: "0"(n), "1"(to)
 	);
 	return n;
 }

