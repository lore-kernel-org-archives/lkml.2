Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab2EUVTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:19:24 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57087 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759238Ab2EUVTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:19:21 -0400
Date: Mon, 21 May 2012 16:19:17 -0500
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
Message-ID: <20120521211917.GA25567@sgi.com>
References: <20120521164959.GE16454@sgi.com>
 <alpine.LFD.2.02.1205212304580.3231@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205212304580.3231@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:07:04PM +0200, Thomas Gleixner wrote:
> On Mon, 21 May 2012, Dimitri Sivanich wrote:
> 
> > The smp_irq_move_cleanup_interrupt routine should be checking for a valid
> > irq_cfg pointer prior to accessing it.  It also seems that this should be
> > done after taking the desc lock.
> 
> It seems that you either missed or failed to explain why it should be
> done _after_ taking the lock.
> 
> Changelogs matter, really.
>
How about this?


The smp_irq_move_cleanup_interrupt routine should be checking for a valid
irq_cfg pointer prior to accessing it.

Follow the same protocol shown in irq_set_chip_data(), by taking the desc
lock before accessing this location.

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
