Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1APPSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:18:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1APPSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:18:11 -0500
Message-ID: <4D330C1F.1000600@redhat.com>
Date: Sun, 16 Jan 2011 17:17:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com
Subject: Re: [RFC -v5 PATCH 1/4] kvm: keep track of which task is running
 a KVM vcpu
References: <20110114030209.53765a0a@annuminas.surriel.com> <20110114030309.3d158404@annuminas.surriel.com>
In-Reply-To: <20110114030309.3d158404@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 10:03 AM, Rik van Riel wrote:
> Keep track of which task is running a KVM vcpu.  This helps us
> figure out later what task to wake up if we want to boost a
> vcpu that got preempted.
>
> Unfortunately there are no guarantees that the same task
> always keeps the same vcpu, so we can only track the task
> across a single "run" of the vcpu.
>
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5225052..65e997a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -185,6 +185,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>   	vcpu->cpu = -1;
>   	vcpu->kvm = kvm;
>   	vcpu->vcpu_id = id;
> +	vcpu->pid = 0;

NULL

> @@ -1456,6 +1459,12 @@ static long kvm_vcpu_ioctl(struct file *filp,
>   		r = -EINVAL;
>   		if (arg)
>   			goto out;
> +		if (unlikely(vcpu->pid != current->pids[PIDTYPE_PID].pid)) {
> +			/* The thread running this VCPU changed. */
> +			struct pid *oldpid = vcpu->pid;
> +			vcpu->pid = get_task_pid(current, PIDTYPE_PID);
> +			put_pid(oldpid);
> +		}

This is subject to the same race as before.  If another vcpu picks up 
vcpu->pid before the assignment (that is, oldpid), but dereferences it 
after put_pid(), it hits freed memory.

You want something like

     struct pid *oldpid = vcpu->pid;
     rcu_assign_pointer(vcpu->pid, get_task_pid());
     synchronize_rcu();
     put_pid(oldpid);

with rcu_read_lock() / rcu_dereference() protection on the reader side.

-- 
error compiling committee.c: too many arguments to function

