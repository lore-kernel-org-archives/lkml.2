Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1FHQdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:33:00 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50819 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1FHQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:32:54 -0400
Date: Wed, 8 Jun 2011 22:02:34 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Paul Turner <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinned
Message-ID: <20110608163234.GA23031@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20110503092846.022272244@google.com>
 <20110607154542.GA2991@linux.vnet.ibm.com>
 <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vladimir Davydov <vdavydov@parallels.com> [2011-06-08 14:46:06]:

> On Tue, 2011-06-07 at 19:45 +0400, Kamalesh Babulal wrote:
> > Hi All,
> > 
> >     In our test environment, while testing the CFS Bandwidth V6 patch set
> > on top of 55922c9d1b84. We observed that the CPU's idle time is seen
> > between 30% to 40% while running CPU bound test, with the cgroups tasks
> > not pinned to the CPU's. Whereas in the inverse case, where the cgroups
> > tasks are pinned to the CPU's, the idle time seen is nearly zero.
> 
> (snip)
> 
> > load_tasks()
> > {
> >         for (( i=1; i<=5; i++ ))
> >         do
> >                 jj=$(eval echo "\$NR_TASKS$i")
> >                 shares="1024"
> >                 if [ $PRO_SHARES -eq 1 ]
> >                 then
> >                         eval shares=$(echo "$jj * 1024" | bc)
> >                 fi
> >                 echo $hares > $MOUNT/$i/cpu.shares
>                         ^^^^^
>                         a fatal misprint? must be shares, I guess
> 
> (Setting cpu.shares to "", i.e. to the minimal possible value, will
> definitely confuse the load balancer)

My bad. It was fatal typo, thanks for pointing it out. It made a big difference 
in the idle time reported. After correcting to $shares, now the CPU idle time 
reported is 20% to 22%. Which is 10% less from the previous reported number.

(snip)

There have been questions on how to interpret the results. Consider the
following test run without pinning of the cgroups tasks

Average CPU Idle percentage 20%
Bandwidth shared with remaining non-Idle 80%

Bandwidth of Group 1 = 7.9700% i.e = 6.3700% of non-Idle CPU time 80%
|...... subgroup 1/1	= 50.0200	i.e = 3.1800% of 6.3700% Groups non-Idle CPU time
|...... subgroup 1/2	= 49.9700	i.e = 3.1800% of 6.3700% Groups non-Idle CPU time
 
For example let consider the cgroup1 and sum_exec time is the 7 field
captured from the /proc/sched_debug

while1 27273     30665.912793      1988   120     30665.912793	30909.566767         0.021951 /1/2
while1 27272     30511.105690      1995   120     30511.105690	30942.998099         0.017369 /1/1
							      -----------------

								61852.564866
							      -----------------
 - The bandwidth for sub-cgroup1 of cgroup1 is calculated  = (30909.566767 * 100) / 61852.564866
					 		   = ~50% 

   and sub-cgroup2 of cgroup1 is calculated 		   = (30942.998099 * 100) / 61852.564866
							   = ~50%

In the similar way If we add up the sum_exec of all the groups its
------------------------------------------------------------------------------------------------
Group1		Group2		Group3		Group4		Group5		sum_exec 
------------------------------------------------------------------------------------------------
61852.564866 + 61686.604930 + 122840.294858 + 232576.303937 +296166.889155 = 	775122.657746

again taking the example of cgroup1
Total percentage of bandwidth allocated to cgroup1 = (61852.564866 * 100) / 775122.657746
						   = ~ 7.9% of total bandwidth of all the cgroups


Calculating the non-idle time is done with
	Total (execution time * 100) / (no of cpus * 60000 ms) [script is run for a 60 seconds]
	i.e. = (775122.657746 * 100) / (16 * 60000)
	     = ~80% of non-idle time

Percentage of bandwidth allocated to cgroup1 of the non-idle is derived as
	= (cgroup bandwith percentage * non-idle time) / 100
	= for cgroup1 	= (7.9700 * 80) / 100
			= 6.376% bandwidth allocated of non-Idle CPU time.	
	
 
Bandwidth of Group 2 = 7.9500% i.e = 6.3600% of non-Idle CPU time 80%
|...... subgroup 2/1	= 49.9900	i.e = 3.1700% of 6.3600% Groups non-Idle CPU time
|...... subgroup 2/2	= 50.0000	i.e = 3.1800% of 6.3600% Groups non-Idle CPU time
 
 
Bandwidth of Group 3 = 15.8400% i.e = 12.6700% of non-Idle CPU time 80%
|...... subgroup 3/1	= 24.9900	i.e = 3.1600% of 12.6700% Groups non-Idle CPU time
|...... subgroup 3/2	= 24.9900	i.e = 3.1600% of 12.6700% Groups non-Idle CPU time
|...... subgroup 3/3	= 25.0600	i.e = 3.1700% of 12.6700% Groups non-Idle CPU time
|...... subgroup 3/4	= 24.9400	i.e = 3.1500% of 12.6700% Groups non-Idle CPU time
 
 
Bandwidth of Group 4 = 30.0000% i.e = 24.0000% of non-Idle CPU time 80%
|...... subgroup 4/1	= 13.1600	i.e = 3.1500% of 24.0000% Groups non-Idle CPU time
|...... subgroup 4/2	= 11.3800	i.e = 2.7300% of 24.0000% Groups non-Idle CPU time
|...... subgroup 4/3	= 13.1100	i.e = 3.1400% of 24.0000% Groups non-Idle CPU time
|...... subgroup 4/4	= 12.3100	i.e = 2.9500% of 24.0000% Groups non-Idle CPU time
|...... subgroup 4/5	= 12.8200	i.e = 3.0700% of 24.0000% Groups non-Idle CPU time
|...... subgroup 4/6	= 11.0600	i.e = 2.6500% of 24.0000% Groups non-Idle CPU time
|...... subgroup 4/7	= 13.0600	i.e = 3.1300% of 24.0000% Groups non-Idle CPU time
|...... subgroup 4/8	= 13.0600	i.e = 3.1300% of 24.0000% Groups non-Idle CPU time
 
 
Bandwidth of Group 5 = 38.2000% i.e = 30.5600% of non-Idle CPU time 80%
|...... subgroup 5/1	= 48.1000	i.e = 14.6900%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/2	= 6.7900	i.e = 2.0700%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/3	= 6.3700	i.e = 1.9400%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/4	= 5.1800	i.e = 1.5800%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/5	= 5.0400	i.e = 1.5400%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/6	= 10.1400	i.e = 3.0900%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/7	= 5.0700	i.e = 1.5400%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/8	= 6.3900	i.e = 1.9500%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/9	= 6.8800	i.e = 2.1000%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/10	= 6.4700	i.e = 1.9700%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/11	= 6.5600	i.e = 2.0000%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/12	= 4.6400	i.e = 1.4100%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/13	= 7.4900	i.e = 2.2800%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/14	= 5.8200	i.e = 1.7700%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/15	= 6.5500	i.e = 2.0000%	of 30.5600% Groups non-Idle CPU time
|...... subgroup 5/16	= 5.2700	i.e = 1.6100%	of 30.5600% Groups non-Idle CPU time

Thanks,
Kamalesh.
