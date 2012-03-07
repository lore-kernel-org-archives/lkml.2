Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab2CGThF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:37:05 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:42725 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758876Ab2CGThC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:37:02 -0500
From: Kevin Hilman <khilman@ti.com>
To: Russ Dill <Russ.Dill@ti.com>
Cc: balbi@ti.com, Matt Porter <mporter@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x regulators
Organization: Texas Instruments, Inc.
References: <1330006564-13290-1-git-send-email-mporter@ti.com>
	<87wr74gis6.fsf@ti.com>
	<20120301204553.GA21841@legolas.emea.dhcp.ti.com>
	<87pqcqnc7u.fsf@ti.com>
	<CA+Bv8XaJqL1L8F-n6skY7dHn1XAdDLRKaRjw0deLeoQ5Ao0Fhg@mail.gmail.com>
Date: Wed, 07 Mar 2012 11:36:57 -0800
In-Reply-To: <CA+Bv8XaJqL1L8F-n6skY7dHn1XAdDLRKaRjw0deLeoQ5Ao0Fhg@mail.gmail.com>
	(Russ Dill's message of "Wed, 7 Mar 2012 10:00:08 -0600")
Message-ID: <87sjhkjj8m.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russ,

Russ Dill <Russ.Dill@ti.com> writes:

> On Mon, Mar 5, 2012 at 12:18 PM, Kevin Hilman <khilman@ti.com> wrote:
>> Felipe Balbi <balbi@ti.com> writes:
>>
>>> Hi,
>>>
>>> On Thu, Mar 01, 2012 at 12:36:57PM -0800, Kevin Hilman wrote:
>>>> Matt Porter <mporter@ti.com> writes:
>>>>
>>>> > This fixes smsc911x support on platforms using gpmc_smsc911x_init().
>>>> >
>>>> > Commit c7e963f6888816 (net/smsc911x: Add regulator support) added
>>>> > the requirement that platforms provide vdd33a and vddvario supplies.
>>>> >
>>>> > Signed-off-by: Matt Porter <mporter@ti.com>
>>>>
>>>> [...]
>>>>
>>>> >  /*
>>>> >   * Initialize smsc911x device connected to the GPMC. Note that we
>>>> >   * assume that pin multiplexing is done in the board-*.c file,
>>>> > @@ -55,6 +101,12 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *board_data)
>>>> >
>>>> >    gpmc_cfg = board_data;
>>>> >
>>>> > +  ret = platform_device_register(&gpmc_smsc911x_regulator);
>>>> > +  if (ret < 0) {
>>>> > +          pr_err("Unable to register smsc911x regulators: %d\n", ret);
>>>> > +          return;
>>>> > +  }
>>>> > +
>>>>
>>>> Boards that have more than one instance of the smsc911x (OMAP3/Overo)
>>>> barf here because of trying to register the same device twice.
>>>>
>>>> We need something like the patch below to make Overo boot again.
>>>>
>>>> Kevin
>>>>
>>>>
>>>>
>>>> From 4114dea2fb897ab75d05eaa943d29454034fc025 Mon Sep 17 00:00:00 2001
>>>> From: Kevin Hilman <khilman@ti.com>
>>>> Date: Thu, 1 Mar 2012 12:30:42 -0800
>>>> Subject: [PATCH] ARM: OMAP2+: gpmc-smsc911x: only register regulators once
>>>>
>>>> commit e4b0b2cbbb (ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
>>>> regulators) added regulators which are registered during
>>>> gpmc_smsc911x_init().  However, some platforms (OMAP3/Overo) have more
>>>> than one instance of the SMSC911x and result in attempting to register
>>>> the same regulator more than once which causes a panic().  Fix this by
>>>> tracking the regulator registration ensuring only a single device is
>>>> registered.
>>>>
>>>> Cc: Matt Porter <mporter@ti.com>
>>>> Signed-off-by: Kevin Hilman <khilman@ti.com>
>>>> ---
>>>>  arch/arm/mach-omap2/gpmc-smsc911x.c |   14 ++++++++++----
>>>>  1 file changed, 10 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mach-omap2/gpmc-smsc911x.c b/arch/arm/mach-omap2/gpmc-smsc911x.c
>>>> index bbb870c..95e6c7d 100644
>>>> --- a/arch/arm/mach-omap2/gpmc-smsc911x.c
>>>> +++ b/arch/arm/mach-omap2/gpmc-smsc911x.c
>>>> @@ -88,6 +88,8 @@ static struct platform_device gpmc_smsc911x_regulator = {
>>>>      },
>>>>  };
>>>>
>>>> +static bool regulator_registered;
>>>> +
>>>>  /*
>>>>   * Initialize smsc911x device connected to the GPMC. Note that we
>>>>   * assume that pin multiplexing is done in the board-*.c file,
>>>> @@ -101,10 +103,14 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *board_data)
>>>>
>>>>      gpmc_cfg = board_data;
>>>>
>>>> -    ret = platform_device_register(&gpmc_smsc911x_regulator);
>>>> -    if (ret < 0) {
>>>> -            pr_err("Unable to register smsc911x regulators: %d\n", ret);
>>>> -            return;
>>>> +    if (!regulator_registered) {
>>>> +            ret = platform_device_register(&gpmc_smsc911x_regulator);
>>>> +            if (ret < 0) {
>>>> +                    pr_err("Unable to register smsc911x regulators: %d\n",
>>>> +                           ret);
>>>> +                    return;
>>>> +            }
>>>> +            regulator_registered = true;
>>>
>>> Wow, this is quite a hack. Is the regulator part of the SMSC911x
>>> device or is it outside ? If it's outside the SMSC91xx (which I
>>> believe it is) there should be a regulator driver instead of this
>>> hack.  For boards which don't provide such a regulator (and tie the
>>> supply pin to some constant voltage source) there should be a constant
>>> regulator supplying the pin. But this patch is quite hacky.
>>
>> Are you referring to my patch or to the original $SUBJECT patch?  It's
>> not terribly clear.
>>
>> My patch doesn't add any regulators, it just fixes a bug when this init
>> function is called more than once.
>>
>> The addition of the regulators was done in $SUBJECT patch, not my fix.
>>
>> In either case $SUBJECT patch is already in Tony's fixes queue, so if it
>> is going be merged, then my fix above is needed also to not break
>> Overo and any other platform that has more than one smsc911x instance.
>>
>> Kevin
>
>
> Have you tested this fix? 

Yes.  On 3530/Overo.

> The only regulator consumer supply would be:
>
> static struct regulator_consumer_supply gpmc_smsc911x_supply[] = {
>         REGULATOR_SUPPLY("vddvario", "smsc911x.0"),
>         REGULATOR_SUPPLY("vdd33a", "smsc911x.0"),
> };
>
> I don't think the second smsc911x on the Overo, "smsc911x.1", would
> find it due to the dev_id.

It's not about finding the second regulator.  As stated in the
changelog, it's about the duplicate attempt to register the exact same
platform_device.

Duplicate attempts to register the exact same platform_device cause
kobject to panic and give up[1].  So, any platform that calls
gpmc_smsc911x_init() twice (Overo and T35 in mainline) will panic on
boot.

This patch fixes those platforms so they can boot.

Kevin



[1]
[    0.337036] kobject (c06b1730): tried to init an initialized object, something is seriously wrong.
[    0.346679] [<c001421c>] (unwind_backtrace+0x0/0xf0) from [<c022b944>] (kobject_init+0x74/0x94)
[    0.355804] [<c022b944>] (kobject_init+0x74/0x94) from [<c0284fa8>] (device_initialize+0x20/0x90)
[    0.365112] [<c0284fa8>] (device_initialize+0x20/0x90) from [<c02894fc>] (platform_device_register+0x10/0x24)
[    0.375488] [<c02894fc>] (platform_device_register+0x10/0x24) from [<c0619d7c>] (gpmc_smsc911x_init+0x1c/0x200)
[    0.386077] [<c0619d7c>] (gpmc_smsc911x_init+0x1c/0x200) from [<c06165e0>] (overo_init+0xdc/0x27c)
[    0.395446] [<c06165e0>] (overo_init+0xdc/0x27c) from [<c0609380>] (customize_machine+0x1c/0x28)
[    0.404663] [<c0609380>] (customize_machine+0x1c/0x28) from [<c0008800>] (do_one_initcall+0x34/0x178)
[    0.414306] [<c0008800>] (do_one_initcall+0x34/0x178) from [<c06068ac>] (kernel_init+0x8c/0x130)
[    0.423553] [<c06068ac>] (kernel_init+0x8c/0x130) from [<c000e850>] (kernel_thread_exit+0x0/0x8)
[    0.432800] ------------[ cut here ]------------
[    0.437652] WARNING: at /work/kernel/omap/pm/fs/sysfs/dir.c:481 sysfs_add_one+0x88/0xb0()
[    0.446228] sysfs: cannot create duplicate filename '/devices/platform/reg-fixed-voltage.42'
[    0.455047] Modules linked in:
[    0.458312] [<c001421c>] (unwind_backtrace+0x0/0xf0) from [<c00391e4>] (warn_slowpath_common+0x4c/0x64)
[    0.468170] [<c00391e4>] (warn_slowpath_common+0x4c/0x64) from [<c0039290>] (warn_slowpath_fmt+0x30/0x40)
[    0.478179] [<c0039290>] (warn_slowpath_fmt+0x30/0x40) from [<c014eed8>] (sysfs_add_one+0x88/0xb0)
[    0.487548] [<c014eed8>] (sysfs_add_one+0x88/0xb0) from [<c014ef60>] (create_dir+0x60/0xc4)
[    0.496307] [<c014ef60>] (create_dir+0x60/0xc4) from [<c014f048>] (sysfs_create_dir+0x58/0x8c)
[    0.505340] [<c014f048>] (sysfs_create_dir+0x58/0x8c) from [<c022bbec>] (kobject_add_internal+0x9c/0x1b8)
[    0.515350] [<c022bbec>] (kobject_add_internal+0x9c/0x1b8) from [<c022bfd8>] (kobject_add+0x50/0x98)
[    0.524932] [<c022bfd8>] (kobject_add+0x50/0x98) from [<c0285a14>] (device_add+0xb8/0x358)
[    0.533599] [<c0285a14>] (device_add+0xb8/0x358) from [<c0289234>] (platform_device_add+0xf8/0x1a4)
[    0.543090] [<c0289234>] (platform_device_add+0xf8/0x1a4) from [<c0619d7c>] (gpmc_smsc911x_init+0x1c/0x200)
[    0.553283] [<c0619d7c>] (gpmc_smsc911x_init+0x1c/0x200) from [<c06165e0>] (overo_init+0xdc/0x27c)
[    0.562652] [<c06165e0>] (overo_init+0xdc/0x27c) from [<c0609380>] (customize_machine+0x1c/0x28)
[    0.571868] [<c0609380>] (customize_machine+0x1c/0x28) from [<c0008800>] (do_one_initcall+0x34/0x178)
[    0.581512] [<c0008800>] (do_one_initcall+0x34/0x178) from [<c06068ac>] (kernel_init+0x8c/0x130)
[    0.590728] [<c06068ac>] (kernel_init+0x8c/0x130) from [<c000e850>] (kernel_thread_exit+0x0/0x8)
[    0.600372] ---[ end trace 1b75b31a2719ed1c ]---
[    0.605285] kobject_add_internal failed for reg-fixed-voltage.42 with -EEXIST, don't try to register things with the same name in the same directory.
[    0.619262] [<c001421c>] (unwind_backtrace+0x0/0xf0) from [<c022bcf0>] (kobject_add_internal+0x1a0/0x1b8)
[    0.629272] [<c022bcf0>] (kobject_add_internal+0x1a0/0x1b8) from [<c022bfd8>] (kobject_add+0x50/0x98)
[    0.638946] [<c022bfd8>] (kobject_add+0x50/0x98) from [<c0285a14>] (device_add+0xb8/0x358)
[    0.647613] [<c0285a14>] (device_add+0xb8/0x358) from [<c0289234>] (platform_device_add+0xf8/0x1a4)
[    0.657073] [<c0289234>] (platform_device_add+0xf8/0x1a4) from [<c0619d7c>] (gpmc_smsc911x_init+0x1c/0x200)
[    0.667266] [<c0619d7c>] (gpmc_smsc911x_init+0x1c/0x200) from [<c06165e0>] (overo_init+0xdc/0x27c)
[    0.676666] [<c06165e0>] (overo_init+0xdc/0x27c) from [<c0609380>] (customize_machine+0x1c/0x28)
[    0.685852] [<c0609380>] (customize_machine+0x1c/0x28) from [<c0008800>] (do_one_initcall+0x34/0x178)
[    0.695526] [<c0008800>] (do_one_initcall+0x34/0x178) from [<c06068ac>] (kernel_init+0x8c/0x130)
[    0.704711] [<c06068ac>] (kernel_init+0x8c/0x130) from [<c000e850>] (kernel_thread_exit+0x0/0x8)
[    0.713897] gpmc_smsc911x_init: Unable to register smsc911x regulators: -17

