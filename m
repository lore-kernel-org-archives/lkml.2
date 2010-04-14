Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0DNDZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:25:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:4534 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab0DNDZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:25:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,202,1270450800"; 
   d="scan'208";a="265388566"
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "Yang, Xiaowei" <xiaowei.yang@intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>, "Li, Xin" <xin.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 14 Apr 2010 11:24:26 +0800
Subject: RE: VM performance issue in KVM guests.
Thread-Topic: VM performance issue in KVM guests.
Thread-Index: Acra1RJBa7/WsUXHSmCNX+Wx4nKFQQAqjs2Q
Message-ID: <EB8593BCECAB3D40A8248BE0B6400A38469C6790@shzsmsx502.ccr.corp.intel.com>
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com>
 <4BC0D125.9050108@redhat.com>
 <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com>
 <4BC2C07B.4040607@redhat.com>
 <EB8593BCECAB3D40A8248BE0B6400A38469046C1@shzsmsx502.ccr.corp.intel.com>
 <4BC41338.80206@redhat.com>
In-Reply-To: <4BC41338.80206@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 04/13/2010 03:50 AM, Zhang, Xiantao wrote:
>> Avi Kivity wrote:
>> 
>>> On 04/12/2010 05:04 AM, Zhang, Xiantao wrote:
>>> 
>>>> 
>>>>> What was the performance hit?  What was your I/O setup (image
>>>>> format, using aio?) 
>>>>> 
>>>>> 
>>>> The issue only happens when vcpu number is over-committed(e.g.
>>>> vcpu/pcpu>2) and physical cpus are saturated. For example,  when
>>>> run webbench in windows OS in this case, its performance drops by
>>>> 80%. In our experiment, we are using image file through virtio,
>>>> and I think aio should be used by default also.
>>>> 
>>>> 
>>> Is this on a machine that does pause-loop exits?  The current
>>> handing of PLE is very suboptimal.  With proper directed yield we
>>> should be much better there. 
>>> 
>>> Without PLE, we need paravirtualized spinlocks, no way around it.
>>> 
>> PLE has the ability to eliminate the issue at some extent, and pv
>> solution should be helpful also.  But for windows guests running on
>> machines without PLE, we still needs to enhance host side to resolve
>> the issue.   
>> 
> 
> Well, was this on a machine with PLE or without PLE?

I am saying the machine has no PLE feature support. Even with PLE feature support, there is still performance loss due to PLE's cost. 
 
>>> Spin loops need to be addressed first, they are known to kill
>>> performance in overcommit situations.
>>> 
>> Even in overcommit case, if vcpu threads of one qemu are not
>> scheduled or pulled to the same logical processor, the performance
>> drop is tolerant like Xen's case today. But for KVM, it has to
>> suffer from additional performance loss, since host's scheduler
>> actively pulls these vcpu threads together.    
>> 
>> 
> Can you quantify this loss?  Give examples of what happens?

For example, one machine is configured with 2 pCPUs and there are two Windows guests running on the machine, and each guest is cconfigured with 2 vcpus and one webbench server runs in it. 
If use host's default scheduler, webbench's performance is very bad, but if pin each geust's vCPU0 to pCPU0 and vCPU1 to pCPU1, we can see 5-10X performance improvement with same CPU utilization. 
In addition, we also see kvm's perf scalability is also impacted in large systems, for some performance experiments, kvm's perf begins to drop when vCPU is overcommitted and pCPU are saturated, but once the wake_up_affine feature is switched off in scheduler, kvm's perf can keep rising in this case.   
Xiantao

