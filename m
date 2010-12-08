Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab0LHTuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:50:08 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1737 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab0LHTuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:50:06 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Jian Peng" <jipeng@broadcom.com>
To: "Tejun Heo" <tj@kernel.org>
cc: "Robert Hancock" <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Date: Wed, 8 Dec 2010 11:49:50 -0800
Subject: RE: questions regarding possible violation of AHCI spec in AHCI
 driver
Thread-Topic: questions regarding possible violation of AHCI spec in
 AHCI driver
Thread-Index: AcuXCSl3mmnmci05SOGWaTyhPcqarwABnwv5
Message-ID: <E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFEE569.4030204@gmail.com> <4CFF58D2.4040006@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>,<4CFFCD56.6050608@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>,<4CFFD3EB.10800@kernel.org>
In-Reply-To: <4CFFD3EB.10800@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 60E13E0B3JS4708690-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree. I have AHCI based PCI card using HBA from Marvell, Via and Silicon Image, and am going to test my patch. 
Before this patch can be applied universally, I like to use it for specific PCI_VENDOR_ID first. Here is my new patch to limit it to Broadcom's AHCI core

--- libahci.c.orig	2010-12-08 10:42:48.383976763 -0800
+++ libahci.c	2010-12-08 11:44:24.394023128 -0800
@@ -44,6 +44,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
+#include <linux/pci.h>
 #include "ahci.h"
 
 static int ahci_skip_host_reset;
@@ -541,8 +542,20 @@
 void ahci_start_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ata_host *host = ap->host;
+	struct pci_dev *pdev = to_pci_dev(host->dev);
 	u32 tmp;
 
+	/* avoid race condition per spec (end of section 10.1.2) */
+	if (pdev->vendor == PCI_VENDOR_ID_BROADCOM) {
+		u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+
+		if (status & (ATA_BUSY | ATA_DRQ) ||
+		    ahci_scr_read(&ap->link, SCR_STATUS, &tmp) ||
+		    (tmp & 0x0f) != 0x03)
+			return;
+	}
+
 	/* start DMA */
 	tmp = readl(port_mmio + PORT_CMD);
 	tmp |= PORT_CMD_START;

Thanks,
Jian

________________________________________
From: Tejun Heo [tj@kernel.org]
Sent: Wednesday, December 08, 2010 10:52 AM
To: Jian Peng
Cc: Robert Hancock; linux-kernel@vger.kernel.org; jgarzik@pobox.com; ide
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver

Hello,

On 12/08/2010 07:48 PM, Jian Peng wrote:
> So it is reasonable to add extra check in ahci_start_engine() without returning status of ST bit. If so, here is my patch
>
> --- libahci.c.orig    2010-12-08 10:42:48.383976763 -0800
> +++ libahci.c 2010-12-08 10:45:17.495156944 -0800
> @@ -542,6 +542,13 @@
>  {
>       void __iomem *port_mmio = ahci_port_base(ap);
>       u32 tmp;
> +     u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
> +
> +     /* avoid race condition per spec (end of section 10.1.2) */
> +     if (status & (ATA_BUSY | ATA_DRQ) ||
> +         ahci_scr_read(&ap->link, SCR_STATUS, &tmp) ||
> +         (tmp & 0x0f) != 0x03)
> +             return;
>
>       /* start DMA */
>       tmp = readl(port_mmio + PORT_CMD);

Yes, it is reasonable but I want to see that it actually fixes
something.  There are just too many controllers which use this path to
blindly apply the above change and given my previous explanation even
without the above change any ahci controller _should_ work fine.

Thanks.

--
tejun


