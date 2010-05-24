Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0EXV6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 17:58:13 -0400
Received: from mx7.orcon.net.nz ([219.88.242.57]:47956 "EHLO mx7.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806Ab0EXV6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 17:58:11 -0400
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org
Message-Id: <E02DFBB5-4841-4C6F-8142-0E7D0F1D4A30@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1272958808.5605.126.camel@twins>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 3/3] alpha: Implement HW performance events on the EV67 and later CPUs.
Date: Tue, 25 May 2010 09:58:05 +1200
References: <cover.1272668360.git.mcree@orcon.net.nz> <8e86ca502b675b3730bd58be391e0239e87e176d.1272668361.git.mcree@orcon.net.nz> <1272958808.5605.126.camel@twins>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx7.orcon.net.nz on Tue, 25 May 2010 09:58:09 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue May 25 09:58:10 2010
X-DSPAM-Confidence: 0.6969
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/05/2010, at 7:40 PM, Peter Zijlstra wrote:
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

My understanding from the Alpha HW Ref. Man. and a brief look at the  
kernel code is that the PMI comes in through the normal IRQ entry  
point on the Alpha.  It is a high priority interrupt and only a  
machine check (i.e. detected hardware failure) can interrupt the PMU  
interrupt handler.  I don't know whether that is an issue for taking  
locks or not and need advice on that.

I originally based the Alpha implementation on the Sparc  
implementation and would've copied the set_perf_event_pending()  
definition from the Sparc code, but I now see that newer Sparc code  
does not have that definition nor does it call perf_event_do_pending()  
in the interrupt handler.

So I need advice on whether to:

1) Just remove the set_perf_event_pending() definition so we are like  
the Sparc code,

2) Add perf_event_do_pending() to the tail of the IRQ handler so we  
are like the ARM code, or

3) Implement the following suggestion:

> Alternatively you can self-IPI like x86 does and run
> perf_event_do_pending() from there.

Another question is what are the observeable symptoms if an incorrect  
option above is implemented?

Regards
Michael.

