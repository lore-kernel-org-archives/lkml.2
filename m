Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1GHSNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:13:49 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55938 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1GHSNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:13:48 -0400
MIME-Version: 1.0
In-Reply-To: <4E171E93.8020608@arm.com>
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
	<CAHXqBFJiovYq5x_JDAxikvFs-t1To6yC-1uajBJFRX_jwjvejA@mail.gmail.com>
	<4E170134.1020306@arm.com>
	<4E171E93.8020608@arm.com>
Date: Fri, 8 Jul 2011 20:13:46 +0200
Message-ID: <CAHXqBFKKGj9c3fNiFRiR-BBdVffxg8bBHYh0_sCQvCZ3SDTewA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] Core device subsystem
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 8 lipca 2011 17:13 u¿ytkownik Marc Zyngier
<marc.zyngier@arm.com> napisa³:
> On 08/07/11 14:08, Marc Zyngier wrote:
>> So you're basically folding of_core_device_populate() and
>> core_driver_init_class() into one call, and generating the
>> of_device_ids on the fly. If you're going down that road,
>> it would be even simpler to directly use of_device_ids
>> instead of core_device_ids and skip the generation altogether.
>>
>> That would also remove the static declaration of devices to be
>> probed in the architecture support code...
>>
>> Let me think of it and prototype that.
>
> See the attached patch against branch dt_gic_twd from
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
>
> It boots fine on my PB11MP.
>
> What do you think?
>
>        M.
> --
> Jazz is not dead. It just smells funny...
> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
> index 74825c2..e7d9922 100644
> --- a/arch/arm/common/gic.c
> +++ b/arch/arm/common/gic.c
> @@ -712,9 +712,9 @@ static int __init gic_core_init(struct core_device *dev)
>        return 0;
>  }
>
> -static struct core_device_id gic_ids[] __initdata = {
> -       { .name = "arm,gic-spi" }, /* DT */
> -       { .name = "arm_gic" },     /* Static device */
> +static struct of_device_id gic_ids[] __initdata = {
> +       { .compatible = "arm,gic-spi" }, /* DT */
> +       { .name = "arm_gic" },           /* Static device */
>        { },
>  };

This will also match devices with name "arm_gic" in DT. Unlikely, but
probably not what you want.

I thought about something more evil. ;) See below.

Assuming we modify of_find_matching_node() to also return matched ID entry:

---- of_core_device_populate()

const struct of_device_id *id;
struct device_node *dn;
struct core_device *dev;

for_each_matching_node_id(dn, matches, id) {
  dev = create_core_dev(...);
  dev->init = id->data;
  add_to_list(class, dev);
}

if (intc class)
  sort_list()

----

And then drivers would register like this:

int __init etc_init(struct core_device *);

DEFINE_CORE_DEVICE_TABLE_DT(class, name) = {
  { .compatible = "etc", .data = etc_init },
};

DEFINE_CORE_DEVICE_TABLE_LEGACY(class, name) = {
  { .name = "etc", .data = etc_init },
};


This removes the need for struct core_driver and instead uses linker
to directly generate match tables for INTC and TIMER classes. This
also allows to get rid of legacy IDs when kernel is built with support
for boards not using DT.

Best Regards,
Micha³ Miros³aw
