Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab1ANUGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 15:06:42 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:27436 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1ANUGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 15:06:41 -0500
Subject: Re: [PATCH 1/2] genirq: Add IRQ affinity notifiers
From: Ben Hutchings <bhutchings@solarflare.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, Tom Herbert <therbert@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-net-drivers@solarflare.com
In-Reply-To: <alpine.LFD.2.00.1101141928210.2678@localhost6.localdomain6>
References: <1294169842.3636.31.camel@bwh-desktop>
	 <1294169919.3636.33.camel@bwh-desktop>
	 <alpine.LFD.2.00.1101141928210.2678@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 14 Jan 2011 20:06:37 +0000
Message-ID: <1295035597.5386.8.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2011 20:06:40.0567 (UTC) FILETIME=[8EAD4C70:01CBB426]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17892.005
X-TM-AS-Result: No--30.658600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 20:47 +0100, Thomas Gleixner wrote:
> On Tue, 4 Jan 2011, Ben Hutchings wrote:
> > +/**
> > + * struct irq_affinity_notify - context for notification of IRQ affinity changes
> > + * @irq:		Interrupt to which notification applies
> > + * @kref:		Reference count, for internal use
> > + * @work:		Work item, for internal use
> > + * @notify:		Function to be called on change.  This will be
> > + *			called in process context.
> > + * @release:		Function to be called on release.  This will be
> > + *			called in process context.  Once registered, the
> > + *			structure must only be freed when this function is
> > + *			called or later.
> > + */
> > +struct irq_affinity_notify {
> > +        unsigned int irq;
> > +        struct kref kref;
> > +#if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
> 
> The whole affinity thing is SMP and GENERIC_HARDIRQS only anyway, so
> what's the point of this ifdeffery ?

The intent is that code using this can be compiled even if those config
options are not set.  The work_struct is not needed in that case.  I
think this is probably pointless though.

> > +        struct work_struct work;
> > +#endif
> > +        void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
> > +        void (*release)(struct kref *ref);
> > +};
> > +
> 
> > +/**
> > + *	irq_set_affinity_notifier - control notification of IRQ affinity changes
> > + *	@irq:		Interrupt for which to enable/disable notification
> > + *	@notify:	Context for notification, or %NULL to disable
> > + *			notification.  Function pointers must be initialised;
> > + *			the other fields will be initialised by this function.
> > + *
> > + *	Must be called in process context.  Notification may only be enabled
> > + *	after the IRQ is allocated but before it is bound with request_irq()
> 
> Why? And if there is that restriction, then it needs to be
> checked. But I don't see why this is necessary.

Which restriction?

> > + *	and must be disabled before the IRQ is freed using free_irq().
> > + */
> 
> > +#ifdef CONFIG_SMP
> > +	BUG_ON(desc->affinity_notify);
> 
> We should be nice here and just WARN and fixup the wreckage by
> uninstalling it.

OK.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

