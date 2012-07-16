Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2GPXXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 19:23:01 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:40093 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab2GPXW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 19:22:58 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda7g2qMErwf-nebKSOW=044=YadEzEoKWM1dT=29yueeA@mail.gmail.com>
References: <1342225001-22962-1-git-send-email-mturquette@linaro.org>
 <1342225001-22962-3-git-send-email-mturquette@linaro.org> <CACRpkda7g2qMErwf-nebKSOW=044=YadEzEoKWM1dT=29yueeA@mail.gmail.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 16 Jul 2012 16:22:35 -0700
Message-ID: <CAJOA=zOSwfVnL=JrNfY5fE2tjzL1T_2Sd0rCrijaO3AxosStDg@mail.gmail.com>
Subject: Re: [PATCH 2/2] [RFC] cpufreq: omap: scale regulator from clk notifier
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Nori, Sekhar" <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        paul@pwsan.com, pgaikwad@nvidia.com, viresh.kumar@linaro.org,
        pdeschrijver@nvidia.com, rnayak@ti.com, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, ccross@android.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        shawn.guo@linaro.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 3:28 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Jul 14, 2012 at 2:16 AM, Mike Turquette <mturquette@linaro.org> wrote:
> '
>> This patch moves direct control of the MPU voltage regulator out of the
>> cpufreq driver .target callback and instead puts that logic into a clock
>> rate change notifier callback.
>
> That's heavy stuff.
>

Gravity is stronger here.

CPU dvfs is the least interesting dvfs in my opinion, since it has
been solved by CPUfreq for eons.  However it was the lowest hanging
fruit for demoing the idea behind dvfs-via-clk-notifer.

This is a chicken before the egg problem: drivers are not adapted for
dvfs since we have no dvfs api.  In trying to demonstrate
dvfs-via-clk-notifier it was much easier for me to hijack one of the
few existing sources of dvfs in the kernel: cpufreq.  If my platform
of choice (pandaboard) had any device which supported devfreq (e.g.
gpu, ddr or mmc controller) then I might have chosen that instead, but
the change would have been essentially the same as the one above.

> I was hoping that the first example of using clk notifiers would be
> something like mach-davinci replacing it's legacy clock framework
> with drivers/clk and then go in and change the horrid cpufreq hack
> that is currently in drivers/mmc/host/davinci_mmc.c to use a
> clock notifier instead of cpufreq.
>

I am not familiar with the issue you're talking about here, but it
sounds more like some clk functional dependencies have been stuffed
into the davinci cpufreq driver?  clk notifiers can handle that as
well, and the reentrancy issues would remain (calling clk_set_rate
from within clk_set_rate).  The point of this series is that the state
of reentrancy in the clk framework sucks and I could use some
collective brainpower to improve it :-)

> Sekhar/Kevin, any chance to have DaVinci converted to Mikes new
> clock framework? It doesn't look super-complex and would be a
> good example for others I think.
>

Again, I'd love more platform ports to the common clock framework, but
I hope that the purpose of this RFC is not lost in the noise.  Devices
like off-soc audio chips and pmics are screwed without some change to
the core code and we are not advancing the state of dvfs in an
upstream kernel until some of these issues are sorted.

Thanks much,
Mike

> Yours,
> Linus Walleij
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
