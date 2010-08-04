Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab0HDMNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:13:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47883 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab0HDMND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:13:03 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, Iranna D Ankad <iranna.ankad@in.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>
	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>
	<m11vagw2fl.fsf@fess.ebiederm.org> <4C57CD9C.70602@kernel.org>
	<m1fwywoz0f.fsf@fess.ebiederm.org> <4C57DACF.1090503@kernel.org>
	<m17hk8oy5g.fsf@fess.ebiederm.org> <4C57E32A.9070401@kernel.org>
	<m18w4onebi.fsf@fess.ebiederm.org> <4C5871BC.4070007@kernel.org>
	<m1bp9jgyww.fsf@fess.ebiederm.org> <4C592BF5.3070008@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Aug 2010 05:12:49 -0700
In-Reply-To: <4C592BF5.3070008@kernel.org> (Yinghai Lu's message of "Wed\, 04 Aug 2010 01\:59\:33 -0700")
Message-ID: <m1mxt28tku.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 08/03/2010 02:38 PM, Eric W. Biederman wrote:
>> 
>> A clean solution would be to scrub the input from the MP table before
>> we attempt to use of it, instead of scrubbing the data as we use in
>> code paths like pin_2_irq.  Just touching pin_2_irq is certainly an
>> incomplete solution because you have not resolved if the pins should
>> be edge or level triggered, and what polarity we should be sampling
>> them at.
>> 
>> Until I see a plausible scenario where not handling buggy MP tables
>> exactly as we have done in the past I don't see hacks like you
>> are proposing making much sense at all.
>
> ok, how about this one?
>
> it will try to add entries to mp_irqs[] with some checking.

This looks roughly like the right approach.
However I don't see what would force the ioapic entries before
the intsrc entries in the table.  Especially when the assumption
is we are dealing with a buggy bios.

> ---
>  arch/x86/kernel/mpparse.c |   44 +++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 37 insertions(+), 7 deletions(-)
>
> Index: linux-2.6/arch/x86/kernel/mpparse.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/mpparse.c
> +++ linux-2.6/arch/x86/kernel/mpparse.c
> @@ -173,17 +173,17 @@ static int __init mp_irq_mpc_intsrc_cmp(
>  {
>  	if (mp_irq->dstapic != m->dstapic)
>  		return 1;
> -	if (mp_irq->type != m->type)
> +	if (mp_irq->dstirq != m->dstirq)
>  		return 2;
> -	if (mp_irq->irqtype != m->irqtype)
> +	if (mp_irq->srcbus != m->srcbus)
>  		return 3;
> -	if (mp_irq->irqflag != m->irqflag)
> +	if (mp_irq->type != m->type)
>  		return 4;
> -	if (mp_irq->srcbus != m->srcbus)
> +	if (mp_irq->irqtype != m->irqtype)
>  		return 5;
> -	if (mp_irq->srcbusirq != m->srcbusirq)
> +	if (mp_irq->irqflag != m->irqflag)
>  		return 6;
> -	if (mp_irq->dstirq != m->dstirq)
> +	if (mp_irq->srcbusirq != m->srcbusirq)
>  		return 7;
>  
>  	return 0;
> @@ -195,9 +195,39 @@ static void __init MP_intsrc_info(struct
>  
>  	print_MP_intsrc_info(m);
>  
> +	/*
> +	 *  Assume BUS, and IOAPIC entries come first all before
> +	 *    INTSRC entries
> +	 */
> +
> +	/* check if dstapic is right */
> +	for (i = 0; i < nr_ioapics; i++) {
> +		if (mp_ioapics[idx].apicid == m->dstapic)
> +			break;
> +	}
> +	if (i == nr_ioapics)
> +		return;

If we can make the algorithm two pass picking up the ioapic
entries first this should be fine.

>  	for (i = 0; i < mp_irq_entries; i++) {
> -		if (!mp_irq_mpc_intsrc_cmp(&mp_irqs[i], m))
> +		int ret = mp_irq_mpc_intsrc_cmp(&mp_irqs[i], m);
> +
> +		/* duplicated entries ? */
> +		if (!ret)
>  			return;
> +
> +		/* same apic/pin, but different bus */
> +		if (ret == 3) {
> +			/* overwrite wrong legacy one */

In practice your test of looking at mp_bus_not_pci is essentially what
we do.  I wonder if it could be made to be a test of polarity and edge
mismatch instead.

Also if we are ditching a non-duplicate intsrc we want to print a message
so there is a chance of debugging things if our heuristic for fixing
up broken BIOS's goes wrong, on some common configuration.

> +			if (test_bit(mp_irqs[i].srcbus, mp_bus_not_pci) &&
> +			    !test_bit(m->srcbus, mp_bus_not_pci)) {
> +				assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);

That should be.
> +				assign_to_mp_irq(m, &mp_irqs[i]);

> +				return;
> +			}
> +			/* dump this legacy one */
> +			if (!test_bit(mp_irqs[i].srcbus, mp_bus_not_pci) &&
> +			    test_bit(m->srcbus, mp_bus_not_pci))
> +				return;
> +		}
>  	}
>  
>  	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);

Eric
