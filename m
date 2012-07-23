Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2GWTeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:34:25 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33086 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab2GWTeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:34:24 -0400
Message-ID: <500DA6A4.1000009@linaro.org>
Date: Mon, 23 Jul 2012 12:31:48 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] time: Cleanup offs_real/wall_to_mono and offs_boot/total_sleep_time
 updates
References: <1342660753-10382-1-git-send-email-john.stultz@linaro.org> <1342660753-10382-3-git-send-email-john.stultz@linaro.org> <20120719093305.GA27086@gmail.com>
In-Reply-To: <20120719093305.GA27086@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072319-7182-0000-0000-0000020ED43E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 02:33 AM, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
>
>> +static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
>> +{
>> +	/* Verify consistency before modifying */
>> +	WARN_ON_ONCE(tk->offs_boot.tv64 !=
>> +				timespec_to_ktime(tk->total_sleep_time).tv64);
> asserts like this can be put into a single line - we rarely need
> to read them if they don't trigger - and making them
> non-intrusive oneliners is a bonus.

Ack.

>>   @@ -456,8 +478,8 @@ int timekeeping_inject_offset(struct timespec *ts)
>>   
>>   
>>   	tk_xtime_add(&timekeeper, ts);
>> -	timekeeper.wall_to_monotonic =
>> -				timespec_sub(timekeeper.wall_to_monotonic, *ts);
>> +	tk_set_wall_to_mono(&timekeeper,
>> +			timespec_sub(timekeeper.wall_to_monotonic, *ts));
> There's a *lot* of unnecessary ugliness here and in many other
> places in kernel/time/ due to repeating patterns of
> "timekeeper.", which gets repeated many times and blows up line
> length.
>
> Please add this to the highest level (system call, irq handler,
> etc.) code:
>
> 	struct timekeeper *tk = &timekeeper;
>
> and pass that down to lower levels. The tk-> pattern will be the
> obvious thing to type in typical time handling functions.
>
> This increases readability and clarifies the data flow and might
> bring other advantages in the future.

Sounds good. Are you ok if this is done in a follow-on patch?

> Stray newline.
>
> I see a pattern with the newlines there - and this isnt the
> first patch from you that has that problem.

Yea, I personally prefer more space between functions, so its a bad 
habit I have (and checkpatch doesn't catch). I'll try to be more 
watchful of it going forward.

thanks
-john


