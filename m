Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab0DJT1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 15:27:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab0DJT1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 15:27:48 -0400
Message-ID: <4BC0D125.9050108@redhat.com>
Date: Sat, 10 Apr 2010 22:27:33 +0300
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
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com>
In-Reply-To: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(copying lkml and some scheduler folk)

On 04/10/2010 11:16 AM, Zhang, Xiantao wrote:
> Hi, all
>    We are working on the scalability work for KVM guests, and found one big issue exists in linux scheduler and it may impact guest's performance and scalability a lot for some special workloads running in VM.  In the current Linux scheduler, there are some features to enhance App's performance which are defined in the file kvm.git/kernel/sched_features.h. Certainly, they are mostly beneficial optimizations to improve system's performance, but unluckily, some of them may hurt VM's performance and scalablity in KVM case
>    We know that if two or more vcpus of one guests are scheduled to one same logical processor,  same CPU utilization may generate less valid output due mutual lock in VM's OS than that are scheduled to different logical processors  .And we also know that VM's vcpus are emulated or executed through the threads of Qemu for KVM.  If the vcpu threads of qemu are often pulled to one same logical processor by some features of Linux scheduler, kvm guests'performance may be hurt a lot.  In our performance testing,  the results also show this performance bottleneck due to this issue.

What was the performance hit?  What was your I/O setup (image format, 
using aio?)

> After analysis about Linux scheduler, we found it is indeed caused by the known features of Linux schduler, such as AFFINE_WAKEUPS, SYNC_WAKEUPS etc. With these features on, linux schduler often tries to schedule the vcpu threads of one guests to one same logical processor when vcpus are over-committed and logical processors are saturated. Once the vcpu threads of one VM are scheduled to the same LP, system performance drops dramatically with some workloads(like webbench running in windows OS).
>    

Were the affine wakeups due to the kernel (emulated guest IPIs) or qemu?

>     To verify this finding, we also worked out a simple patch attached in the mail to dynamially switch off the two sheduler features mentioned above when scheduler knows the scheduling tasks are vcpu threads, and we found the the whole system's performance and scalability are improved a lot.  Certatinly, this patch is not good for upstream, but it can enlighten us to think how to optimize Linux scheduler and we also want to initiate the discussion about how to make LINUX's scheduler more friendly to virtualization.  Besides, this issue maybe not only kvm's special issue, insteadly it should be a common issue for host-based VMs, and we also expect that we can have an elegant solution to thoroughly resolve the performance or scalability gap compared with hypervisor-based VMs.
>    

Most likely it also hits non-virtualized loads as well.  If the 
scheduler pulls two long-running threads to the same cpu, performance 
will take a hit.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

