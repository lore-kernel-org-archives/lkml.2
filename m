Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab2DKPdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:33:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64339 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2DKPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:33:36 -0400
Message-ID: <4F85A44D.2050909@gmail.com>
Date: Wed, 11 Apr 2012 08:33:33 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] iqrdomain: Improve formatting in debugfs.
References: <1334016417-18748-1-git-send-email-ddaney.cavm@gmail.com> <20120411070332.6F3C03E081E@localhost>
In-Reply-To: <20120411070332.6F3C03E081E@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 12:03 AM, Grant Likely wrote:
> On Mon,  9 Apr 2012 17:06:57 -0700, David Daney<ddaney.cavm@gmail.com>  wrote:
>> From: David Daney<david.daney@cavium.com>
>>
>> The irq_domain_mapping file has some interesting output when chip_data
>> contains leading zeros:
>>
>> virq   hwirq    chip name        chip data           domain name
>> .
>> .
>> .
>>    103  0x00000  CIU2-W           0x 5e0000000000000  none
>>    104  0x00000  CIU2-W           0x 5f0000000000000  none
>>    105  0x00000  CIU2-M           0x          (null)  none
>>    113  0x00000  CIU2-E           0x1080000000000000  none
>> .
>> .
>> .
>>
>> I think there should be no space in there between the "0x" and the
>> rest.  Also the '(null)' entry doesn't make much sense at all with a
>> "0x".
>
> Yeah, it doesn't make much sense with the '0x', but I don't want to
> supress the (null) output because it is really important to highlight
> when a domain isn't assigned to an active irq.
>
> Fixing the zero pad is trivial to fix though.  Just remove the
> precision from the %p format.  Here's my counter-patch:

This is good too.

FWIW:
Acked-by: David Daney <david.daney@cavium.com>


>
> ---
>
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 9310a8d..eb05e40 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -643,8 +643,8 @@ static int virq_debug_show(struct seq_file *m, void *private)
>   	void *data;
>   	int i;
>
> -	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
> -		      "chip name", "chip data", "domain name");
> +	seq_printf(m, "%-5s  %-7s  %-15s  %-*s  %s\n", "irq", "hwirq",
> +		      "chip name", 2 * sizeof(void *) + 2, "chip data", "domain name");
>
>   	for (i = 1; i<  nr_irqs; i++) {
>   		desc = irq_to_desc(i);
> @@ -667,7 +667,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
>   			seq_printf(m, "%-15s  ", p);
>
>   			data = irq_desc_get_chip_data(desc);
> -			seq_printf(m, "0x%16p  ", data);
> +			seq_printf(m, data ? "0x%p  " : "  %p  ", data);
>
>   			if (desc->irq_data.domain&&  desc->irq_data.domain->of_node)
>   				p = desc->irq_data.domain->of_node->full_name;

