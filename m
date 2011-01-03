Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1ACLaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:30:08 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:5747 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1ACLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:30:06 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz8275dh15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEG2LS-02-1RW-02
X-M-MSG: 
Date: Mon, 3 Jan 2011 12:29:52 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Jeff Garzik <jeff@garzik.org>
CC: Steffen Moser <lists@steffen-moser.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: IOMMU and DMA mode of pata_jmicron
Message-ID: <20110103112952.GA2100@amd.com>
References: <4D1A7628.3050704@steffen-moser.de>
 <4D1A881C.3080109@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D1A881C.3080109@garzik.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 08:00:12PM -0500, Jeff Garzik wrote:
> (CC'd linux-ide, Joerg)
> 
> On 12/28/2010 06:43 PM, Steffen Moser wrote:
> > I've encountered a problem with my AMD 890FX based system
> > and linux-2.6.35.10 (x86_64 platform).
> >
> > After activating the option "IOMMU" in the mainboard's BIOS
> > setup, the onboard P-ATA controller "JMicron Technology Corp.
> > JMB361 AHCI/IDE (rev 02)" puts itself back in the PIO mode.
> > When loading the module, the kernel reports:
> >
> >    pata_jmicron 0000:06:00.1: BMDMA: failed to set dma mask, \
> >                               falling back to PIO
> [...]
> > As soon as I deactivate IOMMU in BIOS setup, the P-ATA channel
> > runs in the DMA mode again. The S-ATA controllers don't seem
> > to be affected.
> >
> > My question is: Is this a known behavior? Are there any
> > things I have to consider when activating IOMMU (which seems
> > to be AMD-Vi) on an 890FX based system? Is it a problem of
> > the chipset and/or the controller or is it related to a
> > problem in the libata area?
> >
> > Some information about the affected system:
> >
> >  - Mainboard:    ASUS M4A89TD Pro/USB3
> >  - BIOS version: 1101 (most recent version)
> >  - Chipset:      AMD 890FX
> >  - Processor:    AMD Phenom 1090T
> >  - Memory:       4 x 4 GB (Kingston KVR1333D3E9S/4G)
> >  - Distribution: openSUSE 11.3
> >  - Kernel:       2.6.35.10 (from "kernel.org"), x86_64
> >
> 
> This condition occurs when the PCI API cannot set the PCI device's DMA 
> mask to the 32-bit value
> 	#define ATA_DMA_MASK            0xffffffffULL
> 
> That is an unusual failure for such a modern system, which certainly can 
> handle 32-bit masks like that, one would think.

Luckily I have exactly the same motherboard under my desk. It shows the
same issue. The problem is that the PCI device of the PATA controler
(4:00.1 in my case) is not described in the IVRS ACPI table. So the
IOMMU driver does not feel responsible for it and the dma_supported()
call on this device will fail. This also makes pci_set_dma_mask() fail
on this device. So it comes down to a BIOS bug. I look into it to find a
workaround.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

