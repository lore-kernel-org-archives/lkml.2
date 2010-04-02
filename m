Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab0DBJL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 05:11:26 -0400
Received: from 8bytes.org ([88.198.83.132]:35890 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0DBJLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 05:11:19 -0400
Date: Fri, 2 Apr 2010 11:11:18 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Neil Horman <nhorman@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/2] x86/amd-iommu: enable iommu before attaching
	devices
Message-ID: <20100402091118.GM24846@8bytes.org>
References: <m1sk7guv5u.fsf@fess.ebiederm.org> <20100331202745.GE13406@hmsreliant.think-freely.org> <20100401142902.GF24846@8bytes.org> <20100401144736.GA14069@shamino.rdu.redhat.com> <20100401155643.GG24846@8bytes.org> <20100401171149.GH13603@shamino.rdu.redhat.com> <20100401201433.GK24846@8bytes.org> <20100402000012.GA8930@hmsreliant.think-freely.org> <20100402003034.GX29241@sequoia.sous-sol.org> <20100402012353.GY29241@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402012353.GY29241@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
>  	if (iommu_pass_through)
>  		goto out;

Ok, good to know this fixes the problem. One issue: If the
initialization of the domains fails the iommu hardware needs to be
disabled again in the free path.

Thanks,

	Joerg

