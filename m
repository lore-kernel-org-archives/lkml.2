Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0JYXD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:03:26 -0400
Received: from claw.goop.org ([74.207.240.146]:56379 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0JYXDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:03:25 -0400
Message-ID: <4CC60CB7.3070005@goop.org>
Date: Mon, 25 Oct 2010 16:03:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, xen-devel@lists.xensource.com, tglx@linutronix.de
Subject: Re: [PATCH 1/5] xen: events: use irq_alloc_desc(_at) instead of open-coding
 an IRQ allocator.
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com> <1288023813-31989-1-git-send-email-ian.campbell@citrix.com> <20101025173522.GA5590@dumpdata.com>
In-Reply-To: <20101025173522.GA5590@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/25/2010 10:35 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 25, 2010 at 05:23:29PM +0100, Ian Campbell wrote:
>> Encapsulate allocate and free in xen_irq_alloc and xen_irq_free.
>>
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> ---
>>  drivers/xen/events.c |   68 ++++++++++++++++++++-----------------------------
>>  1 files changed, 28 insertions(+), 40 deletions(-)
>>
>> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
>> index 97612f5..c8f3e43 100644
>> --- a/drivers/xen/events.c
>> +++ b/drivers/xen/events.c
>> @@ -394,41 +394,29 @@ static int find_unbound_pirq(void)
>>  	return -1;
>>  }
>>  
>> -static int find_unbound_irq(void)
>> +static int xen_irq_alloc(void)
>>  {
>> -	struct irq_data *data;
>> -	int irq, res;
>> -	int start = get_nr_hw_irqs();
>> +	int irq = irq_alloc_desc(0);
>>  
>> -	if (start == nr_irqs)
>> -		goto no_irqs;
>> -
>> -	/* nr_irqs is a magic value. Must not use it.*/
>> -	for (irq = nr_irqs-1; irq > start; irq--) {
>> -		data = irq_get_irq_data(irq);
>> -		/* only 0->15 have init'd desc; handle irq > 16 */
>> -		if (!data)
>> -			break;
>> -		if (data->chip == &no_irq_chip)
>> -			break;
>> -		if (data->chip != &xen_dynamic_chip)
>> -			continue;
>> -		if (irq_info[irq].type == IRQT_UNBOUND)
>> -			return irq;
>> -	}
>> -
>> -	if (irq == start)
>> -		goto no_irqs;
>> +	if (irq < 0)
>> +		panic("No available IRQ to bind to: increase nr_irqs!\n");
>>  
>> -	res = irq_alloc_desc_at(irq, 0);
>> +	return irq;
>> +}
> So I am curious what the /proc/interrupts looks?The issue (and the reason
> for this implementation above) was that under PV with PCI devices we would
> overlap PCI devices IRQs with Xen event channels. So we could have a USB device
> at IRQ 16 _and_ also a xen_spinlock4 handler. That would throw off the system
> since the xen_spinlock4 was an edge type handler while the USB device was an
> level (at least on my box).

What?  Why?  How?  Surely if we're asking the irq subsystem to allocate
us an irq, it will return a fresh never-before-used (and certainly not
shared) irq?  Shared irqs only make sense if multiple devices are
actually sharing, say, a wire on the board.

Or am I missing something?

    J

