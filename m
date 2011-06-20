Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1FTU5C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:57:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab1FTU47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:56:59 -0400
Date: Mon, 20 Jun 2011 17:56:19 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v2 3/7] KVM-HV: KVM Steal time implementation
Message-ID: <20110620205619.GA3971@amt.cnet>
References: <1308262856-5779-1-git-send-email-glommer@redhat.com>
 <1308262856-5779-4-git-send-email-glommer@redhat.com>
 <4DFDC821.2090905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFDC821.2090905@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 12:57:53PM +0300, Avi Kivity wrote:
> On 06/17/2011 01:20 AM, Glauber Costa wrote:
> >To implement steal time, we need the hypervisor to pass the guest information
> >about how much time was spent running other processes outside the VM.
> >This is per-vcpu, and using the kvmclock structure for that is an abuse
> >we decided not to make.
> >
> >In this patchset, I am introducing a new msr, KVM_MSR_STEAL_TIME, that
> >holds the memory area address containing information about steal time
> >
> >This patch contains the hypervisor part for it. I am keeping it separate from
> >the headers to facilitate backports to people who wants to backport the kernel
> >part but not the hypervisor, or the other way around.
> >
> >
> >
> >+#define KVM_STEAL_ALIGNMENT_BITS 5
> >+#define KVM_STEAL_VALID_BITS ((-1ULL<<  (KVM_STEAL_ALIGNMENT_BITS + 1)))
> >+#define KVM_STEAL_RESERVED_MASK (((1<<  KVM_STEAL_ALIGNMENT_BITS) - 1 )<<  1)
> 
> Clumsy, but okay.
> 
> >+static void record_steal_time(struct kvm_vcpu *vcpu)
> >+{
> >+	u64 delta;
> >+
> >+	if (vcpu->arch.st.stime&&  vcpu->arch.st.this_time_out) {
> 
> 0 is a valid value for stime.
> 
> >+
> >+		if (unlikely(kvm_read_guest(vcpu->kvm, vcpu->arch.st.stime,
> >+			&vcpu->arch.st.steal, sizeof(struct kvm_steal_time)))) {
> >+
> >+			vcpu->arch.st.stime = 0;
> >+			return;
> >+		}
> >+
> >+		delta = (get_kernel_ns() - vcpu->arch.st.this_time_out);
> >+
> >+		vcpu->arch.st.steal.steal += delta;
> >+		vcpu->arch.st.steal.version += 2;
> >+
> >+		if (unlikely(kvm_write_guest(vcpu->kvm, vcpu->arch.st.stime,
> >+			&vcpu->arch.st.steal, sizeof(struct kvm_steal_time)))) {
> >+
> >+			vcpu->arch.st.stime = 0;
> >+			return;
> >+		}
> >+	}
> >+
> >+}
> >+
> >
> >@@ -2158,6 +2206,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  			kvm_migrate_timers(vcpu);
> >  		vcpu->cpu = cpu;
> >  	}
> >+
> >+	record_steal_time(vcpu);
> >  }
> 
> This records time spent in userspace in the vcpu thread as steal
> time.  Is this what we want?  Or just time preempted away?

It also accounts halt time (kvm_vcpu_block) as steal time. Glauber, you
could instead use the "runnable-state-but-waiting-in-runqueue" field of
SCHEDSTATS, i forgot the exact name.

