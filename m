Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab1CZOrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 10:47:41 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:36625 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1CZOrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 10:47:40 -0400
Date: Sat, 26 Mar 2011 15:47:29 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCHv2] fix regression caused by
	e48672fa25e879f7ae21785c7efd187738139593
Message-ID: <20110326144729.GA29447@nik-comp.lan>
References: <20110307101827.GA1762@pcnci.linuxbox.cz> <4D768A62.3050903@redhat.com> <20110309193003.GB1762@pcnci.linuxbox.cz> <4D77F149.8020906@redhat.com> <20110309223651.GC1762@pcnci.linuxbox.cz> <4D8C503D.6000607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8C503D.6000607@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4864671 records (last update: 20110326)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So something bothers me still about this bug.  What you did correctly  
> restores the old behavior - but it shouldn't be fixing a bug.
>
> The only reason you need to schedule an update for the KVM clock area is  
> if a new VCPU has been created, you have an unstable TSC.. or something  
> changes the VM's kvmclock offset.
>
> So this change could in fact be hiding an underlying bug - either an  
> unstable TSC is not being properly reported, the KVM clock offset is  
> being changed, we are missing a KVM clock update for secondary VCPUs -  
> or something else we don't yet understand is going on.
>
> Nikola, can you try the patch below, which reverts your change and  
> attempts to fix other possible sources of the problem, and see if it  
> still reproduces?
with Your patch, 32b SMP guests boot fine as well, without it, they
don't, so if You consider this better fix, I can acknowledge it as
working :)
n.

>
> Thanks,
>
> Zach

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 58f517b..42618fb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2127,8 +2127,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		if (check_tsc_unstable()) {
>  			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
>  			vcpu->arch.tsc_catchup = 1;
> +			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  		}
> -		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> +		if (vcpu->cpu == -1)
> +			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  		if (vcpu->cpu != cpu)
>  			kvm_migrate_timers(vcpu);
>  		vcpu->cpu = cpu;
> @@ -3534,6 +3536,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		struct kvm_clock_data user_ns;
>  		u64 now_ns;
>  		s64 delta;
> +		struct kvm_vcpu *vcpu;
> +		int i;
>  
>  		r = -EFAULT;
>  		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
> @@ -3549,6 +3553,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		delta = user_ns.clock - now_ns;
>  		local_irq_enable();
>  		kvm->arch.kvmclock_offset = delta;
> +		kvm_for_each_vcpu(i, vcpu, kvm)
> +			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  		break;
>  	}
>  	case KVM_GET_CLOCK: {


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
