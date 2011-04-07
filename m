Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1DGHbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 03:31:35 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:41489 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233Ab1DGHbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 03:31:34 -0400
Message-ID: <4D9D6823.70704@stericsson.com>
Date: Thu, 7 Apr 2011 09:30:43 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv5 3/3] ARM: Implement a timer based __delay() loop
References: <1302047800-26720-1-git-send-email-sboyd@codeaurora.org> <1302047800-26720-4-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1302047800-26720-4-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 01:56 AM, Stephen Boyd wrote:
> udelay() can be incorrect on SMP machines that scale their CPU
> frequencies independently of one another (as pointed out here
> http://article.gmane.org/gmane.linux.kernel/977567). The delay
> loop can either be too fast or too slow depending on which CPU the
> loops_per_jiffy counter is calibrated on and which CPU the delay
> loop is running on. udelay() can also be incorrect if the
> CPU frequency switches during the __delay() loop, causing the loop
> to either terminate too early, or too late.
>
> Forcing udelay() to run on one CPU is unreasonable and taking the
> penalty of a rather large loops_per_jiffy in udelay() when the
> CPU is actually running slower is bad for performance. Solve the
> problem by adding a timer based__delay() loop unaffected by CPU
> frequency scaling. Machines should set this loop as their
> __delay() implementation by calling set_timer_fn() during their
> timer initialization.
>
> The kernel is already prepared for a timer based approach
> (evident by the read_current_timer() function). If an arch
> implements read_current_timer(), calibrate_delay() will use
> calibrate_delay_direct() to calculate loops_per_jiffy (in which
> case loops_per_jiffy should really be renamed to
> timer_ticks_per_jiffy). Since the loops_per_jiffy will be based
> on timer ticks, __delay() should be implemented as a loop around
> read_current_timer().
>
> Doing this makes the expensive loops_per_jiffy calculation go
> away (saving ~150ms on boot time on my machine) and fixes
> udelay() by making it safe in the face of independently scaling
> CPUs. The only prerequisite is that read_current_timer() is
> monotonically increasing across calls (and doesn't overflow
> within ~2000us).
>
> There is a downside to this approach though. BogoMIPS is no
> longer "accurate" in that it reflects the BogoMIPS of the timer
> and not the CPU. On most SoC's the timer isn't running anywhere
> near as fast as the CPU so BogoMIPS will be ridiculously low (my
> timer runs at 4.8 MHz and thus my BogoMIPS is 9.6 compared to my
> CPU's 800). This shouldn't be too much of a concern though since
> BogoMIPS are bogus anyway (hence the name).
>
> This loop is pretty much a copy of AVR's version.

Tested-by: Mattias Wallin <mattias.wallin@stericsson.com>

Yours,
Mattias Wallin

