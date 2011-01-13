Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1AMNRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:17:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab1AMNRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:17:20 -0500
Message-ID: <4D2EFB44.2060906@redhat.com>
Date: Thu, 13 Jan 2011 15:16:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v4 PATCH 3/3] kvm: use yield_to instead of sleep in kvm_vcpu_on_spin
References: <20110113002108.3abdf953@annuminas.surriel.com> <20110113002745.51190252@annuminas.surriel.com>
In-Reply-To: <20110113002745.51190252@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 07:27 AM, Rik van Riel wrote:
> Instead of sleeping in kvm_vcpu_on_spin, which can cause gigantic
> slowdowns of certain workloads, we instead use yield_to to hand
> the rest of our timeslice to another vcpu in the same KVM guest.
>
>

> +	for (pass = 0; pass<  2&&  !yielded; pass++) {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			struct task_struct *task = vcpu->task;
> +			if (!pass&&  i<  last_boosted_vcpu) {
> +				i = last_boosted_vcpu;
> +				continue;
> +			} else if (pass&&  i>  last_boosted_vcpu)
> +				break;
> +			if (vcpu == me)
> +				continue;
> +			if (!task)
> +				continue;
> +			if (waitqueue_active(&vcpu->wq))
> +				continue;

Suppose the vcpu exits at this point, and its task terminates.

> +			if (task->flags&  PF_VCPU)
> +				continue;

Here you dereference freed memory.

> +			kvm->last_boosted_vcpu = i;
> +			yielded = 1;
> +			yield_to(task, 1);

And here you do unimaginable things to that freed memory.

I think the first patch needs some reference counting... I'd move it to 
the outermost KVM_RUN loop to reduce the performance impact.

> +			break;
> +		}
> +	}
>   }
>   EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);

-- 
error compiling committee.c: too many arguments to function

