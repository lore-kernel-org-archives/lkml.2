Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1GDI4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:56:38 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:40518 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab1GDI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:56:37 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jul 2011 04:56:36 EDT
From: Ian Campbell <ijc@hellion.org.uk>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, jeremy.fitzhardinge@citrix.com,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
In-Reply-To: <20110703232508.GB4440@Xye>
References: <20110703232508.GB4440@Xye>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 09:49:48 +0100
Message-ID: <1309769388.634.51.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] Modpost section mismatch fix
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 04:55 +0530, Raghavendra D Prabhu wrote:
> [Sorry if duplicate, one earlier was corrupt]
> 
> Hi,
>      I got section mismatches reported by modpost in latest build. It got
>      reported for xen_register_pirq and xen_unplug_emulated_devices
>      functions.


>  xen_register_pirq makes reference to
>      acpi_sci_override_gsi in init.data section; marking
>      xen_register_pirq with __init is not feasible since calls are made
>      to it from acpi_register_gsi in non-init contexts. So marking it
>      __refdata based on assumption that when acpi_sci_override_gsi is
>      referenced, it is in  early stages where it is alive.

I don't think this assumption holds, since xen_register_pirq can be
called at any time and basically unconditionally references
acpi_sci_override_gsi.

If we don't want to remove the __init from acpi_sci_override_gsi then
perhaps xen_setup_acpi_sci needs to stash it somewhere?

Or maybe xen_register_pirq could take an "int force_irq" which, if not
-1, would force a particular IRQ. The callsite in xen_setup_acpi_sci
(actually via xen_register_gsi so the param would need to be propagated
there) would be the only actual user?

The xen_unplug_emulated_devices change looks correct to me since
xen_unplug_emulated_devices is called from xen_arch_hvm_post_suspend.

Ian.

> 
> 
> --------------------------
> Raghavendra Prabhu
> GPG Id : 0xD72BE977
> Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
> www: wnohang.net
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization

-- 
Ian Campbell
Current Noise: Crowbar - Remember Tomorrow (A Tribute To Iron Maiden)

SANTA CLAUS comes down a FIRE ESCAPE wearing bright blue LEG WARMERS
... He scrubs the POPE with a mild soap or detergent for 15 minutes,
starring JANE FONDA!!

