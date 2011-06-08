Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1FHKqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:46:21 -0400
Received: from relay.parallels.com ([195.214.232.42]:32782 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab1FHKqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:46:19 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned
	vs unpinned
From: Vladimir Davydov <vdavydov@parallels.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Paul Turner <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Pavel Emelianov <xemul@parallels.com>
In-Reply-To: <20110607154542.GA2991@linux.vnet.ibm.com>
References: <20110503092846.022272244@google.com>
	 <20110607154542.GA2991@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 8 Jun 2011 14:46:06 +0400
Message-ID: <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 19:45 +0400, Kamalesh Babulal wrote:
> Hi All,
> 
>     In our test environment, while testing the CFS Bandwidth V6 patch set
> on top of 55922c9d1b84. We observed that the CPU's idle time is seen
> between 30% to 40% while running CPU bound test, with the cgroups tasks
> not pinned to the CPU's. Whereas in the inverse case, where the cgroups
> tasks are pinned to the CPU's, the idle time seen is nearly zero.

(snip)

> load_tasks()
> {
>         for (( i=1; i<=5; i++ ))
>         do
>                 jj=$(eval echo "\$NR_TASKS$i")
>                 shares="1024"
>                 if [ $PRO_SHARES -eq 1 ]
>                 then
>                         eval shares=$(echo "$jj * 1024" | bc)
>                 fi
>                 echo $hares > $MOUNT/$i/cpu.shares
                        ^^^^^
                        a fatal misprint? must be shares, I guess

(Setting cpu.shares to "", i.e. to the minimal possible value, will
definitely confuse the load balancer)

>                 for (( j=1; j<=$jj; j++ ))
>                 do
>                         echo "-1" > $MOUNT/$i/cpu.cfs_quota_us
>                         echo "500000" > $MOUNT/$i/cpu.cfs_period_us
>                         if [ $SUBGROUP -eq 1 ]
>                         then
> 
>                                 $LOAD &
>                                 echo $! > $MOUNT/$i/$j/tasks
>                                 echo "1024" > $MOUNT/$i/$j/cpu.shares
> 
>                                 if [ $BANDWIDTH -eq 1 ]
>                                 then
>                                         echo "500000" > $MOUNT/$i/$j/cpu.cfs_period_us
>                                         echo "250000" > $MOUNT/$i/$j/cpu.cfs_quota_us
>                                 fi
>                         else
>                                 $LOAD &
>                                 echo $! > $MOUNT/$i/tasks
>                                 echo $shares > $MOUNT/$i/cpu.shares
> 
>                                 if [ $BANDWIDTH -eq 1 ]
>                                 then
>                                         echo "500000" > $MOUNT/$i/cpu.cfs_period_us
>                                         echo "250000" > $MOUNT/$i/cpu.cfs_quota_us
>                                 fi
>                         fi
>                 done
>         done
>         echo "Captuing idle cpu time with vmstat...."
>         vmstat 2 100 &> vmstat_log &
> }


