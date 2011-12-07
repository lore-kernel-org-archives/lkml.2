Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab1LGMeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:34:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab1LGMes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:34:48 -0500
Date: Wed, 7 Dec 2011 10:33:30 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Raghavendra K T <raghukt@linux.vnet.ibm.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>, Xen <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V3 2/4] kvm hypervisor : Add a hypercall to KVM
 hypervisor to support pv-ticketlocks
Message-ID: <20111207123330.GA32212@amt.cnet>
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com>
 <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com>
 <20111207104849.GA24849@amt.cnet>
 <4EDF5413.1030107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDF5413.1030107@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 05:24:59PM +0530, Raghavendra K T wrote:
> On 12/07/2011 04:18 PM, Marcelo Tosatti wrote:
> >On Wed, Nov 30, 2011 at 02:29:59PM +0530, Raghavendra K T wrote:
> >>
> >>+/*
> >>+ * kvm_pv_kick_cpu_op:  Kick a vcpu.
> >>+ *
> >>+ * @cpu - vcpu to be kicked.
> >>+ */
> >>+static void kvm_pv_kick_cpu_op(struct kvm *kvm, int cpu)
> >>+{
> >>+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
> >>+	struct kvm_mp_state mp_state;
> >>+
> >>+	mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
> >
> >Since vcpu->mp_state is not protected by a lock, this is potentially racy. For example:
> >
> >CPU0						CPU1
> >kvm_pv_kick_cpu_op				running vcpuN
> >vcpuN->mp_state = KVM_MP_STATE_RUNNABLE;
> >						kvm_emulate_halt
> >						vcpuN->mp_state = KVM_MP_STATE_HALTED
> >
> >Is it harmless to lose a kick?
> >
> 
> Yes you are right. It was potentially racy and it was harmful too!.
> I had observed that it was stalling the CPU before I introduced
> kicked flag.
> 
> But now,
> 
> vcpu->kicked = 1  ==> kvm_make_request(KVM_REQ_UNHALT, vcpu); ==>

Ok, please use a more descriptive name, such as "pvlock_kicked" or
something.

> 
> __vcpu_run() ==> kvm_check_request(KVM_REQ_UNHALT, vcpu) ==>
> 
> vcpuN->mp_state = KVM_MP_STATE_RUNNABLE; so eventually we will end up
> in RUNNABLE.
> 
> Also Avi pointed that, logically kvm_arch_vcpu_ioctl_set_mpstate should
> be called only in vcpu thread, so after further debugging, I noticed
> that,  setting vcpuN->mp_state = KVM_MP_STATE_RUNNABLE; is not
> necessary.
> I 'll remove that in the next patch. Thanks for pointing.

In fact you don't need kvm_arch_vcpu_ioctl_set_mpstate either, only the
new "kicked" flag.

> 
> 
> 			
