Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1ATWyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:54:41 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4666 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1ATWyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:54:40 -0500
Message-ID: <4D38BD2A.2070705@caviumnetworks.com>
Date: Thu, 20 Jan 2011 14:54:34 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RTC seems broken on 2.6.38-rc1 for RTCs lacking alarms.
References: <4D38A051.2010301@caviumnetworks.com>	 <1295558196.2998.85.camel@work-vm>	 <AANLkTinJfQCEcqHy8oc8+F+yrmY_AkhPLCdZ7R95tk6H@mail.gmail.com> <1295562203.2998.105.camel@work-vm>
In-Reply-To: <1295562203.2998.105.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2011 22:54:40.0075 (UTC) FILETIME=[0502A9B0:01CBB8F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 02:23 PM, John Stultz wrote:
> On Thu, 2011-01-20 at 22:24 +0100, Geert Uytterhoeven wrote:
>> On Thu, Jan 20, 2011 at 22:16, John Stultz<john.stultz@linaro.org>  wrote:
>>> On Thu, 2011-01-20 at 12:51 -0800, David Daney wrote:
>>>> open("/dev/rtc0", O_RDONLY|O_LARGEFILE) = 3
>>>> ioctl(3, PRESTO_GETMOUNT or RTC_UIE_ON, 0) = 0
>>>> _newselect(4, [3], NULL, NULL, {5, 0})  = 0 (Timeout)
>>>> write(2, "select() to /dev/rtc0 to wait for"..., 55select() to /dev/rtc0
>>>> to wait for clock tick timed out
>>>> ) = 55
>>>> ioctl(3, PRESTO_SETPID or RTC_UIE_OFF, 0) = 0
>>>> close(3)                                = 0
>>>> exit_group(1)                           = ?
>>>>
>>>>
>>>> The hwclock program is asking to put the clock in UIE mode and then
>>>> does a select() on it.  Since the alarm doesn't work, the select times out.
>>>>
>>>> Previously the ioctl(RTC_UIE_ON) would return EINVAL:
>>>
>>> Ah. Good diagnosis! Let me try to get a patch for you and Andreas to
>>> test.
>>
>> I'm also seeing this on m68k (ARAnyM, rtc-generic).
>
> Geert, David, Andreas,
> 	Could you try the following? Its a bit messy of a patch doing a couple
> of things:
>
> 1) Simplify the timer->enabled management by pushing it into
> rtc_timer_enqueue/remove (needed cleanup for #2).
>
> 2) Properly propagating errors from __rtc_set_alarm back through
> rtc_timer_enqueue and users.
>
> 3) Trivial clenaup making rtc_timer_enqueue/remove static.
>
> 4) Fixup virtualized rtc_read_alarm to check hardware capabilities and
> return errors (also restores zeroing of the rtc_wkalrm stucture).
>
> I'll be cleaning these up and breaking them into commits I can send
> upward, but I wanted to make sure it resolves the issue for you.
>
> Let me know if it fixes things.
>
> thanks
> -john
>

John,

With that patch, it works now.  Thanks.

You can add:

Tested-by: David Daney <ddaney@caviumnetworks.com>


