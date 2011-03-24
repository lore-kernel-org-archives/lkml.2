Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab1CXVka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:40:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50309 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab1CXVkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=CxKvXN5T1/25eCbxtU2yaQmTHIp0hOyAFk9smMhDwKQJ0gxiuXQCAReYeJCk7waU0c
         T3IGJpSNaMjqb6WMCthOUDlxylXRMmOlkZ9O5zHGESsu885hnOueM+oA20VRQyxA385a
         uHYeYk6UA/SLrzmK0MZ6h/mvUutDk65ErplBA=
MIME-Version: 1.0
In-Reply-To: <20110324205946.GO3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <1300980071-24645-3-git-send-email-jamie@jamieiles.com> <AANLkTikaO3_WgFjF04+kfQ_vxxpHhCmC1mpHJvjo7ZtS@mail.gmail.com>
 <20110324205946.GO3130@pulham.picochip.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 17:40:04 -0400
X-Google-Sender-Auth: 5I2FE-auUcdkc_neH-ALs7aXmWU
Message-ID: <AANLkTik7Zye1sxVvt5c_hjcAN1VG5kyr5VPivjXXEY3q@mail.gmail.com>
Subject: Re: [RFC PATCHv2 2/4] drivers/otp: add support for Picoxcell PC3X3 OTP
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 16:59, Jamie Iles wrote:
> On Thu, Mar 24, 2011 at 02:50:35PM -0400, Mike Frysinger wrote:
>> On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
>> > +static void otp_charge_pump_enable(struct pc3x3_otp *otp, int enable)
>> > +{
>> > +#define OTP_MRA_CHARGE_PUMP_ENABLE_MASK            (1 << 12)
>> > +#define OTP_MRA_CHARGE_PUMP_MONITOR_MASK    (1 << 15)
>> > +#define OTP_MRA_READ_REFERENCE_LEVEL9_MASK  (1 << 9)
>> > +#define OTP_MRA_READ_REFERENCE_LEVEL5_MASK  (1 << 5)
>> > +#define OTP_STATUS_VPP_APPLIED             (1 << 4)
>> > +       u32 mra = enable ?
>> > +               (OTP_MRA_CHARGE_PUMP_ENABLE_MASK |
>> > +                OTP_MRA_CHARGE_PUMP_MONITOR_MASK |
>> > +                OTP_MRA_READ_REFERENCE_LEVEL9_MASK |
>> > +                OTP_MRA_READ_REFERENCE_LEVEL5_MASK) : 0;
>> > +
>> > +       otp_write_MRA(otp, mra);
>> > +
>> > +       /* Now wait for VPP to reach the correct level. */
>> > +       if (enable && !test_mode) {
>> > +               while (!(otp_read_reg(otp, OTP_MACRO_STATUS_REG_OFFSET) &
>> > +                        OTP_STATUS_VPP_APPLIED))
>> > +                       cpu_relax();
>> > +       }
>> > +
>> > +       udelay(1);
>> > +}
>>
>> is that udelay() really necessary ?  could it be refined to a smaller ndelay() ?
>
> It's what is specifed in the IP vendors datasheets so perhaps it could
> be less but I'd like to err on the side of caution.

if that's what the datasheet says, then np, it's fine.  presumably
you're not charging it for fun which means you cant background the
wait.

>> > +       if (test_mode) {
>> > +               u64 *p = devm_kzalloc(&pdev->dev, SZ_16K + SZ_1K, GFP_KERNEL);
>> > ...
>> > +       } else {
>> > +               pc3x3_dev->iomem = devm_ioremap(&pdev->dev, mem->start,
>> > +                                               resource_size(mem));
>> > ...
>> > +out_unregister:
>> > +       otp_device_unregister(otp);
>> > +out_clk_disable:
>> > +       clk_disable(pc3x3_dev->clk);
>> > +       clk_put(pc3x3_dev->clk);
>> > +out:
>> > +       return err;
>>
>> hmm, but you dont iounmap or free any of the memory from earlier when
>> you error out ...
>
> No, that's what the devm_* stuff does for us.

hmm, wasnt aware of this devm* stuff.  sounds like fun and i could use
it elsewhere.

>> > +static struct platform_driver otp_driver = {
>> > +       .remove         = __devexit_p(otp_remove),
>> > +       .driver         = {
>> > +               .name   = "picoxcell-otp-pc3x3",
>> > +               .pm     = &otp_pm_ops,
>> > +       },
>> > +};
>> >
>> > +static int __init pc3x3_otp_init(void)
>> > +{
>> > +       return platform_driver_probe(&otp_driver, otp_probe);
>> > +}
>>
>> why call probe yourself ?  why not platform_driver_register() ?
>
> I made this comment in another driver myself and another reviewer
> pointed out that if the device isn't some kind of hotplug device then it
> probably isn't needed to let the bus do the matching and probing but I'm
> happy to do what you've suggested, it feels a bit more natural anyway!

that's why the pseudo "platform" bus exists in the first place.  i
could somewhat understand if the probe function actually did probing
to see if the device in question existed before going further, but
this probe function simply assumes that if it gets called, the device
exists.  as such, it makes a lot more sense to force people to "opt
in" via their platform resources.  otherwise, the whole "build one
kernel but deploy to multiple boards" pretty much goes out the window.
-mike
