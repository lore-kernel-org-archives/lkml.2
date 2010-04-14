Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0DNIOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 04:14:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0DNIOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 04:14:21 -0400
Message-ID: <4BC57949.2090003@redhat.com>
Date: Wed, 14 Apr 2010 11:14:01 +0300
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
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com> <4BC0D125.9050108@redhat.com> <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com> <4BC2C07B.4040607@redhat.com> <EB8593BCECAB3D40A8248BE0B6400A38469046C1@shzsmsx502.ccr.corp.intel.com> <4BC41338.80206@redhat.com> <EB8593BCECAB3D40A8248BE0B6400A38469C6790@shzsmsx502.ccr.corp.intel.com>
In-Reply-To: <EB8593BCECAB3D40A8248BE0B6400A38469C6790@shzsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 06:24 AM, Zhang, Xiantao wrote:
>
>>>> Spin loops need to be addressed first, they are known to kill
>>>> performance in overcommit situations.
>>>>
>>>>          
>>> Even in overcommit case, if vcpu threads of one qemu are not
>>> scheduled or pulled to the same logical processor, the performance
>>> drop is tolerant like Xen's case today. But for KVM, it has to
>>> suffer from additional performance loss, since host's scheduler
>>> actively pulls these vcpu threads together.
>>>
>>>
>>>        
>> Can you quantify this loss?  Give examples of what happens?
>>      
> For example, one machine is configured with 2 pCPUs and there are two Windows guests running on the machine, and each guest is cconfigured with 2 vcpus and one webbench server runs in it.
> If use host's default scheduler, webbench's performance is very bad, but if pin each geust's vCPU0 to pCPU0 and vCPU1 to pCPU1, we can see 5-10X performance improvement with same CPU utilization.
> In addition, we also see kvm's perf scalability is also impacted in large systems, for some performance experiments, kvm's perf begins to drop when vCPU is overcommitted and pCPU are saturated, but once the wake_up_affine feature is switched off in scheduler, kvm's perf can keep rising in this case.
>    

Ok.  This is probably due to spinlock contention.

When vcpus are pinned to pcpus, there is a 50% chance that a guest's 
vcpus will be co-scheduled and spinlocks will perform will.

When vcpus are not pinned, but affine wakeups are disabled, there is a 
33% chance that vcpus will be co-scheduled.

When vcpus are not pinned and affine wakeups are enabled there is a 0% 
chance that vcpus will be co-scheduled.

Keeping both vcpus on the same core actually makes sense since they can 
communicate through the local cache faster than across cores.  What we 
need is to make sure that they don't spin.

Windows 2008 can report spinlock spinning through a hypercall.  Can you 
hook to that interface and see if it happens regularly?  Altenatively 
use a PLE capable host and trace the kvm_vcpu_on_spin() function.

-- 
error compiling committee.c: too many arguments to function

