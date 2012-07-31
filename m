Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2GaRPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:15:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49169 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab2GaRPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:15:12 -0400
Message-ID: <50180E6E.20704@linaro.org>
Date: Tue, 31 Jul 2012 09:57:18 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: James Courtier-Dutton <james.dutton@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH 0/2][RFC] Better handling of insane CMOS values
References: <1343716548-38742-1-git-send-email-john.stultz@linaro.org> <CAAMvbhGnNAChs+6mzdRduzgYmWRXQexsbS=w0wgrRhAKrdL6QA@mail.gmail.com>
In-Reply-To: <CAAMvbhGnNAChs+6mzdRduzgYmWRXQexsbS=w0wgrRhAKrdL6QA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073117-7182-0000-0000-0000021E2E86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 02:54 AM, James Courtier-Dutton wrote:
> On 31 July 2012 07:35, John Stultz <john.stultz@linaro.org> wrote:
>> So CAI Qian noticed recent boot trouble on a machine that had its CMOS
>> clock configured for the year 8200.
>> See: http://lkml.org/lkml/2012/7/29/188
>>
>> While running with a crazy CMOS clock isn't advised, and a simple
>> "don't do that" might be reasonable, the behavior has in effect
>> regressed recently due to changes in the hrtimer/timekeeping
>> interactions.
>>
> Would it not be easier to work out which CMOS clock values we can
> handle correctly, and then do input value validation on the CMOS
> values, and if a value is outside the acceptable range, assume a value
> equal to the minimum acceptable value.

I believe patch 2/2 does exactly this.

> Also, surely all timer use within the kernel should use the monotonic
> time source for timer expiry, and not depend on CMOS time.
> I.e. If we want a thread to wake up once every 30 seconds, use the
> monotonic time source for that.
> conversion to local time should only be needed for timestamps.
Timers can also be specified against various clockids like 
CLOCK_REALTIME (and absolute time values, like expire this timer at 
11:55 GMT, Oct 5 2012).  So while the kernel does manage most things 
internally with CLOCK_MONOTONIC, it still has to manage some timers 
against other clockids.

> We might need a compile/boot time option to assign useable ranges to
> local time values.
> E.g. For this boot, local time is between year 2000 and 2100
> For next boot, local time is between year 2050 and 2150.
> Obviously, make the range as wide as we can sensibly handle, so the
> setting does not need to be changed very often.
> The range will be determined by the amount of bits in the time values.
> User space can work on much wider ranges for historical date storage,
> but for accessing the current time, smaller ranges are workable.
Right. So one way to handle the range difference between the ktime_t and 
timespec values would be to have kernel internal ktime_t epochs that we 
remove and readd as needed.  So instead of using 1970, we pick some 
close value to the boot time like 2010, and then subtract 40 years off 
all the inputs, and it back on to the outputs. Aside from the extra 
computation, the problem is that if a system booted up like the one in 
this case w/ a year of 8200, and we selected that as this kernel epoch, 
we then would have problems setting the time back to 2012, as there may 
be CLOCK_REALTIME timers set for 8200 that we could not store within the 
292 year epoch.  We probably could decide that timers larger then the 
ktime_t epoch will expire "never" and then re-calculate if needed when 
the time is set.

Even so, I suspect the extra complication, along with the extra overhead 
required will make such a plan unpopular until its actually needed 
(around the year 2264). So I suspect the input sanitation is really the 
most likely approach for now.

thanks
-john

