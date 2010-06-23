Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0FWUF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:05:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62508 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0FWUF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:05:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6022"; a="45174209"
Subject: Re: [RFC] [PATCH] timer: Added usleep[_range][_interruptable] timer
From: Daniel Walker <dwalker@codeaurora.org>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, sboyd@codeaurora.org, tglx@linutronix.de,
       mingo@elte.hu, heiko.carstens@de.ibm.com, eranian@google.com,
       schwidefsky@de.ibm.com, linux-arm-msm@vger.kernel.org
In-Reply-To: <4C225EED.5040600@codeaurora.org>
References: <4C225EED.5040600@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 13:05:37 -0700
Message-ID: <1277323537.15159.30.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 12:22 -0700, Patrick Pannuto wrote:
> *** INTRO ***
> 
> As discussed here ( http://lkml.org/lkml/2007/8/3/250 ), msleep(1) is not
> precise enough for many drivers (yes, sleep precision is an unfair notion,
> but consistently sleeping for ~an order of magnitude greater than requested
> is worth fixing). This patch adds a usleep API so that udelay does not have
> to be used. Obviously not every udelay can be replaced (those in atomic
> contexts or being used for simple bitbanging come to mind), but there are
> many, many examples of
> 
> mydriver_write(...)
> /* Wait for hardware to latch */
> udelay(100)
> 
> in various drivers where a busy-wait loop is neither beneficial nor
> necessary, but msleep simply does not provide enough precision and people
> are using a busy-wait loop instead.

I think one thing for you to answer would be, why do you think udelay is
a problem? I don't honestly see that many udelay()'s around, and
especially not in important code paths .. Instead of adding a new API
like this you might just rework the problem areas.

Are you approaching this from performance? or battery life? or what?

> *** SOME QUANTIFIABLE (?) NUMBERS ***
> 

> then averaged the results to see if there was any benefit:
> 
> === ORIGINAL (99 samples) ========================================= ORIGINAL ===
>     Avg: 188.760000 wakeups in 9.911010 secs (19.045486 wkups/sec) [18876 total]
> Wakeups: Min - 179, Max - 208, Mean - 190.666667, Stdev - 6.601194
> 
> === USLEEP (99 samples) ============================================= USLEEP ===
>     Avg: 188.200000 wakeups in 9.911230 secs (18.988561 wkups/sec) [18820 total]
> Wakeups: Min - 181, Max - 213, Mean - 190.101010, Stdev - 6.950757
> 
> While not particularly rigorous, the results seem to indicate that there may be
> some benefit from pursuing this.

This is sort of ambiguous .. I don't think you replaced enough of these
for it to have much of an impact. It's actually counter intuitive
because your changes add more timers, yet they reduced average wakeups
by a tiny amount .. Why do you think that is ?

> *** HOW MUCH BENEFIT? ***
> 
> Somewhat arbitrarily choosing 100 as a cut-off for udelay VS usleep:
> 
> 	git grep 'udelay([[:digit:]]\+)' | 
> 		perl -F"[\(\)]" -anl -e 'print if $F[1] >= 100' | wc -l
> 
> yeilds 1093 on Linus's tree. There are 313 instances of >= 1000 and still
> another 53 >= 10000us of busy wait! (If AVOID_POPS is configured in, the
> es18xx driver will udelay(100000) or *0.1 seconds of busy wait*)

I'd say a better question is how often do they run?

Another thing is that your usleep() can't replace udelay() in critical
sections. However, if your doing udelay() in non-critical areas, I don't
think there is anything stopping preemption during the udelay() .. So
udelay() doesn't really cut off the whole system when it runs unless it
_is_ in a critical section.

Although it looks like you've spent a good deal of time on this write
up, the reasoning for these changes is still illusive (at least to me)..

Daniel
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

