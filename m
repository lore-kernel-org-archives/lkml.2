Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab2FDDVD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 23:21:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:32617 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab2FDDVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 23:21:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174328648"
Date: Mon, 4 Jun 2012 11:17:25 +0800
From: Feng Tang <feng.tang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <rui.zhang@intel.com>, <fazerxlo@o2.pl>, <x86@kernel.org>
Subject: Re: [PATCH] ACPI: Fix the irq0 assigning issue for AMILO PRO V2030
 platform
Message-ID: <20120604111725.2cd9828e@feng-i7>
In-Reply-To: <4FC8F36C.8080409@kernel.org>
References: <1338259418-6167-1-git-send-email-feng.tang@intel.com>
	<4FC8F36C.8080409@kernel.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On Fri, 1 Jun 2012 12:53:00 -0400
Len Brown <lenb@kernel.org> wrote:

> Hello Tang-Feng,
> 
> This looks good, but especially w/ interrupt patches,
> it is important to take logically independent baby steps.
> So please break this patch into two, and add another small bit
> in a 3 patch series:
> 
> 1. allow the workaround to apply to non global_irq 2
> 2. delete the WARN from dmi_ignore_irq0_timer_override
> 	as it causes alarm, but gives no benefit
> 3. add the DMI to invoke the workaround for this platform

Thanks for the review, will make it 3 patches as you suggested.

- Feng

> 
> thanks,
> -Len Brown, Intel Open Source Technology Center
> 
> On 05/28/2012 10:43 PM, Feng Tang wrote:
> 
> > This is to fix the kernel bugzilla 40002: "IRQ 0 assigned to VGA"
> >  https://bugzilla.kernel.org/show_bug.cgi?id=40002
> > 
> > The root cause is the buggy FW, whose ACPI tables assign the GSI 16
> > to 2 irqs 0 and 16(VGA), and the VGA is the right owner of GSI 16.
> > So add a quirk to ignore the irq0 overriding GSI 16 for the
> > FUJITSU SIEMENS AMILO PRO V2030 platform will solve this issue.
> > 
> > This also slightly modify the current irq0 override handling, as it
> > only covered the irq0 overriding GSI 2 case.
> > 
> > Reported-and-tested-by: Szymon Kowalczyk <fazerxlo@o2.pl>
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > Cc: x86@kernel.org
> > ---
> >  arch/x86/kernel/acpi/boot.c |   17 ++++++++++++++---
> >  1 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> > index 4558f0d..06c78c3 100644
> > --- a/arch/x86/kernel/acpi/boot.c
> > +++ b/arch/x86/kernel/acpi/boot.c
> > @@ -416,12 +416,14 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header *
> > header, return 0;
> >  	}
> >  
> > -	if (intsrc->source_irq == 0 && intsrc->global_irq == 2) {
> > +	if (intsrc->source_irq == 0) {
> >  		if (acpi_skip_timer_override) {
> > -			printk(PREFIX "BIOS IRQ0 pin2 override
> > ignored.\n");
> > +			printk(PREFIX "BIOS IRQ0 override ignored.\n");
> >  			return 0;
> >  		}
> > -		if (acpi_fix_pin2_polarity && (intsrc->inti_flags &
> > ACPI_MADT_POLARITY_MASK)) { +
> > +		if ((intsrc->global_irq == 2) && acpi_fix_pin2_polarity
> > +			&& (intsrc->inti_flags & ACPI_MADT_POLARITY_MASK))
> > { intsrc->inti_flags &= ~ACPI_MADT_POLARITY_MASK;
> >  			printk(PREFIX "BIOS IRQ0 pin2 override: forcing
> > polarity to high active.\n"); }
> > @@ -1466,6 +1468,15 @@ static struct dmi_system_id __initdata
> > acpi_dmi_table_late[] = { DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6715b"),
> >  		     },
> >  	 },
> > +	{
> > +	 .callback = dmi_ignore_irq0_timer_override,
> > +	 .ident = "FUJITSU SIEMENS",
> > +	 .matches = {
> > +		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
> > +		     DMI_MATCH(DMI_PRODUCT_NAME, "AMILO PRO V2030"),
> > +		     },
> > +	 },
> > +
> >  	{}
> >  };
> >  
> 
> 
