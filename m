Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0KKXdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:33:50 -0500
Received: from ms01.sssup.it ([193.205.80.99]:33591 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753593Ab0KKXdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:33:49 -0500
Message-ID: <4CDC7D57.2070008@sssup.it>
Date: Fri, 12 Nov 2010 00:33:43 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
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
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 09/22] sched: add period support for -deadline tasks
References: <1288333128.8661.137.camel@Palantir>	 <1288334050.8661.150.camel@Palantir>  <1289503054.2084.156.camel@laptop>	 <1289503883.6525.107.camel@Palantir> <1289504635.2084.179.camel@laptop>
In-Reply-To: <1289504635.2084.179.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/11/2010 20:43, Peter Zijlstra ha scritto:
>> The more correct --in the sense that it at least yield a sufficient (not
>> necessary!) condition-- thing to do would be
>> sum_i(runtime_i/min{deadline_i,period_i})<=threshold.
>>
>> So, what you think we should do? Can I go for this latter option?
> So sufficient (but not necessary) means its still a pessimistic approach
> but better than the one currently employed, or does it mean its
> optimistic and allows for unschedulable sets to be allowed in?
It means that, if the new task passes the test, then it has its 
guaranteed runtime_i over each time horizon as long as min{deadline_i, 
period_i} (and all of the other tasks already admitted have their 
guarantees as well of course). From the perspective of analyzing 
capability of the attached task to meet its own deadlines, if the task 
has a WCET of runtime_i, a minimum inter-arrival period of period_i, and 
a relative deadline of deadline_i, then it is guaranteed to meet all of 
its deadlines.

Therefore, this kind of test is sufficient for ensuring schedulability 
of all of the tasks, but it is not actually necessary, because it is too 
pessimistic. In fact, consider a task with a period of 10ms, a runtime 
of 3ms and a relative deadline of 5ms. After the test passed, you have 
actually allocated a "share" of the CPU capable of handling 3ms of 
workload every 5ms. Instead, we actually know that (or, we may actually 
force it to), after the deadline at 5ms, this task will actually be idle 
for further 5ms, till its new period. There are more complex tests which 
account for this, in the analysis.

Generally speaking, with deadlines different from periods, a tighter 
test (for partitioned EDF) is one making use of the demand-bound 
function, which unfortunately is far more heavyweight than a mere 
utilization check (for example, you should perform a number of checks 
along a time horizon that can go as far as the hyper-period [LCM of the 
periods] of the considered task-set -- something that may require 
arbitrary precision arithmetics in the worst-case). However, you can 
check the *RT* conferences in the last 10 years in order to see all the 
possible trade-offs between accuracy of the test and the imposed 
computation requirement/overhead.

Summarizing, the test suggested by Dario is sufficient to ensure the 
correct behavior of the accepted tasks, under the assumption that they 
stick to the "sporadic RT task model", it is very simple to implement in 
the kernel, but it is somewhat pessimistic. Also, it actually uses only 
2 parameters, the runtime and the min{deadline_i, period_i}.
This clarifies also why I was raising the issue of whether to have at 
all the specification of a deadline \neq period, in my other e-mail. If 
the first implementation will just use the minimum of 2 of the supplied 
parameters, then let them be specified as 1 parameter only: it will be 
easier for developers to understand and use. If we identify later a 
proper test we want to use, then we can exploit the "extensibility" of 
the sched_params.

My 2 cents.

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

