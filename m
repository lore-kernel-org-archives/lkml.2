Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab0KRWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:25:26 -0500
Received: from mail.windriver.com ([147.11.1.11]:42738 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554Ab0KRWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:25:25 -0500
Message-ID: <4CE5A7AE.8070703@windriver.com>
Date: Thu, 18 Nov 2010 16:24:46 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        ying.huang@intel.com, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
References: <20101112161144.GP4823@redhat.com> <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com> <20101118215650.GL6028@lenovo> <20101118221554.GA31253@lenovo>
In-Reply-To: <20101118221554.GA31253@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 22:24:49.0027 (UTC) FILETIME=[69702D30:01CB876F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 04:15 PM, Cyrill Gorcunov wrote:
> On Fri, Nov 19, 2010 at 12:56:50AM +0300, Cyrill Gorcunov wrote:
> ...
>   
>> ---
>>  arch/x86/kernel/cpu/perf_event_p4.c |   21 ++++++++++++---------
>>  1 file changed, 12 insertions(+), 9 deletions(-)
>>
>> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
>> =====================================================================
>> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
>> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
>> @@ -753,19 +753,22 @@ out:
>>  
>>  static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
>>  {
>> -	int overflow = 0;
>> -	u32 low, high;
>> +	u32 overflow = 0;
>> +	u32 low, low_cccr, high;
>>  
>> -	rdmsr(hwc->config_base + hwc->idx, low, high);
>> +	/* an official way for overflow indication */
>> +	rdmsr(hwc->config_base + hwc->idx, low_cccr, high);
>> +	overflow |= (low_cccr & P4_CCCR_OVF);
>> +
>> +	/* unflagged overflows */
>> +	rdmsr(hwc->event_base + hwc->idx, low, high);
>> +	overflow |= high & 0x80000000;
>>  
>> -	/* we need to check high bit for unflagged overflows */
>> -	if ((low & P4_CCCR_OVF) || !(high & (1 << 31))) {
>> -		overflow = 1;
>> +	if (overflow)
>>     
>
> this should be rather 'if (low_cccr & P4_CCCR_OVF)' otherwise
> redundant checking_wrmsrl called, updated patch below
>
> /me seems should not touch code at all today 
> ---
>
> perf, x86: P4 PMU - Fix unflagged overflows handling
>
> Jason pointed out that kgdb no longer works with new
> nmi-watchdog. Don found the reason -- P4 PMU reads CCCR
> register instead of counter itself, it forces NMIs to
> be eaten by perf subsystem.
>
> Fix it by reading a proper register.
>
> v2: Call checking_wrmsrl only if needed
>
> Reported-by: Jason Wessel <jason.wessel@windriver.com>
> Reported-by: Don Zickus <dzickus@redhat.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>
> Jason I've removed your Tested-by because the patch differ a bit
>
>   

It is retested and confirmed to work on real HW.   This no longer works
on qemu/kvm likely because the emulation is incorrect.

Thanks,
Jason.
