Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0LMTe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:34:56 -0500
Received: from claw.goop.org ([74.207.240.146]:55580 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab0LMTez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:34:55 -0500
Message-ID: <4D06755C.2050200@goop.org>
Date: Mon, 13 Dec 2010 11:34:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xensource.com, Jan Beulich <JBeulich@novell.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 4/9] xen: Add support to check if IRQ line is shared with
 other domains.
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com> <1292263303-31680-5-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1292263303-31680-5-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 10:01 AM, Konrad Rzeszutek Wilk wrote:
> We do this via the PHYSDEVOP_irq_status_query support hypervisor call.
> We will get a positive value if another domain has binded its
> PIRQ to the specified IRQ line.
>
> [v2: Deal with v2.6.37-rc1 rebase fallout]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/events.c |   13 +++++++++++++
>  include/xen/events.h |    3 +++
>  2 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 96c93e7..690dfad 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -1398,6 +1398,19 @@ void xen_poll_irq(int irq)
>  	xen_poll_irq_timeout(irq, 0 /* no timeout */);
>  }
>  
> +/* Check whether the IRQ line is shared with other guests. */
> +int xen_ignore_irq(int irq)

I think this could do with a better name.  The function actually testing
for sharing; the fact you might choose to ignore it because its shared
is by the by (and becomes very misleading if you end up wanting to test
for sharedness for some other reason).

> +{
> +	struct irq_info *info = info_for_irq(irq);
> +	struct physdev_irq_status_query irq_status = { .irq =
> +							info->u.pirq.gsi };

That's a pretty awkward linebreak.

    J

> +
> +	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
> +		return 0;
> +	return !(irq_status.flags & XENIRQSTAT_shared);
> +}
> +EXPORT_SYMBOL_GPL(xen_ignore_irq);
> +
>  void xen_irq_resume(void)
>  {
>  	unsigned int cpu, irq, evtchn;
> diff --git a/include/xen/events.h b/include/xen/events.h
> index 646dd17..553c664 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -89,4 +89,7 @@ int xen_vector_from_irq(unsigned pirq);
>  /* Return gsi allocated to pirq */
>  int xen_gsi_from_irq(unsigned pirq);
>  
> +/* Determine whether to ignore this IRQ if passed to a guest. */
> +int xen_ignore_irq(int irq);
> +
>  #endif	/* _XEN_EVENTS_H */

