Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0H3RcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:32:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45109 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0H3RcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:32:06 -0400
MIME-Version: 1.0
In-Reply-To: <c7823e09-3ce8-434f-98f4-6a84a996c942@SG2EHSMHS001.ehs.local>
References: <20100628215407.2017bf2f@debian> <20100829235100.6dcedcb8@debxo>
 <20100830000614.0d571f10@debxo> <c7823e09-3ce8-434f-98f4-6a84a996c942@SG2EHSMHS001.ehs.local>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 30 Aug 2010 11:31:44 -0600
X-Google-Sender-Auth: 1ZVXoSFt4HgeF732y1MDd1q_r78
Message-ID: <AANLkTiky2-Sr6+0+yyCuo3sVNYB6cxOuSHQkE9LbyynA@mail.gmail.com>
Subject: Re: [PATCH 8/9] x86: of: irq additions to make drivers/of/* build on x86
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: Andres Salomon <dilinger@queued.net>, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
        Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 9:58 AM, Stephen Neuendorffer
<stephen.neuendorffer@xilinx.com> wrote:
>
>
>> -----Original Message-----
>> From: Andres Salomon [mailto:dilinger@queued.net]
>> Sent: Sunday, August 29, 2010 9:06 PM
>> To: devicetree-discuss@lists.ozlabs.org
>> Cc: sparclinux@vger.kernel.org; x86@kernel.org; tglx@linutronix.de;
> mingo@redhat.com; hpa@zytor.com;
>> cjb@laptop.org; Mitch Bradley; pgf@laptop.org;
> linux-kernel@vger.kernel.org; davem@davemloft.net;
>> grant.likely@secretlab.ca; Stephen Neuendorffer
>> Subject: [PATCH 8/9] x86: of: irq additions to make drivers/of/* build
> on x86
>>
>>
>> This functionality overlaps with patches previously submitted
>> by Stephen Neuendorffer.  I don't care whose eventually get applied,
>> so long as drivers/of/* becomes buildable on x86.
>>
>> Signed-off-by: Andres Salomon <dilinger@queued.net>
>
> Agreed..
> Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>

Okay, I've thought about this problem some more, and I think I've
decided how I want it solved.  Nack on this particular patch because
it adds NO_IRQ to arch/x86/kernel/irq.c (it has been nacked before).
Instead, I'd like the of irq code to be reworked a bit to make this
nicer and isolate the NO_IRQ definition only to the OF irq .c file
(when the arch doesn't explicitly define it).

Right now, there are two files in drivers/of referencing NO_IRQ;
drivers/of/platform.c and drivers/of/irq.c.  platform.c only
references in the context of figuring out how many irqs there are and
populating a resource table.  I'd like to remove that code from
platform.c and add a pair of helper functions to irq.c.  Then the top
of irq.c could conditionally #define NO_IRQ 0 and thereby prevent the
definition leaking out to the rest of the kernel.

Eventually I'll get around to doing this myself, but it would be
helpful to me if either you or Stephen could craft and test a patch.

Perhaps something like:

int of_irq_count(device_node *np)
{
        /* Count and return the number of IRQs. */
}

int of_irq_to_resource_table(device_node *np, struct resource *res, int max)
{
        for (i = 0; i < max; i++; res++)
                if (of_irq_to_resource(np, i, res) == NO_IRQ)
                        break;
        return i;
}

>> ---
>> @@ -275,6 +276,13 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
>>
>>  EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
>>
>> +unsigned int irq_create_of_mapping(struct device_node *controller,
>> +             const u32 *intspec, unsigned int intsize)
>> +{
>> +     return intspec[0] + 1;
>> +}
>> +EXPORT_SYMBOL_GPL(irq_create_of_mapping);
>> +

This simplistic implementation is of course non-ideal, but it works as
a stop-gap measure until I've got the irq infrastructure more mature.

g.
