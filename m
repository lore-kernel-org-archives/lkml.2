Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1BWRWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:22:55 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44671 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1BWRWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:22:53 -0500
MIME-Version: 1.0
In-Reply-To: <4D653C48.4090608@gmail.com>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
 <20110223043447.20795.80653.stgit@localhost6.localdomain6> <4D653C48.4090608@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 23 Feb 2011 10:22:33 -0700
X-Google-Sender-Auth: eJopgFfKXgMec8WADowfWL1v_nI
Message-ID: <AANLkTimp0moaqnRfn8hp_TQJxdh7G8ODG_SkwO_hz8kE@mail.gmail.com>
Subject: Re: [RFC PATCH 14/15] dt: Eliminate of_platform_{,un}register_driver
To: Rob Herring <robherring2@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 9:56 AM, Rob Herring <robherring2@gmail.com> wrote:
> Grant,
>
> On 02/22/2011 10:34 PM, Grant Likely wrote:
>>
>> Final step to eliminate of_platform_bus_type.  They're all just
>> platform drivers now.
>>
>> Signed-off-by: Grant Likely<grant.likely@secretlab.ca>
>> ---
>
> snip
>
>> diff --git a/drivers/char/ipmi/ipmi_si_intf.c
>> b/drivers/char/ipmi/ipmi_si_intf.c
>> index b6ae6e9..132951d 100644
>> --- a/drivers/char/ipmi/ipmi_si_intf.c
>> +++ b/drivers/char/ipmi/ipmi_si_intf.c
>> @@ -2556,8 +2556,7 @@ static struct pci_driver ipmi_pci_driver = {
>>
>>
>>  #ifdef CONFIG_PPC_OF
>> -static int __devinit ipmi_of_probe(struct platform_device *dev,
>> -                        const struct of_device_id *match)
>> +static int __devinit ipmi_of_probe(struct platform_device *dev)
>>  {
>>        struct smi_info *info;
>>        struct resource resource;
>> @@ -2568,6 +2567,9 @@ static int __devinit ipmi_of_probe(struct
>> platform_device *dev,
>>
>>        dev_info(&dev->dev, "probing via device tree\n");
>>
>> +       if (!dev->dev.of_match)
>> +               return -EINVAL;
>> +
>>        ret = of_address_to_resource(np, 0,&resource);
>>        if (ret) {
>>                dev_warn(&dev->dev, PFX "invalid address from OF\n");
>> @@ -2600,7 +2602,7 @@ static int __devinit ipmi_of_probe(struct
>> platform_device *dev,
>>                return -ENOMEM;
>>        }
>>
>> -       info->si_type           = (enum si_type) match->data;
>> +       info->si_type           = (enum si_type) dev->dev.of_match->data;
>>        info->addr_source       = SI_DEVICETREE;
>>        info->irq_setup         = std_irq_setup;
>>
>> @@ -2652,9 +2654,9 @@ static struct of_device_id ipmi_match[] =
>>        {},
>>  };
>>
>> -static struct of_platform_driver ipmi_of_platform_driver = {
>> +static struct platform_driver ipmi_of_platform_driver = {
>>        .driver = {
>> -               .name = "ipmi",
>> +               .name = "of-ipmi",
>>                .owner = THIS_MODULE,
>>                .of_match_table = ipmi_match,
>>        },
>> @@ -3396,7 +3398,7 @@ static int __devinit init_ipmi_si(void)
>>  #endif
>>
>>  #ifdef CONFIG_PPC_OF
>> -       of_register_platform_driver(&ipmi_of_platform_driver);
>> +       platform_driver_register(&ipmi_of_platform_driver);
>>        of_registered = 1;
>>  #endif
>>
>> @@ -3457,7 +3459,7 @@ static int __devinit init_ipmi_si(void)
>>
>>  #ifdef CONFIG_PPC_OF
>>                if (of_registered)
>> -
>> of_unregister_platform_driver(&ipmi_of_platform_driver);
>> +
>> platform_driver_unregister(&ipmi_of_platform_driver);
>>  #endif
>>                driver_unregister(&ipmi_driver.driver);
>>                printk(KERN_WARNING PFX
>> @@ -3558,7 +3560,7 @@ static void __exit cleanup_ipmi_si(void)
>>
>>  #ifdef CONFIG_PPC_OF
>>        if (of_registered)
>> -               of_unregister_platform_driver(&ipmi_of_platform_driver);
>> +               platform_driver_unregister(&ipmi_of_platform_driver);
>>  #endif
>>
>>        mutex_lock(&smi_infos_lock);
>
> Um, you are doing exactly what you said I should not do. Now the driver has
> 2 platform drivers defined. I have an updated patch that addresses your
> previous comments. I will send it out later today.

Thanks.  I wacked this whole series out one evening and converted all
the drivers at once, so it's not surprising that I missed some
duplications.  Send me your patch and I'll drop my changes here.

g.
