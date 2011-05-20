Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270Ab1ETP3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:29:11 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:31152 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934082Ab1ETP3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:29:08 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: u67qr4oVM1nzpqnCMrUU3CpaWJamRhHzc0ScRfq483EHPgt
 9.U3Lany.CVxhUHnghJyXPAvnQ4L6VFvsjefbbs_z5X10J60sFc3F5e17kDz
 rESy8tfT.8iCBp7oTdso4WPZX4GQu_7_ei8IloCcx9R52KR6mkovt5T5oWSo
 174beIy.bakT6t0IynJn2pM08aztrIdOciSvCMdXPYnhmOHGAHN7jN..AiSf
 FsXXGIsXd7SQERRX_Ax8ENCASXevzZn.kRaD.lQKXTMCler95EwUJTk2d48h
 63d68n3G3YMzsEcdPl4yrmLl9kY3xLHI3jv8AUXKSsb_8zipLKuAW70Pq2p0
 AFHL_nmX29zz7Mn.DULO9Zonm
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 20 May 2011 10:29:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: percpu: Fixup __this_cpu_xchg* operations
Message-ID: <alpine.DEB.2.00.1105201027000.5610@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has been in my tree for awhile now.


Subject: percpu: Fixup __this_cpu_xchg* operations

Somehow we got into a situation where the __this_cpu_xchg() operations were
not defined in the same way as this_cpu_xchg() and friends. I had some build
failures under 32 bit that were addressed by these fixes.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 arch/x86/include/asm/percpu.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2011-03-30 14:09:28.000000000 -0500
+++ linux-2.6/arch/x86/include/asm/percpu.h	2011-03-30 14:10:16.000000000 -0500
@@ -388,12 +388,9 @@ do {									\
 #define __this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
-/*
- * Generic fallback operations for __this_cpu_xchg_[1-4] are okay and much
- * faster than an xchg with forced lock semantics.
- */
-#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define __this_cpu_xchg_1(pcp, val)	percpu_xchg_op(pcp, val)
+#define __this_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
+#define __this_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)

 #define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -471,6 +468,7 @@ do {									\
 #define __this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
 #define this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
 #define irqsafe_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
+
 #endif /* CONFIG_X86_CMPXCHG64 */

 /*
@@ -485,6 +483,8 @@ do {									\
 #define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
+#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)

 #define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
