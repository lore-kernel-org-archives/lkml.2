Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0DMAu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 20:50:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:15455 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab0DMAu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 20:50:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,193,1270450800"; 
   d="scan'208";a="264861321"
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "Yang, Xiaowei" <xiaowei.yang@intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>, "Li, Xin" <xin.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 13 Apr 2010 08:50:08 +0800
Subject: RE: VM performance issue in KVM guests.
Thread-Topic: VM performance issue in KVM guests.
Thread-Index: AcraCyn2aeoqd45yTZ2+fSecFMG8/wAAhCoQ
Message-ID: <EB8593BCECAB3D40A8248BE0B6400A38469046C1@shzsmsx502.ccr.corp.intel.com>
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com>
 <4BC0D125.9050108@redhat.com>
 <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com>
 <4BC2C07B.4040607@redhat.com>
In-Reply-To: <4BC2C07B.4040607@redhat.com>
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
> On 04/12/2010 05:04 AM, Zhang, Xiantao wrote:
>> 
>>> What was the performance hit?  What was your I/O setup (image
>>> format, using aio?) 
>>> 
>> The issue only happens when vcpu number is over-committed(e.g.
>> vcpu/pcpu>2) and physical cpus are saturated. For example,  when run
>> webbench in windows OS in this case, its performance drops by 80%. 
>> In our experiment, we are using image file through virtio, and I
>> think aio should be used by default also.    
>> 
> 
> Is this on a machine that does pause-loop exits?  The current handing
> of PLE is very suboptimal.  With proper directed yield we should be
> much better there.
> 
> Without PLE, we need paravirtualized spinlocks, no way around it.

PLE has the ability to eliminate the issue at some extent, and pv solution should be helpful also.  But for windows guests running on machines without PLE, we still needs to enhance host side to resolve the issue.

>>>> After analysis about Linux scheduler, we found it is indeed caused
>>>> by the known features of Linux schduler, such as AFFINE_WAKEUPS,
>>>> SYNC_WAKEUPS etc. With these features on, linux schduler often
>>>> tries to schedule the vcpu threads of one guests to one same
>>>> logical processor when vcpus are over-committed and logical
>>>> processors are saturated. Once the vcpu threads of one VM are
>>>> scheduled to the same LP, system performance drops dramatically
>>>> with some workloads(like webbench running in windows OS).
>>> 
>> Since the hit only happens when physical cpus are saturated, and
>> sheduling non-virtualized multiple threads of one process to same
>> processor can benefit the performance due to cache share or other
>> affinities, but you know it hurts performance a lot once schedule
>> two vcpu theads to a same processor due to mutual spin-lock in
>> guests.     
>> 
> Spin loops need to be addressed first, they are known to kill
> performance in overcommit situations.

Even in overcommit case, if vcpu threads of one qemu are not scheduled or pulled to the same logical processor, the performance drop is tolerant like Xen's case today. But for KVM, it has to suffer from additional performance loss, since host's scheduler actively pulls these vcpu threads together. 
Xiantao 

