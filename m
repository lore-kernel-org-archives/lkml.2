Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2BPBc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 20:32:27 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44494 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756040Ab2BPBcX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 20:32:23 -0500
MIME-Version: 1.0
In-Reply-To: <20120206061517.GD21449@ponder.secretlab.ca>
References: <CACxGe6sTO_Jy-vecKS9SoVs55ZA8BMc+O0NODLdq6KvkcbPByg@mail.gmail.com>
 <1328492111.30631.24.camel@pasglop> <20120206061517.GD21449@ponder.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 15 Feb 2012 18:32:03 -0700
X-Google-Sender-Auth: HVxkiGFy20RA0yn7u4Di1-9qfZU
Message-ID: <CACxGe6tAVW2zCrWFPDgvu8sjd4KXJnfqhT16sYa1UvyRVEVyhQ@mail.gmail.com>
Subject: Re: Please add irqdomain branch to linux-next
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 11:15 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Feb 06, 2012 at 12:35:11PM +1100, Benjamin Herrenschmidt wrote:
>> On Thu, 2012-02-02 at 14:10 -0700, Grant Likely wrote:
>> > Hi Stephen,
>> >
>> > Can you please add the following branch to linux-next?  It contains
>> > the majority of the irqdomain rework that I've been doing.  I'd like
>> > to get it marinating in linux-next early so I'm sure it will be ready
>> > when the v3.4 merge window rolls around.
>>
>> Ho !
>>
>> I don't have v4 in my mailbox to reply to the individual patches,
>> but I've spotted some issues so here they are in no specific order.
>>
>> @@ -739,31 +712,36 @@ unsigned int irq_create_mapping(struct irq_domain *host,
>>
>>       /* Get a virtual interrupt number */
>>       if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
>>               /* Handle legacy */
>>               virq = (unsigned int)hwirq;
>>               if (virq == 0 || virq >= NUM_ISA_INTERRUPTS)
>>                       return NO_IRQ;
>>               return virq;
>>       } else {
>>               /* Allocate a virtual interrupt number */
>>               hint = hwirq % irq_virq_count;
>> -             virq = irq_alloc_virt(host, 1, hint);
>> +             virq = irq_alloc_desc_from(hint, 0);
>> +             if (!virq)
>> +                     virq = irq_alloc_desc_from(1, 0);
>>               if (virq == NO_IRQ) {
>>                       pr_debug("irq: -> virq allocation failed\n");
>>                       return NO_IRQ;
>>               }
>>
>> So first, the way you "avoid" allocating irq 0 seems to be by ...
>> allocating irq 0 and then allocating again once you've done that :-)
>>
>> You should either make sure hint is non-0 to begin with or use
>> irq_reserve_irq() to reserve irq 0 (tho I don't know whether the later
>> could be an issue on x86).
>
> Okay, I'll ensure that hint != 0

Now fixed.  Will be in v5

>
>> Also, you no longer honor irq_virq_count. It's a limitation of
>> __irq_alloc_descs() to not be able to get an upper boundary, but you
>> need that for iseries and ps3 at least.
>
> I'll look at adding an upper limit to __irq_alloc_descs().  If that won't
> work, then I'll add an explicit test after allocation to make sure it is not
> over the limit.
>
>> Also the default for irq_virq_count should probably be changed when you
>> move to the core to use IRQ_BITMAP_BITS (so we get the 8192 additional
>> irqs on SPARSE_IRQ).
>
> Good catch.

Only nomap users will care about this, and of those 5, only iseries
and ps3 actually change it.  How about I add a max_virq parameter to
only be used by the nomap revmap?  That seems to be cleaner than a
global setting.  I've crafted a patch and will post it with v5 of the
series.

>
>>
>> Another thing I noticed, tho I'm still only half way through the series
>> so you -may- have fixed that, is that you allocate all descs on node 0
>> (not even the current node) and have no way to do otherwise.
>
> No, I've not fixed that.
>
>> Now, it's a bit of a nasty issue because ideally we should "move" the
>> descs around as we set the affinity of interrupts and we really can't do
>> that just yet, but at least having a way to allocate the desc with a
>> node number (adding a node argument to irq_create_mapping) would be
>> useful. For things like PCI we could make that use the node where the
>> device is, which is better than having everything on node 0.
>
> okay.

For now I'll use numa_node_id() at allocation time.  I'll craft a
follow-on patch to change the API since it touches a lot of call
sites.

>
>> Also you should probably make the whole match & xlate business
>> #ifdef CONFIG_OF (especially in the definition of the irq domain). There
>> is no reason why archs couldn't use the domain mapper without
>> device-tree support.
>
> It builds and runs fine without the CONFIG_OF wrappers, but I can trim stuff
> down.
>
>> +int irq_domain_xlate_pci(struct irq_domain *d, struct device_node *ctrlr,
>> +                      const u32 *intspec, unsigned int intsize,
>> +                      unsigned long *out_hwirq, unsigned int *out_type)
>> +{
>> +     if (WARN_ON(intsize != 1))
>> +             return -EINVAL;
>> +     *out_hwirq = intspec[0];
>> +     *out_type = IRQ_TYPE_LEVEL_HIGH;
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(irq_domain_xlate_pci);
>>
>> That's bogus. PCI interrupts are level -low-. However some bridges
>> internally invert them on the way to the PIC (this is actually common
>> with PCIe bridges where they are generated from messages). So if you are
>> to provide a default helper, make it LEVEL_LOW really.
>
> Haha, good point.  I'll fix that.

I've dropped irq_domain_xlate_pci()

I think I've addressed all the problems you've brought up.  I'm
testing now and I'll be posting v5 very shortly.

g.
