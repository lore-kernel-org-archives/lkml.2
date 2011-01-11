Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1AKLP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:15:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49633 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab1AKLPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:15:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Grt52g+sxRW1P8p4yUJk/fMMm4VPhvqx6lmxTI14CLsc0Hrow+/Dcu+T9DVjUdUKLS
         QH/qG1061z0uI8w+GH+ohrPrGq3bFPz2IV8AKURR6fHbZG8rk4I6jrE+0SZSKyOTA4ea
         BcQuuHhL7amqEl85jJp4xWGZH17fhxvU51jiM=
MIME-Version: 1.0
In-Reply-To: <20110111103929.GN24920@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com>
	<20110111091607.GI12552@n2100.arm.linux.org.uk>
	<201101111744.59712.jeremy.kerr@canonical.com>
	<20110111103929.GN24920@pengutronix.de>
Date: Tue, 11 Jan 2011 19:15:24 +0800
Message-ID: <AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>
Subject: Re: Locking in the clk API
From: Richard Zhao <linuxzsc@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/11 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hi,
>
> On Tue, Jan 11, 2011 at 05:44:59PM +0800, Jeremy Kerr wrote:
>> > I object to this as one of the purposes behind the clk API is to allow
>> > power savings to be made, and unless we can perform clk enable/disable
>> > from atomic contexts, the best you can do is enable the clock when the
>> > device is probed and disable it when it's released.
>> >
>> > [...]
>> >
>> > Sometimes the only point that you know you need the clock enabled is when
>> > your driver has already been called in an atomic context.
>>
>> .. provided that the enable (and subsequent things that depend on the clock
>> signal to be valid) can't be deferred; I'm not sure how often this will be
>> possible.
>>
>> So, it sounds like the best approach is to provide an atomic clk_enable. I
>> agree with Sascha that the clk_enable and clk_enable_atomic polarity makes the
>> most sense, so how about:
>>
>> int clk_enable(struct clk *clk)
>> {
>>       might_sleep();
>>
>>       [...]
>> }
>>
>> int clk_enable_atomic(struct clk *clk)
>> {
>>       BUG_ON(!(clk->flags & CLK_ATOMIC));
>>
>>       [...]
>> }
>>
>> Paul: even though you mention that the atomic clocks are the usual case, I
>> think that this way around illustrates the atomic 'restriction' at the call
>> site more clearly. When the drivers don't care about the atomicity,
>> clk_enable() is fine. When drivers do need an atomic clock,
>> clk_enable_atomic() shows this requirement.
> I agree that we should try to make the clk api easy and consistent.  So
> if we can go the atomic way we should in my opinion.
>
> On i.mx the roots in the clk hierarchy are plls, so it would be nice to
> know how long it takes to enable these.
>
> Back when I implemented clk support for ns921x I had a clock that made
> me think that a sleeping implementation would be the way to go.  I don't
> remember the exact details.  (It was the rtc clk.)
>
> A quick look into Digi's BSP (digiEL-5.0) shows they implemented
> something I suggested earlier here:
>
>        static int clk_enable_haslocknchange(struct clk *clk)
>        {
>                int ret = 0;
>
>                assert_spin_locked(&clk_lock);
>                BUG_ON(!test_bit(CLK_FLAG_CHANGESTATE, &clk->flags));
>
>                if (clk->usage++ == 0) {
>                        if (clk->parent) {
>                                ret = clk_enable_haslock(clk->parent);
>                                if (ret)
>                                        goto err_enable_parent;
>                        }
>
>                        spin_unlock(&clk_lock);
>
>                        if (clk->endisable)
>                                ret = clk->endisable(clk, 1);
>
>                        spin_lock(&clk_lock);
>
>                        if (ret) {
>                                clk_disable_parent_haslock(clk);
>        err_enable_parent:
>                                clk->usage = 0;
>                        }
>                }
>
>                return ret;
>        }
>
>        static int clk_enable_haslock(struct clk *clk)
>        {
>                int ret;
>                assert_spin_locked(&clk_lock);
>                if (__test_and_set_bit(CLK_FLAG_CHANGESTATE, &clk->flags))
>                        return -EBUSY;
>
>                ret = clk_enable_haslocknchange(clk);
>
>                clear_bit(CLK_FLAG_CHANGESTATE, &clk->flags);
>
>                return ret;
>        }
>
>        int clk_enable(struct clk *clk)
>        {
>                ...
>                spin_lock_irqsave(&clk_lock, flags);
>                ret = clk_enable_haslock(clk);
>                spin_unlock_irqrestore(&clk_lock, flags);
>                return ret;
>        }
>
>
> I think the idea is nice.  At least it allows with a single lock to
> implement both, sleeping and atomic clks without the need to mark the
> atomicity in a global flag.
>
> In the meantime Sascha checked on mx51 how long it takes to enable one
> of the three PLLs: 50us.  Is this fast enough to accept disabled irqs
> that long?
A well running board will not enable/disable PLLs frequently. It don't
make sense. PLLs are normally disabled on request to enter low power
mode, rather not because all their child clocks are disabled.   So we
don't have to consider the time here.

Thanks
Richard
>
> Best regards
> Uwe
>
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
