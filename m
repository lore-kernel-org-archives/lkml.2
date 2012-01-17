Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2AQSWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:22:36 -0500
Received: from david.siemens.de ([192.35.17.14]:26542 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab2AQSWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:22:31 -0500
Message-ID: <4F15BBE3.4090800@siemens.com>
Date: Tue, 17 Jan 2012 19:20:19 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 V9] Add ioctl for KVMCLOCK_GUEST_STOPPED
References: <1326823488-11413-1-git-send-email-emunson@mgebm.net> <1326823488-11413-4-git-send-email-emunson@mgebm.net>
In-Reply-To: <1326823488-11413-4-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-17 19:04, Eric B Munson wrote:
> Now that we have a flag that will tell the guest it was suspended, create an
> interface for that communication using a KVM ioctl.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> 
> Cc: mingo@redhat.com
> Cc: hpa@zytor.com
> Cc: ryanh@linux.vnet.ibm.com
> Cc: aliguori@us.ibm.com
> Cc: mtosatti@redhat.com
> Cc: jeremy.fitzhardinge@citrix.com
> Cc: kvm@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> Changes from V8:
>  Make KVM_GUEST_PAUSED a per vm ioctl instead of per vcpu
> 
> Changes from V7:
>  Define KVM_CAP_GUEST_PAUSED and support check
>  Call mark_page_dirty () after setting PVCLOCK_GUEST_STOPPED
> 
> Changes from V4:
>  Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
>  Add new ioctl description to api.txt
> 
>  Documentation/virtual/kvm/api.txt |   13 +++++++++++++
>  arch/x86/kvm/x86.c                |   26 ++++++++++++++++++++++++++
>  include/linux/kvm.h               |    3 +++
>  3 files changed, 42 insertions(+), 0 deletions(-)
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
>  Application code obtains a pointer to the kvm_run structure by
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 14d6cad..4661abe 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2056,6 +2056,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_X86_ROBUST_SINGLESTEP:
>  	case KVM_CAP_XSAVE:
>  	case KVM_CAP_ASYNC_PF:
> +	case KVM_CAP_GUEST_PAUSED:
>  	case KVM_CAP_GET_TSC_KHZ:
>  		r = 1;
>  		break;
> @@ -3061,6 +3062,27 @@ out:
>  	return r;
>  }
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
> +	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++) {
> +		vcpu = kvm->vcpus[i];

kvm_for_each_vcpu?

> +		if (!vcpu->arch.time_page)
> +			continue;
> +		src = &vcpu->arch.hv_clock;
> +		src->flags |= PVCLOCK_GUEST_STOPPED;
> +		mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
> +	}
> +	return 0;
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> @@ -3351,6 +3373,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
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

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
