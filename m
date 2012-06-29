Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab2F2J0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:26:00 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39205 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2F2JZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:25:58 -0400
X-AuditID: b753bd60-a3089ba000000655-7d-4fed74a4d1b7
X-AuditID: b753bd60-a3089ba000000655-7d-4fed74a4d1b7
Message-ID: <4FED74AA.7020709@hitachi.com>
Date: Fri, 29 Jun 2012 18:26:02 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, mtosatti@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 06/18] KVM: Add facility to run guests on slave CPUs
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <20120628060751.19298.39801.stgit@localhost.localdomain> <4FEC8E22.4000208@redhat.com>
In-Reply-To: <4FEC8E22.4000208@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/06/29 2:02, Avi Kivity wrote:
> On 06/28/2012 09:07 AM, Tomoki Sekiyama wrote:
>> Add path to migrate execution of vcpu_enter_guest to a slave CPU when
>> vcpu->arch.slave_cpu is set.
>>
>> After moving to the slave CPU, it goes back to the online CPU when the
>> guest is exited by reasons that cannot be handled by the slave CPU only
>> (e.g. handling async page faults).
> 
> What about, say, instruction emulation?  It may need to touch guest
> memory, which cannot be done from interrupt disabled context.

Hmm, it seems difficult to resolve this in interrupt disabled context.

Within partitioning scenario, it might be possible to give up execution
if the memory is not pinned down, but I'm not sure that is acceptable.

It looks better to make the slave core interruptible and sleepable.

>> +
>> +static  int vcpu_post_run(struct kvm_vcpu *vcpu, struct task_struct *task,
>> +			 int *can_complete_async_pf)
>> +{
>> +	int r = LOOP_ONLINE;
>> +
>> +	clear_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
>> +	if (kvm_cpu_has_pending_timer(vcpu))
>> +		kvm_inject_pending_timer_irqs(vcpu);
>> +
>> +	if (dm_request_for_irq_injection(vcpu)) {
>> +		r = -EINTR;
>> +		vcpu->run->exit_reason = KVM_EXIT_INTR;
>> +		++vcpu->stat.request_irq_exits;
>> +	}
>> +
>> +	if (can_complete_async_pf) {
>> +		*can_complete_async_pf = kvm_can_complete_async_pf(vcpu);
>> +		if (r == LOOP_ONLINE)
>> +			r = *can_complete_async_pf ? LOOP_APF : LOOP_SLAVE;
>> +	} else
>> +		kvm_check_async_pf_completion(vcpu);
>> +
>> +	if (signal_pending(task)) {
>> +		r = -EINTR;
>> +		vcpu->run->exit_reason = KVM_EXIT_INTR;
>> +		++vcpu->stat.signal_exits;
>> +	}
> 
> Isn't this racy?  The signal can come right after this.

Oops, this is racy here.
However, this is resolved if later patch [RFC PATCH 16/18] is applied.
I will reorder patches.

Signals will wake up vCPU user thread (sleeping in
vcpu_enter_guest_slave > wait_for_completion_interruptible in an online CPU)
and the thread kicks vcpu(by NMI). Then, kvm_arch_vcpu_prevent_run is
called in NMI handler to fail the VM enter again.

(But kvm_arch_vcpu_prevent_run still has another problem, as you replied.)

Thanks,
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

