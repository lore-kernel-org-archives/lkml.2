Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1AZNCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:02:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab1AZNCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:02:07 -0500
Message-ID: <4D401B39.4040109@redhat.com>
Date: Wed, 26 Jan 2011 15:01:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [RFC -v6 PATCH 7/8] kvm: keep track of which task is running
 a KVM vcpu
References: <20110120163127.2568f4fe@annuminas.surriel.com> <20110120163632.021c3f37@annuminas.surriel.com>
In-Reply-To: <20110120163632.021c3f37@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 11:36 PM, Rik van Riel wrote:
> Keep track of which task is running a KVM vcpu.  This helps us
> figure out later what task to wake up if we want to boost a
> vcpu that got preempted.
>
> Unfortunately there are no guarantees that the same task
> always keeps the same vcpu, so we can only track the task
> across a single "run" of the vcpu.
>
> Signed-off-by: Rik van Riel<riel@redhat.com>
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a055742..9d56ed5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -81,6 +81,7 @@ struct kvm_vcpu {
>   #endif
>   	int vcpu_id;
>   	struct mutex mutex;
> +	struct pid *pid;
>   	int   cpu;
>   	atomic_t guest_mode;
>   	struct kvm_run *run;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5225052..86c4905 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -185,6 +185,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>   	vcpu->cpu = -1;
>   	vcpu->kvm = kvm;
>   	vcpu->vcpu_id = id;
> +	vcpu->pid = NULL;
>   	init_waitqueue_head(&vcpu->wq);
>
>   	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> @@ -208,6 +209,8 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_init);
>
>   void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
>   {
> +	if (vcpu->pid)
> +		put_pid(vcpu->pid);

Unconditional put_pid() suffices.

>   	kvm_arch_vcpu_uninit(vcpu);
>   	free_page((unsigned long)vcpu->run);
>   }
> @@ -1456,6 +1459,14 @@ static long kvm_vcpu_ioctl(struct file *filp,
>   		r = -EINVAL;
>   		if (arg)
>   			goto out;
> +		if (unlikely(vcpu->pid != current->pids[PIDTYPE_PID].pid)) {
> +			/* The thread running this VCPU changed. */
> +			struct pid *oldpid = vcpu->pid;
> +			struct pid *newpid = get_task_pid(current, PIDTYPE_PID);
> +			rcu_assign_pointer(vcpu->pid, newpid);
> +			synchronize_rcu();
> +			put_pid(oldpid);
> +		}

This is executed without any lock held, so two concurrent KVM_RUNs can 
race and cause a double put_pid().

Suggest moving the code to vcpu_load(), where it can execute under the 
protection of vcpu->mutex.

-- 
error compiling committee.c: too many arguments to function

