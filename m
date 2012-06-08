Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240Ab2FHR2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:28:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60841 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759228Ab2FHR2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:28:32 -0400
Message-ID: <4FD23626.4020802@zytor.com>
Date: Fri, 08 Jun 2012 10:28:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
References: <20120608135200.371649691@goodmis.org>  <20120608135603.699156773@goodmis.org> <4FD223E1.1090707@zytor.com> <1339173716.13377.50.camel@gandalf.stny.rr.com>
In-Reply-To: <1339173716.13377.50.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 09:41 AM, Steven Rostedt wrote:
>>
>> The cost of this on real hardware better be zero (which I cannot
>> immediately judge.)
> 
> Is dec_and_test cheaper than cmpxchg? I would think so.
> 

Should be more or less the same (but see below w.r.t. _local).

>>
>> Why?  Because cmpxchg has been in every CPU since the i486, the i386 is
>> royally crippled on Linux anyway (due to minor architectural defects,
>> the main one being the write protect issue) and NMI is almost never used
>> on i386 as anything other than a fatal error indication.
>>
>> Most "real" NMI users generate the NMI from the local APIC, but the i386
>> has no local APIC, and unlike the i486 cannot even have an external
>> local APIC to the best of my knowledge.
> 
> Yeah, this is why I didn't rush to do this change. But it does seem to
> make the code simpler and it may actually speed things up. It replaces a
> cmpxchg with a local_dec_and_test, which, I believe, doesn't even lock
> the cachelines.
> 

Yeah, the cmpxchg here rather than cmpxchg_local seems like it just was
a plain bug, no?

> So lets look at the patch in detail, shall we?
> 
> 
>>  enum nmi_states {
>> -       NMI_NOT_RUNNING,
>> +       NMI_NOT_RUNNING = 0,
> 
> This change was done more for documenting that the first element must be
> zero. Even though C guarantees this. I wanted to point out that we
> expect it to be zero and that it being zero really does matter. No
> functionality change whats-so-ever.
> 

Yes, that makes sense.

>>         NMI_EXECUTING,
>>         NMI_LATCHED,
>>  };
>> -static DEFINE_PER_CPU(enum nmi_states, nmi_state);
>> +static DEFINE_PER_CPU(local_t, nmi_state);
> 
> local_t is is just an atomic_long_t, which on i386 is nothing different
> than what an enum would be.
> 
>>  
>>  #define nmi_nesting_preprocess(regs)                                   \
>>         do {                                                            \
>> -               if (__get_cpu_var(nmi_state) != NMI_NOT_RUNNING) {      \
>> -                       __get_cpu_var(nmi_state) = NMI_LATCHED;         \
>> +               local_t *__state = &__get_cpu_var(nmi_state);           \
>> +               if (local_read(__state) != NMI_NOT_RUNNING) {           \
>> +                       local_set(__state, NMI_LATCHED);                \
> 
> The above change is probably a little bit of a speed up because we
> remove the double '__get_cpu_var()' and replace it with a pointer that
> is reused. I haven't looked at the assembly for this, but it is either
> the same or better with the patch.
> 
> Sure, we could improve this by using this_cpu_var() which may make it
> better than the patch. But the patch is currently the same or better
> than what is there now.

But yes, if you're going to modify this use this_cpu_read() and
this_cpu_write() and avoid the pointer completely.

>>                         return;                                         \
>>                 }                                                       \
>> -       nmi_restart:                                                    \
>> -               __get_cpu_var(nmi_state) = NMI_EXECUTING;               \
>> -       } while (0)
>> +               local_set(__state, NMI_EXECUTING);                      \
>> +       } while (0);                                                    \
>> +       nmi_restart:
> 
> Here it's better or the same than what is there now as we again remove
> the reference to getting the pointer. In case gcc doesn't optimize it
> nicely. But again we could have switched to this_cpu_write() which could
> be better.
> 
> The movement of nmi_restart does help too. I'll explain that below.
> 
>>  
>>  #define nmi_nesting_postprocess()                                      \
>>         do {                                                            \
>> -               if (cmpxchg(&__get_cpu_var(nmi_state),                  \
>> -                   NMI_EXECUTING, NMI_NOT_RUNNING) != NMI_EXECUTING)   \
>> +               if (!local_dec_and_test(&__get_cpu_var(nmi_state)))     \
> 
> Now this is where I think the patch helps. I'm almost certain that
> local_dec_and_test is faster than a cmpxchg by many cycles. Especially
> on i386.
> 

On i386 it's infinite, but again, I don't think the code will ever be
exercised on i386.  I'm much more concerned about performance on current
processors.

But yes, local_dec_and_test should at least not be more expensive.  Even
better, use this_cpu_dec_return().

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

