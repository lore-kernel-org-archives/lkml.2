Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2DUARd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:17:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34967 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2DUARb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:17:31 -0400
Date: Fri, 20 Apr 2012 17:17:20 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-535c0c34698061544f81a51c65fc51f4eeeebff6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable: Add _ASM_EXTABLE_EX() macro
Git-Commit-ID: 535c0c34698061544f81a51c65fc51f4eeeebff6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 17:17:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  535c0c34698061544f81a51c65fc51f4eeeebff6
Gitweb:     http://git.kernel.org/tip/535c0c34698061544f81a51c65fc51f4eeeebff6
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 16:57:35 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 16:57:35 -0700

x86, extable: Add _ASM_EXTABLE_EX() macro

Add _ASM_EXTABLE_EX() to generate the special extable entries that are
associated with uaccess_err.  This allows us to change the protocol
associated with these special entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/include/asm/asm.h     |   28 ++++++++++++++++++++--------
 arch/x86/include/asm/uaccess.h |    8 ++++----
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 53dce41..0f15e8a 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -40,16 +40,28 @@
 
 /* Exception table entry */
 #ifdef __ASSEMBLY__
-# define _ASM_EXTABLE(from,to)			\
-	.pushsection "__ex_table","a" ;		\
-	_ASM_ALIGN ;				\
-	_ASM_PTR from , to ;			\
+# define _ASM_EXTABLE(from,to)					\
+	.pushsection "__ex_table","a" ;				\
+	_ASM_ALIGN ;						\
+	_ASM_PTR from , to ;					\
+	.popsection
+
+# define _ASM_EXTABLE_EX(from,to)				\
+	.pushsection "__ex_table","a" ;				\
+	_ASM_ALIGN ;						\
+	_ASM_PTR from , (to) - (from) ;				\
 	.popsection
 #else
-# define _ASM_EXTABLE(from,to)			\
-	" .pushsection \"__ex_table\",\"a\"\n"	\
-	_ASM_ALIGN "\n" 			\
-	_ASM_PTR #from "," #to "\n" 		\
+# define _ASM_EXTABLE(from,to)					\
+	" .pushsection \"__ex_table\",\"a\"\n"			\
+	_ASM_ALIGN "\n" 					\
+	_ASM_PTR #from "," #to "\n" 				\
+	" .popsection\n"
+
+# define _ASM_EXTABLE_EX(from,to)				\
+	" .pushsection \"__ex_table\",\"a\"\n"			\
+	_ASM_ALIGN "\n" 					\
+	_ASM_PTR #from ",(" #to ")-(" #from ")\n" 		\
 	" .popsection\n"
 #endif
 
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index e054459..4ee59dd 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -202,8 +202,8 @@ extern int __get_user_bad(void);
 	asm volatile("1:	movl %%eax,0(%1)\n"			\
 		     "2:	movl %%edx,4(%1)\n"			\
 		     "3:\n"						\
-		     _ASM_EXTABLE(1b, 2b - 1b)				\
-		     _ASM_EXTABLE(2b, 3b - 2b)				\
+		     _ASM_EXTABLE_EX(1b, 2b)				\
+		     _ASM_EXTABLE_EX(2b, 3b)				\
 		     : : "A" (x), "r" (addr))
 
 #define __put_user_x8(x, ptr, __ret_pu)				\
@@ -408,7 +408,7 @@ do {									\
 #define __get_user_asm_ex(x, addr, itype, rtype, ltype)			\
 	asm volatile("1:	mov"itype" %1,%"rtype"0\n"		\
 		     "2:\n"						\
-		     _ASM_EXTABLE(1b, 2b - 1b)				\
+		     _ASM_EXTABLE_EX(1b, 2b)				\
 		     : ltype(x) : "m" (__m(addr)))
 
 #define __put_user_nocheck(x, ptr, size)			\
@@ -450,7 +450,7 @@ struct __large_struct { unsigned long buf[100]; };
 #define __put_user_asm_ex(x, addr, itype, rtype, ltype)			\
 	asm volatile("1:	mov"itype" %"rtype"0,%1\n"		\
 		     "2:\n"						\
-		     _ASM_EXTABLE(1b, 2b - 1b)				\
+		     _ASM_EXTABLE_EX(1b, 2b)				\
 		     : : ltype(x), "m" (__m(addr)))
 
 /*
