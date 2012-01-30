Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2A3PHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:07:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab2A3PHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:07:41 -0500
Message-ID: <4F26B220.9050101@redhat.com>
Date: Mon, 30 Jan 2012 17:07:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 V10] Add ioctl for KVMCLOCK_GUEST_STOPPED
References: <1326825641-15765-1-git-send-email-emunson@mgebm.net> <1326825641-15765-4-git-send-email-emunson@mgebm.net>
In-Reply-To: <1326825641-15765-4-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 08:40 PM, Eric B Munson wrote:
> Now that we have a flag that will tell the guest it was suspended, create an
> interface for that communication using a KVM ioctl.
>
>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index e1d94bf..1931e5c 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1491,6 +1491,19 @@ following algorithm:
>  Some guests configure the LINT1 NMI input to cause a panic, aiding in
>  debugging.
>  
> +4.65 KVMCLOCK_GUEST_PAUSED
> +
> +Capability: KVM_CAP_GUEST_PAUSED
> +Architechtures: Any that implement pvclocks (currently x86 only)
> +Type: vcpu ioctl

vm ioctl.

> +Parameters: None
> +Returns: 0 on success, -1 on error
> +
> +This signals to the host kernel that the specified guest is being paused by
> +userspace.  The host will set a flag in the pvclock structure that is checked
> +from the soft lockup watchdog.  This ioctl can be called during pause or
> +unpause.
> +
>  5. The kvm_run structure
>  
>  
> +/*
> + * kvm_set_guest_paused() indicates to the guest kernel that it has been
> + * stopped by the hypervisor.  This function will be called from the host only.
> + */
> +static int kvm_set_guest_paused(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct pvclock_vcpu_time_info *src;
> +	int i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!vcpu->arch.time_page)
> +			continue;
> +		src = &vcpu->arch.hv_clock;
> +		src->flags |= PVCLOCK_GUEST_STOPPED;

This looks racy.  The vcpu can remove its kvmclock concurrently with
this access, and src will be NULL.

Can you point me to the discussion that moved this to be a vm ioctl?  In
general vm ioctls that do things for all vcpus are racy, like here. 
You're accessing variables that are protected by the vcpu mutex, and not
taking the mutex (nor can you, since it is held while the guest is
running, unlike most kernel mutexes).

> +		mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
> +	}
> +	return 0;
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> @@ -3351,6 +3372,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		r = 0;
>  		break;
>  	}
> +	case KVMCLOCK_GUEST_PAUSED: {
> +		r = kvm_set_guest_paused(kvm);
> +		break;
> +	}
>  
>  	default:
>  		;
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 68e67e5..4ffe0df 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -558,6 +558,7 @@ struct kvm_ppc_pvinfo {
>  #define KVM_CAP_PPC_PAPR 68
>  #define KVM_CAP_S390_GMAP 71
>  #define KVM_CAP_TSC_DEADLINE_TIMER 72
> +#define KVM_CAP_GUEST_PAUSED 73
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -763,6 +764,8 @@ struct kvm_clock_data {
>  #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
>  /* Available with KVM_CAP_RMA */
>  #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
> +/* VM is being stopped by host */
> +#define KVMCLOCK_GUEST_PAUSED	  _IO(KVMIO,   0xaa)
>  
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  


-- 
error compiling committee.c: too many arguments to function

