Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2LMASg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:18:36 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:59233 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2LMASf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:18:35 -0500
Message-ID: <50C91ED7.5050905@linaro.org>
Date: Wed, 12 Dec 2012 16:18:31 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] NTP: Add a CONFIG_RTC_SYSTOHC configuration
References: <20121212055643.GA18078@obsidianresearch.com> <50C8DDAA.5010101@linaro.org> <20121212210443.GB11530@obsidianresearch.com>
In-Reply-To: <20121212210443.GB11530@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 01:04 PM, Jason Gunthorpe wrote:
> On Wed, Dec 12, 2012 at 11:40:26AM -0800, John Stultz wrote:
>
>>> The option also overrides the call to any platform update_persistent_clock
>>> so that the RTC subsystem completely and generically replaces this
>>> functionality.
>>>
>>> Tested on ARM kirkwood and PPC405
>> So I'm initially mixed on this, as it feels a little redundant (esp
>> given it may override a higher precision arch-specific function).
>> But from the perspective of this being a generic RTC function,
>> instead of an per-arch implementation, it does seem reasonable.
> It isn't really redundant. The kernel still has two RTC subsystems,
> 'class RTC' and various platform specific
> things. update_persisent_clock is the entry for the platform specific
> RTC, while rtc_update_persistent_clock is the entry for class RTC.
>
> The issue is on platforms like PPC where both co-exist. On PPC
> update_persisent_clock just calls through a function pointer
> (set_rtc_time) to the machine description to do whatever that mach
> needs. Currently all the PPC mach's that use class RTC drivers via DTS
> set set_rtc_time to null. Only the machs that implement a non class
> RTC driver provide an implementation.
>
> So it is an either/or case - either rtc_update_persistent_clock works
> or update_persistent_clock does, never both.
Right.  I just want to make sure that we reduce the duplication between 
the two paths (and ensure sane defaults, so users don't have to go 
hunting for the right config for things to work properly). The other 
complication is that in some cases, the arch specific path is much finer 
grained then the RTC layer's second granularity, so we need to ensure we 
prefer the arch specific path in those cases.

>> Hrm. So on architectures that support GENERIC_CMOS_UPDATE already,
>> this creates a duplicated code path that is slightly different. I'd
>> like to avoid this if possible.  Since you're plugging
>> rtc_update_persistent_clock into the GENERIC_CMOS_UPDATE code, we
>> can't just have this option depend on !GENERIC_CMOS_UPDATE.
> It isn't duplicate, we need to keep update_persistent_clock to support
> non-class RTC machines.
>
> I thought about this:
>
>          if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
> 	        fail = -1;
> #ifdef CONFIG_RTC_SYSTOHC
> 	        fail = rtc_update_persistent_clock(now);
> #endif
> #ifdef CONFIG_GENERIC_CMOS_UPDATE
>                  if (fail)
>                           fail = update_persistent_clock(now);
> #endif
>         }
>
> Try the RTC function first, then fall back to the legacy platform
> function if it didn't work.
>
> That seems better to me, do you agree?

I do, although again, in the case where the arch specific implementation 
is "better", we end up losing granularity (s390 is the specific example 
I'm thinking of), since this prefers the RTC implementation over the 
arch specific one.  So maybe I'd suggest switching it so we prefer the 
arch specific one, and then remove the arch specific implementations 
where they are inferior to the RTC one.

>
>> So this might need a slightly deeper rework?
>> I'd suggest the following:
>> 1) Convert GENERIC_CMOS_UPDATE into SUPPORTS_UPDATE_PERSISTENT_CLOCK.
>> 2) Add RTC_SYSTOHC but make it depend on !SUPPORTS_UPDATE_PERSISTENT_CLOCK
> This would only work for ARM, not PPC..
>
> Ultimately I suspect the clean up needed is to convert more things to
> class rtc drivers and remove update_persistent_clock.
> ppc is pretty close already, and I think ARM is already there.
As long as we have a clear iterative path forward, with a solution for 
the cases where the arch method is actually preferred, I think it sounds 
like a reasonable approach.

thanks
-john
