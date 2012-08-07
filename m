Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2HGVEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 17:04:14 -0400
Received: from 8bytes.org ([85.214.48.195]:52547 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab2HGVEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 17:04:12 -0400
Date: Tue, 7 Aug 2012 23:04:08 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] irq_remap: disable IRQ remapping if any IOAPIC lacks an
 IOMMU
Message-ID: <20120807210408.GK1917@8bytes.org>
References: <20120807201030.GJ1917@8bytes.org>
 <1344372489-14087-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344372489-14087-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Aug  7 23:04:10 2012
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 502182ca20421372317312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 03:48:09PM -0500, Seth Forshee wrote:
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
> +

I would change this to pr_err() and add FW_BUG to make clear that this
is an error caused by a firmware bug.


	Joerg


