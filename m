Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0CWURJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:17:09 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:48373 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab0CWURH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:17:07 -0400
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Message-Id: <F08667D7-387E-420A-A983-6537991DBDA7@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1267827657.4997.51.camel@laptop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: HW perf. events arch implementation
Date: Wed, 24 Mar 2010 09:16:59 +1300
References: <1EE1A83F-EB50-40F3-A6A0-5D8DE0B38446@orcon.net.nz> <1267827657.4997.51.camel@laptop>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx6.orcon.net.nz on Wed, 24 Mar 2010 09:17:03 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Mar 24 09:17:03 2010
X-DSPAM-Confidence: 0.6526
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/03/2010, at 11:20 AM, Peter Zijlstra wrote:
> On Wed, 2010-02-24 at 14:35 +1300, Michael Cree wrote:
>> I am trying to implement arch specific code on the Alpha for hardware
>> performance events
> Right, so the architecture interface is 2 fold, a struct pmu, and a
> bunch of weak hw_perf_*() functions.

Thanks for the description of the hw perf arch interface.

I have now identified why my code on the Alpha didn't work.  I had  
borrowed the code for reading the hw counters and calculating deltas  
from the sparc/x86 code, but I now realise that code is based on the  
assumption that the hw counters are read frequently enough that the  
counter cannot count more than half of its maximum period between  
updates.  That assumption is violated on the Alpha (which has 20 bit  
counters) and I was occasionally getting negative deltas.

Your comment following is relevant:

> As to your counter width, if you have a special overflow bit in a
> separate register then you can possibly use that, but otherwise you  
> need
> it to keep your count straight.

On the Alpha which counter caused the overflow is passed to the  
interrupt routine so I have used that to keep the count straight.

It is also appears that the interrupt routine, when it calls  
perf_event_overflow() can incur quite a bit of execution so I disable  
the hw counters for the duration of the interrupt routine.

I therefore will complete the coding for measuring cycles,  
instructions, cache misses and mbox replays (the last one I presume  
will have to be coded as a RAW event) on the EV67 CPUs and later.  At  
this stage I will probably keep it simple and implement counting one  
hw event at a time only.  Might be able to submit something for review  
within the week; but it could be three or four weeks in coming since I  
go on holiday for 12 days about Easter.

I have no plans to implement hw perf events on Alpha CPUs older than  
the EV67 unless someone jumps up and down and says they really need it!

>> Also, the Alpha CPUs have an interesting mode whereby one programmes
>> up one counter with a specified (or random) value that specifies a
>> future instruction to profile.  The CPU runs for that number of
>> instructions/cycles, then a short monitoring window (of a few cycles)
>> is opened about the profiled instruction and when completed an
>> interrupt is generated.  One can then read back a whole lot of
>> information about the pipeline at the time of the profiled
>> instruction.  This can be used for statistical sampling.  Does the
>> performance events subsystem support monitoring with such a mode?
>
> That sounds like AMD IBS, which I've been told is based on the Alpha
> PMU. We currently do no have AMD IBS supported.

I will therefore leave implementing that mode for the future.

Cheers
Michael.

