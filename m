Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1JXKPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:15:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab1JXKPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:15:18 -0400
Message-ID: <4EA53A7D.300@redhat.com>
Date: Mon, 24 Oct 2011 12:14:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen <xen-devel@lists.xensource.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 3/5] kvm hypervisor : Add two hypercalls to support
 pv-ticketlock
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2011 09:05 PM, Raghavendra K T wrote:
> Add two hypercalls to KVM hypervisor to support pv-ticketlocks.
>     
> KVM_HC_WAIT_FOR_KICK blocks the calling vcpu until another vcpu kicks it or it
> is woken up because of an event like interrupt.
>    
> KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu.
>     
> The presence of these hypercalls is indicated to guest via
> KVM_FEATURE_WAIT_FOR_KICK/KVM_CAP_WAIT_FOR_KICK.
>
> Qemu needs a corresponding patch to pass up the presence of this feature to 
> guest via cpuid. Patch to qemu will be sent separately.
>
> There is no Xen/KVM hypercall interface to await kick from.
>     
>  
> +/*
> + * kvm_pv_wait_for_kick_op : Block until kicked by either a KVM_HC_KICK_CPU
> + * hypercall or a event like interrupt.
> + *
> + * @vcpu : vcpu which is blocking.
> + */
> +static void kvm_pv_wait_for_kick_op(struct kvm_vcpu *vcpu)
> +{
> +	DEFINE_WAIT(wait);
> +
> +	/*
> +	 * Blocking on vcpu->wq allows us to wake up sooner if required to
> +	 * service pending events (like interrupts).
> +	 *
> +	 * Also set state to TASK_INTERRUPTIBLE before checking vcpu->kicked to
> +	 * avoid racing with kvm_pv_kick_cpu_op().
> +	 */
> +	prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
> +
> +	/*
> +	 * Somebody has already tried kicking us. Acknowledge that
> +	 * and terminate the wait.
> +	 */
> +	if (vcpu->kicked) {
> +		vcpu->kicked = 0;
> +		goto end_wait;
> +	}
> +
> +	/* Let's wait for either KVM_HC_KICK_CPU or someother event
> +	 * to wake us up.
> +	 */
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> +	schedule();
> +	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
> +end_wait:
> +	finish_wait(&vcpu->wq, &wait);
> +}

This hypercall can be replaced by a HLT instruction, no?

I'm pretty sure this misses a lot of stuff from kvm_vcpu_block().

> +
> +/*
> + * kvm_pv_kick_cpu_op:  Kick a vcpu.
> + *
> + * @cpu - vcpu to be kicked.
> + */
> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int cpu)
> +{
> +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
> +

Is the vcpu number meaningful?  We should reuse an existing identifier
like the APIC ID.

> +	if (vcpu) {
> +		vcpu->kicked = 1;

Need to use smp memory barriers here.

> +		wake_up_interruptible(&vcpu->wq);
> +	}
> +}
> +
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long nr, a0, a1, a2, a3, ret;
>

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

