Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2IUR2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:28:45 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40564 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2IUR2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:28:42 -0400
Message-ID: <505CA2EB.7050403@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2012 22:54:59 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com>
In-Reply-To: <505C654B.2050106@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092117-9264-0000-0000-000002604B8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 06:32 PM, Rik van Riel wrote:
> On 09/21/2012 08:00 AM, Raghavendra K T wrote:
>> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>>
>> When total number of VCPUs of system is less than or equal to physical
>> CPUs,
>> PLE exits become costly since each VCPU can have dedicated PCPU, and
>> trying to find a target VCPU to yield_to just burns time in PLE handler.
>>
>> This patch reduces overhead, by simply doing a return in such
>> scenarios by
>> checking the length of current cpu runqueue.
>
> I am not convinced this is the way to go.
>
> The VCPU that is holding the lock, and is not releasing it,
> probably got scheduled out. That implies that VCPU is on a
> runqueue with at least one other task.

I see your point here, we have two cases:

case 1)

rq1 : vcpu1->wait(lockA) (spinning)
rq2 : vcpu2->holding(lockA) (running)

Here Ideally vcpu1 should not enter PLE handler, since it would surely
get the lock within ple_window cycle. (assuming ple_window is tuned for
that workload perfectly).

May be this explains why we are not seeing benefit with kernbench.

On the other side, Since we cannot have a perfect ple_window tuned for
all type of workloads, for those workloads, which may need more than
4096 cycles, we gain. thinking is it that we are seeing in benefited
cases?

case 2)
rq1 : vcpu1->wait(lockA) (spinning)
rq2 : vcpu3 (running) ,  vcpu2->holding(lockA) [scheduled out]

I agree that checking rq1 length is not proper in this case, and as you
rightly pointed out, we are in trouble here. 
nr_running()/num_online_cpus() would give more accurate picture here,
but it seemed costly. May be load balancer save us a bit here in not
running to such sort of cases. ( I agree load balancer is far too
complex).

