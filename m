Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab2DXWul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:50:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:23243 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457Ab2DXWuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="136324504"
Subject: Re: [PATCH 1/1] x86: Use x2apic physical mode based on FADT setting
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Greg Pearson <greg.pearson@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Apr 2012 15:53:26 -0700
In-Reply-To: <1335307115-15480-1-git-send-email-greg.pearson@hp.com>
References: <1335307115-15480-1-git-send-email-greg.pearson@hp.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1335308006.28674.266.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 16:38 -0600, Greg Pearson wrote:
> Provide systems that do not support x2apic cluster mode
> a mechanism to select x2apic physical mode using the
> FADT FORCE_APIC_PHYSICAL_DESTINATION_MODE bit.
> 
> Signed-off-by: Greg Pearson <greg.pearson@hp.com>
> ---
>  arch/x86/kernel/apic/x2apic_phys.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
> index 8a778db..c372926 100644
> --- a/arch/x86/kernel/apic/x2apic_phys.c
> +++ b/arch/x86/kernel/apic/x2apic_phys.c
> @@ -6,6 +6,10 @@
>  #include <linux/init.h>
>  #include <linux/dmar.h>
>  
> +#ifdef CONFIG_ACPI
> +#include <linux/acpi.h>
> +#endif

dmar.h already includes acpi.h

> +
>  #include <asm/smp.h>
>  #include <asm/x2apic.h>
>  
> @@ -24,6 +28,14 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>  {
>  	if (x2apic_phys)
>  		return x2apic_enabled();
> +#ifdef CONFIG_ACPI
> +	else if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
> +		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) &&
> +		x2apic_enabled()) {
> +		printk(KERN_DEBUG "System requires x2apic physical mode\n");
> +		return 1;
> +	}
> +#endif

x2apic is already dependent on irq-remapping which depends on ACPI. So I
think you can do away with those ifdef CONFIG_ACPI.

Also, which system requires this? If you can include the information in
the changelog that will be great.

thanks,
suresh

