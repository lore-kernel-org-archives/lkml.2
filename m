Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964947Ab2HGDnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:43:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59850 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964814Ab2HGDi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:56 -0400
Message-Id: <20120807032801.806903120@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 39/70] s390/mm: fix fault handling for page table walk case
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 008c2e8f247f0a8db1e8e26139da12f3a3abcda0 upstream.

Make sure the kernel does not incorrectly create a SIGBUS signal during
user space accesses:

For user space accesses in the switched addressing mode case the kernel
may walk page tables and access user address space via the kernel
mapping. If a page table entry is invalid the function __handle_fault()
gets called in order to emulate a page fault and trigger all the usual
actions like paging in a missing page etc. by calling handle_mm_fault().

If handle_mm_fault() returns with an error fixup handling is necessary.
For the switched addressing mode case all errors need to be mapped to
-EFAULT, so that the calling uaccess function can return -EFAULT to
user space.

Unfortunately the __handle_fault() incorrectly calls do_sigbus() if
VM_FAULT_SIGBUS is set. This however should only happen if a page fault
was triggered by a user space instruction. For kernel mode uaccesses
the correct action is to only return -EFAULT.
So user space may incorrectly see SIGBUS signals because of this bug.

For current machines this would only be possible for the switched
addressing mode case in conjunction with futex operations.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[bwh: Backported to 3.2: do_exception() and do_sigbus() parameters differ]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/mm/fault.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -453,6 +453,7 @@ int __handle_fault(unsigned long uaddr,
 	struct pt_regs regs;
 	int access, fault;
 
+	/* Emulate a uaccess fault from kernel mode. */
 	regs.psw.mask = psw_kernel_bits | PSW_MASK_DAT | PSW_MASK_MCHECK;
 	if (!irqs_disabled())
 		regs.psw.mask |= PSW_MASK_IO | PSW_MASK_EXT;
@@ -461,12 +462,12 @@ int __handle_fault(unsigned long uaddr,
 	uaddr &= PAGE_MASK;
 	access = write ? VM_WRITE : VM_READ;
 	fault = do_exception(&regs, access, uaddr | 2);
-	if (unlikely(fault)) {
-		if (fault & VM_FAULT_OOM)
-			return -EFAULT;
-		else if (fault & VM_FAULT_SIGBUS)
-			do_sigbus(&regs, pgm_int_code, uaddr);
-	}
+	/*
+	 * Since the fault happened in kernel mode while performing a uaccess
+	 * all we need to do now is emulating a fixup in case "fault" is not
+	 * zero.
+	 * For the calling uaccess functions this results always in -EFAULT.
+	 */
 	return fault ? -EFAULT : 0;
 }
 


