Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0DQTDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:03:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab0DQTDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:03:12 -0400
Message-ID: <4BCA05D6.4010709@redhat.com>
Date: Sat, 17 Apr 2010 22:02:46 +0300
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
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com> <4BC0D125.9050108@redhat.com> <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com> <4BC2C07B.4040607@redhat.com> <EB8593BCECAB3D40A8248BE0B6400A38469046C1@shzsmsx502.ccr.corp.intel.com> <4BC41338.80206@redhat.com> <EB8593BCECAB3D40A8248BE0B6400A38469C6790@shzsmsx502.ccr.corp.intel.com> <4BC57949.2090003@redhat.com> <EB8593BCECAB3D40A8248BE0B6400A38469C71EB@shzsmsx502.ccr.corp.intel.com>
In-Reply-To: <EB8593BCECAB3D40A8248BE0B6400A38469C71EB@shzsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2010 05:27 AM, Zhang, Xiantao wrote:
>
>
>> When vcpus are pinned to pcpus, there is a 50% chance that a guest's
>> vcpus will be co-scheduled and spinlocks will perform will.
>>
>> When vcpus are not pinned, but affine wakeups are disabled, there is a
>> 33% chance that vcpus will be co-scheduled.
>>
>> When vcpus are not pinned and affine wakeups are enabled there is a 0%
>> chance that vcpus will be co-scheduled.
>>
>> Keeping both vcpus on the same core actually makes sense since they
>> can communicate through the local cache faster than across cores.
>> What we need is to make sure that they don't spin.
>>
>> Windows 2008 can report spinlock spinning through a hypercall.  Can
>> you hook to that interface and see if it happens regularly?
>> Altenatively use a PLE capable host and trace the kvm_vcpu_on_spin()
>> function.
>>      
> We only tried windows 2003 for the experiments, and have no data related to windows 2008.
> But maybe we can have  a try later.  Anyway, the key point is we have to enhance the scheduler to let it
> Know which threads are vcpu threads to avoid perf loss in this case.
>    

I have two worries about this approach:

1.  Affine wakeups were introduced for a reason; if we disable them 
(even just for vcpus), we lost something.  Maybe we can tune the 
mechanism not to fail, instead of disabling it.

2.  Affine wakeups are a scheduler internal detail.  How do we explain 
what it does?  the scheduler may not have affine wakeups in a few years, 
yet we'll have an ABI to disable them.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

