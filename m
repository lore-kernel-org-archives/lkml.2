Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab2F1RCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:02:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab2F1RCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:02:40 -0400
Message-ID: <4FEC8E22.4000208@redhat.com>
Date: Thu, 28 Jun 2012 20:02:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 06/18] KVM: Add facility to run guests on slave CPUs
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <20120628060751.19298.39801.stgit@localhost.localdomain>
In-Reply-To: <20120628060751.19298.39801.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 09:07 AM, Tomoki Sekiyama wrote:
> Add path to migrate execution of vcpu_enter_guest to a slave CPU when
> vcpu->arch.slave_cpu is set.
> 
> After moving to the slave CPU, it goes back to the online CPU when the
> guest is exited by reasons that cannot be handled by the slave CPU only
> (e.g. handling async page faults).

What about, say, instruction emulation?  It may need to touch guest
memory, which cannot be done from interrupt disabled context.

> +
> +static int vcpu_post_run(struct kvm_vcpu *vcpu, struct task_struct *task,
> +			 int *can_complete_async_pf)
> +{
> +	int r = LOOP_ONLINE;
> +
> +	clear_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
> +	if (kvm_cpu_has_pending_timer(vcpu))
> +		kvm_inject_pending_timer_irqs(vcpu);
> +
> +	if (dm_request_for_irq_injection(vcpu)) {
> +		r = -EINTR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTR;
> +		++vcpu->stat.request_irq_exits;
> +	}
> +
> +	if (can_complete_async_pf) {
> +		*can_complete_async_pf = kvm_can_complete_async_pf(vcpu);
> +		if (r == LOOP_ONLINE)
> +			r = *can_complete_async_pf ? LOOP_APF : LOOP_SLAVE;
> +	} else
> +		kvm_check_async_pf_completion(vcpu);
> +
> +	if (signal_pending(task)) {
> +		r = -EINTR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTR;
> +		++vcpu->stat.signal_exits;
> +	}

Isn't this racy?  The signal can come right after this.

-- 
error compiling committee.c: too many arguments to function


