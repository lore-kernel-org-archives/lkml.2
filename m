Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1FNKRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:17:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55449 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1FNKRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:17:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF73514.4080901@jp.fujitsu.com>
Date: Tue, 14 Jun 2011 19:16:52 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned
 vs unpinned
References: <20110503092846.022272244@google.com> <20110607154542.GA2991@linux.vnet.ibm.com>
In-Reply-To: <20110607154542.GA2991@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/08 0:45), Kamalesh Babulal wrote:
> Hi All,
> 
>     In our test environment, while testing the CFS Bandwidth V6 patch set 
> on top of 55922c9d1b84. We observed that the CPU's idle time is seen
> between 30% to 40% while running CPU bound test, with the cgroups tasks 
> not pinned to the CPU's. Whereas in the inverse case, where the cgroups 
> tasks are pinned to the CPU's, the idle time seen is nearly zero.

I've some test with your test script but I'm not sure whether it is really
a considerable problem. Am I missing the point?

I add -c option to your script to toggle pinning (1:pinned, 0:not pinned).
In short the results in my environment (16 cpu, 4 quad core) are:

				# group's usage
 -b 0 -p 0 -c 0 : Idle = 0%	(12,12,25,25,25)
 -b 0 -p 0 -c 1 : Idle = 0%	(6,6,12,25,50)
 -b 0 -p 1 -c * : Idle = 0%	(6,6,12,25,50)
 -b 1 -p 0 -c 0 : Idle = ~25%	(6,6,12,25,25)
 -b 1 -p 0 -c 1 : Idle = 0%	(6,6,12,25,50)
 -b 1 -p 1 -c * : Idle = 0%	(6,6,12,25,50)	

In my understanding is correct, when -p0, there are 5 groups (with share=1024)
and each group has 2,2,4,8,16 subgroups, so a subgroup in /1 is weighted 8 times
higher than one in /5.  And when -p1, share of 5 parent groups are promoted and
all subgroups are evenly weighted.
With -p0 the cpu usage of 5 groups is going to be 20,20,20,20,20 but group /1
and /2 have only 2 subgroups for each, so even if /1 and /2 fully use 2 cpus
for each the usage will be 12,12,25,25,25.

OTOH the bandwidth of a subgroup is 250000/500000 (=0.5 cpu), so in case of
Idle=0% the cpu usage of groups are likely be 6,6,12,25,50%. 

The question is what happen if both are mixed.

For example in case of your unpinned Idle=34.8%: 

> Average CPU Idle percentage 34.8% (as explained above in the Idle time measured)
> Bandwidth shared with remaining non-Idle 65.2%

> Bandwidth of Group 1 = 9.2500 i.e = 6.0300% of non-Idle CPU time 65.2%
> Bandwidth of Group 2 = 9.0400 i.e = 5.8900% of non-Idle CPU time 65.2%
> Bandwidth of Group 3 = 16.9300 i.e = 11.0300% of non-Idle CPU time 65.2%
> Bandwidth of Group 4 = 27.9300 i.e = 18.2100% of non-Idle CPU time 65.2%
> Bandwidth of Group 5 = 36.8300 i.e = 24.0100% of non-Idle CPU time 65.2%

The usage is 6,6,11,18,24.
It looks like that group /1 to /3 are limited by bandwidth, while group /5 is
limited by share. (I have no idea about the noise on /4 here)

BTW since pinning in your script always pin a couple of subgroup in a same
group to a cpu, subgroups are weighted evenly everywhere so as the result
share doesn't work for these cases.


Thanks,
H.Seto

