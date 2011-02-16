Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1BPVBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:01:17 -0500
Received: from smtp-out.google.com ([74.125.121.67]:58234 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1BPVBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jNA0O+qOToBj+fMrqh2MrZHmAgMuc1Rg3DxVX6zC3/l+89UXtoKl12sjtRxJHvfbT1
         CqC6l7hygqsMkLjRK6lg==
MIME-Version: 1.0
In-Reply-To: <4D5C34E0.5000209@codeaurora.org>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
	<1297590033-15035-13-git-send-email-ccross@android.com>
	<4D5C34E0.5000209@codeaurora.org>
Date: Wed, 16 Feb 2011 13:01:09 -0800
X-Google-Sender-Auth: vKWRU8DxgUB_3EfB6OiniPYu4mc
Message-ID: <AANLkTi=knKY65xaOT85jFidy6Be8K8RT0L1XtGqq_v2V@mail.gmail.com>
Subject: Re: [PATCH 12/21] ARM: tegra: clock: Add shared bus clock type
From: Colin Cross <ccross@android.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        konkers@android.com, linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 12:34 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 02/13/2011 01:40 AM, Colin Cross wrote:
>> +/* shared bus ops */
>> +/*
>> + * Some clocks may have multiple downstream users that need to request a
>> + * higher clock rate.  Shared bus clocks provide a unique shared_bus_user
>> + * clock to each user.  The frequency of the bus is set to the highest
>> + * enabled shared_bus_user clock, with a minimum value set by the
>> + * shared bus.
>> + */
>> +static void tegra_clk_shared_bus_update(struct clk *bus)
>> +{
>> +     struct clk *c;
>> +     unsigned long rate = bus->min_rate;
>> +
>> +     list_for_each_entry(c, &bus->shared_bus_list, u.shared_bus_user.node)
>> +             if (c->u.shared_bus_user.enabled)
>> +                     rate = max(c->u.shared_bus_user.rate, rate);
>> +
>> +     if (rate != clk_get_rate(bus))
>> +             clk_set_rate(bus, rate);
>
> What do you do if clk_set_rate() fails? Should you unwind all the state
> such as the rate and if it's enabled/disabled? Or is it safe to say
> clk_set_rate() can't fail unless the kernel is buggy in which case why
> aren't all those return -E* in the set rate functions just BUG_ONs?

In general, clk_set_rate can fail and return an error, but in this
case the failure may not be directly related to the driver that called
into tegra_clk_shared_bus_update.  For example, if clk_disable is
called on a shared clock handle, the rate may drop to the rate
requested by another shared clock handle.  clk_disable cannot fail, so
there's nothing that could be done with the return code, and the
problem was not caused by the driver that called clk_disable, so an
error would be meaningless.

I will modify tegra_clk_shared_bus_update to BUG on a failed
clk_set_rate, and modify tegra_clk_shared_bus_set_rate to
call clk_round_rate on the parent to ensure that the requested rate is valid.

>> +};
>> +
>> +static void tegra_clk_shared_bus_init(struct clk *c)
>> +{
>> +     c->max_rate = c->parent->max_rate;
>> +     c->u.shared_bus_user.rate = c->parent->max_rate;
>> +     c->state = OFF;
>> +#ifdef CONFIG_DEBUG_FS
>> +     c->set = 1;
>> +#endif
>> +
>> +     list_add_tail(&c->u.shared_bus_user.node,
>> +             &c->parent->shared_bus_list);
>> +}
>> +
>> +static int tegra_clk_shared_bus_set_rate(struct clk *c, unsigned long rate)
>> +{
>> +     c->u.shared_bus_user.rate = rate;
>> +     tegra_clk_shared_bus_update(c->parent);
>> +     return 0;
>> +}
>> +
>> +static long tegra_clk_shared_bus_round_rate(struct clk *c, unsigned long rate)
>> +{
>> +     return clk_round_rate(c->parent, rate);
>> +}
>> +
>> +static int tegra_clk_shared_bus_enable(struct clk *c)
>> +{
>> +     c->u.shared_bus_user.enabled = true;
>> +     tegra_clk_shared_bus_update(c->parent);
>> +     return 0;
>> +}
>
> Shouldn't you call clk_enable(c->parent)? And do you need to check for
> errors from clk_enable()?

clk_enable on the parent is handled by the clock op implementation in
mach-tegra/clock.c

>> +
>> +static void tegra_clk_shared_bus_disable(struct clk *c)
>> +{
>> +     c->u.shared_bus_user.enabled = false;
>> +     tegra_clk_shared_bus_update(c->parent);
>> +}
>
> And a similar clk_disable(c->parent) here.

Same for disable
