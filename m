Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2AMAbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:31:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51484 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab2AMAbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:31:31 -0500
Message-ID: <4F0F7B60.5040701@gmail.com>
Date: Thu, 12 Jan 2012 18:31:28 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 13/14] irq_domain: Remove 'new' irq_domain in favour of
 the ppc one
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca> <1326313337-24603-14-git-send-email-grant.likely@secretlab.ca> <4F0DFC0F.2090005@gmail.com> <CACxGe6vVSO0cTgPurr6jFoo9QF_W02UaABOFYadCTQGU9dcwmg@mail.gmail.com>
In-Reply-To: <CACxGe6vVSO0cTgPurr6jFoo9QF_W02UaABOFYadCTQGU9dcwmg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding lakml...

On 01/11/2012 03:27 PM, Grant Likely wrote:
> On Wed, Jan 11, 2012 at 2:15 PM, Rob Herring <robherring2@gmail.com> wrote:
>> Grant,
>>
>> On 01/11/2012 02:22 PM, Grant Likely wrote:
>>> This patch removes the simplistic implementation of irq_domains and enables
>>> the powerpc infrastructure for all irq_domain users.  The powerpc
>>> infrastructure includes support for complex mappings between Linux and
>>> hardware irq numbers, and can manage allocation of irq_descs.
>>>
>>> This patch also converts the few users of irq_domain_add()/irq_domain_del()
>>> to call irq_domain_add_legacy() instead.
>>
>> So what is the non-legacy way? Legacy implies we don't want to do it
>> that way. I guess until we remove all non-DT platforms with GIC we are
>> stuck with legacy. That seems like it could be a ways out until we get
>> there.
> 
> Non-legacy is letting the irq_domain manage the irq_desc allocations.
> Some of the controllers will be easy to convert, some will be more
> difficult.  The primary thing that really blocks getting away from the
> legacy method is anything that expects hardcoded #defined irq numbers.
>  The goal is to convert all users over to the linear revmap method.
> 

So I gave this a spin on highbank. I ran into a couple problems.

I had to revert "irqdesc: Consolidate irq reservation logic" which is in
your branch, but not this series. irq_alloc_desc_from was returning -EEXIST.

The GIC code did not work which I think is specific to using gic_of_init
which makes irq_start = -1. With that it still doesn't work. It dies in
gic_set_type... I've found one problem which I'll reply inline to, but I
think this is a dead end path anyway.

You have removed the irq_alloc_descs call from the GIC which is a step
backwards. Several of the ARM DT enabled platforms are at the point they
can fully support dynamic virq base for each irqchip. I changed the
domain from legacy to linear and got things working. The issue with
linear is for SPARSE_IRQ. The default behavior on ARM for SPARSE_IRQ is
all nr_irqs are allocated at boot time before any controller is
initialized. The only platform with a GIC and requiring SPARSE_IRQ is
shmobile, but it is also the only one that calls irq_alloc_desc
functions for it's interrupts. So I think we are okay there. The problem
occurs when enabling SPARSE_IRQ for a non-DT platform with a GIC and
with irqchips that don't call irq_alloc_desc for their irqs. IMHO, this
should be an okay trade-off. There's no advantage to enabling SPARSE_IRQ
on ARM for platforms that don't require it. All the platforms with a GIC
have active work to convert to DT (except shmobile which I think is
okay), so it's a temporary issue.

Rob
