Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732Ab2EWSQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:16:39 -0400
Received: from relay1.sgi.com ([192.48.179.29]:48826 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab2EWSQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:16:38 -0400
Date: Wed, 23 May 2012 13:16:36 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
Message-ID: <20120523181636.GA2032@sgi.com>
References: <20120521164959.GE16454@sgi.com>
 <alpine.LFD.2.02.1205212304580.3231@ionos>
 <20120521211917.GA25567@sgi.com>
 <alpine.LFD.2.02.1205212324260.3231@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205212324260.3231@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:34:32PM +0200, Thomas Gleixner wrote:
> Don't misunderstand me. The patch is correct, just the explanation
> sucks.
> 
Hopefully this explanation is descriptive enough.



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
 arch/x86/kernel/apic/io_apic.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c
+++ linux/arch/x86/kernel/apic/io_apic.c
@@ -2478,9 +2478,12 @@ asmlinkage void smp_irq_move_cleanup_int
 		if (!desc)
 			continue;
 
-		cfg = irq_cfg(irq);
 		raw_spin_lock(&desc->lock);
 
+		cfg = irq_cfg(irq);
+		if (!cfg)
+			goto unlock;
+
 		/*
 		 * Check if the irq migration is in progress. If so, we
 		 * haven't received the cleanup request yet for this irq.
