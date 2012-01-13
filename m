Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2AMAsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:48:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39304 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2AMAr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:47:59 -0500
MIME-Version: 1.0
In-Reply-To: <4F0F7B60.5040701@gmail.com>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
 <1326313337-24603-14-git-send-email-grant.likely@secretlab.ca>
 <4F0DFC0F.2090005@gmail.com> <CACxGe6vVSO0cTgPurr6jFoo9QF_W02UaABOFYadCTQGU9dcwmg@mail.gmail.com>
 <4F0F7B60.5040701@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 12 Jan 2012 17:47:38 -0700
X-Google-Sender-Auth: _D4rVma6c5UGwh_kJ9SaE84Zwas
Message-ID: <CACxGe6vER6hTr0ez9_=bTL+F1n3DZHCa9Yc9fVGQ36i=X62sVQ@mail.gmail.com>
Subject: Re: [RFC 13/14] irq_domain: Remove 'new' irq_domain in favour of the
 ppc one
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 5:31 PM, Rob Herring <robherring2@gmail.com> wrote:
> Adding lakml...
>
> On 01/11/2012 03:27 PM, Grant Likely wrote:
>> On Wed, Jan 11, 2012 at 2:15 PM, Rob Herring <robherring2@gmail.com> wrote:
>>> Grant,
>>>
>>> On 01/11/2012 02:22 PM, Grant Likely wrote:
>>>> This patch removes the simplistic implementation of irq_domains and enables
>>>> the powerpc infrastructure for all irq_domain users.  The powerpc
>>>> infrastructure includes support for complex mappings between Linux and
>>>> hardware irq numbers, and can manage allocation of irq_descs.
>>>>
>>>> This patch also converts the few users of irq_domain_add()/irq_domain_del()
>>>> to call irq_domain_add_legacy() instead.
>>>
>>> So what is the non-legacy way? Legacy implies we don't want to do it
>>> that way. I guess until we remove all non-DT platforms with GIC we are
>>> stuck with legacy. That seems like it could be a ways out until we get
>>> there.
>>
>> Non-legacy is letting the irq_domain manage the irq_desc allocations.
>> Some of the controllers will be easy to convert, some will be more
>> difficult.  The primary thing that really blocks getting away from the
>> legacy method is anything that expects hardcoded #defined irq numbers.
>>  The goal is to convert all users over to the linear revmap method.
>>
>
> So I gave this a spin on highbank. I ran into a couple problems.
>
> I had to revert "irqdesc: Consolidate irq reservation logic" which is in
> your branch, but not this series. irq_alloc_desc_from was returning -EEXIST.

Hmmm... I thought I sorted that out.  Thanks for letting me know.

>
> The GIC code did not work which I think is specific to using gic_of_init
> which makes irq_start = -1. With that it still doesn't work. It dies in
> gic_set_type... I've found one problem which I'll reply inline to, but I
> think this is a dead end path anyway.

Haha, I'm not surprised.  That last patch was only compile tested on
platforms using the gic.  I'm not surprised that I flubbed it.

> You have removed the irq_alloc_descs call from the GIC which is a step
> backwards. Several of the ARM DT enabled platforms are at the point they
> can fully support dynamic virq base for each irqchip. I changed the
> domain from legacy to linear and got things working.
> The issue with

I hadn't actually intended to remove the irq_alloc_descs in this
patch.  That was a leftover hunk from when I was playing with going
straight to irq_domain_add_linear().  For this specific patch, I'll
put the alloc back in and test it that way.  A follow-on patch can do
a proper conversion to the linear revmap.

> linear is for SPARSE_IRQ. The default behavior on ARM for SPARSE_IRQ is
> all nr_irqs are allocated at boot time before any controller is
> initialized. The only platform with a GIC and requiring SPARSE_IRQ is
> shmobile, but it is also the only one that calls irq_alloc_desc
> functions for it's interrupts. So I think we are okay there. The problem
> occurs when enabling SPARSE_IRQ for a non-DT platform with a GIC and
> with irqchips that don't call irq_alloc_desc for their irqs. IMHO, this
> should be an okay trade-off. There's no advantage to enabling SPARSE_IRQ
> on ARM for platforms that don't require it. All the platforms with a GIC
> have active work to convert to DT (except shmobile which I think is
> okay), so it's a temporary issue.

Actually, I believe Thomas' long term goal is to always enable
SPARSE_IRQ and remove the option entirely, so it should still be
properly resolved. I'll take a look next week if I don't get to it
tomorrow.  I need to resurrect my vexpress qemu test environment so I
can test the permutations.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
