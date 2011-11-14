Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1KNKZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 05:25:25 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:41480 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1KNKZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 05:25:24 -0500
Date: Mon, 14 Nov 2011 15:33:06 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Ben Segall <bsegall@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch 3/3] From: Ben Segall <bsegall@google.com>
Message-ID: <20111114100306.GA10520@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20111108042632.977080206@google.com>
 <20111108042736.683407863@google.com>
 <4EBB3742.7060404@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4EBB3742.7060404@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11111410-8878-0000-0000-0000003647FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

> Since throttling occurs in the put_prev_task() path we do not get to observe
> this delta against nr_running when making the decision to idle_balance().
> 
> Fix this by first enumerating cfs_rq throttle states so that we can distinguish
> throttling cfs_rqs.  Then remove tasks that will be throttled in put_prev_task
> from rq->nr_running/cfs_rq->h_nr_running when in account_cfs_rq_runtime,
> rather than delaying until put_prev_task.
> 
> This allows schedule() to call idle_balance when we go idle due to throttling.
> 
> Using Kamalesh's nested-cgroup test case[1] we see the following improvement on
> a 16 core system:
> baseline: Average CPU Idle percentage 13.9667%
>   +patch: Average CPU Idle percentage 3.53333%
> [1]: https://lkml.org/lkml/2011/9/15/261
> 
> Signed-off-by: Ben Segall <bsegall@google.com>
> Signed-off-by: Paul Turner <pjt@google.com>

  Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Thanks for the patch. I tested patches on the same test environment, over which 
the cpu idle time was reported first at https://lkml.org/lkml/2011/6/7/352. In 
brief, tests were run on 2 socket quad core machine with three level of nested 
cgroups hierarchy and five cgroups created below the third level. Each of the 
five cgroups, having 2,2,4,8,16 while1 or cpu-matrix (https://lkml.org/lkml/2011/11/4/107) 
tasks attached to them respectively.

[1] CFS Bandwith tweaks, were the patches posted by Paul Turner (https://lkml.org/lkml/2011/11/7/603)
[2] nohz idle balance RFC patch by Srivatsa Vaddagiri (https://lkml.org/lkml/2011/11/2/117)

While running the cpu-matrix benchmark with the patches, there was an improvement 
around ~50 to 55% and additional ~3% benefit in idle time with nohz idle balance
patch. With while1 loop the improvment was around ~36 to 40% over tip and an 
additional benefit of ~4 to 5% was seen with nohz idle balance patch.

(1) cpu-matrix benchmark with nohz=on
    ----------------------------------

Run     Base (tip)                                              tip +  CFS Bandwith tweaks                              tip +  CFS Bandwith tweaks + nohz idle patch
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1       Average CPU Idle percentage 4.1%                        Average CPU Idle percentage 2.36667%                    Average CPU Idle percentage 2.23333%
	Bandwidth shared with remaining non-Idle 95.9%          Bandwidth shared with remaining non-Idle 97.63333%      Bandwidth shared with remaining non-Idle 97.76667%

2       Average CPU Idle percentage 4.23%                       Average CPU Idle percentage 2.3%                        Average CPU Idle percentage 2.16667%
	Bandwidth shared with remaining non-Idle 95.77%         Bandwidth shared with remaining non-Idle 97.7%          Bandwidth shared with remaining non-Idle 97.83333%

(2) cpu-matrix benchmark with nohz=off
    -----------------------------------

Run     Base (tip)                                              tip +  CFS Bandwith tweaks                              tip +  CFS Bandwith tweaks + nohz idle patch
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1       Average CPU Idle percentage 4.53333%                    Average CPU Idle percentage 2.43333%                    Average CPU Idle percentage 2.36667%
	Bandwidth shared with remaining non-Idle 95.46667%      Bandwidth shared with remaining non-Idle 97.56667%      Bandwidth shared with remaining non-Idle 97.63333%

2       Average CPU Idle percentage 4.4%                        Average CPU Idle percentage 2.36667%                    Average CPU Idle percentage 2.4%
	Bandwidth shared with remaining non-Idle 95.6%          Bandwidth shared with remaining non-Idle 97.63333%      Bandwidth shared with remaining non-Idle 97.6%


(3) while1 loop with nohz=on
    -------------------------

Run     Base (tip)                                              tip +  CFS Bandwith tweaks                              tip +  CFS Bandwith tweaks + nohz idle patch
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1       Average CPU Idle percentage 6.26667%                    Average CPU Idle percentage 2.5%                        Average CPU Idle percentage 2.23333%
	Bandwidth shared with remaining non-Idle 93.73333%      Bandwidth shared with remaining non-Idle 97.5%          Bandwidth shared with remaining non-Idle 97.76667%

2       Average CPU Idle percentage 6.73333%                    Average CPU Idle percentage 2.46667%                    Average CPU Idle percentage 2.13333%
	Bandwidth shared with remaining non-Idle 93.26667%      Bandwidth shared with remaining non-Idle 97.53333%      Bandwidth shared with remaining non-Idle 97.86667%

(4) while1 loop with nohz=off
    --------------------------

Run     Base (tip)                                              tip +  CFS Bandwith tweaks                              tip +  CFS Bandwith tweaks + nohz idle patch
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1       Average CPU Idle percentage 3.6%                        Average CPU Idle percentage 2.4%                        Average CPU Idle percentage 2.43333%
	Bandwidth shared with remaining non-Idle 96.4%          Bandwidth shared with remaining non-Idle 97.6%          Bandwidth shared with remaining non-Idle 97.56667%

2       Average CPU Idle percentage 3.46667%                    Average CPU Idle percentage 2.33333%                    Average CPU Idle percentage 2.4%
	Bandwidth shared with remaining non-Idle 96.53333%      Bandwidth shared with remaining non-Idle 97.66667%      Bandwidth shared with remaining non-Idle 97.6%

each cpu-matrix benchmark task was run as # perf sched cpu-matrix -s1k -i 1000 -p100

		Kamalesh.

