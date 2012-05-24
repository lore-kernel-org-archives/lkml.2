Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab2EXXmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:42:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:59300 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2EXXmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:42:21 -0400
Date: Fri, 25 May 2012 01:42:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, arnd@arndb.de, horms@verge.net.au,
        linux-sh@vger.kernel.org, johnstul@us.ibm.com, rjw@sisk.pl,
        lethal@linux-sh.org, gregkh@linuxfoundation.org, olof@lixom.net
Subject: Re: [PATCH 02/03] clocksource: em_sti: Emma Mobile STI driver V2
In-Reply-To: <20120509143942.27521.8595.sendpatchset@w520>
Message-ID: <alpine.LFD.2.02.1205250135340.3231@ionos>
References: <20120509143926.27521.20342.sendpatchset@w520> <20120509143942.27521.8595.sendpatchset@w520>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Magnus Damm wrote:
> +static irqreturn_t em_sti_interrupt(int irq, void *dev_id)
> +{
> +	struct em_sti_priv *p = dev_id;
> +
> +	/* Always regprogram timer compare A */
> +	if (p->ced.mode == CLOCK_EVT_MODE_PERIODIC)
> +		em_sti_update(p);

Why do you want to do that? The core code already handles timers which
only support oneshot mode.

> +	spin_lock_irqsave(&p->lock, flags);

Please make that a raw_spinlock.

> +static void em_sti_clock_event_mode(enum clock_event_mode mode,
> +				    struct clock_event_device *ced)
> +{
> +	struct em_sti_priv *p = ced_to_em_sti(ced);
> +
> +	/* deal with old setting first */
> +	switch (ced->mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		em_sti_stop(p, USER_CLOCKEVENT);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		dev_info(&p->pdev->dev, "used for periodic clock events\n");
> +		em_sti_start(p, USER_CLOCKEVENT);
> +		clockevents_config(&p->ced, p->rate);
> +		p->delta = (p->rate + HZ/2) / HZ;
> +		p->next = em_sti_count(p);
> +		em_sti_update(p);
> +		break;

All that code in this case can go away.

> +static void em_sti_register_clockevent(struct em_sti_priv *p)
> +{
> +	struct clock_event_device *ced = &p->ced;
> +
> +	memset(ced, 0, sizeof(*ced));
> +	ced->name = dev_name(&p->pdev->dev);
> +	ced->features = CLOCK_EVT_FEAT_PERIODIC;
> +	ced->features |= CLOCK_EVT_FEAT_ONESHOT;

If you make that:

	ced->features = CLOCK_EVT_FEAT_ONESHOT;

Thanks,

	tglx
