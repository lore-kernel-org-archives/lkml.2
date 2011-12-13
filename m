Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1LMAk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:40:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37890 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472Ab1LMAk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:40:57 -0500
Message-ID: <4EE69F02.2090805@fb.com>
Date: Mon, 12 Dec 2011 16:40:34 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
References: <1323718578-1157-1-git-send-email-asharma@fb.com> <1323718578-1157-3-git-send-email-asharma@fb.com> <CAObL_7F8v1PT0FQ=GNcNmJKWkzQ7DfkQ9ym2EeR0TgFKiZPPaw@mail.gmail.com> <4EE6850F.5070002@fb.com> <CAObL_7GPA2RvVQSO9PhDs0X++=_62B83Y-CM1DL1+a9oftJ=YQ@mail.gmail.com>
In-Reply-To: <CAObL_7GPA2RvVQSO9PhDs0X++=_62B83Y-CM1DL1+a9oftJ=YQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-12_10:2011-12-12,2011-12-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 3:01 PM, Andrew Lutomirski wrote:

>> The timing based attacks depend on the granularity of timestamps. I feel
>> what's available here is too coarse grained to be useful. Happy to
>> disable the code at compile time for those cases. Are there
>> CONFIG_HIGH_SECURITY type of options I could use for this purpose?
>
> It allows anyone to detect with very high precision when context
> switches happen on another CPU.  This sounds a little dangerous.  I
> don't know if a config option is the right choice.

Minor nit: attacker gets to see sum_exec_runtime - sched_clock(), not 
sched_clock() directly. It might still be equally damaging (assuming the 
attacker can work out sum_exec_runtime by observing the VVAR page).

Either way, I think it's important to get to the bottom of this. 
Conversely, we might want to consider enabling things like this only 
under CONFIG_I_TRUST_STUFF_RUNNING_ON_MY_MACHINE.

>> Yes - this should be a separate patch. gcc-4.4 likes to get rid of the
>> instruction in __do_thread_cpu_time without the asm volatile (in spite of
>> the memory clobber).
>>
>
> gcc 4.4 caught a genuine bug in your code.  You ignored the return
> value (which is an output constraint), so you weren't using any
> outputs and gcc omitted the apparently useless code.  The right fix is
> to check the return value.  (And to consider adding the missing
> volatile.)

Yes - there are two bugs here.

>
>>
>>
>>>> +       if (vp->tsc_unstable) {
>>>> +               struct timespec ts;
>>>> +               vdso_fallback_gettime(CLOCK_THREAD_CPUTIME_ID,&ts);
>>>> +               return timespec_to_ns(&ts);
>>>> +       }
>>>
>>>
>>> Yuck -- another flag indicating whether we're using the tsc.
>>
>>
>> I renamed it to thread_cputime_disabled to deal with NR_CPUS>  64.
>>
>
> Still yuck.  IMO this should always work.
>

Yes - but boot time VVAR page allocation is going to take me some time 
to implement. In the meanwhile I was merely trying to ensure that 
compilation doesn't break for unsupported configs and the app doesn't 
get SIGILL when running on old 64 bit CPUs.

[..]
> Sorry, I was unclear.  gtod_data contains vclock_mode, which will tell
> you whether the tsc is usable.  I have a buggy computer (I'm typing
> this email on it) that has a TSC that is only useful per-process.  I
> don't think it's worth supporting this particular case, since it's a
> bios bug and needs fixing by the vendor.  It's hopefully rare.

Ah yes. Will make this change as well.

  -Arun
