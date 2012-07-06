Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750828Ab2GFEC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 00:02:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47573 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2GFEC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 00:02:56 -0400
MIME-Version: 1.0
In-Reply-To: <1341520528.3076.3.camel@lorien2>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
 <1341378617-10386-26-git-send-email-bryan.wu@canonical.com>
 <1341506839.2605.11.camel@lorien2> <20120705194828.GA1563@gmail.com> <1341520528.3076.3.camel@lorien2>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 6 Jul 2012 12:02:35 +0800
X-Google-Sender-Auth: HjS_pJdmj2k0wz6JF7Dg-R_f1_4
Message-ID: <CAK5ve-+_FHeSiMJ-VAO4GDhtmf-+h9Y+msuiaZunRBoQ8NNC3w@mail.gmail.com>
Subject: Re: [PATCH 25/25] leds: convert One-shot LED trigger driver to
 devm_kzalloc() and cleanup error exit path
To: shuahkhan@gmail.com
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>, linux-leds@vger.kernel.org,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 4:35 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Thu, 2012-07-05 at 21:48 +0200, Fabio Baltieri wrote:
>
>> > >
>> > Bryan,
>> >
>> > I don't believe memory triggers allocate in their activate routine
>> > should be converted to devm_kzalloc(). Based on my understanding, the
>> > memory allocated using devm_kzalloc() us free'ed when driver is
>> > detached. In the case of led triggers, driver stays registered while the
>> > triggers it supports can be activated and deactivated many times. By
>> > converting these allocations into devm_kzalloc()s could lead to memory
>> > leaks. Please correct me if my understanding is incorrect.
>>
>> Shuah,
>>
>> I'm as the same opinion - as triggers are not really "driver", in the
>> sense that they are not using the driver structures, using devm_
>> functions doesn't seems to be really appropriate.
>>
>
> Correct. Each driver could support multiple triggers and triggers are
> not at the same level as the device.
>
>> Specifically:
>>
>> > > + oneshot_data = devm_kzalloc(led_cdev->dev, sizeof(*oneshot_data),
>> > > +                         GFP_KERNEL);
>>
>> this one is registering the data on the relative LED's resources, so
>> that they are not freed until you unload the LED's driver itself.
>> I also think that this leads to memory leak if you keep activating
>> triggers, as the deactivate function is not actually freeing the
>> resources, so in that case the correct procedure should be the usual
>> kalloc/kfree.
>>
>> Is this consistent with what your conclusions, Shuah?
>
> Correct. Using devm_ in triggers is not the correct and there is no need
> to change from using kalloc()/kfree().
>

Exactly, you guys are right about this. Thanks for correcting me.

Trigger drivers kzalloc() in activate() which will be called multiple
times as trigger drivers normally sit in memory and don't follow
normal driver probe/remove or device register/unregister.

I will drop these patches.

-Bryan

>>
>> > If what I am saying makes sense, please take this as comment that is
>> > applicable to all led triggers, not just this one.
>> >
>> > Thanks,
>> > -- Shuah
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-leds" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
