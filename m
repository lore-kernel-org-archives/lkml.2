Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2BGTKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:10:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab2BGTJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:09:58 -0500
Date: Tue, 7 Feb 2012 16:59:03 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 V11] Add ioctl for KVMCLOCK_GUEST_STOPPED
Message-ID: <20120207185903.GB19800@amt.cnet>
References: <1328024132-7687-1-git-send-email-emunson@mgebm.net>
 <1328024132-7687-4-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328024132-7687-4-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 10:35:31AM -0500, Eric B Munson wrote:
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
> Cc: kvm@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> Changes from V10:
>  Return the ioctl to per vcpu instead of per vm
> Changes from V9:
>  Use kvm_for_each_vcpu to iterate online vcpu's
> Changes from V8:
>  Make KVM_GUEST_PAUSED a per vm ioctl instead of per vcpu
> Changes from V7:
>  Define KVM_CAP_GUEST_PAUSED and support check
>  Call mark_page_dirty () after setting PVCLOCK_GUEST_STOPPED
> Changes from V4:
>  Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
>  Add new ioctl description to api.txt
> 
>  Documentation/virtual/kvm/api.txt |   13 +++++++++++++
>  arch/x86/kvm/x86.c                |   21 +++++++++++++++++++++
>  include/linux/kvm.h               |    3 +++
>  3 files changed, 37 insertions(+), 0 deletions(-)
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

typo: Architectures.


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
> index 14d6cad..c9cabba 100644
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
> @@ -2503,6 +2504,22 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> +/*
> + * kvm_set_guest_paused() indicates to the guest kernel that it has been
> + * stopped by the hypervisor.  This function will be called from the host only.
> + * EINVAL is returned when the host attempts to set the flag for a guest that
> + * does not support pv clocks.
> + */
> +static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
> +{
> +	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
> +	if (!vcpu->arch.time_page)
> +		return -EINVAL;
> +	src->flags |= PVCLOCK_GUEST_STOPPED;
> +	mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
> +	return 0;
> +}

It should also call kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu), so
that the hv_clock is written to guest memory as soon as possible.

Please fix the comments and rebase as soon as possible, it is annoying 
that this feature is taking so long to be integrated.

Thanks

