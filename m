Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab3AGFaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:30:39 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53392 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3AGFah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:30:37 -0500
Message-ID: <50EA5D41.4090502@linux.vnet.ibm.com>
Date: Mon, 07 Jan 2013 10:59:37 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Alex Shi <alex.shi@intel.com>,
        srikar@linux.vnet.ibm.com
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
References: <50E3B61A.3040808@linux.vnet.ibm.com> <1357114354.5586.39.camel@marge.simpson.net> <50E55F99.6090104@linux.vnet.ibm.com> <1357373590.5690.172.camel@marge.simpson.net> <1357489955.5717.21.camel@marge.simpson.net>
In-Reply-To: <1357489955.5717.21.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010705-5564-0000-0000-0000061709DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,
Thank you very much for your inputs.Just a few thoughts so that we are
clear with the problems so far in the scheduler scalability and in what
direction we ought to move to correct them.

1. During fork or exec,the scheduler goes through find_idlest_group()
and find_idlest_cpu() in select_task_rq_fair() by iterating through all
domains.Why then was a similar approach not followed for wake up
balancing? What was so different about wake ups (except that the woken
up task had to remain close to the prev/waking cpu) that we had to
introduce select_idle_sibling() in the first place?

2.To the best of my knowlege,the concept of buddy cpu was introduced in
select_idle_sibling() so as to avoid the entire package traversal and
restrict it to the buddy cpus alone.But even during fork or exec,we
iterate through all the sched domains,like I have mentioned above.Why
did not the buddy cpu solution come to the rescue here as well?

3.So the correct problem stands at avoid iterating through the entire
package at the cost of less aggression in finding the idle cpu or
iterate through the package with an intention of finding the idlest
cpu.To the best of my understanding the former is your approach or
commit 37407ea7,the latter is what I tried to do.But as you have rightly
pointed out my approach will have scaling issues.In this light,how does
your best_combined patch(below) look like?
Do you introduce a cut off value on the loads to decide on which
approach to take?

Meanwhile I will also try to run tbench and a few other benchmarks to
find out why the results are like below.Will update you very soon on this.

Thank you

Regards
Preeti U Murthy



On 01/06/2013 10:02 PM, Mike Galbraith wrote:
> On Sat, 2013-01-05 at 09:13 +0100, Mike Galbraith wrote:
> 
>> I still have a 2.6-rt problem I need to find time to squabble with, but
>> maybe I'll soonish see if what you did plus what I did combined works
>> out on that 4x10 core box where current is _so_ unbelievably horrible.
>> Heck, it can't get any worse, and the restricted wake balance alone
>> kinda sorta worked.
> 
> Actually, I flunked copy/paste 101.  Below (preeti) shows the real deal.
> 
> tbench, 3 runs, 30 secs/run
> revert = 37407ea7 reverted
> clients                     1          5         10        20         40         80
> 3.6.0.virgin            27.83     139.50    1488.76   4172.93    6983.71    8301.73
>                         29.23     139.98    1500.22   4162.92    6907.16    8231.13
>                         30.00     141.43    1500.09   3975.50    6847.24    7983.98
> 
> 3.6.0+revert           281.08    1404.76    2802.44   5019.49    7080.97    8592.80
>                        282.38    1375.70    2747.23   4823.95    7052.15    8508.45
>                        270.69    1375.53    2736.29   5243.05    7058.75    8806.72
> 
> 3.6.0+preeti            26.43     126.62    1027.23   3350.06    7004.22    7561.83
>                         26.67     128.66     922.57   3341.73    7045.05    7662.18
>                         25.54     129.20    1015.02   3337.60    6591.32    7634.33
> 
> 3.6.0+best_combined    280.48    1382.07    2730.27   4786.20    6477.28    7980.07
>                        276.88    1392.50    2708.23   4741.25    6590.99    7992.11
>                        278.92    1368.55    2735.49   4614.99    6573.38    7921.75
> 
> 3.0.51-0.7.9-default   286.44    1415.37    2794.41   5284.39    7282.57   13670.80
> 
> Something is either wrong with 3.6 itself, or the config I'm using, as
> max throughput is nowhere near where it should be (see default).  On the
> bright side, integrating the two does show some promise.
> 
> -Mike
> 

