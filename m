Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0DZNSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:18:55 -0400
Received: from bar.sig21.net ([80.81.252.164]:52412 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0DZNSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:18:54 -0400
Date: Mon, 26 Apr 2010 15:18:43 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Magnus Damm <damm@opensource.se>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Q: sched_clock() vs. clocksource, how to implement correctly
Message-ID: <20100426131843.GA28332@sig21.net>
References: <20100423150917.GA25714@sig21.net>
 <20100423182933.0df45b53@mschwide.boeblingen.de.ibm.com>
 <20100424205011.GA21632@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100424205011.GA21632@sig21.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.757,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 10:50:11PM +0200, Johannes Stezenbach wrote:
> /*
>  * Orion's sched_clock implementation. It has a resolution of
>  * at least 7.5ns (133MHz TCLK) and a maximum value of 834 days.
>  *
>  * Because the hardware timer period is quite short (21 secs if
>  * 200MHz TCLK) and because cnt32_to_63() needs to be called at
>  * least once per half period to work properly, a kernel timer is
>  * set up to ensure this requirement is always met.
>  */
> #define TCLK2NS_SCALE_FACTOR 8

I found the following discussion of the sched_clock()
implementation trade-offs very informative:
http://lkml.org/lkml/2010/4/15/299

It mentions clocksource_calc_mult_shift() which was added in 2.6.33,
however I had some difficulties understanding the meaning of the minsec
parameter, especially since all existing callers use a value of 4.
But when using minsec = 365*24*60*60 (1 year) it results in the shift value of 8.

So finally the pieces connect together :-)

> BTW, even though this uses TCLK2NS_SCALE_FACTOR of 8, the same file
> uses a shift vaue of 20 for the orion_clksrc...

It seems clocksource_cyc2ns() is used in kernel/time/timekeeping.c
and kernel/time/clocksource.c only on relatively
small delta values, so there's no need to worry
about overflow and a large clocksource.shift and .mult is OK.

(Apparently the minsec value of 4 mentioned above is suitable
for timekeeping?  Where does the 4 come from?)


Thanks,
Johannes
