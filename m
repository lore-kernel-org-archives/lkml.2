Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab0KLSH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:07:56 -0500
Received: from ms01.sssup.it ([193.205.80.99]:36602 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932089Ab0KLSHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:07:55 -0500
Message-ID: <4CDD8279.1020803@sssup.it>
Date: Fri, 12 Nov 2010 19:07:53 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Luca Abeni <luca.abeni@unitn.it>, Peter Zijlstra <peterz@infradead.org>
CC: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline tasks
References: <1288333128.8661.137.camel@Palantir>	 <1288334546.8661.161.camel@Palantir>  <1289513573.2084.199.camel@laptop>	 <1289576177.6525.509.camel@Palantir> <1289577841.2084.302.camel@laptop> <4CDD7C65.9090400@unitn.it>
In-Reply-To: <4CDD7C65.9090400@unitn.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/11/2010 18:41, Luca Abeni ha scritto:
>
>> algorithm with resource reservation. It explicitly allows for deadline
>> misses, but requires the tardiness of those misses to be bounded, ie.
>> the UNC soft real-time definition.
>>
>> The problem the stochastic execution time model tries to address is the
>> WCET computation mess, WCET computation is hard and often overly
>> pessimistic, resulting in under-utilized systems.
>
> [...]
> BTW, sorry for the shameless plug, but even with the current 
> SCHED_DEADLINE you are not forced to dimension the runtime using the 
> WCET. You can use some stochastic analysis, providing probabilistic 
> deadline guarantees. See (for example) "QoS Guarantee Using 
> Probabilistic Deadlines"
> http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.22.7683&rep=rep1&type=pdf 
>
> and "Stochastic analysis of a reservation based system"
> http://www.computer.org/portal/web/csdl/doi?doc=doi/10.1109/IPDPS.2001.925049 
>
> (sorry, this is not easy to download... But I can provide a copy if 
> you are interested).
Thanks, Luca, for supporting the viewpoint. I also repeated this 
multiple times, during the LPC as well.

Let me underline a few key points, also about the technique suggested by 
Zijlstra:

-) the specification of a budget every period may be exploited for 
providing deterministic guarantees to applications, if the budget = 
WCET, as well as probabilistic guarantees, if the budget < WCET. For 
example, what we do in many of our papers is to set budget = to some 
percentile/quantile of the observed computation time distribution, 
especially in those cases in which there are isolated peaks of 
computation times which would cause an excessive under-utilization of 
the system (these are ruled out by the percentile-based allocation); I 
think this is a way of reasoning that can be easily understood and used 
by developers;

-) setting a budget equal to (or too close to) the average computation 
time is *bad*, because the is almost in a meta-stable condition in which 
its response-time may easily grow uncontrolled;

-) same thing applies to admitting tasks in the system: if you only 
ensure that the sum of average/expected bandwidths < system capacity, 
then the whole system is at risk of having uncontrolled and arbitrarily 
high peak delays, but from a theoretical viewpoint it is still a 
"stable" system; this is not a condition you want to have in a sane 
real-time scenario;

-) if you want to apply the Mills & Anderson's rule for controlling the 
bound on the tardiness percentiles, as in that paper (A Stochastic 
Framework for Multiprocessor
Soft Real-Time Scheduling), then I can see 2 major drawbacks:
   a) you need to compute the "\psi" in order to use the "Corollary 10" 
of that paper, but that quantity needs to solve a LP optimization 
problem (see also the example in Section 6); the \psi can be used in Eq. 
(36) in order to compute the *expected tardiness*;
   b) unfortunately, the expected tardiness is hardly the quantity of 
interest for any concrete real-time application, where some percentile 
of the tardiness distribution may be much more important; therefore, you 
are actually interested in Eq. (37) for computing the q-th percentile of 
the tardiness. Unfortunately, such last bound is provided through the 
Chebychev (or Markov, or whatever it is called) inequality simply from 
the expected average, and this bound is well-known to be so conservative 
(a 99% percentile is basically hundred times the average). The 
consequence is that you would end-up to actually admit very few tasks as 
compared to what actually fits into the system.

Please, understand me: I don't want to say that that particular 
technique is not useful, but I'd like simply to stress that such 
policies might just belong to the user-space. If you really want, you 
can disable *any* type of admission control at the kernel-level, and you 
can disable *any* kind of budget enforcement, and just trust the 
user-space to have deployed the proper/correct number & type of tasks 
into your embedded RT platform.

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

