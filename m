Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1AEJzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:55:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab1AEJzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:55:02 -0500
Message-ID: <4D243FEF.6090105@redhat.com>
Date: Wed, 05 Jan 2011 11:54:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: make make_all_cpus_request() lockless
References: <4D243B95.3070203@cn.fujitsu.com> <4D243C7B.8060205@cn.fujitsu.com>
In-Reply-To: <4D243C7B.8060205@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 11:40 AM, Xiao Guangrong wrote:
> Now, we have 'vcpu->guest_mode' to judge whether need to send
> ipi to other cpus, this way is very exact, so checking request
> bit is needless, then we can drop the spinlock let it's collateral

Clever.

> @@ -147,11 +147,9 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>
>   	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
>
> -	raw_spin_lock(&kvm->requests_lock);
> -	me = smp_processor_id();
> +	me = get_cpu();
>   	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (kvm_make_check_request(req, vcpu))
> -			continue;
> +		kvm_make_request(req, vcpu);
>   		cpu = vcpu->cpu;
>   		if (cpus != NULL&&  cpu != -1&&  cpu != me&&
>   		atomic_read(&vcpu->guest_mode))
> @@ -163,7 +161,7 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>   		smp_call_function_many(cpus, ack_flush, NULL, 1);
>   	else
>   		called = false;
> -	raw_spin_unlock(&kvm->requests_lock);
> +	put_cpu();
>   	free_cpumask_var(cpus);
>   	return called;
>   }

Maybe we can drop 'cpu != me' and then we don't need to disable preemption?

Can be done in a later patch.

Anyway, I really like this, requests_lock is an ugly wart.

-- 
error compiling committee.c: too many arguments to function

