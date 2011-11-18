Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab1KRQDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:03:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929Ab1KRQD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:03:29 -0500
Message-ID: <1321632197.26410.104.camel@bling.home>
Subject: Re: [PATCH] intel-iommu: Manage iommu_coherency globally
From: Alex Williamson <alex.williamson@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: rajesh.sankaran@intel.com, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        chrisw@sous-sol.org, ddutile@redhat.com
Date: Fri, 18 Nov 2011 09:03:17 -0700
In-Reply-To: <1321617817.15493.33.camel@shinybook.infradead.org>
References: <20111116040752.11878.18642.stgit@bling.home>
	 <1321617817.15493.33.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 12:03 +0000, David Woodhouse wrote:
> On Tue, 2011-11-15 at 21:11 -0700, Alex Williamson wrote:
> > We currently manage iommu_coherency on a per domain basis,
> > choosing the safest setting across the iommus attached to a
> > particular domain.  This unfortunately has a bug that when
> > no iommus are attached, the domain defaults to coherent.
> > If we fall into this mode, then later add a device behind a
> > non-coherent iommu to that domain, the context entry is
> > updated using the wrong coherency setting, and we get dmar
> > faults.
> > 
> > Since we expect chipsets to be consistent in their coherency
> > setting, we can instead determine the coherency once and use
> > it globally. 
> 
> (Adding Rajesh).
> 
> Hm, it seems I lied to you about this. The non-coherent mode isn't just
> a historical mistake; it's configurable by the BIOS, and we actually
> encourage people to use the non-coherent mode because it makes the
> hardware page-walk faster — so reduces the latency for IOTLB misses.
> 
> In addition to that, the IOMMU associated with the integrated graphics
> is so "special" that it doesn't support coherent mode either. So it *is*
> quite feasible that we'll see a machine where some IOMMUs support
> coherent mode, and some don't.
> 
> And thus we do need to address the concern that just assuming
> non-coherent mode will cause unnecessary performance issues, for the
> case where a domain *doesn't* happen to include any of the non-coherent
> IOMMUs.
> 
> However... for VM domains I don't think we care. Setting up the page
> tables *isn't* a fast path there (at least not until/unless we support
> exposing an emulated IOMMU to the guest).
> 
> The case we care about is *native* DMA, where this cache flush will be
> happening for example in the fast path of network TX/RX. But in *that*
> case, there is only *one* IOMMU to worry about so it's simple enough to
> do the right thing, surely?
> 
> So, referring to your patch... perhaps we should retain the
> domain->iommu_coherency variable, but *still* have the global
> 'iommu_coherency' calculated at init time. For *VM* domains, we set
> domain->iommu_coherency = iommu_coherency and use the
> globally-calculated (and pessimistic) result. For *DMA* domains (i.e. in
> domain_init()), we keep the code that was there before, which looks at
> ecap_coherent(iommu->ecap). Does that seem sane? Revised patch...

I can't help but thinking we're just taking the easy, lazy path for VM
domains when it sounds like we really would prefer to keep the coherency
set to the least common denominator of the domain rather than the
platform.  Couldn't we instead force a flush of the domain when we
transition from coherent to non-coherent?  Not sure I'm qualified to
write that, but seems like it would keep the efficiency of VM domains
with no effect to native DMA domains since they'd never trigger such a
transition.  The below appears as if it would work and probably be OK
since the unnecessary cache flushes are rare, but they're still
unnecessary... and the comments/commit log are now wrong.  Thanks,

Alex

> From c6b04e1c7456892f43a6f81f0005b3ade8ca0383 Mon Sep 17 00:00:00 2001
> From: Alex Williamson <alex.williamson@redhat.com>
> Date: Tue, 15 Nov 2011 21:11:09 -0700
> Subject: [PATCH] intel-iommu: Manage iommu_coherency globally
> 
> We currently manage iommu_coherency on a per domain basis,
> choosing the safest setting across the iommus attached to a
> particular domain.  This unfortunately has a bug that when
> no iommus are attached, the domain defaults to coherent.
> If we fall into this mode, then later add a device behind a
> non-coherent iommu to that domain, the context entry is
> updated using the wrong coherency setting, and we get dmar
> faults.
> 
> Since we expect chipsets to be consistent in their coherency
> setting, we can instead determine the coherency once and use
> it globally.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> [dwmw2: Do the above for VM domains only; use capabilities for normal domains]
> ---
>  drivers/iommu/intel-iommu.c |   33 +++++++++++++++++----------------
>  1 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index c0c7820..ce8f933 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -419,6 +419,8 @@ static LIST_HEAD(device_domain_list);
>  
>  static struct iommu_ops intel_iommu_ops;
>  
> +static int vm_iommu_coherency __read_mostly = 1;
> +
>  static int __init intel_iommu_setup(char *str)
>  {
>  	if (!str)
> @@ -556,20 +558,6 @@ static struct intel_iommu *domain_get_iommu(struct dmar_domain *domain)
>  	return g_iommus[iommu_id];
>  }
>  
> -static void domain_update_iommu_coherency(struct dmar_domain *domain)
> -{
> -	int i;
> -
> -	domain->iommu_coherency = 1;
> -
> -	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
> -		if (!ecap_coherent(g_iommus[i]->ecap)) {
> -			domain->iommu_coherency = 0;
> -			break;
> -		}
> -	}
> -}
> -
>  static void domain_update_iommu_snooping(struct dmar_domain *domain)
>  {
>  	int i;
> @@ -608,7 +596,6 @@ static void domain_update_iommu_superpage(struct dmar_domain *domain)
>  /* Some capabilities may be different across iommus */
>  static void domain_update_iommu_cap(struct dmar_domain *domain)
>  {
> -	domain_update_iommu_coherency(domain);
>  	domain_update_iommu_snooping(domain);
>  	domain_update_iommu_superpage(domain);
>  }
> @@ -3583,6 +3570,8 @@ static struct notifier_block device_nb = {
>  
>  int __init intel_iommu_init(void)
>  {
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
>  	int ret = 0;
>  
>  	/* VT-d is required for a TXT/tboot launch, so enforce that */
> @@ -3643,6 +3632,18 @@ int __init intel_iommu_init(void)
>  
>  	init_iommu_pm_ops();
>  
> +	/*
> +	 * Check for coherency support across all iommus.  If unsupported
> +	 * by any, force cache flushes.  Expected to be consistent across
> +	 * all iommus in the system.
> +	 */
> +	for_each_active_iommu(iommu, drhd) {
> +		if (!ecap_coherent(iommu->ecap)) {
> +			vm_iommu_coherency = 0;
> +			break;
> +		}
> +	}
> +
>  	bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
>  
>  	bus_register_notifier(&pci_bus_type, &device_nb);
> @@ -3820,7 +3821,7 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
>  	INIT_LIST_HEAD(&domain->devices);
>  
>  	domain->iommu_count = 0;
> -	domain->iommu_coherency = 0;
> +	domain->iommu_coherency = vm_iommu_coherency;
>  	domain->iommu_snooping = 0;
>  	domain->iommu_superpage = 0;
>  	domain->max_addr = 0;
> -- 
> 1.7.7.1
> 
> 
> 



