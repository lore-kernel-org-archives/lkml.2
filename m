Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0KLCJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 21:09:06 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:33537 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0KLCJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 21:09:04 -0500
Subject: Re: Re: [RFC-PATCH] clocksource: update lpj if clocksource has
 been changed.
From: john stultz <johnstul@us.ibm.com>
To: myungjoo.ham@samsung.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Magnus Damm <damm@opensource.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>
In-Reply-To: <6129485.11361289525487170.JavaMail.weblogic@epml16>
References: <6129485.11361289525487170.JavaMail.weblogic@epml16>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 18:08:33 -0800
Message-ID: <1289527713.2742.174.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 01:31 +0000, MyungJoo Ham wrote:
> On Fri, 2010-11-12 at 09:23 AM, john stultz wrote:
> > Looking through the 2.6.37-rc arm code, I'm not seeing any counter based
> > delay implementation. I only see the loop based implementation in
> > arm/lib/delay.S. Additionally, I don't see ARCH_HAS_READ_CURRENT_TIMER
> > or a get_cycles implementation that uses the clocksource.
> > 
> > Have implemented a non-loop based delay for your platform? Or could you
> > more clearly explain how the clocksource being used for timekeeping
> > effects the delay function on your hardware?
> > 
> 
> Ah.. I'm not concerned with delay functions in this clocksource
> recalibration issue. The delay function has been working just fine.
> The issue affects the consistency of "BogoMIPS" values when we try "#
> cat /proc/cpuinfo", which is based on loops_per_jiffy stroed at
> cpu_data of each core. The cpu-on/off function recalibrates
> loops_per_jiffy for the cpu that was turned off and on.

So I'm focused on __delay(), because it is used to generate the
loops_per_jiffy value in calibrate_delay(). Or is loops_per_jiffy
calculated by some other method on your board?

And if the issue is between the two cpus, it could be something
interfering with calibrate_delay when startup up the second cpu.
Is it that the first one is faster and the second one slower? Or the
other way around? Or is one right and the other just wrong?

>  In a situation where part of cpus were turned off and on after the
> clocksource has been changed, the bogomips values have inconsistency
> between cpus. So, I'm not concerned with the delay function, which has
> been working fine before and after the patch, but with the consistency
> of loops_per_jiffy values in different cpus/cores.

So have you isolated as to why the bogomips value changes when the
clocksource changes? They *should* be independent.

I suspect your patch works, because its causing the calibration to
happen again at a later time to correct for whatever interruption
occurred during the initial calibration.  So if the calibration were run
again from an device_initcall() hook instead of the clocksource_select
point it would do the exact same thing.

I'd suggest focusing on why the calibration was incorrect the first
time, rather then just running it again to fix it.

thanks
-john



