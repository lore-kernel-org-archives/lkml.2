Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1CFRmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 12:42:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43748 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1CFRmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 12:42:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=vyYqEvvYcErnf8P2mfi5P0cUVE3O1yoTzlV3gm2/pAqXHgRgNBT9fUpdL0kycjcYsd
         i9vDweltzP9Cx3kZ8Ngg==
MIME-Version: 1.0
In-Reply-To: <7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com>
References: <1290060899-9786-1-git-send-email-ccross@android.com>
	<AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
	<4D70BE9D.4000507@stericsson.com>
	<AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com>
	<4D714C17.7080102@gmail.com>
	<AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com>
	<eea425c066cc69c30f118fb102fff43e@mail.gmail.com>
	<AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com>
	<7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com>
Date: Sun, 6 Mar 2011 09:42:46 -0800
X-Google-Sender-Auth: sASoQzA5qYWaQCthCHAPyinOoWU
Message-ID: <AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency withcpufreqnotifiers
From: Colin Cross <ccross@android.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        martin persson <martin.persson@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 6, 2011 at 6:20 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
>> -----Original Message-----
>> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-
>> arm-kernel-bounces@lists.infradead.org] On Behalf Of Linus Walleij
>> Sent: Sunday, March 06, 2011 5:37 PM
>> To: Santosh Shilimkar
>> Cc: Russell King; Srinidhi KASAGAR; Harald Gustafsson; Linus
>> Walleij; linux-kernel@vger.kernel.org; Rickard ANDERSSON; martin
>> persson; Colin Cross; Varun Swara; Catalin Marinas; linux-arm-
>> kernel@lists.infradead.org
>> Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency
>> withcpufreqnotifiers
>>
>> On Sat, Mar 5, 2011 at 9:19 AM, Santosh Shilimkar
>> <santosh.shilimkar@ti.com> wrote:
>>
>> > While doing this patch for OMAP I also found that
>> > CPUFREQ notifiers does delays scaling timer frequency
>> > and there is a tick deviation(3-4 ms) around 1st tick and
>> > last tick around twd rescaling.
>>
>> Is this caused by ticks that have been programmed
>> already (based on the previous frequency) when the scaling
>> takes effect? (That's most likely I think.)
>>
> That's correct Linus. I noticed that Collin's patch reduces that
> problem a bit. In my patch I was always leaving the scaling
> to post notifier which actually aggravates the scenario.

If you always scale in the post notifier, you will end up with delays
that are too short when the cpu frequency increases before the scaling
is decreased.

A large tick deviation is unexpected - the timer value doesn't need to
be reprogrammed, we are adjusting a prescaler between the cpu clock
and the counter so that the counter always increments at the same
frequency.  The only inaccuracy occurs between when the prescaler is
reprogrammed and the clock frequency changes, where it counts at the
wrong frequency.  This time should hopefully be very short.

On Tegra, the worst case transition is from the lowest frequency,
54MHz, to the highest frequency, 250 MHz.  Assuming a 1MHz twd rate,
the prescaler goes from 54 to 250.  If the time between changing the
prescaler and clock is 3 ms (1 ms for the pll to lock, 2 ms worst case
waiting for the IPI to the other cpu), the timer will increment 648
times (3 ms * 54 MHz / 250) instead of 3000 times (3 ms * 250 Mhz /
250), delaying the next tick by 2.3 ms.

>> The latter could be fixed by simply calling
>> schedule() for each CPU connected in the same core as
>> the TWD at the end of twd_update_cpu_frequency(),
>> couldn't it?
>>
> I don't think schedule will do any difference here because
> it's the actual tick duration which getting changed. The
> tick does happen as per the timer load value. Now it all
> depends at what point time in tick window the timer scaling
> happens.
>
>> Colin what do you say?
>>

You can't call schedule, interrupts are disabled.  You may be able to
reprogram the clockevents based on the clocksource.  Is there any way
for a clockevent to invalidate the current event and ask for it to be
reprogrammed?

>> > Another issue was not able to select higher fixed twd rate
>> > and found fix for the same.
>>
>> Can you send out the patch?
>>
> Sure. May be let's get all these twd scaling
> patches on the list. Rob's clock patches, Collin's
> notifier patch. And then I shall post the fix on
> top of that.
>
> Regards,
> Santosh
>
