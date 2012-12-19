Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab2LSGtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 01:49:31 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59654 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2LSGt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 01:49:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121218074711.GU26326@pengutronix.de>
References: <CADApbej+f9P1sgLMR8_McoCCSLDjJt_qitWdNd8X1v6PwZqsnQ@mail.gmail.com>
	<20121217201945.GA19651@pengutronix.de>
	<CADApbej17udzpStNeY+tsSkeOy_Fv2+o+zKs4zBLV8+ST4DWTg@mail.gmail.com>
	<20121218074711.GU26326@pengutronix.de>
Date: Wed, 19 Dec 2012 14:49:25 +0800
Message-ID: <CADApbej8ddpgQAgr3ghMJaQfwcKk_bQe++MaHiRECzpPZNCuXg@mail.gmail.com>
Subject: Re: common clock framwork: clk_set_rate issue
From: Chao Xie <xiechao.mail@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, haojian.zhuang@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 3:47 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, Dec 18, 2012 at 10:19:21AM +0800, Chao Xie wrote:
>> On Tue, Dec 18, 2012 at 4:19 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> > On Thu, Dec 06, 2012 at 10:52:03AM +0800, Chao Xie wrote:
>> >> hi
>> >> When develop the clk drivers for SOCs based on common clock framework.
>> >> I met a issue.
>> >> For example there is a uart device, it's function clock comes from a
>> >> divider, and the divider's parent is a mux. It means
>> >>
>> >> MUX --> DIV --> UART
>> >>
>> >> As we know that UART can work at low baudrate for a terminal, while it
>> >> can also connect to GPS module which needs a high rate. So the MUX
>> >> will provide two clock source, a low clock rate and high clock rate.
>> >>
>> >> The MUX clk driver clk-mux.c does not implement a ->round_rate callbacks.
>> >> It means that when uart driver is used for a GPS and it want to change
>> >> it clock, the driver will call clk_set_rate(); clk_set_rate will loop
>> >> upward to DIV, and DIV will try to set its divider, and it need loop
>> >> upward to MUX.
>> >> In fact the current clk drivers have some issue.
>> >> MUX clk driver should provide the round_rate callback, it then can
>> >> provide a new_rate. It means that in clk_calc_subtree MUX can switch
>> >> the clock source.
>> >
>> > It's not that simple. The input clocks to a mux may not only differ in
>> > their rate but can also have other different properties, like for
>> > example one input may be always present whereas another input only runs
>> > when the CPU is in run mode.
>> >
>> > It may be a possibility to add a flag to the mux to explicitely
>> > allow reparenting on a rate change.
>> >
>> There is already a flag to do it.
>> CLK_SET_RATE_PARENT
>
> That flag has another meaning. It means that a clock is allowed to
> change the parents rate when a rate change is requested. What I meant
> is a flag that allows a mux to change its parent when a rate change is
> requested.
>
another flag can help it. what i mean is that i can clear the flag
CLK_SET_RATE_PARENT of MUX's children, so when clock changing will not
impact the MUX.

>> if the mux does not want to changes the input for clk_set_rate called
>> by its child, it can clear this flag.
>> The question is whether we need add the round_rate/recalc_rate for MUX
>> type of clock? Is there any special issue about it that why current
>> MUX implementation does not have these callbacks?
>
> They currently do not need these callbacks. When a clock does not have
> round_rate propagates up to the parent if CLK_SET_RATE_PARENT is set or
> it returns the parents rate if this flag is not set. The situation with
> set_rate is similar.
>
So it means that for a uart clock  that get its clock from
MUX --> DIV --> UART
when uart want to change its rate, the driver has to know the topology
of clock tree. It can not directly clk_set_rate(uart), because it only
change the DIV settings, and if we want to change the MUX input, we
have to invoke clk_set_parent(MUX). So the uart driver need to know
the clock tree topology, and it is not good for sharing a driver
between mutiple SOCs that has same UART controller IP.
That is what i am confused about.

> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
