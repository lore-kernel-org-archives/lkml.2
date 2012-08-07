Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab2HGWaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:30:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964824Ab2HGWaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:30:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 058/122] s390/mm: fix fault handling for page table walk case
Date: Tue,  7 Aug 2012 15:25:46 -0700
Message-Id: <20120807221953.518580471@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/fault.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -443,6 +443,7 @@ int __handle_fault(unsigned long uaddr,
 	struct pt_regs regs;
 	int access, fault;
 
+	/* Emulate a uaccess fault from kernel mode. */
 	regs.psw.mask = psw_kernel_bits | PSW_MASK_DAT | PSW_MASK_MCHECK;
 	if (!irqs_disabled())
 		regs.psw.mask |= PSW_MASK_IO | PSW_MASK_EXT;
@@ -452,12 +453,12 @@ int __handle_fault(unsigned long uaddr,
 	regs.int_parm_long = (uaddr & PAGE_MASK) | 2;
 	access = write ? VM_WRITE : VM_READ;
 	fault = do_exception(&regs, access);
-	if (unlikely(fault)) {
-		if (fault & VM_FAULT_OOM)
-			return -EFAULT;
-		else if (fault & VM_FAULT_SIGBUS)
-			do_sigbus(&regs);
-	}
+	/*
+	 * Since the fault happened in kernel mode while performing a uaccess
+	 * all we need to do now is emulating a fixup in case "fault" is not
+	 * zero.
+	 * For the calling uaccess functions this results always in -EFAULT.
+	 */
 	return fault ? -EFAULT : 0;
 }
 


