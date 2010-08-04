Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0HDEi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:38:27 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:40912 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab0HDEiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:38:16 -0400
X-Greylist: delayed 2687 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 00:38:15 EDT
Message-ID: <4C58E403.6060209@cs.unc.edu>
Date: Tue, 03 Aug 2010 23:52:35 -0400
From: Andrea Bastoni <bastoni@cs.unc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Bjoern Brandenburg <bbb@email.unc.edu>, Raistlin <raistlin@linux.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: periods and deadlines in SCHED_DEADLINE
References: <1278682707.6083.227.camel@Palantir>	 <1278685133.1900.201.camel@laptop>	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>	 <1278693304.1900.266.camel@laptop> <1278752489.4390.97.camel@Palantir>	 <F96CDA2C-534B-4344-B4B4-F890F9BA1D8E@email.unc.edu> <1280828475.1923.444.camel@laptop>
In-Reply-To: <1280828475.1923.444.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 05:41 AM, Peter Zijlstra wrote:
> On Sun, 2010-07-11 at 08:42 +0200, Bjoern Brandenburg wrote:
>>
>> If you want to do G-EDF with limited and different budgets on each CPU
>> (e.g., G-EDF tasks may only run for 100 out of 1000 ms on CPU 0, but
>> for 400 out of 1000 ms on CPU 1), then you are entering the domain of
>> restricted-supply scheduling, which is significantly more complicated
>> to analyze (see [1,2]). 
> 
> Without having looked at the refs, won't the soft case still have
> bounded tardiness? Since the boundedness property mostly depends on
> u<=1, that is, as long as we can always run everything within the
> available time we won't start drifting.

Yes, the soft case will still have bounded tardiness (see [2]), although the reason is more
related to the fact that priorities are defined by deadlines, than to U<=1.

Anyway, both hard and soft real-time cases become very difficult to analyze if limited/different
budgets are allowed on each CPU.

>> As far as I know there is no exiting analysis for "almost G-EDF",
>> i.e.,  the case where each task may only migrate among a subset of the
>> processors (= affinity masks), except for the special case of
>> clustered EDF (C-EDF), wherein the subsets of processors are
>> non-overlapping. 
> 
> Right, affinity masks are a pain, hence I proposed to limit that to
> either 1 cpu (yielding fully paritioned) or the full cluster.

I'm not sure I get what you mean by "full cluster". With G-EDF-like scheduling policies it only
makes sense to cluster cores around some memory level (cache Lx, NUMA node...), as the idea is
to reduce the cost of a task migration among cores. Depending on the workload, a higher (lower)
level of clustering may perform better.

A "full cluster" therefore should be created around some memory level. But if a socket has, for
example, two level of caches (L2 + L3) and a "full cluster" forces to select all cores in the
socket (first hierarchy level in cpusets), we miss the possibility to cluster the cores that
shares the L2 (and this configuration may lead better performance). In these clusters the
processors are _non-overlapping_.

Instead, if you want to use the cpuset + affinity to define possibly _overlapping_ clusters (or
containers, or servers) to support different budgets on each CPU (something similar to cgroup,
see [1,3]), forcing only two configuration (single cpu/full cluster) may be restrictive.

Thanks,

- Andrea

[3] H. Leontyev and J. Anderson, " A Hierarchical Multiprocessor Bandwidth Reservation Scheme
with Timing Guarantees",  Real-Time Systems, Volume 43, Number 1, pp. 60-92, September 2009.
http://www.cs.unc.edu/~anderson/papers/rtj09b.pdf

-- 
Andrea Bastoni
Visiting Ph.D. Student
Dept. of Computer Science
University of North Carolina at Chapel Hill
http://www.sprg.uniroma2.it/home/bastoni/
