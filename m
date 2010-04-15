Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0DOITQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab0DOITK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:19:10 -0400
Message-ID: <4BC6CBE3.8020207@redhat.com>
Date: Thu, 15 Apr 2010 11:18:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Srivatsa Vaddagiri <vatsa.ml@gmail.com>
CC: "Zhang, Xiantao" <xiantao.zhang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "Yang, Xiaowei" <xiaowei.yang@intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>, "Li, Xin" <xin.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vatsa@linux.vnet.ibm.com
Subject: Re: VM performance issue in KVM guests.
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com>	 <4BC0D125.9050108@redhat.com>	 <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com>	 <4BC2C07B.4040607@redhat.com> <p2o2eae271004142158xaa5da968ueff0c2afe6894f9d@mail.gmail.com>
In-Reply-To: <p2o2eae271004142158xaa5da968ueff0c2afe6894f9d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 07:58 AM, Srivatsa Vaddagiri wrote:
> On Sun, Apr 11, 2010 at 11:40 PM, Avi Kivity <avi@redhat.com 
> <mailto:avi@redhat.com>> wrote:
>
>     The current handing of PLE is very suboptimal.  With proper
>     directed yield we should be much better there.
>
>
>
> Hi Avi,
>               By directed yield, do you mean transfer the timeslice of 
> one thread (which is contending for a lock) to another thread (which 
> is holding a lock)?

It's a priority transfer (in CFS terms, vruntime) (we don't know who 
holds the lock, so we pick a co-vcpu at random).

> If at that point in time, the lock-holder thread/VCPU is actually not 
> running currently, ie it is at the back of the runqueue, would it help 
> much? In such case, it will take time for the lock holder to run again 
> and the default timeslice it would have got could have been sufficient 
> to release the lock?

The idea is to increase the chances to the target vcpu to run, and to 
decrease the changes of the spinner to run (hopefully they change places).

>
> I am also working on a prototype for some other technique here - to 
> avoid preempting guest threads/VCPUs in the middle of their 
> (spin-lock) critical section. This requires guest to hint host when 
> there are in such a section. [1] has shown 33% improvement to an 
> apache benchmark based on this idea.
>

Certainly that has even greater potential for Linux guests.  Note that 
we spin on mutexes now, so we need to prevent preemption while the lock 
owner is running.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

