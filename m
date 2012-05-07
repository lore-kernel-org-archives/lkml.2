Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab2EGTKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:10:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:41623 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602Ab2EGTKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:10:12 -0400
Date: Mon, 7 May 2012 21:10:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, horms@verge.net.au, arnd@arndb.de,
        linux-sh@vger.kernel.org, johnstul@us.ibm.com, rjw@sisk.pl,
        lethal@linux-sh.org, gregkh@linuxfoundation.org, olof@lixom.net
Subject: Re: [PATCH] clocksource: em_sti: Emma Mobile STI driver
In-Reply-To: <20120503125611.4314.52231.sendpatchset@w520>
Message-ID: <alpine.LFD.2.02.1205072054130.6271@ionos>
References: <20120503125611.4314.52231.sendpatchset@w520>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2012, Magnus Damm wrote:
> +/* private flags */
> +#define FLAG_CLOCKEVENT (1 << 0)
> +#define FLAG_CLOCKSOURCE (1 << 1)
> +
> +static int em_sti_start(struct em_sti_priv *p, unsigned long flag)
> +{
> +	int ret = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&p->lock, flags);
> +
> +	if (!(p->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE)))
> +		ret = em_sti_enable(p);

That's confusing. You seem to enable both CLOCKEVENT and CLOCKSOURCE
independent of "flag" value.

> +
> +	if (!ret)
> +		p->flags |= flag;

And then just or "flag" ??????

> +	spin_unlock_irqrestore(&p->lock, flags);
> +
> +	return ret;
> +}
> +
> +static void em_sti_stop(struct em_sti_priv *p, unsigned long flag)
> +{
> +	unsigned long flags;
> +	unsigned long f;
> +
> +	spin_lock_irqsave(&p->lock, flags);
> +
> +	f = p->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE);
> +	p->flags &= ~flag;
> +
> +	if (f && !(p->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE)))
> +		em_sti_disable(p);

Huch? If the caller wants to disable the clockevent, you stop the
clocksource as well because em_sti_disable() stops the clock.

/me is confused.

> +static void em_sti_clock_event_start(struct em_sti_priv *p)
> +{
> +	struct clock_event_device *ced = &p->ced;
> +
> +	em_sti_start(p, FLAG_CLOCKEVENT);
> +
> +	/* TODO: calculate good shift from rate and counter bit width */
> +
> +	ced->shift = 32;
> +	ced->mult = div_sc(p->rate, NSEC_PER_SEC, ced->shift);

IIRC, we have a generic function to do that :)

Thanks,

	tglx
