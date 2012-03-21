Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2CUE7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:59:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57978 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab2CUE7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:59:40 -0400
Message-ID: <4F696011.7080409@linaro.org>
Date: Tue, 20 Mar 2012 21:58:57 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Ajeet Yadav <ajeet.yadav.77@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com> <20120319130445.GN15988@n2100.arm.linux.org.uk> <CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com> <20120319132623.GO15988@n2100.arm.linux.org.uk>
In-Reply-To: <20120319132623.GO15988@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032104-1976-0000-0000-00000BA18296
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 06:26 AM, Russell King - ARM Linux wrote:
> On Mon, Mar 19, 2012 at 06:49:34PM +0530, Ajeet Yadav wrote:
>> Therefore our target configuration with 2.6 kernel was
>> GENERIC_CLOCKEVENTS=y, ARCH_USES_GETTIMEOFFSET=y,
> It's absolutely absurd to have a platform converted to use clockevents
> and clocksources, and then select ARCH_USES_GETTIMEOFFSET.  That's saying
> "I provide the new infrastructure, but I want the dodgy old compatibility
> which doesn't work properly with a set of other features as well".
>
>> I conclude that GENERIC_CLOCKEVENTS is supported, hence I must set
>> ARCH_USES_GETTIMEOFFSET=n, in order to use NO_HZ, HIGH_RES_TIMERS,
>> IRQSOFF_TRACER, PREEMPT_TRACER
> Correct.  If you're using clockevents and clocksources, you should not
> select ARCH_USES_GETTIMEOFFSET.
>

Hey Ajeet,
     As Russell pointed out, it looks like you're confused as to the use 
of ARCH_USES_GETTIMEOFFSET. That option is only for legacy systems that 
don't provide continuous clocksources that can be used for timekeeping.

In the past, time was incremented by one tick every timer interrupt.  
Some systems could use the timer hardware (usually PIT style 
decrementer) to calculate inter-tick times. Its only for this style of 
hardware, that either wraps or resets each tick, that GETTIMEOFFSET is 
needed.  If you have a continuous counter that doesn't wrap for a 
reasonable number of ticks, you want to use the clocksource abstraction 
to represent that hardware. That has the benefits of allowing high res 
timers and nohz, since we don't need to keep a constant tick-beat to 
keep time (and also avoids lost-ticks and a host of problems that tick 
based timekeeping can run into).

So I suspect you probably want to verify your hardware supports a 
clocksource and disable ARCH_USES_GETTIMEOFFSET.

Sorry for any confusion!

thanks
-john

