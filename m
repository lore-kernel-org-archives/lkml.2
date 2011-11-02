Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015Ab1KCBin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:38:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933857Ab1KCBij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:38:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:41 2011
Message-Id: <20111102222740.954115104@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:25:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Igor Mammedov <imammedo@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [014/101] xen: x86_32: do not enable iterrupts when returning from exception in interrupt context
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Igor Mammedov <imammedo@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/xen-asm_32.S |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

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


