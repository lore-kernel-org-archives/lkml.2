Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2DELAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 07:00:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab2DELAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 07:00:36 -0400
Message-ID: <4F7D7B4B.7050203@redhat.com>
Date: Thu, 05 Apr 2012 07:00:27 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com>
In-Reply-To: <4F7CF094.5020201@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/04/2012 09:08 PM, John Stultz wrote:
> On 04/04/2012 11:33 AM, Prarit Bhargava wrote:
>>> One idea might be to replace the cyc2ns w/ mult_frac in only the watchdog code.
>>> I need to think on that some more (and maybe have you provide some debug output)
>>> to really understand how that's solving the issue for you, but it would be able
>>> to be done w/o affecting the other assumptions of the timekeeping core.
>>>
>> Hey John,
>>
>> After reading the initial part of your reply I was thinking about calling
>> mult_frac() directly from the watchdog code as well.
>>
>> Here's some debug output I cobbled together to get an idea of how quickly the
>> overflow was happening.
>>
>> [    5.435323] clocksource_watchdog: {0} cs tsc csfirst 227349443638728 mask
>> 0xFFFFFFFFFFFFFFFF mult 797281036 shift 31
>> [    5.444930] clocksource_watchdog: {0} wd hpet wdfirst 78332535 mask
>> 0xFFFFFFFF mult 292935555 shift 22
>>
>> These, of course, are just the basic data from the clocksources tsc and hpet.
> 
> If I'm doing the math right, these are ~2.7 Ghz cpus?

Yes.

> 
> So what kernel version are you using?

I was on an earlier version of Fedora (F16) ... but I'll jump forward and see if
I can still hit it.

> 
> In trying to reproduce this locally against Linus' HEAD on a much smaller system
> (single core + HT 1.6Ghz), I got:
> [    6.611366] clocksource_watchdog: {0} cs tsc csfirst 36177888648 mask
> ffffffffffffffff mult 10485747 shift 24
> [    6.611596] clocksource_watchdog: {0} wd hpet wdfirst 169168400 mask ffffffff
> mult 2684354560 shift 26
> 
> Note the smaller shift values. Not too long ago the shift calculation was
> adjusted to allow for longer periods between interrupts,  so I suspect you're on
> an older kernel.
> 
> Further, using your debug patch on my system, it was well beyond 10 minutes
> before the debug overflow occurred.  And similarly I couldn't trip the watchdog
> trigger using sysrq-t (but again, only two threads here, so not nearly as much
> data to print as you have).

I'm going to try this on a 32-cpu system (running the previously mentioned test)
with linux.git HEAD.

> 
> Could you verify that the issue you're seeing is still is present w/ current
> mainline?  Please don't take this as me dismissing your problem!  As I mentioned

Absolutely :)  I didn't take it that way at all. .... when I get in this AM I'll
bang out a test and see if I can cause this to happen with sysrq-t.  Keep in
mind that 10000 threads is the *minimum* I was able to cause this with, which is
only ~315 threads/cpu, which isn't a lot :/.  At that number of threads the dump
takes about 6 mins.  Doubling it, IIRC, exceeded 10 mins.

> earlier there are some known issues w/ the clocksource watchdog code. But I want
> to narrow down if you're  problem  is currently present in mainline or only in
> older kernels, as that will help us find the proper fix.

Thanks John,

P.

> 
> thanks
> -john
> 
