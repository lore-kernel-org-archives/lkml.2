Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0JVLMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:12:23 -0400
Received: from www.tglx.de ([62.245.132.106]:55206 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab0JVLMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:12:21 -0400
Date: Fri, 22 Oct 2010 13:12:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Weinberger <richard@nod.at>
cc: peterz@infradead.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: User Mode Linux broken
In-Reply-To: <ed248baebfad9b050f53a6832435a9a5@radon2.swed.at>
Message-ID: <alpine.LFD.2.00.1010221309370.3345@localhost6.localdomain6>
References: <201010211315.26679.richard@nod.at> <201010212122.38437.richard@nod.at> <alpine.LFD.2.00.1010212143300.3467@localhost6.localdomain6> <201010212227.12919.richard@nod.at> <alpine.LFD.2.00.1010220900230.3467@localhost6.localdomain6>
 <ed248baebfad9b050f53a6832435a9a5@radon2.swed.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Richard Weinberger wrote:

> On Fri, 22 Oct 2010 09:03:44 +0200 (CEST), Thomas Gleixner
> <tglx@linutronix.de> wrote:
> > On Thu, 21 Oct 2010, Richard Weinberger wrote:
> >> Am Donnerstag 21 Oktober 2010, 21:45:35 schrieb Thomas Gleixner:
> >> > Why shold it solve it ? irq_enable is set to compat_irq_enable which
> >> > in turn calls chip->enable.
> >> >
> >> > So how's that different ?
> >>
> >> I took a closer look on the issue.
> >>
> >> check_irq_resend() gets called before irq_chip_set_defaults().
> >> In the first call to check_irq_resend() desc->irq_data.chip->irq_enable is
> >> NULL. UML dies due to a NULL-pointer dereference...
> >>
> >> I don't know why check_irq_resend() is called before irq_chip_set_defaults().
> >> It's your code. ;-)
> > 
> > Well, but it only gets called via enable_irq(). So that means
> > something is calling enable_irq _before_ request/setup_irq().
> > 
> > arch/um/kernel/irq.c:init_IRQ() does that :)
> 
> Sorry I'm not very familiar with the IRQ stuff.
> Does that mean init_IRQ() is not allowed to call enable_irq()?

Well, nothing is supposed to call enable_irq() before an interrupt is
installed with request_irq() or setup_irq().

Patch below should fix your problem.

Thanks,

	tglx
---
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index a746e30..6abc1af 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -395,7 +395,6 @@ void __init init_IRQ(void)
 	irq_desc[TIMER_IRQ].action = NULL;
 	irq_desc[TIMER_IRQ].depth = 1;
 	irq_desc[TIMER_IRQ].chip = &SIGVTALRM_irq_type;
-	enable_irq(TIMER_IRQ);
 	for (i = 1; i < NR_IRQS; i++) {
 		irq_desc[i].status = IRQ_DISABLED;
 		irq_desc[i].action = NULL;
