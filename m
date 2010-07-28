Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0G1Uwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:52:30 -0400
Received: from mx7.orcon.net.nz ([219.88.242.57]:55648 "EHLO mx7.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0G1Uw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:52:29 -0400
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-alpha@vger.kernel.org
Message-Id: <FA98B8E5-B4E8-4FC7-94F0-9A8EA38CFF97@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100728125330.af75e63c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 3/3 V2] alpha: Implement HW performance events on the EV67 and later CPUs.
Date: Thu, 29 Jul 2010 08:52:24 +1200
References: <1272958808.5605.126.camel@twins> <1280226579-6117-2-git-send-email-mcree@orcon.net.nz> <20100728125330.af75e63c.akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx7.orcon.net.nz on Thu, 29 Jul 2010 08:52:27 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Jul 29 08:52:27 2010
X-DSPAM-Confidence: 0.9917
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/2010, at 7:53 AM, Andrew Morton wrote:
> On Tue, 27 Jul 2010 22:29:39 +1200
> Michael Cree <mcree@orcon.net.nz> wrote:
>
>> This implements hardware performance events for the EV67 and later
>> CPUs within the Linux performance events subsystem.  Only using the
>> performance monitoring unit in HP/Compaq's so called "Aggregrate
>> mode" is supported.
>>
>> The code has been implemented in a manner that makes extension to
>> other older Alpha CPUs relatively straightforward should some mug
>> wish to indulge his or herself.
>
> Below is the incremental diff.
>
> I have a note here that Peter had issues with the earlier version of
> this patch.  But I see no info here regarding what those issues were,
> nor whether or how they were addressed.

Yeah, I addressed those in the cover letter, which I include here FYI:

On 04/05/10 19:40, Peter Zijlstra wrote:
> On Sat, 2010-05-01 at 11:55 +1200, Michael Cree wrote:
>> +/* I wonder what this is for ??? */
>> +void set_perf_event_pending(void)
>> +{
>> +}
>
> If the PMU Interrupt comes in as an NMI we cannot take locks and such
> from its handler. So what we do is queue that work to be ran later.  
> The
> kernel has a fallback to run this stuff from the timer hardirq, but if
> the PMI is IRQ context (like ARM) you can simply call
> perf_event_do_pending() at its tail.
>
> Alternatively you can self-IPI like x86 does and run
> perf_event_do_pending() from there.

OK, I couldn't see how to self-IPI on the Apha (there is no obvious  
way in
the Alpha arch code, and the Alpha HW Ref. Man. only describes such a
feature being supported by the PALcode for OpenVMS which we are  
obviously
not running) and the PMI on Alpha is at such a high priority there is no
chance that the lock can be freed while in the PMI handler, so I have  
put
the call to perf_event_do_pending() in the timer interrupt, but unlike  
the
PowerPC code I don't know any tricks to force the timer interrupt to  
happen
early when there is pending work, so there is a potential maximum  
delay of
1ms from pending work being notified to calling  
perf_event_do_pending().  Is
this delay acceptable?

I also fix a nasty, but heretofore hidden, bug that could completely  
lock up
a machine with continuous PMIs due to a throttled PMC being accidently
re-enabled by the other PMC. It only showed up when I set the NMI flag  
true
in the call to perf_event_overflow() and had two events counting
simultaneously with a very short sample period.

I also see the x86 and Sparc code in 2.6.35 have reimplemented
the call to hw_perf_group_sched_in() in terms of new functions  
start_txn(),
cancel_txn() and commit_txn().  Is this change necessary to get the  
Alpha
code accepted for 2.6.36?  If so it would be helpful if I could have a  
brief
description of what each function does.

Cheers
Michael.

