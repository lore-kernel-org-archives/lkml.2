Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2HOUcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:32:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:36515 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab2HOTtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Igor Mammedov <imammedo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 032/165] xen: x86_32: do not enable iterrupts when returning from exception in interrupt context
Date: Wed, 15 Aug 2012 15:46:16 -0400
Message-ID: <1345060109-9187-33-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Igor Mammedov <imammedo@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d198d499148a0c64a41b3aba9e7dd43772832b91 upstream.

If vmalloc page_fault happens inside of interrupt handler with interrupts
disabled then on exit path from exception handler when there is no pending
interrupts, the following code (arch/x86/xen/xen-asm_32.S:112):

	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
	sete XEN_vcpu_info_mask(%eax)

will enable interrupts even if they has been previously disabled according to
eflags from the bounce frame (arch/x86/xen/xen-asm_32.S:99)

	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
	setz XEN_vcpu_info_mask(%eax)

Solution is in setting XEN_vcpu_info_mask only when it should be set
according to
	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
but not clearing it if there isn't any pending events.

Reproducer for bug is attached to RHBZ 707552

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/xen/xen-asm_32.S | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index 22a2093..b040b0e 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -113,11 +113,13 @@ xen_iret_start_crit:
 
 	/*
 	 * If there's something pending, mask events again so we can
-	 * jump back into xen_hypervisor_callback
+	 * jump back into xen_hypervisor_callback. Otherwise do not
+	 * touch XEN_vcpu_info_mask.
 	 */
-	sete XEN_vcpu_info_mask(%eax)
+	jne 1f
+	movb $1, XEN_vcpu_info_mask(%eax)
 
-	popl %eax
+1:	popl %eax
 
 	/*
 	 * From this point on the registers are restored and the stack
-- 
1.7.12.rc2

