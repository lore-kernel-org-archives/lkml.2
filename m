Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab2EUQuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:50:03 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54435 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912Ab2EUQuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:50:01 -0400
Date: Mon, 21 May 2012 11:49:59 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
Message-ID: <20120521164959.GE16454@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The smp_irq_move_cleanup_interrupt routine should be checking for a valid
irq_cfg pointer prior to accessing it.  It also seems that this should be
done after taking the desc lock.

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
