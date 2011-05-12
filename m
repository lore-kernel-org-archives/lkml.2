Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab1ELVh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:37:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39443 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab1ELVhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:37:21 -0400
Message-ID: <4DCC52FB.6030500@kernel.org>
Date: Thu, 12 May 2011 14:36:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <4DC9A5A4.1050308@kernel.org> <20110511045443.GS2258@linux.vnet.ibm.com> <BANLkTi=r707A9yy5-7+dw3Hozt=G1HBQ-Q@mail.gmail.com> <20110511201852.GC2258@linux.vnet.ibm.com> <4DCAF894.7030707@kernel.org> <4DCAFFD8.2080605@kernel.org> <4DCB157F.20202@kernel.org> <20110512060344.GB3191@elte.hu> <4DCB8BCD.1080607@kernel.org> <4DCB8F7A.90603@kernel.org> <20110512092013.GJ2258@linux.vnet.ibm.com>
In-Reply-To: <20110512092013.GJ2258@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DCC5303.005A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 02:20 AM, Paul E. McKenney wrote:
> On Thu, May 12, 2011 at 12:42:50AM -0700, Yinghai Lu wrote:
>> On 05/12/2011 12:27 AM, Yinghai Lu wrote:
>>> On 05/11/2011 11:03 PM, Ingo Molnar wrote:
>>>>
>>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>>
>>>>> e59fb3120becfb36b22ddb8bd27d065d3cdca499 is the first bad commit
>>>>> commit e59fb3120becfb36b22ddb8bd27d065d3cdca499
>>>>> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>>>> Date:   Tue Sep 7 10:38:22 2010 -0700
>>>>>
>>>>>     rcu: Decrease memory-barrier usage based on semi-formal proof
>>>>
>>>> Find below an (untested!) attempt at reverting it for debugging purposes: could 
>>>> you please try it, does your system now boot up fine?
>>>>
>>>> Thanks,
>>>>
>>>> 	Ingo
>>>>
>>>
>>> yes, reverted manually that commit fix the problem.
>>
>> on system with 8 sockets westmere-ex
>>
>> it seems other commits after that commit contribute some delay too.
>>
>> [   32.240739] cpu_dev_init done
>> [   73.587288] memory_dev_init done
> 
> I am testing a revert of e59fb3120becfb36b22ddb8bd27d065d3cdca499 and
> will chase down the delay.
> 

it seems still need to revert following one in addition  e59fb3120becfb36b22ddb8bd27d065d3cdca499.

[root@mpk14-2404-239-158 linux-2.6]# git bisect good
a26ac2455ffcf3be5c6ef92bc6df7182700f2114 is the first bad commit
commit a26ac2455ffcf3be5c6ef92bc6df7182700f2114
Author: Paul E. McKenney <paul.mckenney@linaro.org>
Date:   Wed Jan 12 14:10:23 2011 -0800

    rcu: move TREE_RCU from softirq to kthread
    
    If RCU priority boosting is to be meaningful, callback invocation must
    be boosted in addition to preempted RCU readers.  Otherwise, in presence
    of CPU real-time threads, the grace period ends, but the callbacks don't
    get invoked.  If the callbacks don't get invoked, the associated memory
    doesn't get freed, so the system is still subject to OOM.
    
    But it is not reasonable to priority-boost RCU_SOFTIRQ, so this commit
    moves the callback invocations to a kthread, which can be boosted easily.
    
    Also add comments and properly synchronized all accesses to
    rcu_cpu_kthread_task, as suggested by Lai Jiangshan.
    
    Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Reviewed-by: Josh Triplett <josh@joshtriplett.org>

:040000 040000 e40306ac6405952c1d387325a98588442209abe8 efe9ea2f408c62daaccf49e6d1339dff3a74f049 M	Documentation
:040000 040000 8f9e7a8fa3a728d4ae58e2efb8ada7cf08aed00e 9b44deba45ba905c5d9b3cc314812f0ba3f7e639 M	include
:040000 040000 4b10b719a2d56ed4bc796a9f43775732bb5ff144 4db269277ccf607e1a6a7d7f4c2a7cf8d592d46a M	kernel
:040000 040000 881f102e6831381beed016ed240d690f6a2ccd5e 57d2fc6f84e47394c116bc617a9a0ef9b8b6dbd4 M	tools
