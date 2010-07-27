Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab0G0KaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:30:24 -0400
Received: from mx1.orcon.net.nz ([219.88.242.51]:49558 "EHLO mx1.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab0G0KaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:30:22 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org
Subject: [PATCH 3/3] alpha: Implement HW performance events on the EV67 and later CPUs.
Date: Tue, 27 Jul 2010 22:29:38 +1200
Message-Id: <1280226579-6117-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1272958808.5605.126.camel@twins>
References: <1272958808.5605.126.camel@twins>
X-DSPAM-Check: by mx1.orcon.net.nz on Tue, 27 Jul 2010 22:30:19 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Jul 27 22:30:19 2010
X-DSPAM-Confidence: 0.9924
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/10 19:40, Peter Zijlstra wrote:
> On Sat, 2010-05-01 at 11:55 +1200, Michael Cree wrote:
>> +/* I wonder what this is for ??? */
>> +void set_perf_event_pending(void)
>> +{
>> +}
> 
> If the PMU Interrupt comes in as an NMI we cannot take locks and such
> from its handler. So what we do is queue that work to be ran later. The
> kernel has a fallback to run this stuff from the timer hardirq, but if
> the PMI is IRQ context (like ARM) you can simply call
> perf_event_do_pending() at its tail.
> 
> Alternatively you can self-IPI like x86 does and run
> perf_event_do_pending() from there.

OK, I couldn't see how to self-IPI on the Apha (there is no obvious way in
the Alpha arch code, and the Alpha HW Ref. Man. only describes such a
feature being supported by the PALcode for OpenVMS which we are obviously
not running) and the PMI on Alpha is at such a high priority there is no
chance that the lock can be freed while in the PMI handler, so I have put
the call to perf_event_do_pending() in the timer interrupt, but unlike the
PowerPC code I don't know any tricks to force the timer interrupt to happen
early when there is pending work, so there is a potential maximum delay of
1ms from pending work being notified to calling perf_event_do_pending().  Is
this delay acceptable?

I also fix a nasty, but heretofore hidden, bug that could completely lock up
a machine with continuous PMIs due to a throttled PMC being accidently
re-enabled by the other PMC. It only showed up when I set the NMI flag true
in the call to perf_event_overflow() and had two events counting
simultaneously with a very short sample period.

I also see the x86 and Sparc code in 2.6.35 have reimplemented
the call to hw_perf_group_sched_in() in terms of new functions start_txn(),
cancel_txn() and commit_txn().  Is this change necessary to get the Alpha
code accepted for 2.6.36?  If so it would be helpful if I could have a brief
description of what each function does.

The updated patch follows this message.

Cheers
Michael.


Michael Cree (1):
  alpha: Implement HW performance events on the EV67 and later CPUs.

 arch/alpha/include/asm/perf_event.h |    8 +-
 arch/alpha/kernel/Makefile          |    1 +
 arch/alpha/kernel/irq_alpha.c       |    3 +
 arch/alpha/kernel/perf_event.c      |  842 +++++++++++++++++++++++++++++++++++
 arch/alpha/kernel/time.c            |   26 ++
 5 files changed, 879 insertions(+), 1 deletions(-)
 create mode 100644 arch/alpha/kernel/perf_event.c

