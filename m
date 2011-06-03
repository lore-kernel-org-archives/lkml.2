Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1FCJY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:24:28 -0400
Received: from mail4.comsite.net ([205.238.176.238]:54707 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab1FCJY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:24:27 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: Re: genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Message-Id: <nack-locate@mdm.bga.com>
In-Reply-To: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Fri, 03 Jun 2011 04:24:02 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jun 2011 17:55:13 -0000, Mark Brown wrote:
> When irq_alloc_descs() is called with no base IRQ specified then it will
> search for a range of IRQs starting from a specified base address. In the
> case where an IRQ is specified it still does this search in order to ensure
> that none of the requested range is already allocated and it still uses the
> from parameter to specify the base for the search. This means that in the
> case where a base is specified but from is zero (which is reasonable as
> any IRQ number is in the range specified by a zero from) the function will
> get confused and try to allocate the first suitably sized block of free IRQs
> it finds.
> 
> Instead use a specified IRQ as the base address for the search, and insist
> that any from that is specified can support that IRQ.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> ---
> kernel/irq/irqdesc.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index 886e803..bb53d6c 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -346,6 +346,12 @@ irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
>  	if (!cnt)
>  		return -EINVAL;
>  
> +	if (irq >= 0) {
> +		if (from > irq)
> +			return -EINVAL;
> +		from = irq;
> +	}
> +
>  	mutex_lock(&sparse_irq_lock);
>  
>  	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,

and then right after this the code continues:

        ret = -EEXIST;
        if (irq >=0 && start != irq)
                goto err;


This patch enables exactly the calls I want to forbid !  Why do
you need to verify that there are no irqs between from and irq ?
What is your use case?

Change your caller to specify the irq twice if you need a specific irq
block, or if you only need one then use the helper irq_alloc_desc_at.

If you want to change irq_alloc_descs, please make it return -EINVAL
if irq >=0 && from != irq (like I did).

See http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/00739.html
[PATCH RFC 4/4] irq: allow a per-allocation upper limit when allocating irqs

(and yes, I have made the changes based on the feedback but haven't
had time to get back to the series).

Thanks,
milton
QUIT
