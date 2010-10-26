Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053Ab0JZQiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:38:03 -0400
Received: from claw.goop.org ([74.207.240.146]:44256 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760044Ab0JZQiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:38:00 -0400
Message-ID: <4CC703E5.6000009@goop.org>
Date: Tue, 26 Oct 2010 09:37:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, xen-devel@lists.xensource.com, tglx@linutronix.de
Subject: Re: [PATCH 4/5] xen: events: dynamically allocate irq info structures
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com> <1288023813-31989-4-git-send-email-ian.campbell@citrix.com> <20101026143027.GB9557@dumpdata.com>
In-Reply-To: <20101026143027.GB9557@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/26/2010 07:30 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 25, 2010 at 05:23:32PM +0100, Ian Campbell wrote:
>> Removes nr_irq sized array allocation at start of day.
>>
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> ---
>>  drivers/xen/events.c |   50 +++++++++++++++++++++++++++++++++++++++++---------
>>  1 files changed, 41 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
>> index 94055ea..9b58505 100644
>> --- a/drivers/xen/events.c
>> +++ b/drivers/xen/events.c
>> @@ -56,6 +56,8 @@
>>   */
>>  static DEFINE_SPINLOCK(irq_mapping_update_lock);
>>  
>> +static LIST_HEAD(xen_irq_list_head);
>> +
>>  /* IRQ <-> VIRQ mapping. */
>>  static DEFINE_PER_CPU(int [NR_VIRQS], virq_to_irq) = {[0 ... NR_VIRQS-1] = -1};
>>  
>> @@ -85,6 +87,7 @@ enum xen_irq_type {
>>   */
>>  struct irq_info
>>  {
>> +	struct list_head list;
>>  	enum xen_irq_type type;	/* type */
>>  	unsigned short evtchn;	/* event channel */
>>  	unsigned short cpu;	/* cpu bound */
>> @@ -103,7 +106,6 @@ struct irq_info
>>  #define PIRQ_NEEDS_EOI	(1 << 0)
>>  #define PIRQ_SHAREABLE	(1 << 1)
>>  
>> -static struct irq_info *irq_info;
>>  static int *pirq_to_irq;
>>  static int nr_pirqs;
>>  
>> @@ -132,7 +134,7 @@ static struct irq_chip xen_pirq_chip;
>>  /* Get info for IRQ */
>>  static struct irq_info *info_for_irq(unsigned irq)
>>  {
>> -	return &irq_info[irq];
>> +	return get_irq_data(irq);
>>  }
>>  
>>  /* Constructors for packed IRQ information. */
>> @@ -315,7 +317,7 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
>>  	__clear_bit(chn, cpu_evtchn_mask(cpu_from_irq(irq)));
>>  	__set_bit(chn, cpu_evtchn_mask(cpu));
>>  
>> -	irq_info[irq].cpu = cpu;
>> +	info_for_irq(irq)->cpu = cpu;
>>  }
>>  
>>  static void init_evtchn_cpu_bindings(void)
>> @@ -428,6 +430,21 @@ static int find_unbound_pirq(void)
>>  	return -1;
>>  }
>>  
>> +static void xen_irq_init(unsigned irq)
>> +{
>> +	struct irq_info *info;
>> +
>> +	info = kmalloc(sizeof(*info), GFP_KERNEL);
>> +	if (info == NULL)
>> +		panic("Unable to allocate metadata for IRQ%d\n", irq);
> There is a bunch of panic around allocating IRQs. There is one earlier
> in xen_irq_alloc too, and I was wondering - would it make sense to
> perhaps print an error to both the hypervisor and the kernel and
> just return -1 as an IRQ and let the kernel continue with its normal
> failure path?
>
> I am thinking just in terms of making the system still be able to
> work even if parts of it are busted, instead of just crashing the system.
>
> Not sure which philosophy is domiant in the Linux kernel?

Normally to print something and struggle on, rather than crash over
every little thing.  There's been a general tendency to convert BUG into
WARN, for example.

    J

