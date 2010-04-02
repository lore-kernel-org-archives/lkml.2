Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0DBQAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:00:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab0DBQAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:00:30 -0400
Date: Fri, 2 Apr 2010 11:59:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Neil Horman <nhorman@tuxdriver.com>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/2] x86/amd-iommu: enable iommu before attaching
	devices
Message-ID: <20100402155932.GA3516@redhat.com>
References: <m1sk7guv5u.fsf@fess.ebiederm.org> <20100331202745.GE13406@hmsreliant.think-freely.org> <20100401142902.GF24846@8bytes.org> <20100401144736.GA14069@shamino.rdu.redhat.com> <20100401155643.GG24846@8bytes.org> <20100401171149.GH13603@shamino.rdu.redhat.com> <20100401201433.GK24846@8bytes.org> <20100402000012.GA8930@hmsreliant.think-freely.org> <20100402003034.GX29241@sequoia.sous-sol.org> <20100402012353.GY29241@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402012353.GY29241@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 06:23:53PM -0700, Chris Wright wrote:
> Hit another kdump problem as reported by Neil Horman.  When initializaing
> the IOMMU, we attach devices to their domains before the IOMMU is
> fully (re)initialized.  Attaching a device will issue some important
> invalidations.  In the context of the newly kexec'd kdump kernel, the
> IOMMU may have stale cached data from the original kernel.  Because we
> do the attach too early, the invalidation commands are placed in the new
> command buffer before the IOMMU is updated w/ that buffer.  This leaves
> the stale entries in the kdump context and can renders device unusable.
> Simply enable the IOMMU before we do the attach.
> 
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  arch/x86/kernel/amd_iommu_init.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -1288,6 +1288,8 @@ static int __init amd_iommu_init(void)
>  	if (ret)
>  		goto free;
>  
> +	enable_iommus();
> +
>  	if (iommu_pass_through)
>  		ret = amd_iommu_init_passthrough();
>  	else
> @@ -1300,8 +1302,6 @@ static int __init amd_iommu_init(void)
>  
>  	amd_iommu_init_notifier();
>  
> -	enable_iommus();
> -

Ok, so now we do enable_iommu() before we attach devices and flush DTE and
domain PDE, IO TLB. That makes sense.

Following is just for my education purposes. Trying to understand better
the impact of in-flight DMAs. So IIUC, in kudmp context following seems to be
sequence of events.

1. kernel crashes, we leave IOMMU enabled.

2. boot into capture kernel and we call enable_iommus(). This function
   first disables iommu, sets up new device table and enables iommus
   again.
	a. So during this small window when iommu is disabled and we enable
	   it back, any inflight DMA will passthrough possibly to an
	   unintended physical address as translation is disabled and it
	   can corrupt the kdump kenrel.

	b. Even after enabling the iommu, I guess we will continue to
	   use cached DTE, and translation information to handle any
	   in-flight DMA. The difference is that now iommus are enabled
	   so any in-flight DMA should go to the address as intended in
	   first kenrel and should not corrupt anything.

3. Once iommus are enabled again, we allocated and initilize protection
   domains. We attach devices to domains. In the process we flush the
   DTE, PDE and IO TLBs.

	c. Looks like do_attach->set_dte_entry(), by default gives write
	   permission (IW) to all the devices. I am assuming that at
	   this point of time translation is enabled and possibly unity
	   mapped. If that's the case, any in-flight DMA will not be
	   allowed to happen at unity mapped address and this can possibly
	   corrupt the kernel? 

I understand this patch should fix the case when in second kernel a 
device is not doing DMA because of possibly cached DTE, and translation
information. But looks like in-flight DMA issues will still need a closer
look. But that is a separate issue and needs to be addressed in separate
set of patches.

Thanks
Vivek
