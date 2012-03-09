Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2CIQRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:17:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:46702 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab2CIQRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:17:18 -0500
Date: Fri, 9 Mar 2012 17:17:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] genirq: Get rid of unnecessary IRQTF_DIED flag
In-Reply-To: <20120309150612.GA7353@redhat.com>
Message-ID: <alpine.LFD.2.02.1203091716260.2742@ionos>
References: <20120309135958.GD2114@dhcp-26-207.brq.redhat.com> <20120309150612.GA7353@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, Oleg Nesterov wrote:

> Of course I can't ack this, but afaics the whole series looks fine.
> 
> Only one minor nit,
> 
> On 03/09, Alexander Gordeev wrote:
> >
> > --- a/kernel/irq/handle.c
> > +++ b/kernel/irq/handle.c
> > @@ -60,8 +60,8 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
> >  	 * device interrupt, so no irq storm is lurking. If the
> >  	 * RUNTHREAD bit is already set, nothing to do.
> >  	 */
> > -	if (test_bit(IRQTF_DIED, &action->thread_flags) ||
> > -	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
> > +	if (test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags) ||
> > +	    (action->thread->flags & PF_EXITING))
> >  		return;
> 
> perhaps it makes sense to check PF_EXITING first, we do not want
> to set IRQTF_RUNTHREAD in this case. I think this doesn't really
> matter (and the check is obviously racy anyway), just looks a bit
> confusing.

It does not matter, the thread cleans it up in the exit path. So it's
mostly cosmetic, but you are right, it reads better :)
