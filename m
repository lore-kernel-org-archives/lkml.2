Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1HaVsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:48:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab1HaVsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:48:23 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com
Subject: [PATCH] xen: x86_32: do not enable iterrupts when returning from exception in interrupt context
Date: Thu,  1 Sep 2011 01:47:18 +0200
Message-Id: <1314834438-3181-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <20110829194633.GB16530@dumpdata.com>
References: <20110829194633.GB16530@dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/xen/xen-asm_32.S |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index 22a2093..313dca7 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -113,10 +113,14 @@ xen_iret_start_crit:
 
 	/*
 	 * If there's something pending, mask events again so we can
-	 * jump back into xen_hypervisor_callback
+	 * jump back into xen_hypervisor_callback. Otherwise do not
+	 * touch XEN_vcpu_info_mask.
 	 */
+	jne ignore_vcpu_info_mask
 	sete XEN_vcpu_info_mask(%eax)
 
+ignore_vcpu_info_mask:
+
 	popl %eax
 
 	/*
-- 
1.7.1

