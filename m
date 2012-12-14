Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2LNB3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:29:44 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:59178 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab2LNB3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:29:41 -0500
Message-ID: <50CA8100.2060209@linaro.org>
Date: Thu, 13 Dec 2012 17:29:36 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] NTP: Add a CONFIG_RTC_SYSTOHC configuration
References: <20121212055643.GA18078@obsidianresearch.com> <50C8DDAA.5010101@linaro.org> <20121212210443.GB11530@obsidianresearch.com> <50C91ED7.5050905@linaro.org> <20121213052132.GA19577@obsidianresearch.com>
In-Reply-To: <20121213052132.GA19577@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 09:21 PM, Jason Gunthorpe wrote:
> On Wed, Dec 12, 2012 at 04:18:31PM -0800, John Stultz wrote:
>
>> I do, although again, in the case where the arch specific
>> implementation is "better", we end up losing granularity (s390 is
>> the specific example I'm thinking of), since this prefers the RTC
>> implementation over the arch specific one.  So maybe I'd suggest
>> switching it so we prefer the arch specific one, and then remove the
>> arch specific implementations where they are inferior to the RTC
>> one.
> Unfortunately I put rtc_update_persistent_clock first because it can
> have sensible error reporting. update_persistent_clock will return 0
> if there is no RTC device available, or if the RTC was successfully
> updated.

Hrm.. Maybe update_persistent_clock() should be changed to return an error?

> I can make rtc_update_persistent_clock return -ENODEV.
>
>> As long as we have a clear iterative path forward, with a solution
>> for the cases where the arch method is actually preferred, I think
>> it sounds like a reasonable approach.
> I think it is fine to leave it as a configure option, archs can
> default it to yes when it is appropriate for them.
>
> A quick scan through the 3.7 tree for update_persistent_clock::
>   alpha - single non class RTC clock scheme
>   cris - printk's and does nothing
>   mips - weak function rtc_mips_set_time, all implementations are
>          non class rtc
>   mn10300 - single non class RTC clock scheme
>   powerpc - indirects through ppc_md.set_rtc_time, all implementations
>             do not use class RTC
>   sh - indirects through rtc_sh_set_time, two implementations, neither
>        use class RTC
>   sparc - Seems to be class rtc converted. Already implements this
>           patch's functionality in an arch specific file
>   x86 - All the functions under the set_wallclock indirection seem
>         to be non class RTC cases
>
> No other arches seem to have update_persistent_clock in them.
>
> I think the s390 functionality you are refering to is in its
> read_persistant_clock, which looks like it has ns resolution.
>
> That is also fine because s390 does not use class rtc so there is no
> duplicate path to the 'tod' code either through
> rtc_update_persistent_clock or through rtc_hctosys.
>
> Basically, as far as I can tell, if rtc_update_persistent_clock
> succeeds then update_persistent_clock is a nop. I can't find any case
> where *both* could succeed. Thus trying rtc_update_persistent_clock
> first is OK.
Ok then. I think part of my confusion is that on the 
read_persistent_clock/rtc_hctosys side of things, we are careful to 
prioritize the read_persistent_clock implementation (since it has the 
additional requirement to be safe to call in irq context, it allows us 
to update the system time at resume earlier, avoiding time error).  So I 
guess I just naturally expect the same prioritization on the write side.

So yea, I guess your approach will work. Although I get the suspicion it 
will require further cleanups down the road (just to help make the 
various arches more consistent).

Want to resend with the changes you suggested, and I'll take another 
look at it?

thanks
-john

