Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0DEOHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:07:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46719 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab0DEOGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:06:54 -0400
Message-ID: <4BB9EE72.3010902@us.ibm.com>
Date: Mon, 05 Apr 2010 07:06:42 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: john cooper <john.cooper@third-harmonic.com>
CC: "Peter W. Morreale" <pmorreale@novell.com>, rostedt@goodmis.org,
       "lkml," <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       john cooper <john.cooper@redhat.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com> <1270078689.19685.8040.camel@gandalf.stny.rr.com> <1270081066.2997.22.camel@hermosa.site> <4BB4041C.6020302@us.ibm.com> <4BB7822F.1000100@third-harmonic.com>
In-Reply-To: <4BB7822F.1000100@third-harmonic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john cooper wrote:
> Darren Hart wrote:
>> Right, and I'm looking to provide some kernel assistance for userspace
>> spinlocks here, and am targeting short lived critical sections as well.
> 
> What did you have in mind beyond existing mechanisms
> which address sibling contention?
> 
> One scenario which AFAICT isn't yet addressed is that
> of a userspace spin lock holder taking a scheduling
> preemption which may result in other threads piling up
> on the lock orders of magnitude beyond normal wait times,
> until the lock holder is rescheduled.  

That is an excellent example.

Another is the highly fragile performance characteristics of spinlocks 
with sched_yield() implementations lead to. As sched_yield 
implementations change, the scheduling behavior of the spinning tasks 
also changes. As the number of cores grows, more performance tuning is 
required. Sched_yield() essentially allows the spinner to spin for a 
time and then get off the cpu for a time - but it doesn't have any idea 
about the state of the lock owner and it's pure chance if the spinning 
task with schedule back in at an opportune time, or if it will just be 
adding to the scheduling overhead and CPU resources the owner is still 
trying to acquire.

The idea here is to leverage the additional information we have in the 
kernel to make more intelligent decisions about how long to spin (as 
well as how many tasks should spin).

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
