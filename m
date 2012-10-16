Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab2JPMu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:50:27 -0400
Received: from relay1.sgi.com ([192.48.179.29]:47841 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab2JPMuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:50:24 -0400
Date: Tue, 16 Oct 2012 07:50:21 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
Message-ID: <20121016125021.GA22935@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Posting this patch to fix an issue concerning sparse irq's that I raised
a while back.  There was discussion about adding refcounting to sparse
irqs (to fix other potential race conditions), but that does not appear to
have been addressed yet.  This covers the only issue of this type that I've
encountered in this area.




A NULL pointer dereference can occur in smp_irq_move_cleanup_interrupt() if
we haven't yet setup the irq_cfg pointer in the irq_desc.irq_data.chip_data.

In create_irq_nr() there is a window where we have set vector_irq in
__assign_irq_vector(), but not yet called irq_set_chip_data() to set the
irq_cfg pointer.

Should an IRQ_MOVE_CLEANUP_VECTOR hit the cpu in question during this time,
smp_irq_move_cleanup_interrupt() will attempt to process the aforementioned
irq, but panic when accessing irq_cfg.

Only continue processing the irq if irq_cfg is non-NULL.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/kernel/apic/io_apic.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c
+++ linux/arch/x86/kernel/apic/io_apic.c
@@ -2257,6 +2257,9 @@ asmlinkage void smp_irq_move_cleanup_int
 			continue;
 
 		cfg = irq_cfg(irq);
+		if (!cfg)
+			continue;
+
 		raw_spin_lock(&desc->lock);
 
 		/*
