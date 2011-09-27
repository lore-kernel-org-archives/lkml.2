Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1I0Hfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 03:35:37 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:47864 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1I0Hfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 03:35:36 -0400
X-Greylist: delayed 3702 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Sep 2011 03:35:36 EDT
Date: Tue, 27 Sep 2011 08:32:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110927063222.GB18519@elte.hu>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926115049.GA22604@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> While trying to test recently introduced cpu bandwidth control feature for
> non-realtime tasks, we noticed "more than expected" idle time, which
> reduced considerably when booted with nohz=off. This patch is an attempt
> to fix that discrepancy so that we see little variance in idle time between
> nohz=on and nohz=off.
> 
> Test setup:
> 
> Machine : 16-cpus (2 Quad-core w/ HT enabled)
> Kernel  : Latest code (HEAD at 6e8d0472ea63969e2df77c7e84741495fedf7d9b) found 
> 	  at git://tesla.tglx.de/git/linux-2.6-tip
> 
> Cgroups :
> 
> 5 in number (/L1/L2/C1 - /L1/L2/C5), each having {2, 2, 4, 8, 16} tasks
> respectively. /L1 and /L2 were added to the hierarchy to mimic cgroup hierarchy 
> created by libvirt and otherwise do not contain any tasks. Each cgroup has 
> cpu.shares proportional to # of tasks in it. For ex: /L1/L2/C1's cpu.shares =
> 2 * 1024 = 2048, C3's cpu.shares = 4096 etc. Further, each task is placed in its
> own (sub-)cgroup with default shares of 1024 and a capped usage of 50% CPU.
>   
>         /L1/L2/C1/C1_1/Task1  -> capped at 50% cpu usage
>         /L1/L2/C1/C1_2/Task2  -> capped at 50% cpu usage
>         /L1/L2/C2/C2_1/Task3  -> capped at 50% cpu usage
>         /L1/L2/C2/C2_2/Task3  -> capped at 50% cpu usage
>         /L1/L2/C3/C3_1/Task4  -> capped at 50% cpu usage
>         /L1/L2/C3/C3_2/Task4  -> capped at 50% cpu usage
>         /L1/L2/C3/C3_3/Task4  -> capped at 50% cpu usage
>         /L1/L2/C3/C3_4/Task4  -> capped at 50% cpu usage
>         ...
>         /L1/L2/C5/C5_16/Task32 -> capped at 50% cpu usage
> 
> So we have 32 tasks, each capped at 50% CPU usage, run on a 16-CPU
> system, which one may expect to consume all CPU resource leaving no idle
> time. While that may be "insane" expectation, the goal is to minimize idle time
> in this situation as much as possible.
> 
> I am using a slightly modified script provided at
> https://lkml.org/lkml/2011/6/7/352 for generating this test scenario -
> can make that available if required.
> 
> Idle time was sampled every second (using vmstat) over a window of 60 seconds
> and was found as below:
> 
> Idle time 		Average	 Std-deviation	 Min	Max
> ============================================================
> 
> nohz=off		4%        0.5%           3%      5%
> nohz=on	 	10% 	  2.4% 		 5%	 18%
> nohz=on + patch	5.3%      1.3%		 3%      9%
> 
> The patch cuts down idle time significantly when kernel is booted 
> with 'nohz=on' (which is good for saving power when idle).

What are the tasks doing which are running - are they plain burning 
CPU time? If the tasks do something more complex, do you also have a 
measure of how much work gets done by the workload, per second?

Percentual changes in that metric would be nice to include in an 
additional column - that way we can see that it's not only idle
that has gone down, but workload performance has gone up too.

In fact even if there was only a CPU burning loop in the workload it 
would be nice to make that somewhat more sophisticated by letting it 
process some larger array that has a cache footprint. This mimics 
real workloads that don't just spin burning CPU time but do real data 
processing.

For any non-trivial workload it's possible to reduce idle time 
without much increase in work done and in fact it's possible to 
decrease idle time *and* work done - so we need to see more clearly 
here and make sure it's all an improvement.

Thanks,

	Ingo

