Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1GGQZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:25:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50232 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1GGQZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:25:54 -0400
Date: Thu, 7 Jul 2011 12:24:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: xen-devel@lists.xensource.com, jeremy.fitzhardinge@citrix.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [Xen-devel] Re: [PATCH] Modpost section mismatch fix
Message-ID: <20110707162454.GA8164@dumpdata.com>
References: <20110703232508.GB4440@Xye>
 <1309769388.634.51.camel@zakaz.uk.xensource.com>
 <20110704221646.GB4490@Xye>
 <20110705141323.GG2972@dumpdata.com>
 <20110705142731.GA4463@Xye>
 <20110705144846.GA13548@dumpdata.com>
 <20110705213243.GA3647@dumpdata.com>
 <20110707154648.GA4394@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707154648.GA4394@Xye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A020205.4E15DDE3.00B4:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tested it. Works now.

Ok, Stuck Tested-by on the patch. Hopefully Linus hasn't pulled it yet.

> Reviewed-by: Raghavendra Prabhu <rprabhu@wnohang.net>
> 
> Also,
> The condition for acpi_gsi_to_irq can be removed since it always returns zero.

The function might in the future return something that is non-zero
and we should guard for it. Also you make 'irq' be unsigned which is not
good as the IRQ 0 is a valid value - and with making it unsigned if it is
set to -1 (the -1 is the invalid IRQ value) the check for 'irq != gsi'
will be true and and we will pass in -1 casted to unsigned. That is a
large value and not the right thing we want to pass to xen_register_gsi.


> ============================================
>  diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
>  index f567965..3faa55b 100644
>  --- a/arch/x86/pci/xen.c
>  +++ b/arch/x86/pci/xen.c
>  @@ -405,7 +405,7 @@ static __init void xen_setup_acpi_sci(void)
>          int rc;
>          int trigger, polarity;
>          int gsi = acpi_sci_override_gsi;
>  -       int irq = -1;
>  +       unsigned int irq = 0u;
>          int gsi_override = -1;
> 
>          if (!gsi)
>  @@ -435,11 +435,10 @@ static __init void xen_setup_acpi_sci(void)
>           * setup as we had setup IRQ 20 for it).
>           */
>          /* Check whether the GSI != IRQ */
>  -       if (acpi_gsi_to_irq(gsi, &irq) == 0) {
>  -               if (irq >= 0 && irq != gsi)
>  -                       /* Bugger, we MUST have that IRQ. */
>  -                       gsi_override = irq;
>  -       }
>  +       acpi_gsi_to_irq(gsi, &irq);
>  +       if (irq != gsi)
>  +               /* Bugger, we MUST have that IRQ. */
>  +               gsi_override = irq;
> 
>          gsi = xen_register_gsi(gsi, gsi_override, trigger, polarity);
>          printk(KERN_INFO "xen: acpi sci %d\n", gsi);
> 
> 
> --------------------------
> Raghavendra Prabhu
> GPG Id : 0xD72BE977
> Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
> www: wnohang.net



> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

