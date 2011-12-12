Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1LLWuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:50:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33860 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753184Ab1LLWuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:50:08 -0500
Message-ID: <4EE6850F.5070002@fb.com>
Date: Mon, 12 Dec 2011 14:49:51 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
References: <1323718578-1157-1-git-send-email-asharma@fb.com> <1323718578-1157-3-git-send-email-asharma@fb.com> <CAObL_7F8v1PT0FQ=GNcNmJKWkzQ7DfkQ9ym2EeR0TgFKiZPPaw@mail.gmail.com>
In-Reply-To: <CAObL_7F8v1PT0FQ=GNcNmJKWkzQ7DfkQ9ym2EeR0TgFKiZPPaw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-12_10:2011-12-12,2011-12-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 12:15 PM, Andrew Lutomirski wrote:

> This seems like a neat idea, but I'm a little worried about the
> implementation.  Surely someone with 4k+ cpus will complain when the
> percpu vvar data exceeds a page and crashes.  I have no personal
> objection to a dynamically-sized vvar area, but it might need more
> careful handling.

I'm for disabling the vsyscall when the data doesn't fit in a couple of 
pages.

>
> I also wonder if there a problem with information leaking.  If there
> was an entire per-cpu vvar page (perhaps mapped differently on each
> cpu) then nothing interesting would leak.  But that could add
> overhead.
>

The timing based attacks depend on the granularity of timestamps. I feel 
what's available here is too coarse grained to be useful. Happy to
disable the code at compile time for those cases. Are there 
CONFIG_HIGH_SECURITY type of options I could use for this purpose?


>> diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
>> index 0fd7a4a..e36e1c1 100644
>> --- a/arch/x86/include/asm/vvar.h
>> +++ b/arch/x86/include/asm/vvar.h
>> @@ -47,5 +47,6 @@
>>   DECLARE_VVAR(0, volatile unsigned long, jiffies)
>>   DECLARE_VVAR(16, int, vgetcpu_mode)
>>   DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
>> +DECLARE_VVAR(2048, struct vcpu_data, vcpu_data)
>
> Any reason this isn't page-aligned?  Offset 2048 seems like an odd place.
>

I meant it to be 128 + sizeof(struct vsyscall_gtod_data) so we fit 
everything in one page if CONFIG_NR_CPUS is small enough.

I'll fix it up in the next rev.

>>   notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
>>   {
>>         long ret;
>> -       asm("syscall" : "=a" (ret) :
>> -           "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
>> +       asm volatile("syscall" : "=a" (ret) :
>> +                    "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
>>         return ret;
>>   }
>
> Huh?  This should probably be a separate patch (and probably not a
> -stable candidate, since it would take amazing compiler stupidity to
> generate anything other than the obvious code).  The memory clobber
> may also be enough to make this officially safe.

Yes - this should be a separate patch. gcc-4.4 likes to get rid of the 
instruction in __do_thread_cpu_time without the asm volatile (in spite 
of the memory clobber).


>> +       if (vp->tsc_unstable) {
>> +               struct timespec ts;
>> +               vdso_fallback_gettime(CLOCK_THREAD_CPUTIME_ID,&ts);
>> +               return timespec_to_ns(&ts);
>> +       }
>
> Yuck -- another flag indicating whether we're using the tsc.

I renamed it to thread_cputime_disabled to deal with NR_CPUS > 64.

>
>> +
>> +       do {
>> +               native_read_tscp(&p);
>
> Do all 64-bit cpus have rdtscp?  ISTR older Intel machines don't have it.
>

Yeah - I ran into this one when testing with KVM on a rdtscp capable 
CPU. Will disable the vsyscall when the CPU doesn't support rdtscp.

>> --- a/arch/x86/vdso/vdso.lds.S
>> +++ b/arch/x86/vdso/vdso.lds.S
>> @@ -25,6 +25,8 @@ VERSION {
>>                 __vdso_getcpu;
>>                 time;
>>                 __vdso_time;
>> +               thread_cpu_time;
>> +               __vdso_thread_cpu_time;
>>         local: *;
>>         };
>>   }
>
> Why do we have the non-__vdso versions?  IMO anything that actually
> uses them is likely to be confused.  They have the same names as the
> glibc wrappers, but the glibc wrappers have different return value and
> errno semantics.  I'd say just use __vdso.

I'm not familiar with the history of __vdso_foo vs foo. Happy to get rid 
of the non __vdso versions.

>
> Also, what's wrong with just adding the functionality to __vdso_clock_gettime?
>

Performance. Most of this is client dependent (whether it expects time 
in nanoseconds or timespec).

Baseline: 		19.34 secs
vclock_gettime: 	4.74 secs
thread_cpu_time:	3.62 secs

Our use case prefers nanoseconds, so the conversion to timespec and back 
adds overhead. Also, having a direct entry point vs going through the 
switch in clock_gettime() adds some cycles.

I have some people here asking me if they could get CLOCK_REALTIME and 
CLOCK_MONOTONIC also in nanoseconds for the same reason.


>> +struct vcpu_data {
>> +       struct vpercpu_data vpercpu[NR_CPUS];
>> +       unsigned int tsc_khz;
>
> I think this also duplicates some of the gtod_data stuff, at least in
> the case that TSC works for gtod.
>

vgotd.h seems to be clock source independent. This vsyscall is usable 
only on systems with tsc_unstable == 0. Also, there is only one instance 
of mult and shift there, whereas we save it on a per-cpu basis in the 
VVAR page.

Thanks for the review and comments!

  -Arun
