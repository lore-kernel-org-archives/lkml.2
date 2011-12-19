Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1LSCG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 21:06:59 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:39390 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1LSCGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 21:06:55 -0500
Message-ID: <1324260407.3006.17.camel@ThinkPad-T61>
Subject: [PATCH powerpc] fix unpaired __trace_hcall_entry and
 __trace_hcall_exit
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        Anton Blanchard <anton@samba.org>
Date: Mon, 19 Dec 2011 10:06:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121816-5140-0000-0000-000000704181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unpaired calling of __trace_hcall_entry and __trace_hcall_exit could
cause incorrect preempt count. And it might happen as the global
variable hcall_tracepoint_refcount is checked separately before calling
them. 

I don't know much about the powerpc arch. But the idea here is to store
the hcall_tracepoint_refcount locally, so __trace_hcall_entry and
__trace_hcall_exit will be called or not called in pair by checking the
same value. 

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/hvCall.S |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
index fd05fde..1240bd2 100644
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -14,6 +14,7 @@
 #include <asm/ptrace.h>
 	
 #define STK_PARM(i)     (48 + ((i)-3)*8)
+#define REG_SIZE        (2*8)
 
 #ifdef CONFIG_TRACEPOINTS
 
@@ -32,11 +33,12 @@ hcall_tracepoint_refcount:
  * unconditional cpu feature.
  */
 #define HCALL_INST_PRECALL(FIRST_REG)				\
+	std	r31,-8(r1);					\
 BEGIN_FTR_SECTION;						\
 	b	1f;						\
 END_FTR_SECTION(0, 1);						\
-	ld      r12,hcall_tracepoint_refcount@toc(r2);		\
-	cmpdi	r12,0;						\
+	ld      r31,hcall_tracepoint_refcount@toc(r2);		\
+	cmpdi	r31,0;						\
 	beq+	1f;						\
 	mflr	r0;						\
 	std	r3,STK_PARM(r3)(r1);				\
@@ -49,9 +51,9 @@ END_FTR_SECTION(0, 1);						\
 	std	r10,STK_PARM(r10)(r1);				\
 	std	r0,16(r1);					\
 	addi	r4,r1,STK_PARM(FIRST_REG);			\
-	stdu	r1,-STACK_FRAME_OVERHEAD(r1);			\
+	stdu	r1,-STACK_FRAME_OVERHEAD-REG_SIZE(r1);		\
 	bl	.__trace_hcall_entry;				\
-	addi	r1,r1,STACK_FRAME_OVERHEAD;			\
+	addi	r1,r1,STACK_FRAME_OVERHEAD+REG_SIZE;		\
 	ld	r0,16(r1);					\
 	ld	r3,STK_PARM(r3)(r1);				\
 	ld	r4,STK_PARM(r4)(r1);				\
@@ -74,8 +76,7 @@ END_FTR_SECTION(0, 1);						\
 BEGIN_FTR_SECTION;						\
 	b	1f;						\
 END_FTR_SECTION(0, 1);						\
-	ld      r12,hcall_tracepoint_refcount@toc(r2);		\
-	cmpdi	r12,0;						\
+	cmpdi	r31,0;						\
 	beq+	1f;						\
 	mflr	r0;						\
 	ld	r6,STK_PARM(r3)(r1);				\
@@ -83,13 +84,14 @@ END_FTR_SECTION(0, 1);						\
 	mr	r4,r3;						\
 	mr	r3,r6;						\
 	std	r0,16(r1);					\
-	stdu	r1,-STACK_FRAME_OVERHEAD(r1);			\
+	stdu	r1,-STACK_FRAME_OVERHEAD-REG_SIZE(r1);		\
 	bl	.__trace_hcall_exit;				\
-	addi	r1,r1,STACK_FRAME_OVERHEAD;			\
+	addi	r1,r1,STACK_FRAME_OVERHEAD+REG_SIZE;		\
 	ld	r0,16(r1);					\
 	ld	r3,STK_PARM(r3)(r1);				\
 	mtlr	r0;						\
-1:
+1:								\
+	ld	r31,-8(r1);
 
 #define HCALL_INST_POSTCALL_NORETS				\
 	li	r5,0;						\
-- 
1.7.5.4

