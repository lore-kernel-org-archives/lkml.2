Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0CaPzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 11:55:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042Ab0CaPzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 11:55:15 -0400
Date: Wed, 31 Mar 2010 11:54:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: iommu@lists.linux-foundation.org, joerg.roedel@amd.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
Message-ID: <20100331155430.GF14011@redhat.com>
References: <20100331152417.GB13406@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331152417.GB13406@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 11:24:17AM -0400, Neil Horman wrote:
> Flush iommu during shutdown
> 
> When using an iommu, its possible, if a kdump kernel boot follows a primary
> kernel crash, that dma operations might still be in flight from the previous
> kernel during the kdump kernel boot.  This can lead to memory corruption,
> crashes, and other erroneous behavior, specifically I've seen it manifest during
> a kdump boot as endless iommu error log entries of the form:
> AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.1 domain=0x000d
> address=0x000000000245a0c0 flags=0x0070]
> 
> Followed by an inability to access hard drives, and various other resources.
> 
> I've written this fix for it.  In short it just forces a flush of the in flight
> dma operations on shutdown, so that the new kernel is certain not to have any
> in-flight dmas trying to complete after we've reset all the iommu page tables,
> causing the above errors.  I've tested it and it fixes the problem for me quite
> well.

CCing Eric also.

Neil, this is interesting. In the past we noticed similar issues,
especially on PPC. But I was told that we could not clear the iommu
mapping entries as we had no control on in flight DMA and if a DMA comes
later after clearing an entry and entry is not present, it is an error.

Hence one of the suggestions was not to clear iommu mapping entries but
reserve some for kdump operation and use those in kdump kernel.

So this call amd_iommu_flush_all_devices() will be able to tell devices
that don't do any more DMAs and hence it is safe to reprogram iommu
mapping entries.

Thanks
Vivek
 
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
> amd_iommu_init.c |   25 ++++++++++++++++++++++---
> 1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> index 9dc91b4..8fbdf58 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -265,8 +265,26 @@ static void iommu_enable(struct amd_iommu *iommu)
>  	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
>  }
>  
> -static void iommu_disable(struct amd_iommu *iommu)
> +static void iommu_disable(struct amd_iommu *iommu, bool flush)
>  {
> +
> +	/*
> +	 * This ensures that all in-flight dmas for this iommu
> +	 * are complete prior to shutting it down
> +	 * its a bit racy, but I think its ok, given that if we're flushing
> +	 * we're in a shutdown path (either a graceful shutdown or a
> +	 * crash leading to a kdump boot.  That means we're down to one
> +	 * cpu, and the other system hardware isn't going to issue
> +	 * subsequent dma operations.
> +	 * Also note that we gate the flusing on the flush boolean because
> +	 * the enable_iommus path uses this function and we can't flush any
> +	 * data in that path until later when the iommus are fully initialized
> +	 */
> +	if (flush) {
> +		amd_iommu_flush_all_devices();
> +		amd_iommu_flush_all_domains();
> +	}
> +
>  	/* Disable command buffer */
>  	iommu_feature_disable(iommu, CONTROL_CMDBUF_EN);
>  
> @@ -276,6 +294,7 @@ static void iommu_disable(struct amd_iommu *iommu)
>  
>  	/* Disable IOMMU hardware itself */
>  	iommu_feature_disable(iommu, CONTROL_IOMMU_EN);
> +
>  }
>  
>  /*
> @@ -1114,7 +1133,7 @@ static void enable_iommus(void)
>  	struct amd_iommu *iommu;
>  
>  	for_each_iommu(iommu) {
> -		iommu_disable(iommu);
> +		iommu_disable(iommu, false);
>  		iommu_set_device_table(iommu);
>  		iommu_enable_command_buffer(iommu);
>  		iommu_enable_event_buffer(iommu);
> @@ -1129,7 +1148,7 @@ static void disable_iommus(void)
>  	struct amd_iommu *iommu;
>  
>  	for_each_iommu(iommu)
> -		iommu_disable(iommu);
> +		iommu_disable(iommu, true);
>  }
>  
>  /*
