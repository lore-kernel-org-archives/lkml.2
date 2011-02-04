Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1BDXcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 18:32:31 -0500
Received: from smtp-out.google.com ([216.239.44.51]:40349 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1BDXca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 18:32:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nV+QtBVJHo8k9BfOuV05s73vFinBMOoQOJDypyyoES+nHqCwsnYH6nm1tcq3BBEwXR
         3Px9ySO5hvn03YmCPrbQ==
MIME-Version: 1.0
In-Reply-To: <-8932138696981683633@unknownmsgid>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	<1295834493-5019-5-git-send-email-ccross@android.com>
	<1295968464.10109.264.camel@e102109-lin.cambridge.arm.com>
	<20110125154133.GB17280@n2100.arm.linux.org.uk>
	<1295979242.10109.308.camel@e102109-lin.cambridge.arm.com>
	<2f97ec8a084e590220e1548fc927b60e@mail.gmail.com>
	<-8932138696981683633@unknownmsgid>
Date: Fri, 4 Feb 2011 17:32:26 -0600
X-Google-Sender-Auth: MHUFUISvSpJ4IOM0ZzUf9e51JEU
Message-ID: <AANLkTi=cTXmQFm_s5OL2pGyyaFv5UR_f9MV=S5Ajx0tu@mail.gmail.com>
Subject: Re: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for re-enabling l2x0
From: Colin Cross <ccross@android.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>, konkers@android.com,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:39 PM, Will Deacon <will.deacon@arm.com> wrote:
> Santosh,
>
>> > > Maybe we need a notifier list which can be told when cpuidle
>> > events
>> > > happen, so that parts of the system such as VFP and L2 cache
>> > support
>> > > can do the right thing without having platforms add lots of stuff
>> > like
>> > >
>> > >         gic_secondary_init();
>> > >         gic_restore_interrupt_types();
>> > >         vfp_enable();
>> > >         l2x0_enable();
>> > >         twd_enable();
>> > >         ... etc ...
>> > >
>> > > in their SoC specific code.
>> >
>> > But do we need a strict order between such operations? The notifier
>> > call
>> > chain isn't too flexible.
>> >
>> I guess it does depends on how the archs have integrated a9. Example
>> on OMAP there are different power modes possible.
>>       1. CPU context ,TWD lost
>>       2. CPU context ,TWD + L1 is lost
>>       3. CPU context + L1 is lost + GIC lost
>>       4. CPU context + L1 is lost + GIC lost + L2 lost
>> So there is need to have flexibility of calling these function
>> based on power modes. I don't know how notifiers can give
>> this flexibility
>
> Well if you set the priority fields in the notifier blocks correctly
> then you can just return NOTIFY_STOP when you've saved/restored as much
> as you want. This assumes of course that you can identify which power
> mode you're entering/leaving and that each one is `deeper' than the previous.

I doubt its possible to create an order that will work for all
architectures, and returning NOTIFY_STOP would require the decision on
when to finish to be made by the notifier block instead of the
platform code.

Tegra has three possible idle modes:

1.  WFI - nothing reset
2.  CPU, TWD, L1, GIC lost, L2 needs to be disabled but not reset
3.  CPU, TWD, L1, GIC, and L2 lost

CPU and L1 are already handled by the platform-specific suspend code.
TWD is handled by the clockevents broadcast notifiers.  That leaves L2
and GIC.

The L2 can be idled in two ways: just disable it, but keep the
contents, which prevents having to refill the cache, or a full reset.
Disabling can already be handled by outer_cache_disable().

The GIC needs to be idled differently depending on which cpus are
idle.  On Tegra, if both cpus are idle, the secondary cpu needs to
disable its GIC and go to WFI, while the first cpu saves the GIC
distributor state and powers off both cpus.

While it seems possible to handle all of these cases with a notifier
chain, the amount of platform-specific knowledge and ordering seems
too much to make it worthwhile.

If the ordering requirements are close enough between platforms, or
non-existent (I don't think there are any requirements on Tegra), a
notifier chain with a mask of the hardware that is being reset could
work.  On Tegra, in case 2 above, CPU1 would call:

idle_notify(IDLE_ENTER | GIC_DISABLE)

and CPU0 would call:

idle_notify(IDLE_ENTER | GIC_DISABLE | GIC_SAVE | L2_DISABLE)
