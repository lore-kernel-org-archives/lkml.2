Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2CEAae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:30:34 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:45307 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755985Ab2CEAad convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:30:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mturquette@ti.com designates 10.213.27.84 as permitted sender) smtp.mail=mturquette@ti.com
MIME-Version: 1.0
In-Reply-To: <20120304174229.GD11546@lunn.ch>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-5-git-send-email-mturquette@linaro.org> <20120304174229.GD11546@lunn.ch>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sun, 4 Mar 2012 16:30:08 -0800
Message-ID: <CAJOA=zNWN6L+-YEkNKoQnjnrrswNpCBmtnhKBm04HekWP46i5w@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] clk: basic clock hardware types
To: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
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

On Sun, Mar 4, 2012 at 9:42 AM, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sat, Mar 03, 2012 at 12:29:01AM -0800, Mike Turquette wrote:
>> Many platforms support simple gateable clocks, fixed-rate clocks,
>> adjustable divider clocks and multi-parent multiplexer clocks.
>>
>> This patch introduces basic clock types for the above-mentioned hardware
>> which share some common characteristics.
>
> Hi Mike
>
> These basic clocks don't allow the use of prepare/unprepare, from the
> side of the clock provider. I think i need this.

This is an interesting point and might help us nail down exactly what
we expect from clk_prepare/clk_unprepare.

>
> The Orion Kirkwood SoC has clock gating for most of its on chip
> peripherals, which the other older Orion devices don't have. The SATA
> and PCIe also allows the PHY to be shut down, again which older Orion
> devices don't have. The current code links the clock and the PHY
> together, shutting both down are the same time. So i would like to
> perform the PHY shutdown in the unprepare() function of the clk
> driver.

Do you feel it is The Right Thing to enable/disable the phy from
clk_prepare/clk_unprepare?  I had always imagined that clk_prepare's
purpose was always specific to clock-related activities; for example
maybe turn on a parent PLL that takes a long time to lock, as well as
for the sleepable cases such as clocks over i2c, etc.

However, I know that some others have already started performing
voltage scaling from clk_prepare, so clearly the api is not strict in
it's purpose.

Have you investigated powering up/down the phy from a different layer
such pm_runtime?  That might create a better layer of separation
between other resources needed by an IP block and the clock framework.
 For instance on OMAP we use pm_runtime_get(_sync) to call clk_prepare
& clk_enable and handle other power management-related resources.
Perhaps using the clock framework to power up/down your IP block is
not the right tool for the job.

>
> Is allowing to pass prepare/unprepare functions to basic clocks
> something you want to support? If i prepare a patch would you consider
> it?

My original instinct was "no".  The simple gate clock was always
supposed to be "simple" and if you need more than it provides then it
might be best for your platform to implement a specific clock type.
Especially since the purpose of clk_prepare is still up in the air.

But I'll keep an open mind and hopefully others can chime in.  Please
let me know what you think about my pm_runtime suggestion.  I've Cc'd
Rafael just in case he has something to add here from a design
perspective.

Regards,
Mike

>
>        Thanks
>                Andrew
