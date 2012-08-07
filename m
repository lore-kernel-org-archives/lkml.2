Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2HGUxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:53:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:2379 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab2HGUxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:53:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="178065162"
Subject: Re: [PATCH] irq_remap: disable IRQ remapping if any IOAPIC lacks an
 IOMMU
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>
Date: Tue, 07 Aug 2012 13:50:33 -0700
In-Reply-To: <1344372489-14087-1-git-send-email-seth.forshee@canonical.com>
References: <20120807201030.GJ1917@8bytes.org>
	 <1344372489-14087-1-git-send-email-seth.forshee@canonical.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1344372634.27383.11.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 15:48 -0500, Seth Forshee wrote:
> The ACPI tables in the Macbook Air 5,1 define a single IOAPIC with id 2,
> but the only remapping unit described in the DMAR table matches id 0.
> Interrupt remapping fails as a result, and the kernel panics with the
> message "timer doesn't work through Interrupt-remapped IO-APIC."
> 
> To fix this, check each IOAPIC for a corresponding IOMMU. If an IOMMU is
> not found, do not allow IRQ remapping to be enabled.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/iommu/intel_irq_remapping.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index e0b18f3..ce2c0c6 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -526,6 +526,7 @@ static int __init intel_irq_remapping_supported(void)
>  static int __init intel_enable_irq_remapping(void)
>  {
>  	struct dmar_drhd_unit *drhd;
> +	int ioapic_idx;
>  	int setup = 0;
>  	int eim = 0;
>  
> @@ -534,6 +535,16 @@ static int __init intel_enable_irq_remapping(void)
>  		return -1;
>  	}
>  
> +	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
> +		int ioapic_id = mpc_ioapic_id(ioapic_idx);
> +		if (!map_ioapic_to_ir(ioapic_id)) {
> +			pr_info("ioapic %d has no mapping iommu, "
> +				"interrupt remapping will be disabled\n",
> +				ioapic_id);
> +			return -1;
> +		}
> +	}

It will be cleaner to move this to parse_ioapics_under_ir().

Other than that feel free to add my
"Acked-by: Suresh Siddha <suresh.b.siddha@intel.com"

thanks,
suresh

> +
>  	if (x2apic_supported()) {
>  		eim = !dmar_x2apic_optout();
>  		WARN(!eim, KERN_WARNING


