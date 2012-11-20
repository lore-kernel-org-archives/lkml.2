Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2KTOj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:39:27 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:43025 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2KTOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:39:25 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 2/2] ARC: provide optimal __get_user_fn()
Date: Tue, 20 Nov 2012 20:08:17 +0530
Message-ID: <1353422297-29079-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353422297-29079-1-git-send-email-vgupta@synopsys.com>
References: <1353422297-29079-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/uaccess.h |   51 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/arc/include/asm/uaccess.h b/arch/arc/include/asm/uaccess.h
index 503c98d..d9cbae4 100644
--- a/arch/arc/include/asm/uaccess.h
+++ b/arch/arc/include/asm/uaccess.h
@@ -35,6 +35,57 @@
 #define __access_ok(addr, sz)	(unlikely(__kernel_ok) || \
 				 likely(__user_ok((addr), (sz))))
 
+/*********** Single byte/s-word/word copies ******************/
+
+#define __get_user_fn(sz, u, k)					\
+({								\
+	long __ret = 0;	/* success by default */	\
+	switch (sz) {						\
+	case 1: __arc_get_user_one(*(k), u, "ldb", __ret); break;	\
+	case 2: __arc_get_user_one(*(k), u, "ldw", __ret); break;	\
+	case 4: __arc_get_user_one(*(k), u, "ld", __ret);  break;	\
+	case 8: __arc_get_user_one_64(*(k), u, __ret);     break;	\
+	}							\
+	__ret;							\
+})
+
+#define __arc_get_user_one(dst, src, op, ret)	\
+	__asm__ __volatile__(                   \
+	"1:	"op"    %1,[%2]\n"		\
+	"2:	;nop\n"				\
+	"	.section .fixup, \"ax\"\n"	\
+	"	.align 4\n"			\
+	"3:	mov %0, %3\n"			\
+	"	j   2b\n"			\
+	"	.previous\n"			\
+	"	.section __ex_table, \"a\"\n"	\
+	"	.align 4\n"			\
+	"	.word 1b,3b\n"			\
+	"	.previous\n"			\
+						\
+	: "+r" (ret), "=r" (dst)		\
+	: "r" (src), "i" (-EFAULT))
+
+#define __arc_get_user_one_64(dst, src, ret)	\
+	__asm__ __volatile__(                   \
+	"1:	ld   %1,[%2]\n"			\
+	"4:	ld  %R1,[%2, 4]\n"		\
+	"2:	;nop\n"				\
+	"	.section .fixup, \"ax\"\n"	\
+	"	.align 4\n"			\
+	"3:	mov %0, %3\n"			\
+	"	j   2b\n"			\
+	"	.previous\n"			\
+	"	.section __ex_table, \"a\"\n"	\
+	"	.align 4\n"			\
+	"	.word 1b,3b\n"			\
+	"	.word 4b,3b\n"			\
+	"	.previous\n"			\
+						\
+	: "+r" (ret), "=r" (dst)		\
+	: "r" (src), "i" (-EFAULT))
+
+
 static inline unsigned long
 __arc_copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-- 
1.7.4.1

