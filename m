Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab2CZRfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:35:46 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43644 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab2CZRfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:35:45 -0400
Date: Mon, 26 Mar 2012 23:05:33 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120326173533.GA4689@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1329764866.2293.376.camhel@twins>
 <20120305152443.GE26559@linux.vnet.ibm.com>
 <20120306091410.GD27238@elte.hu>
 <20120322153205.GA28570@linux.vnet.ibm.com>
 <1332750960.16159.81.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1332750960.16159.81.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12032617-5816-0000-0000-000001E83876
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-03-26 10:36:00]:

> >                 tip     tip + patch 
> > 
> > volano          1       1.29   (29% improvement)
> > sysbench [n3]   1       2      (100% improvement)
> > tbench 1 [n4]   1       1.07   (7% improvement)
> > tbench 8 [n5]   1       1.26   (26% improvement)
> > httperf  [n6]   1       1.05   (5% improvement)
> > Trade           1       1.31   (31% improvement) 
> 
> That smells like there's more to the story, a 100% improvement is too
> much..

Yeah I have rubbed my eyes several times to make sure its true and ran
the same benchmark (sysbench) again now! I can recreate that ~100%
improvement with the patch even now.

To quickly re-cap my environment, I have a 16-cpu machine w/ 5 cgroups.
1 cgroup (8192 shares) hosts sysbench inside 8-vcpu VM while remaining 4
cgroups (1024 shares each) hosts 4 cpu hogs running on bare metal.
Given this overcommittment, select_idle_sibling() should mostly be a 
no-op (i.e it won't find any idle cores and thus defaults to prev_cpu).
Also the only tasks that will (sleep and) wakeup are the VM tasks.

Since the patch potentially affects (improves) scheduling latencies, I measured 
Sum(se.statistics.wait_sum) for the VM tasks over the benchmark run (5
iterations of sysbench).

tip	    : 987240 ms
tip + patch : 280275 ms 

I will get more comprehensive perf data shortly and post. 

>From what I can tell, the huge improvement in benchmark score is coming from 
reduced latencies for its VM tasks. 

The hard part to figure out (when we are inside select_task_rq_fair()) is 
whether any potential improvement in latencies (because of waking up on a
less loaded cpu) will offshoot the cost of potentially more L2-cache misses, 
for which IMHO we don't have enough data to make a good decision.

- vatsa

