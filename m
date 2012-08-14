Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2HNOsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:48:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59157 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2HNOsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:48:20 -0400
Date: Tue, 14 Aug 2012 22:48:08 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Aaron Lu <ziqian.lu@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Holger Macht <holger@homac.de>, Lin Ming <minggr@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: bisected regression: v3.6-rc1: resume from s2ram does not
 restore ata_piix (v3.5 worked)
Message-ID: <20120814144804.GA23416@localhost.localdomain>
References: <CA2E3DE2DD06CA4FA11644750E4E292F102ACD65@SHSMSX102.ccr.corp.intel.com>
 <20120814080952.GA4981@localhost.localdomain>
 <20120814114420.2e844ea1@sf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814114420.2e844ea1@sf>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 11:44:20AM +0300, Sergei Trofimovich wrote:
> > The only problem I can see is the offending commit didn't do a gtm for
> > IDE channel during init. It was used to be done in
> > ata_acpi_associate_ide_port.
> > 
> > So can you please test if the following code fix your problem? Thanks.
> 
> Unfortunately, nothing changed. The same hangup after resume.
> Did the bisected patch change the way kernel relies on ACPI
> information? I have some complains in dmesg output about it
> (attached whole dmesg) like that:
> 
> ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0000000000000004) is beyond end of object (20120711/exoparg2-418)
> ACPI Error: Method parse/execution failed [\_SB_.C003.C09A._DOD] (Node ffff88007b82c988), AE_AML_PACKAGE_LIMIT (20120711/psparse-536)
> ACPI Exception: AE_AML_PACKAGE_LIMIT, Evaluating _DOD (20120711/video-1149)


> ata1: ACPI get timing mode failed (AE 0x1001)
Do you see this error message when using a working kernel?

And here is another try:

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 902b5a4..fd9ecf7 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -60,17 +60,7 @@ acpi_handle ata_ap_acpi_handle(struct ata_port *ap)
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return NULL;
 
-	/*
-	 * If acpi bind operation has already happened, we can get the handle
-	 * for the port by checking the corresponding scsi_host device's
-	 * firmware node, otherwise we will need to find out the handle from
-	 * its parent's acpi node.
-	 */
-	if (ap->scsi_host)
-		return DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev);
-	else
-		return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev),
-				ap->port_no);
+	return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev), ap->port_no);
 }
 EXPORT_SYMBOL(ata_ap_acpi_handle);
 
@@ -1101,6 +1091,9 @@ static int ata_acpi_bind_host(struct ata_port *ap, acpi_handle *handle)
 	if (!*handle)
 		return -ENODEV;
 
+	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
+		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
+
 	return 0;
 }

Thanks,
Aaron
