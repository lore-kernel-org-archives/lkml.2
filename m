Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab2K0DJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 22:09:14 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38341 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab2K0DJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 22:09:13 -0500
Message-ID: <50B42EB0.8090609@linux.vnet.ibm.com>
Date: Tue, 27 Nov 2012 08:38:32 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Benjamin Segall <bsegall@google.com>
CC: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org,
        pjt@google.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] enable runnable load avg in load balance
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com> <xm26ehjg5gra.fsf@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <xm26ehjg5gra.fsf@sword-of-the-dawn.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12112703-3568-0000-0000-000002D4E6CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On 11/27/2012 12:33 AM, Benjamin Segall wrote:
> So, I've been trying out using the runnable averages for load balance in
> a few ways, but haven't actually gotten any improvement on the
> benchmarks I've run. I'll post my patches once I have the numbers down,
> but it's generally been about half a percent to 1% worse on the tests
> I've tried.
> 
> The basic idea is to use (cfs_rq->runnable_load_avg +
> cfs_rq->blocked_load_avg) (which should be equivalent to doing
> load_avg_contrib on the rq) for cfs_rqs and possibly the rq, and
> p->se.load.weight * p->se.avg.runnable_avg_sum / period for tasks.

Why should cfs_rq->blocked_load_avg be included to calculate the load
on the rq? They do not contribute to the active load of the cpu right?

When a task goes to sleep its load is removed from cfs_rq->load.weight
as well in account_entity_dequeue(). Which means the load balancer
considers a sleeping entity as *not* contributing to the active runqueue
load.So shouldn't the new metric consider cfs_rq->runnable_load_avg alone?
> 
> I have not yet tried including wake_affine, so this has just involved
> h_load (task_load_down and task_h_load), as that makes everything
> (besides wake_affine) be based on either the new averages or the
> rq->cpu_load averages.
> 

Yeah I have been trying to view the performance as well,but with
cfs_rq->runnable_load_avg as the rq load contribution and the task load,
same as mentioned above.I have not completed my experiments but I would
expect some significant performance difference due to the below scenario:

                     Task3(10% task)
Task1(100% task)     Task4(10% task)
Task2(100% task)     Task5(10% task)
---------------     ----------------       ----------
CPU1                  CPU2                  CPU3

When cpu3 triggers load balancing:

CASE1:
 without PJT's metric the following loads will be perceived
 CPU1->2048
 CPU2->3042
 Therefore CPU2 might be relieved of one task to result in:


Task1(100% task)     Task4(10% task)
Task2(100% task)     Task5(10% task)       Task3(10% task)
---------------     ----------------       ----------
CPU1                  CPU2                  CPU3

CASE2:
  with PJT's metric the following loads will be perceived
  CPU1->2048
  CPU2->1022
 Therefore CPU1 might be relieved of one task to result in:

                     Task3(10% task)
                     Task4(10% task)
Task2(100% task)     Task5(10% task)     Task1(100% task)
---------------     ----------------       ----------
CPU1                  CPU2                  CPU3


The differences between the above two scenarios include:

1.Reduced latency for Task1 in CASE2,which is the right task to be moved
in the above scenario.

2.Even though in the former case CPU2 is relieved of one task,its of no
use if Task3 is going to sleep most of the time.This might result in
more load balancing on behalf of cpu3.

What do you guys think?

Thank you

Regards
Preeti U Murthy




