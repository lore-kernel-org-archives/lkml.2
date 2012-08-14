Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2HNIKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:10:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:26675 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab2HNIKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:10:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,765,1336374000"; 
   d="scan'208";a="186094102"
Date: Tue, 14 Aug 2012 16:09:52 +0800
From: Aaron Lu <ziqian.lu@intel.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>,
        Lin Ming <minggr@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
        Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: FW: bisected regression: v3.6-rc1: resume from s2ram does not
 restore ata_piix (v3.5 worked)
Message-ID: <20120814080952.GA4981@localhost.localdomain>
References: <CA2E3DE2DD06CA4FA11644750E4E292F102ACD65@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA2E3DE2DD06CA4FA11644750E4E292F102ACD65@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-send due to the last email is not plain text.]

Hi Sergei,

The only problem I can see is the offending commit didn't do a gtm for
IDE channel during init. It was used to be done in
ata_acpi_associate_ide_port.

So can you please test if the following code fix your problem? Thanks.

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 902b5a4..0f338bb 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1101,6 +1101,9 @@ static int ata_acpi_bind_host(struct ata_port *ap, acpi_handle *handle)
 	if (!*handle)
 		return -ENODEV;
 
+	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
+		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
+
 	return 0;
 }

Thanks,
Aaron

> ---------- Forwarded message ----------
> From: Sergei Trofimovich <slyich@gmail.com>
> Date: Mon, Aug 13, 2012 at 5:20 PM
> Subject: bisected regression: v3.6-rc1: resume from s2ram does not restore ata_piix (v3.5 worked)
> To: linux-pm@lists.linux-foundation.org, Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>, Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> 
> 
> It's a laptop compaq 2510p (~5 years old core2 laptop) with a single SATA drive:
> 
> 00:1f.1 IDE interface: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
>         Subsystem: Hewlett-Packard Company Device 30c9
>         Kernel driver in use: ata_piix
> 
> kernel v3.5 worked fine. 3.6-rc1 resumes, but disk stays inaccessble.
> Seems to be 100% reproducible. Bisection gave sane result[1].
> 
> I was not able to revert it as-is, thus couldn't verify the revert helps on top of master.
> 
> Do you need more info?
> 
> Thanks!
> 
> [1]
> commit 30dcf76acc695cbd2fa919e294670fe9552e16e7
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Mon Jun 25 16:13:04 2012 +0800
> 
>     libata: migrate ACPI code over to new bindings
> 
>     Now that we have the ability to directly glue the ACPI namespace to the
>     driver model in libata, we don't need the custom code to handle the same
>     thing. Remove it and migrate the functions over to the new code.
> 
>     Signed-off-by: Matthew Garrett <mjg@redhat.com>
>     Signed-off-by: Holger Macht <holger@homac.de>
>     Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> :040000 040000 6a659a9d4a92b2085f6d0b58484cb2f82cd12cfa
> 125fe5d5fa8b208a08792b03e752571d825465d2 M      drivers
> :040000 040000 b7c3819be4e82ae6e2ac9688055aeb2bc1bc4ebd
> 9cbc8fd15b147a178f723bcdb9e7c34f9868400f M      include
> 
> git bisect good 492d542273a4859f8bf8cc7744cdf71ef50b39ea
> # bad: [354b2eac3848bddbcb111079138b907ccca70ae8] libata-acpi: fix up for acpi_pm_device_sleep_state API git bisect bad 354b2eac3848bddbcb111079138b907ccca70ae8
> # bad: [dc7f71f486f4f5fa96f6dcf86833da020cde8a11] sata_dwc_460ex:
> device tree may specify dma_channel
> git bisect bad dc7f71f486f4f5fa96f6dcf86833da020cde8a11
> # bad: [91e4d5a1d7d11ca0b08803a11cb8dc866d2d611f] drivers/acpi/glue:
> revert accidental license-related 6b66d95895c bits git bisect bad 91e4d5a1d7d11ca0b08803a11cb8dc866d2d611f
> # bad: [3bd46600a7a7e938c54df8cdbac9910668c7dfb0] libata-acpi: add ata port runtime D3Cold support git bisect bad 3bd46600a7a7e938c54df8cdbac9910668c7dfb0
> # bad: [30dcf76acc695cbd2fa919e294670fe9552e16e7] libata: migrate ACPI code over to new bindings git bisect bad 30dcf76acc695cbd2fa919e294670fe9552e16e7
> # good: [6b66d95895c149cbc04d4fac5a2f5477c543a8ae] libata: bind the Linux device tree to the ACPI device tree git bisect good 6b66d95895c149cbc04d4fac5a2f5477c543a8ae
> # good: [6b66d95895c149cbc04d4fac5a2f5477c543a8ae] libata: bind the Linux device tree to the ACPI device tree git bisect good 6b66d95895c149cbc04d4fac5a2f5477c543a8ae
> 30dcf76acc695cbd2fa919e294670fe9552e16e7 is the first bad commit
> 
> --
> 
>   Sergei


