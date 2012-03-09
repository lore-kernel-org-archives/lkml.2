Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2CIXjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 18:39:07 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33967 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754268Ab2CIXjF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 18:39:05 -0500
MIME-Version: 1.0
In-Reply-To: <20120305101708.GF24858@lunn.ch>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-5-git-send-email-mturquette@linaro.org> <20120304174229.GD11546@lunn.ch>
 <CAJOA=zNWN6L+-YEkNKoQnjnrrswNpCBmtnhKBm04HekWP46i5w@mail.gmail.com>
 <20120305084823.GD24858@lunn.ch> <20120305092948.GV3852@pengutronix.de> <20120305101708.GF24858@lunn.ch>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 9 Mar 2012 15:38:39 -0800
Message-ID: <CAJOA=zNS+s+b1_KvBeur0KxnBkUbXeu0Pyj9n877dvUQF22VPw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] clk: basic clock hardware types
To: Andrew Lunn <andrew@lunn.ch>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 2:17 AM, Andrew Lunn <andrew@lunn.ch> wrote:
>> > I think i can wrap your simple gate clock, to make my "complex" gate
>> > clock. What would help is if you would EXPORT_SYMBOL_GPL
>> > clk_gate_enable() and clk_gate_disable(), since they do exactly what i
>> > want. I can then build my own clk_ops structure, with my own
>> > unprepare() function. I would probably use DEFINE_CLK_GATE as is, and
>> > then at run time, before calling __clk_init() overwrite the .ops with
>> > my own version.
>>
>> Maybe I don't get your point, but clk_unprepare should be used when
>> you have to sleep to disable your clock. When clk_gate_disable() is
>> exactly why do you want to use clk_unprepare instead of clk_disable?
>
> I'm trying to avoid having to implement a new clock provider. The
> whole point of the generic clk code is to consolidate code. It seems
> silly to create a new clk provider which is 95% identical to Mike's
> gated provider, if i can avoid it.

I will export the operations in my next patchset, but I'm concerned
over how useful this might be...

Using your example of struct clk_gate, both clk_gate_enable and
clk_gate_disable call to_clk_gate.  So you would either have to re-use
struct clk_gate for your own needs (which involves hacking up a
specific struct clk_gate_foo_ops for your needs) or you could not use
struct clk_gate and pack your data identically (struct clk_hw must be
the first member) which is too horrible to imagine.

Hmm, or you could re-use struct clk_gate but provide your own struct
clk_ops AND your own registration functions (since you won't be able
to pass in the ops to your clk_register_gate).  So that sounds sane,
if a bit convoluted.  It does re-use code though...

Regards,
Mike

>
> If i stuff it into clk_disable(), it means i cannot use the basic gate
> clock Mike provides in the generic clock framework. Which is a shame,
> since it does exactly what i want in terms of gating the clock.
>
> If i can use unprepare(), which basic gate does not use, i can use
> Mikes code, and just extend it. It is there, it is unused, so why not
> use it?
>
>    Andrew
