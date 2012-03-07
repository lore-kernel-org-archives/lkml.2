Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab2CGQAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:00:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45671 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab2CGQAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:00:08 -0500
MIME-Version: 1.0
In-Reply-To: <87pqcqnc7u.fsf@ti.com>
References: <1330006564-13290-1-git-send-email-mporter@ti.com>
	<87wr74gis6.fsf@ti.com>
	<20120301204553.GA21841@legolas.emea.dhcp.ti.com>
	<87pqcqnc7u.fsf@ti.com>
Date: Wed, 7 Mar 2012 10:00:08 -0600
X-Google-Sender-Auth: X7h4e44gj7sBAg_fLJpnU3xxgDc
Message-ID: <CA+Bv8XaJqL1L8F-n6skY7dHn1XAdDLRKaRjw0deLeoQ5Ao0Fhg@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x regulators
From: Russ Dill <Russ.Dill@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: balbi@ti.com, Matt Porter <mporter@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 12:18 PM, Kevin Hilman <khilman@ti.com> wrote:
> Felipe Balbi <balbi@ti.com> writes:
>
>> Hi,
>>
>> On Thu, Mar 01, 2012 at 12:36:57PM -0800, Kevin Hilman wrote:
>>> Matt Porter <mporter@ti.com> writes:
>>>
>>> > This fixes smsc911x support on platforms using gpmc_smsc911x_init().
>>> >
>>> > Commit c7e963f6888816 (net/smsc911x: Add regulator support) added
>>> > the requirement that platforms provide vdd33a and vddvario supplies.
>>> >
>>> > Signed-off-by: Matt Porter <mporter@ti.com>
>>>
>>> [...]
>>>
>>> >  /*
>>> >   * Initialize smsc911x device connected to the GPMC. Note that we
>>> >   * assume that pin multiplexing is done in the board-*.c file,
>>> > @@ -55,6 +101,12 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *board_data)
>>> >
>>> >    gpmc_cfg = board_data;
>>> >
>>> > +  ret = platform_device_register(&gpmc_smsc911x_regulator);
>>> > +  if (ret < 0) {
>>> > +          pr_err("Unable to register smsc911x regulators: %d\n", ret);
>>> > +          return;
>>> > +  }
>>> > +
>>>
>>> Boards that have more than one instance of the smsc911x (OMAP3/Overo)
>>> barf here because of trying to register the same device twice.
>>>
>>> We need something like the patch below to make Overo boot again.
>>>
>>> Kevin
>>>
>>>
>>>
>>> From 4114dea2fb897ab75d05eaa943d29454034fc025 Mon Sep 17 00:00:00 2001
>>> From: Kevin Hilman <khilman@ti.com>
>>> Date: Thu, 1 Mar 2012 12:30:42 -0800
>>> Subject: [PATCH] ARM: OMAP2+: gpmc-smsc911x: only register regulators once
>>>
>>> commit e4b0b2cbbb (ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
>>> regulators) added regulators which are registered during
>>> gpmc_smsc911x_init().  However, some platforms (OMAP3/Overo) have more
>>> than one instance of the SMSC911x and result in attempting to register
>>> the same regulator more than once which causes a panic().  Fix this by
>>> tracking the regulator registration ensuring only a single device is
>>> registered.
>>>
>>> Cc: Matt Porter <mporter@ti.com>
>>> Signed-off-by: Kevin Hilman <khilman@ti.com>
>>> ---
>>>  arch/arm/mach-omap2/gpmc-smsc911x.c |   14 ++++++++++----
>>>  1 file changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-omap2/gpmc-smsc911x.c b/arch/arm/mach-omap2/gpmc-smsc911x.c
>>> index bbb870c..95e6c7d 100644
>>> --- a/arch/arm/mach-omap2/gpmc-smsc911x.c
>>> +++ b/arch/arm/mach-omap2/gpmc-smsc911x.c
>>> @@ -88,6 +88,8 @@ static struct platform_device gpmc_smsc911x_regulator = {
>>>      },
>>>  };
>>>
>>> +static bool regulator_registered;
>>> +
>>>  /*
>>>   * Initialize smsc911x device connected to the GPMC. Note that we
>>>   * assume that pin multiplexing is done in the board-*.c file,
>>> @@ -101,10 +103,14 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *board_data)
>>>
>>>      gpmc_cfg = board_data;
>>>
>>> -    ret = platform_device_register(&gpmc_smsc911x_regulator);
>>> -    if (ret < 0) {
>>> -            pr_err("Unable to register smsc911x regulators: %d\n", ret);
>>> -            return;
>>> +    if (!regulator_registered) {
>>> +            ret = platform_device_register(&gpmc_smsc911x_regulator);
>>> +            if (ret < 0) {
>>> +                    pr_err("Unable to register smsc911x regulators: %d\n",
>>> +                           ret);
>>> +                    return;
>>> +            }
>>> +            regulator_registered = true;
>>
>> Wow, this is quite a hack. Is the regulator part of the SMSC911x
>> device or is it outside ? If it's outside the SMSC91xx (which I
>> believe it is) there should be a regulator driver instead of this
>> hack.  For boards which don't provide such a regulator (and tie the
>> supply pin to some constant voltage source) there should be a constant
>> regulator supplying the pin. But this patch is quite hacky.
>
> Are you referring to my patch or to the original $SUBJECT patch?  It's
> not terribly clear.
>
> My patch doesn't add any regulators, it just fixes a bug when this init
> function is called more than once.
>
> The addition of the regulators was done in $SUBJECT patch, not my fix.
>
> In either case $SUBJECT patch is already in Tony's fixes queue, so if it
> is going be merged, then my fix above is needed also to not break
> Overo and any other platform that has more than one smsc911x instance.
>
> Kevin


Have you tested this fix? The only regulator consumer supply would be:

static struct regulator_consumer_supply gpmc_smsc911x_supply[] = {
        REGULATOR_SUPPLY("vddvario", "smsc911x.0"),
        REGULATOR_SUPPLY("vdd33a", "smsc911x.0"),
};

I don't think the second smsc911x on the Overo, "smsc911x.1", would
find it due to the dev_id.
