Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1JCPZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:25:03 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60562 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab1JCPY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:24:56 -0400
Message-ID: <4E89D3C4.8090001@gmail.com>
Date: Mon, 03 Oct 2011 10:24:52 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org, eric.miao@linaro.org,
        magnus.damm@gmail.com, amit.kucheria@linaro.org,
        richard.zhao@linaro.org, grant.likely@secretlab.ca, dsaxena@linaro.org,
        arnd.bergmann@linaro.org, shawn.guo@freescale.com, skannan@quicinc.com,
        linux@arm.linux.org.uk, jeremy.kerr@canonical.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, sboyd@quiinc.com
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-2-git-send-email-mturquette@ti.com> <4E89C3FA.9020206@gmail.com> <20111003142524.GN3731@opensource.wolfsonmicro.com>
In-Reply-To: <20111003142524.GN3731@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 09:25 AM, Mark Brown wrote:
> On Mon, Oct 03, 2011 at 09:17:30AM -0500, Rob Herring wrote:
>> On 09/22/2011 05:26 PM, Mike Turquette wrote:
> 
> A lot of stuff that should really have been cut plus...
> 
>>> +	if (clk->ops->get_parent)
>>> +		/* We don't to lock against prepare/enable here, as
>>> +		 * the clock is not yet accessible from anywhere */
>>> +		clk->parent = clk->ops->get_parent(clk->hw);
> 
>> I don't think this is going to work. This implies that the parent clock
>> is already registered. For simple clk trees, that's probably not an
>> issue, but for chips with lots of muxing it will be impossible to get
>> the order correct for all cases. This is not an issue today as most
>> clocks are statically created.
> 
>> I think what is needed is a 2 stage init. The 1st stage to create all
>> the clocks and a 2nd stage to build the tree once all clocks are created.
> 
>> Tracking the parents using struct clk_hw instead would help as long as
>> clocks are still statically allocated. However, that won't help for
>> devicetree.
> 
> This isn't in any way specific to clocks, right now the likely solution
> looks to be Grant's changes for retrying probe() as new devices come on
> line.  With that devices can return a code from their probe() which
> tells the driver core that they couldn't get all the resources they need
> and that it should retry the probe() if more devices come on-line.

Except SOC clocks are initialized very early before timers are up and
there can be a very high number of dependencies (every clock except
fixed clocks). With the driver probe retry, retrying is the exception,
not the rule.

Retrying would require every caller to maintain a list of clks to
retry. With 2 stages, you can move that into the core clock code.

There are not typically a large number of board-level/driver created
clocks, so ensuring correct register order is not really a problem. In
cases where there is a cross-driver dependency, the probe retry is a
good solution.

Rob
