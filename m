Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab2JWWg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:36:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:47473 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2JWWgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:36:53 -0400
Date: Wed, 24 Oct 2012 00:36:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Hilman <khilman@deeprootsystems.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] genirq: provide means to retrigger parent
In-Reply-To: <871ugo7rqv.fsf@deeprootsystems.com>
Message-ID: <alpine.LFD.2.02.1210240033310.2756@ionos>
References: <1350425269-11489-1-git-send-email-khilman@deeprootsystems.com> <20121016221502.GY28061@n2100.arm.linux.org.uk> <871ugo7rqv.fsf@deeprootsystems.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Kevin Hilman wrote:

> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> 
> > On Tue, Oct 16, 2012 at 03:07:49PM -0700, Kevin Hilman wrote:
> >> From: Thomas Gleixner <tglx@linutronix.de>
> >> 
> >> Attempts to retrigger nested threaded IRQs currently fail because they
> >> have no primary handler.  In order to support retrigger of nested
> >> IRQs, the parent IRQ needs to be retriggered.
> >> 
> >> To fix, when an IRQ needs to be resent, if the interrupt has a parent
> >> IRQ and runs in the context of the parent IRQ, then resend the parent.
> >> 
> >> Also, handle_nested_irq() needs to clear the replay flag like the
> >> other handlers, otherwise check_irq_resend() will set it and it will
> >> never be cleared.  Without clearing, it results in the first resend
> >> working fine, but check_irq_resend() returning early on subsequent
> >> resends because the replay flag is still set.
> >> 
> >> Problem discovered on ARM/OMAP platforms where a nested IRQ that's
> >> also a wakeup IRQ happens late in suspend and needed to be retriggered
> >> during the resume process.
> >> 
> >> Reported-by: Kevin Hilman <khilman@ti.com>
> >> Tested-by: Kevin Hilman <khilman@ti.com>
> >> [khilman@ti.com: changelog edits, clear IRQS_REPLAY in handle_nested_irq()]
> >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >
> > Umm, we also have the converse situation.  We have platforms where the
> > resend has to be done from the child IRQ, and the parent must not be
> > touched.  I hope that doesn't break those.
> 
> I'm assuming the child IRQs you're concerned with are not threaded,
> right?  This patch only addresses nested, threaded IRQs, and these don't
> have a primary handler to run at all, so cannot do any triggering.

And it involves that you activly set the parent irq via the new
interface: irq_set_parent()

You don't have that yet or you don't use that in your future changes,
then you're good. :)

Thanks,

	tglx


