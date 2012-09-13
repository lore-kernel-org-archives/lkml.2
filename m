Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab2IMMNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837Ab2IMMNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:13:32 -0400
Message-ID: <5051CDDD.6040103@redhat.com>
Date: Thu, 13 Sep 2012 15:13:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE handler
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>  <500D2162.8010209@redhat.com>  <1347023509.10325.53.camel@oc6622382223.ibm.com>  <504A37B0.7020605@linux.vnet.ibm.com>  <1347046931.7332.51.camel@oc2024037011.ibm.com>  <20120908084345.GU30238@linux.vnet.ibm.com>  <1347283005.10325.55.camel@oc6622382223.ibm.com>  <1347293035.2124.22.camel@twins>  <20120910165653.GA28033@linux.vnet.ibm.com>  <1347297124.2124.42.camel@twins>  <1347307972.7332.78.camel@oc2024037011.ibm.com>  <504ED54E.6040608@linux.vnet.ibm.com> <1347388061.19098.20.camel@oc2024037011.ibm.com>
In-Reply-To: <1347388061.19098.20.camel@oc2024037011.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 09:27 PM, Andrew Theurer wrote:
> 
> So, having both is probably not a good idea.  However, I feel like
> there's more work to be done.  With no over-commit (10 VMs), total
> throughput is 23427 +/- 2.76%.  A 2x over-commit will no doubt have some
> overhead, but a reduction to ~4500 is still terrible.  By contrast,
> 8-way VMs with 2x over-commit have a total throughput roughly 10% less
> than 8-way VMs with no overcommit (20 vs 10 8-way VMs on 80 cpu-thread
> host).  We still have what appears to be scalability problems, but now
> it's not so much in runqueue locks for yield_to(), but now
> get_pid_task():
> 
> perf on host:
> 
> 32.10% 320131 qemu-system-x86 [kernel.kallsyms] [k] get_pid_task
> 11.60% 115686 qemu-system-x86 [kernel.kallsyms] [k] _raw_spin_lock
> 10.28% 102522 qemu-system-x86 [kernel.kallsyms] [k] yield_to
>  9.17%  91507 qemu-system-x86 [kvm]             [k] kvm_vcpu_on_spin
>  7.74%  77257 qemu-system-x86 [kvm]             [k] kvm_vcpu_yield_to
>  3.56%  35476 qemu-system-x86 [kernel.kallsyms] [k] __srcu_read_lock
>  3.00%  29951 qemu-system-x86 [kvm]             [k] __vcpu_run
>  2.93%  29268 qemu-system-x86 [kvm_intel]       [k] vmx_vcpu_run
>  2.88%  28783 qemu-system-x86 [kvm]             [k] vcpu_enter_guest
>  2.59%  25827 qemu-system-x86 [kernel.kallsyms] [k] __schedule
>  1.40%  13976 qemu-system-x86 [kernel.kallsyms] [k] _raw_spin_lock_irq
>  1.28%  12823 qemu-system-x86 [kernel.kallsyms] [k] resched_task
>  1.14%  11376 qemu-system-x86 [kvm_intel]       [k] vmcs_writel
>  0.85%   8502 qemu-system-x86 [kernel.kallsyms] [k] pick_next_task_fair
>  0.53%   5315 qemu-system-x86 [kernel.kallsyms] [k] native_write_msr_safe
>  0.46%   4553 qemu-system-x86 [kernel.kallsyms] [k] native_load_tr_desc
> 
> get_pid_task() uses some rcu fucntions, wondering how scalable this
> is....  I tend to think of rcu as -not- having issues like this... is
> there a rcu stat/tracing tool which would help identify potential
> problems?

It's not, it's the atomics + cache line bouncing.  We're basically
guaranteed to bounce here.

Here we're finally paying for the ioctl() based interface.  A syscall
based interface would have a 1:1 correspondence between vcpus and tasks,
so these games would be unnecessary.

-- 
error compiling committee.c: too many arguments to function
