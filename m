Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1I1WvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:51:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933594Ab1I1Wu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:48 2011
Message-Id: <20110928220148.884066566@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [223/244] ARM: 7099/1: futex: preserve oldval in SMP __futex_atomic_op
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit df77abcafc8dc881b6c9347548651777088e4b27 upstream.

The SMP implementation of __futex_atomic_op clobbers oldval with the
status flag from the exclusive store. This causes it to always read as
zero when performing the FUTEX_OP_CMP_* operation.

This patch updates the ARM __futex_atomic_op implementations to take a
tmp argument, allowing us to store the strex status flag without
overwriting the register containing oldval.

Reported-by: Minho Ban <mhban@samsung.com>
Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/include/asm/futex.h |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/arch/arm/include/asm/futex.h
+++ b/arch/arm/include/asm/futex.h
@@ -25,17 +25,17 @@
 
 #ifdef CONFIG_SMP
 
-#define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)	\
+#define __futex_atomic_op(insn, ret, oldval, tmp, uaddr, oparg)	\
 	smp_mb();						\
 	__asm__ __volatile__(					\
-	"1:	ldrex	%1, [%2]\n"				\
+	"1:	ldrex	%1, [%3]\n"				\
 	"	" insn "\n"					\
-	"2:	strex	%1, %0, [%2]\n"				\
-	"	teq	%1, #0\n"				\
+	"2:	strex	%2, %0, [%3]\n"				\
+	"	teq	%2, #0\n"				\
 	"	bne	1b\n"					\
 	"	mov	%0, #0\n"				\
-	__futex_atomic_ex_table("%4")				\
-	: "=&r" (ret), "=&r" (oldval)				\
+	__futex_atomic_ex_table("%5")				\
+	: "=&r" (ret), "=&r" (oldval), "=&r" (tmp)		\
 	: "r" (uaddr), "r" (oparg), "Ir" (-EFAULT)		\
 	: "cc", "memory")
 
@@ -73,14 +73,14 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 #include <linux/preempt.h>
 #include <asm/domain.h>
 
-#define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)	\
+#define __futex_atomic_op(insn, ret, oldval, tmp, uaddr, oparg)	\
 	__asm__ __volatile__(					\
-	"1:	" T(ldr) "	%1, [%2]\n"			\
+	"1:	" T(ldr) "	%1, [%3]\n"			\
 	"	" insn "\n"					\
-	"2:	" T(str) "	%0, [%2]\n"			\
+	"2:	" T(str) "	%0, [%3]\n"			\
 	"	mov	%0, #0\n"				\
-	__futex_atomic_ex_table("%4")				\
-	: "=&r" (ret), "=&r" (oldval)				\
+	__futex_atomic_ex_table("%5")				\
+	: "=&r" (ret), "=&r" (oldval), "=&r" (tmp)		\
 	: "r" (uaddr), "r" (oparg), "Ir" (-EFAULT)		\
 	: "cc", "memory")
 
@@ -117,7 +117,7 @@ futex_atomic_op_inuser (int encoded_op,
 	int cmp = (encoded_op >> 24) & 15;
 	int oparg = (encoded_op << 8) >> 20;
 	int cmparg = (encoded_op << 20) >> 20;
-	int oldval = 0, ret;
+	int oldval = 0, ret, tmp;
 
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
@@ -129,19 +129,19 @@ futex_atomic_op_inuser (int encoded_op,
 
 	switch (op) {
 	case FUTEX_OP_SET:
-		__futex_atomic_op("mov	%0, %3", ret, oldval, uaddr, oparg);
+		__futex_atomic_op("mov	%0, %4", ret, oldval, tmp, uaddr, oparg);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op("add	%0, %1, %3", ret, oldval, uaddr, oparg);
+		__futex_atomic_op("add	%0, %1, %4", ret, oldval, tmp, uaddr, oparg);
 		break;
 	case FUTEX_OP_OR:
-		__futex_atomic_op("orr	%0, %1, %3", ret, oldval, uaddr, oparg);
+		__futex_atomic_op("orr	%0, %1, %4", ret, oldval, tmp, uaddr, oparg);
 		break;
 	case FUTEX_OP_ANDN:
-		__futex_atomic_op("and	%0, %1, %3", ret, oldval, uaddr, ~oparg);
+		__futex_atomic_op("and	%0, %1, %4", ret, oldval, tmp, uaddr, ~oparg);
 		break;
 	case FUTEX_OP_XOR:
-		__futex_atomic_op("eor	%0, %1, %3", ret, oldval, uaddr, oparg);
+		__futex_atomic_op("eor	%0, %1, %4", ret, oldval, tmp, uaddr, oparg);
 		break;
 	default:
 		ret = -ENOSYS;


