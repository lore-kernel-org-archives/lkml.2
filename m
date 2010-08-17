Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab0HQPLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:11:55 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:26924 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260Ab0HQPLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:11:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAOtCakzCTtAn/2dsb2JhbACTJ40WccAthTcEiWc
Date: Tue, 17 Aug 2010 17:11:42 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org
Subject: [PATCH] m68knommu : Fix strace support for 68328/68360
Message-ID: <20100817151142.GA11940@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strace is enabled using the `flags' field of the `thread_info' struct.
68360 version of entry.S did test a wrong bit in a wrong structure
(task_struct).
68328 version of entry.S did test the right bit in the right structure,
but wrongly, because the `flags' field is 32 bit wide, while the used
assembler insn (btst) only accesses a 8 bit byte in memory.

Fix both using code already used in the coldfire version of entry.S
Also fix some spaces/tabs issues.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 arch/m68knommu/platform/68328/entry.S |   16 ++++++++--------
 arch/m68knommu/platform/68360/entry.S |    7 ++++++-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/m68knommu/platform/68328/entry.S b/arch/m68knommu/platform/68328/entry.S
index 9d80d2c..74229f7 100644
--- a/arch/m68knommu/platform/68328/entry.S
+++ b/arch/m68knommu/platform/68328/entry.S
@@ -43,7 +43,7 @@ badsys:
 	jra	ret_from_exception
 
 do_trace:
-	movel	#-ENOSYS,%sp@(PT_OFF_D0)	/* needed for strace*/
+	movel	#-ENOSYS,%sp@(PT_OFF_D0) /* needed for strace*/
 	subql	#4,%sp
 	SAVE_SWITCH_STACK
 	jbsr	syscall_trace
@@ -57,7 +57,7 @@ do_trace:
 	lea	sys_call_table, %a0
 	jbsr	%a0@(%d1)
 
-1:	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value */
+1:	movel	%d0,%sp@(PT_OFF_D0)	/* save the return value */
 	subql	#4,%sp			/* dummy return address */
 	SAVE_SWITCH_STACK
 	jbsr	syscall_trace
@@ -71,16 +71,16 @@ ENTRY(system_call)
 	SAVE_ALL
 
 	/* save top of frame*/
-	pea     %sp@
-	jbsr    set_esp0
-	addql   #4,%sp
+	pea	%sp@
+	jbsr	set_esp0
+	addql	#4,%sp
 
 	movel	%sp@(PT_OFF_ORIG_D0),%d0
 
 	movel	%sp,%d1			/* get thread_info pointer */
 	andl	#-THREAD_SIZE,%d1
 	movel	%d1,%a2
-	btst    #TIF_SYSCALL_TRACE,%a2@(TI_FLAGS)
+	btst	#(TIF_SYSCALL_TRACE%8),%a2@(TI_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
 	jne	do_trace
 	cmpl	#NR_syscalls,%d0
 	jcc	badsys
@@ -88,10 +88,10 @@ ENTRY(system_call)
 	lea	sys_call_table,%a0
 	movel	%a0@(%d0), %a0
 	jbsr	%a0@
-	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value*/
+	movel	%d0,%sp@(PT_OFF_D0)	/* save the return value*/
 
 ret_from_exception:
-	btst	#5,%sp@(PT_OFF_SR)		/* check if returning to kernel*/
+	btst	#5,%sp@(PT_OFF_SR)	/* check if returning to kernel*/
 	jeq	Luser_return		/* if so, skip resched, signals*/
 
 Lkernel_return:
diff --git a/arch/m68knommu/platform/68360/entry.S b/arch/m68knommu/platform/68360/entry.S
index 6d3460a..d5ad408 100644
--- a/arch/m68knommu/platform/68360/entry.S
+++ b/arch/m68knommu/platform/68360/entry.S
@@ -71,7 +71,12 @@ ENTRY(system_call)
 	jbsr	set_esp0
 	addql	#4,%sp
 
-	btst	#PF_TRACESYS_BIT,%a2@(TASK_FLAGS+PF_TRACESYS_OFF)
+	movel	%sp@(PT_OFF_ORIG_D0),%d0
+
+	movel	%sp,%d1			/* get thread_info pointer */
+	andl	#-THREAD_SIZE,%d1
+	movel	%d1,%a2
+	btst	#(TIF_SYSCALL_TRACE%8),%a2@(TI_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
 	jne	do_trace
 	cmpl	#NR_syscalls,%d0
 	jcc	badsys
-- 
1.6.3.3

