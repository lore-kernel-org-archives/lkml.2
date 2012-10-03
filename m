Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965068Ab2JCRGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:06:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933093Ab2JCRG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:06:27 -0400
Message-ID: <506C7057.6000102@redhat.com>
Date: Wed, 03 Oct 2012 19:05:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
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
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com>
In-Reply-To: <20121003122209.GA9076@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 02:22 PM, Raghavendra K T wrote:
>> So I think it's worth trying again with ple_window of 20000-40000.
>> 
> 
> Hi Avi,
> 
> I ran different benchmarks increasing ple_window, and results does not
> seem to be encouraging for increasing ple_window.

Thanks for testing! Comments below.

> Results:
> 16 core PLE machine with 16 vcpu guest. 
> 
> base kernel = 3.6-rc5 + ple handler optimization patch 
> base_pleopt_8k = base kernel + ple window = 8k
> base_pleopt_16k = base kernel + ple window = 16k
> base_pleopt_32k = base kernel + ple window = 32k
> 
> 
> Percentage improvements of benchmarks w.r.t base_pleopt with ple_window = 4096
> 
> 		base_pleopt_8k	base_pleopt_16k	base_pleopt_32k
> -----------------------------------------------------------------			
> kernbench_1x	-5.54915	-15.94529	-44.31562
> kernbench_2x	-7.89399	-17.75039	-37.73498

So, 44% degradation even with no overcommit?  That's surprising.

> I also got perf top output to analyse the difference. Difference comes
> because of flushtlb (and also spinlock).

That's in the guest, yes?

> 
> Ebizzy run for 4k ple_window
> -  87.20%  [kernel]  [k] arch_local_irq_restore
>    - arch_local_irq_restore
>       - 100.00% _raw_spin_unlock_irqrestore
>          + 52.89% release_pages
>          + 47.10% pagevec_lru_move_fn
> -   5.71%  [kernel]  [k] arch_local_irq_restore
>    - arch_local_irq_restore
>       + 86.03% default_send_IPI_mask_allbutself_phys
>       + 13.96% default_send_IPI_mask_sequence_phys
> -   3.10%  [kernel]  [k] smp_call_function_many
>      smp_call_function_many
> 
> 
> Ebizzy run for 32k ple_window
> 
> -  91.40%  [kernel]  [k] arch_local_irq_restore
>    - arch_local_irq_restore
>       - 100.00% _raw_spin_unlock_irqrestore
>          + 53.13% release_pages
>          + 46.86% pagevec_lru_move_fn
> -   4.38%  [kernel]  [k] smp_call_function_many
>      smp_call_function_many
> -   2.51%  [kernel]  [k] arch_local_irq_restore
>    - arch_local_irq_restore
>       + 90.76% default_send_IPI_mask_allbutself_phys
>       + 9.24% default_send_IPI_mask_sequence_phys
> 

Both the 4k and the 32k results are crazy.  Why is
arch_local_irq_restore() so prominent?  Do you have a very high
interrupt rate in the guest?




-- 
error compiling committee.c: too many arguments to function
