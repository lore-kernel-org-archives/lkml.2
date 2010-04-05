Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0DEPfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:35:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57355 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab0DEPfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:35:13 -0400
Date: Mon, 5 Apr 2010 11:34:55 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       hbabu@us.ibm.com, iommu@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/2] x86/amd-iommu: enable iommu before attaching devices
Message-ID: <20100405153455.GB27116@hmsreliant.think-freely.org>
References: <m1sk7guv5u.fsf@fess.ebiederm.org>
 <20100331202745.GE13406@hmsreliant.think-freely.org>
 <20100401142902.GF24846@8bytes.org>
 <20100401144736.GA14069@shamino.rdu.redhat.com>
 <20100401155643.GG24846@8bytes.org>
 <20100401171149.GH13603@shamino.rdu.redhat.com>
 <20100401201433.GK24846@8bytes.org>
 <20100402000012.GA8930@hmsreliant.think-freely.org>
 <20100402003034.GX29241@sequoia.sous-sol.org>
 <20100402012353.GY29241@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402012353.GY29241@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
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
>  
> 

FWIW, this patch series fixed the kdump issues I was having on my AMD system
here.  Thanks Chris

Acked-by: Neil Horman <nhorman@tuxdriver.com>

