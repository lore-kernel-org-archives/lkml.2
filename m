Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1LSOYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:24:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35082 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1LSOX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:23:59 -0500
Message-ID: <4EEF48EE.1070800@gmail.com>
Date: Mon, 19 Dec 2011 08:23:42 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Kevin Hilman <khilman@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Barry Song <baohua.song@csr.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/9] irq: check domain hwirq range for DT translate
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com> <1323876538-20406-3-git-send-email-robherring2@gmail.com> <4EEF3110.30203@ti.com>
In-Reply-To: <4EEF3110.30203@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

On 12/19/2011 06:41 AM, Cousson, Benoit wrote:
> Hi Rob,
> 
> While trying your series to take advantage of the generic-irq domain
> support for OMAP3 INTC, I realized that the following patch is breaking
> drivers that are using irq_domain_add_simple.
> 
> The point is that irq_domain_add_simple does not populate hwirq_base or
> nr_irq, so that test will always fail if the domain is created by the
> irq_domain_add_simple API.
> 
> Adding an extra parameter to provide the nr_irq should fix that.
> 
> The long term fix should be to use the generic-irq for such driver, but
> this is not the same effort, so it might worth fixing that API for the
> moment.
> 
> Regards,
> Benoit
> 
> On 12/14/2011 4:28 PM, Rob Herring wrote:
>> From: Rob Herring<rob.herring@calxeda.com>
>>
>> A DT node may have more than 1 domain associated with it, so make sure
>> the hwirq number is within range when doing DT translation.
>>
>> Signed-off-by: Rob Herring<rob.herring@calxeda.com>
>> Cc: Thomas Gleixner<tglx@linutronix.de>
>> ---
>>   kernel/irq/irqdomain.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>> index 200ce83..ae6441e 100644
>> --- a/kernel/irq/irqdomain.c
>> +++ b/kernel/irq/irqdomain.c
>> @@ -135,6 +135,9 @@ int irq_domain_simple_dt_translate(struct
>> irq_domain *d,
>>           return -EINVAL;
>>       if (intsize<  1)
>>           return -EINVAL;
>> +    if ((intspec[0]<  d->hwirq_base) ||
>> +        (intspec[0]>= d->hwirq_base + d->nr_irq))

I think this should work:

if (d->nr_irq && ((intspec[0] < d->hwirq_base) ||
    (intspec[0] >= d->hwirq_base + d->nr_irq)))

Rob

>> +        return -EINVAL;
>>
>>       *out_hwirq = intspec[0];
>>       *out_type = IRQ_TYPE_NONE;
> 

