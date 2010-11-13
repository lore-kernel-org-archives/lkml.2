Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0KMBtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 20:49:41 -0500
Received: from ms01.sssup.it ([193.205.80.99]:57109 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751540Ab0KMBtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 20:49:39 -0500
Message-ID: <4CDDEEAE.9060706@sssup.it>
Date: Sat, 13 Nov 2010 02:49:34 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Luca Abeni <luca.abeni@unitn.it>, Raistlin <raistlin@linux.it>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline tasks
References: <1288333128.8661.137.camel@Palantir>	 <1288334546.8661.161.camel@Palantir>  <1289513573.2084.199.camel@laptop>	 <1289576177.6525.509.camel@Palantir> <1289577841.2084.302.camel@laptop>	 <4CDD7C65.9090400@unitn.it>  <4CDD8279.1020803@sssup.it> <1289608988.2084.501.camel@laptop>
In-Reply-To: <1289608988.2084.501.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/11/2010 01:43, Peter Zijlstra ha scritto:
> On Fri, 2010-11-12 at 19:07 +0100, Tommaso Cucinotta wrote:
>> -) the specification of a budget every period may be exploited for
>> providing deterministic guarantees to applications, if the budget =
>> WCET, as well as probabilistic guarantees, if the budget<  WCET. For
>> example, what we do in many of our papers is to set budget = to some
>> percentile/quantile of the observed computation time distribution,
>> especially in those cases in which there are isolated peaks of
>> computation times which would cause an excessive under-utilization of
>> the system (these are ruled out by the percentile-based allocation); I
>> think this is a way of reasoning that can be easily understood and used
>> by developers;
> Maybe, but I'm clearly not one of them because I'm not getting it.
My fault for not having explained. Let me see if I can clarify. Let's 
just consider the simple case in which application instances do not 
enqueue (i.e., as soon as the application detects to have missed a 
deadline, it discards the current job, as opposed to keep computing the 
current job), and consider a reservation period == application period.

In such a case, if 'C' represents the (probabilistically modeled) 
computation time of a job, then:

   Prob{deadline hit} = Prob{enough runtime for a job instance} = Prob{C 
<= runtime}.

So, if runtime is set as the q-th quantile of the `C' probability 
distribution, then:

   Prob{deadline hit} = Prob{C <= runtime} = q

This is true independently of what else is admitted into the system, as 
far as I get my runtime guaranteed from the scheduler.

Does this now make sense ?

If, on the other hand, task instances enqueue (e.g., I keep decoding the 
current frame even if I know a new frame arrived), then the probability 
of deadline-hit will be lower than q, and generally speaking one can use 
stochastic analysis & queueing theory techniques in order to figure out 
what it actually is.
>> -) setting a budget equal to (or too close to) the average computation
>> time is *bad*, because the is almost in a meta-stable condition in which
>> its response-time may easily grow uncontrolled;
> How so? Didn't the paper referenced just prove that the response time
> stays bounded?
Here I was not referring to GEDF, but simply to the case in which we are 
reserved from the kernel a budget every period (whatever the scheduling 
algorithm): as the reserved budget moves from the WCET down towards the 
average computation time, the response time distribution moves from a 
shape entirely contained below the deadline, to a more and more flat 
shape, where the probability of missing the deadline for the task 
increases over and over. Roughly speaking, if the application instances 
do not enqueue, then with a budget = average computation time, I would 
expect a ~50% deadline miss, something which hardly is acceptable even 
for soft RT applications.
If instances instead enqueue, then the situation may go much worse, 
because the response-time distribution flattens with a long tail beyond 
the deadline. The maximum value of it approaches +\infty with the 
reserved budget approaching the average computation time.
> Setting it lower will of course wreak havoc, but that's what we have
> bandwidth control for (implementing stochastic bandwidth control is a
> whole separate fun topic though -- although I've been thinking we could
> do something by lowering the max runtime every time a job overruns the
> average, and limit it at 2*avg - max, if you take a simple parametrized
> reduction function and compute the variability of th resulting series
> you can invert that and find the reduction parameter to a given
> variability).
I'd need some more explanation, sorry, I couldn't understand what you're 
proposing.

>> -) if you want to apply the Mills&  Anderson's rule for controlling the
>> bound on the tardiness percentiles, as in that paper (A Stochastic
>> Framework for Multiprocessor
>> Soft Real-Time Scheduling), then I can see 2 major drawbacks:
>>     a) you need to compute the "\psi" in order to use the "Corollary 10"
>> of that paper, but that quantity needs to solve a LP optimization
>> problem (see also the example in Section 6); the \psi can be used in Eq.
>> (36) in order to compute the *expected tardiness*;
> Right, but do we ever actually want to compute the bound? G-EDF also
> incurs tardiness but we don't calculate it either.
I was assuming you were proposing to keep an admission test based on 
providing the parameters needed for checking whether or not a given 
tardiness bound were respected. I must have misunderstood. Would you 
please detail what is the test (and result in the paper) you are 
thinking of using ?
>> If you really want, you
>> can disable *any* type of admission control at the kernel-level, and you
>> can disable *any* kind of budget enforcement, and just trust the
>> user-space to have deployed the proper/correct number&  type of tasks
>> into your embedded RT platform.
> I'm very much against disabling everything and letting the user sort it,
> that's basically what SCHED_FIFO does too and its a frigging nightmare.
Sure, I agree. I was simply suggesting it as a last-resort option 
(possibly usable by exploiting a compile-time option of the scheduler 
compiling out the admission test), useful in those cases in which you do 
have a user-space complex admission test that you made (or even an 
off-line static analysis of your system) but the simple admission test 
into the kernel would actually reject the task set, being the test 
merely sufficient.

Bye,

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

