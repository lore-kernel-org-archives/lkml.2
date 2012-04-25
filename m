Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab2DYIuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:50:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:38054 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab2DYIuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:50:22 -0400
Date: Wed, 25 Apr 2012 10:50:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: NeilBrown <neilb@suse.de>
cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/3] IRQ: allow check_wakeup_irqs to notice level-triggered
 interrupts.
In-Reply-To: <20120425030524.7832.85239.stgit@notabene.brown>
Message-ID: <alpine.LFD.2.02.1204251018530.2542@ionos>
References: <20120425025637.7832.14013.stgit@notabene.brown> <20120425030524.7832.85239.stgit@notabene.brown>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012, NeilBrown wrote:

> Level triggered interrupts do not cause IRQS_PENDING to be set, so
> check_wakeup_irqs ignores them.
> They don't need to set IRQS_PENDING as the level stays high which
> shows that they must be pending.  However if such an interrupt fired
> during late suspend, it will have been masked so the fact that it
> is still asserted will not cause the suspend to abort.
> 
> So if any wakeup interrupt is masked, unmask it when checking wakeup
> irqs.  If the interrupt is asserted, suspend will abort.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
> 
>  kernel/irq/pm.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> index 15e53b1..0d26206 100644
> --- a/kernel/irq/pm.c
> +++ b/kernel/irq/pm.c
> @@ -106,6 +106,12 @@ int check_wakeup_irqs(void)
>  		if (irqd_is_wakeup_set(&desc->irq_data)) {
>  			if (desc->istate & IRQS_PENDING)
>  				return -EBUSY;
> +			if (irqd_irq_masked(&desc->irq_data))
> +				/* Probably a level interrupt
> +				 * which fired recently and was
> +				 * masked
> +				 */
> +				unmask_irq(desc);

Oh no. We don't unmask unconditionally. What about an interrupt which
is disabled, has no handler ..... ? That needs more thought.

Thanks,

	tglx
