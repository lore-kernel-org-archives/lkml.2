Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab1CYIUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:20:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab1CYIU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:20:28 -0400
Message-ID: <4D8C503D.6000607@redhat.com>
Date: Fri, 25 Mar 2011 04:20:13 -0400
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCHv2] fix regression caused by	e48672fa25e879f7ae21785c7efd187738139593
References: <20110307101827.GA1762@pcnci.linuxbox.cz> <4D768A62.3050903@redhat.com> <20110309193003.GB1762@pcnci.linuxbox.cz> <4D77F149.8020906@redhat.com> <20110309223651.GC1762@pcnci.linuxbox.cz>
In-Reply-To: <20110309223651.GC1762@pcnci.linuxbox.cz>
Content-Type: multipart/mixed;
 boundary="------------090006070200090102020603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090006070200090102020603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/09/2011 05:36 PM, Nikola Ciprich wrote:
> commit 387b9f97750444728962b236987fbe8ee8cc4f8c moved kvm_request_guest_time_update(vcpu),
> breaking 32bit SMP guests using kvm-clock. Fix this by moving (new) clock update function
> to proper place.
>
> Signed-off-by: Nikola Ciprich<nikola.ciprich@linuxbox.cz>
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4c27144..ba3f76f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2101,8 +2101,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   		if (check_tsc_unstable()) {
>   			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
>   			vcpu->arch.tsc_catchup = 1;
> -			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>   		}
> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>   		if (vcpu->cpu != cpu)
>   			kvm_migrate_timers(vcpu);
>   		vcpu->cpu = cpu;
>
>    


So something bothers me still about this bug.  What you did correctly 
restores the old behavior - but it shouldn't be fixing a bug.

The only reason you need to schedule an update for the KVM clock area is 
if a new VCPU has been created, you have an unstable TSC.. or something 
changes the VM's kvmclock offset.

So this change could in fact be hiding an underlying bug - either an 
unstable TSC is not being properly reported, the KVM clock offset is 
being changed, we are missing a KVM clock update for secondary VCPUs - 
or something else we don't yet understand is going on.

Nikola, can you try the patch below, which reverts your change and 
attempts to fix other possible sources of the problem, and see if it 
still reproduces?

Thanks,

Zach

--------------090006070200090102020603
Content-Type: text/plain;
 name="kvm-regres-test.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kvm-regres-test.patch"

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58f517b..42618fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2127,8 +2127,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (check_tsc_unstable()) {
 			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
 			vcpu->arch.tsc_catchup = 1;
+			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		}
-		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+		if (vcpu->cpu == -1)
+			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		if (vcpu->cpu != cpu)
 			kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;
@@ -3534,6 +3536,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		struct kvm_clock_data user_ns;
 		u64 now_ns;
 		s64 delta;
+		struct kvm_vcpu *vcpu;
+		int i;
 
 		r = -EFAULT;
 		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
@@ -3549,6 +3553,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		delta = user_ns.clock - now_ns;
 		local_irq_enable();
 		kvm->arch.kvmclock_offset = delta;
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		break;
 	}
 	case KVM_GET_CLOCK: {

--------------090006070200090102020603--
