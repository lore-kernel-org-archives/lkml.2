Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab0HQRHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:07:19 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:6140 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757321Ab0HQRHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:07:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOldakzCTtAn/2dsb2JhbACgPnHBS4U3BIln
Date: Tue, 17 Aug 2010 18:58:29 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org
Subject: [PATCH] m68knommu : Fix strace support for 68328/68360
Message-ID: <20100817165829.GA17086@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68knommu : Fix strace support for 68328/68360

strace enabled is marked using the `flags' field of the `thread_info' struct.
68360 version of entry.S did test a wrong bit in a wrong structure
(task_struct).
68328 version of entry.S did test the right bit in the right structure,
but wrongly, because the `flags' field is 32 bit wide, while the used
assembler insn (btst) only accesses a 8 bit byte in memory.

Fix both using code already used in the coldfire version of entry.S

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
diff --git a/arch/m68knommu/platform/68328/entry.S b/arch/m68knommu/platform/68328/entry.S
index 9d80d2c..74229f7 100644
--- a/arch/m68knommu/platform/68328/entry.S
+++ b/arch/m68knommu/platform/68328/entry.S
@@ -80,7 +80,7 @@ ENTRY(system_call)
 	movel	%sp,%d1			/* get thread_info pointer */
 	andl	#-THREAD_SIZE,%d1
 	movel	%d1,%a2
-	btst    #TIF_SYSCALL_TRACE,%a2@(TI_FLAGS)
+	btst	#(TIF_SYSCALL_TRACE%8),%a2@(TI_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
 	jne	do_trace
 	cmpl	#NR_syscalls,%d0
 	jcc	badsys
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
Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
