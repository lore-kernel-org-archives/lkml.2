Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab0IEHTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 03:19:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0IEHS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 03:18:59 -0400
Message-ID: <4C83445B.4020103@redhat.com>
Date: Sun, 05 Sep 2010 10:18:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: don't sent IPI if the vcpu is not online
References: <4C807593.1050903@cn.fujitsu.com>
In-Reply-To: <4C807593.1050903@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/03/2010 07:12 AM, Xiao Guangrong wrote:
> It's no need sent IPI to the vcpu which is schedule out
>
>
> @@ -86,6 +86,7 @@ struct kvm_vcpu {
>   	unsigned long requests;
>   	unsigned long guest_debug;
>   	int srcu_idx;
> +	bool online;

Why not check for guest_mode instead?

>
>   	int fpu_active;
>   	int guest_fpu_loaded, guest_xcr0_loaded;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9a73b98..998cbc8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -148,8 +148,9 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>   	raw_spin_lock(&kvm->requests_lock);
>   	me = smp_processor_id();
>   	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (kvm_make_check_request(req, vcpu))
> +		if (kvm_make_check_request(req, vcpu) || !vcpu->online)
>   			continue;
> +
>   		cpu = vcpu->cpu;
>   		if (cpus != NULL&&  cpu != -1&&  cpu != me)
>   			cpumask_set_cpu(cpu, cpus);

btw, I think a more important optimization would be to drop 
kvm->requests_lock.  But I have no idea how to do it.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

