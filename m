Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0DLGlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:41:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869Ab0DLGlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:41:18 -0400
Message-ID: <4BC2C07B.4040607@redhat.com>
Date: Mon, 12 Apr 2010 09:40:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Xiantao" <xiantao.zhang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "Yang, Xiaowei" <xiaowei.yang@intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>, "Li, Xin" <xin.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: VM performance issue in KVM guests.
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com> <4BC0D125.9050108@redhat.com> <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com>
In-Reply-To: <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 05:04 AM, Zhang, Xiantao wrote:
>
>> What was the performance hit?  What was your I/O setup (image format,
>> using aio?)
>>      
> The issue only happens when vcpu number is over-committed(e.g. vcpu/pcpu>2) and physical cpus are saturated. For example,  when run webbench in windows OS in this case, its performance drops by 80%.  In our experiment, we are using image file through virtio, and I think aio should be used by default also.
>    

Is this on a machine that does pause-loop exits?  The current handing of 
PLE is very suboptimal.  With proper directed yield we should be much 
better there.

Without PLE, we need paravirtualized spinlocks, no way around it.

>>> After analysis about Linux scheduler, we found it is indeed caused
>>> by the known features of Linux schduler, such as AFFINE_WAKEUPS,
>>> SYNC_WAKEUPS etc. With these features on, linux schduler often tries
>>> to schedule the vcpu threads of one guests to one same logical
>>> processor when vcpus are over-committed and logical processors are
>>> saturated. Once the vcpu threads of one VM are scheduled to the same
>>> LP, system performance drops dramatically with some workloads(like
>>> webbench running in windows OS).
>>>
>>>        
>> Were the affine wakeups due to the kernel (emulated guest IPIs) or
>> qemu?
>>      
> We have basic guesses about the reasone, one is wakeup affinity between vcpu threads due to IPI, and the other is wakeup affinity between io theads and vcpu threads.
>    

It would be good to find out.

>> Most likely it also hits non-virtualized loads as well.  If the
>> scheduler pulls two long-running threads to the same cpu, performance
>> will take a hit.
>>      
> Since the hit only happens when physical cpus are saturated, and sheduling non-virtualized multiple threads of one process to same processor can benefit the performance due to cache share or other affinities, but you know it hurts performance a lot once schedule two vcpu theads to a same processor due to mutual spin-lock in guests.
>    

Spin loops need to be addressed first, they are known to kill 
performance in overcommit situations.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

