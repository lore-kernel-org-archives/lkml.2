Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab2IUNCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:02:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab2IUNCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:02:33 -0400
Message-ID: <505C654B.2050106@redhat.com>
Date: Fri, 21 Sep 2012 09:02:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
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
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue>
In-Reply-To: <20120921120000.27611.71321.sendpatchset@codeblue>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 08:00 AM, Raghavendra K T wrote:
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>
> When total number of VCPUs of system is less than or equal to physical CPUs,
> PLE exits become costly since each VCPU can have dedicated PCPU, and
> trying to find a target VCPU to yield_to just burns time in PLE handler.
>
> This patch reduces overhead, by simply doing a return in such scenarios by
> checking the length of current cpu runqueue.

I am not convinced this is the way to go.

The VCPU that is holding the lock, and is not releasing it,
probably got scheduled out. That implies that VCPU is on a
runqueue with at least one other task.

> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1629,6 +1629,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>   	int pass;
>   	int i;
>
> +	if (unlikely(rq_nr_running() == 1))
> +		return;
> +
>   	kvm_vcpu_set_in_spin_loop(me, true);
>   	/*
>   	 * We boost the priority of a VCPU that is runnable but not
>


-- 
All rights reversed
