Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207Ab2JLR2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:28:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab2JLR2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:28:51 -0400
Message-ID: <1350062918.2112.53.camel@bling.home>
Subject: Re: [PATCH -stable] amd_iommu: attach device fails on the last pci
 device
From: Alex Williamson <alex.williamson@redhat.com>
To: shuah.khan@hp.com
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Greg KH <gregkh@linuxfoundation.org>, iommu@lists.linux-foundation.org,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, shuahkhan@gmail.com
Date: Fri, 12 Oct 2012 11:28:38 -0600
In-Reply-To: <1350059367.2643.17.camel@lorien2>
References: <1350059367.2643.17.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 10:29 -0600, Shuah Khan wrote:
> amd_iommu_attach_device() checks if device id is within the limits
> of amd_iommu_last_bdf and instead checking if devid > amd_iommu_last_bdf,
> it checks devid >= amd_iommu_last_bdf. As a result the last device attach
> fails because amd_iommu_attach_device() returns an -EINVAL.
> 
> This bug is in linux-2.6.32 and an equivalent fix in linux-2.6.33 and has been
> carried forward to later kernels and is in the upstream kernel. This equivalent
> fix includes restructuring and consolidating device checks into a routine
> check_device(). Instead of back-porting all of that work, spot-fixed the bug in
> amd_iommu_attach_device() for linux-2.6.32.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> CC: <stable@vger.kernel.org> v2.6.32
> ---
>  arch/x86/kernel/amd_iommu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index 3a44b75..67de7d7 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -2288,7 +2288,7 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
>  
>  	devid = calc_devid(pdev->bus->number, pdev->devfn);
>  
> -	if (devid >= amd_iommu_last_bdf ||
> +	if (devid > amd_iommu_last_bdf ||
>  			devid != amd_iommu_alias_table[devid])
>  		return -EINVAL;
>  

Looks correct to me, this case was clearly inconsistent with other users
of amd_iommu_last_bdf.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

