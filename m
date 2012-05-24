Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab2EXWSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:18:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab2EXWSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:18:14 -0400
Message-ID: <1337897864.4714.57.camel@ul30vt>
Subject: Re: [PATCH v2 12/13] pci: Misc pci_reg additions
From: Alex Williamson <alex.williamson@redhat.com>
To: Don Dutile <ddutile@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Date: Thu, 24 May 2012 16:17:44 -0600
In-Reply-To: <4FBEACE2.1050701@redhat.com>
References: <20120522043607.5871.11340.stgit@bling.home>
	 <20120522050557.5871.15364.stgit@bling.home> <4FBEACE2.1050701@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 17:49 -0400, Don Dutile wrote:
> On 05/22/2012 01:05 AM, Alex Williamson wrote:
> > Fill in many missing definitions and add sizeof fields for many
> > sections allowing for more extensive config parsing.
> >
> > Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
> > ---
> >
> overall, i'm very glad to see defines instead of hardcoded numbers in the code, but....
> 
> >   include/linux/pci_regs.h |  112 +++++++++++++++++++++++++++++++++++++++++-----
> >   1 files changed, 100 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
> > index 4b608f5..379be84 100644
> > --- a/include/linux/pci_regs.h
> > +++ b/include/linux/pci_regs.h
> > @@ -26,6 +26,7 @@
> >    * Under PCI, each device has 256 bytes of configuration address space,
> >    * of which the first 64 bytes are standardized as follows:
> >    */
> > +#define PCI_STD_HEADER_SIZEOF	64
> >   #define PCI_VENDOR_ID		0x00	/* 16 bits */
> >   #define PCI_DEVICE_ID		0x02	/* 16 bits */
> >   #define PCI_COMMAND		0x04	/* 16 bits */
> > @@ -209,9 +210,12 @@
> >   #define  PCI_CAP_ID_SHPC 	0x0C	/* PCI Standard Hot-Plug Controller */
> >   #define  PCI_CAP_ID_SSVID	0x0D	/* Bridge subsystem vendor/device ID */
> >   #define  PCI_CAP_ID_AGP3	0x0E	/* AGP Target PCI-PCI bridge */
> > +#define  PCI_CAP_ID_SECDEV	0x0F	/* Secure Device */
> >   #define  PCI_CAP_ID_EXP 	0x10	/* PCI Express */
> >   #define  PCI_CAP_ID_MSIX	0x11	/* MSI-X */
> > +#define  PCI_CAP_ID_SATA	0x12	/* SATA Data/Index Conf. */
> >   #define  PCI_CAP_ID_AF		0x13	/* PCI Advanced Features */
> > +#define  PCI_CAP_ID_MAX		PCI_CAP_ID_AF
> >   #define PCI_CAP_LIST_NEXT	1	/* Next capability in the list */
> >   #define PCI_CAP_FLAGS		2	/* Capability defined flags (16 bits) */
> >   #define PCI_CAP_SIZEOF		4
> > @@ -276,6 +280,7 @@
> >   #define  PCI_VPD_ADDR_MASK	0x7fff	/* Address mask */
> >   #define  PCI_VPD_ADDR_F		0x8000	/* Write 0, 1 indicates completion */
> >   #define PCI_VPD_DATA		4	/* 32-bits of data returned here */
> > +#define PCI_CAP_VPD_SIZEOF	8
> >
> >   /* Slot Identification */
> >
> > @@ -297,8 +302,10 @@
> >   #define PCI_MSI_ADDRESS_HI	8	/* Upper 32 bits (if PCI_MSI_FLAGS_64BIT set) */
> >   #define PCI_MSI_DATA_32		8	/* 16 bits of data for 32-bit devices */
> >   #define PCI_MSI_MASK_32		12	/* Mask bits register for 32-bit devices */
> > +#define PCI_MSI_PENDING_32	16	/* Pending intrs for 32-bit devices */
> >   #define PCI_MSI_DATA_64		12	/* 16 bits of data for 64-bit devices */
> >   #define PCI_MSI_MASK_64		16	/* Mask bits register for 64-bit devices */
> > +#define PCI_MSI_PENDING_64	20	/* Pending intrs for 64-bit devices */
> >
> >   /* MSI-X registers */
> >   #define PCI_MSIX_FLAGS		2
> > @@ -308,6 +315,7 @@
> >   #define PCI_MSIX_TABLE		4
> >   #define PCI_MSIX_PBA		8
> >   #define  PCI_MSIX_FLAGS_BIRMASK	(7<<  0)
> > +#define PCI_CAP_MSIX_SIZEOF	12	/* size of MSIX registers */
> >
> >   /* MSI-X entry's format */
> >   #define PCI_MSIX_ENTRY_SIZE		16
> > @@ -338,6 +346,7 @@
> >   #define  PCI_AF_CTRL_FLR	0x01
> >   #define PCI_AF_STATUS		5
> >   #define  PCI_AF_STATUS_TP	0x01
> > +#define PCI_CAP_AF_SIZEOF	6	/* size of AF registers */
> >
> >   /* PCI-X registers */
> >
> > @@ -374,6 +383,9 @@
> >   #define  PCI_X_STATUS_SPL_ERR	0x20000000	/* Rcvd Split Completion Error Msg */
> >   #define  PCI_X_STATUS_266MHZ	0x40000000	/* 266 MHz capable */
> >   #define  PCI_X_STATUS_533MHZ	0x80000000	/* 533 MHz capable */
> > +#define PCI_X_ECC_CSR		8	/* ECC control and status */
> > +#define PCI_CAP_PCIX_SIZEOF_V0	8	/* size of registers for Version 0 */
> > +#define PCI_CAP_PCIX_SIZEOF_V12	24	/* size for Version 1&  2 */
> ew!
> unlikely that version 12 will ever exist, but why not:
> #define PCI_CAP_PCIX_SIZEOF_V1	24
> #define PCI_CAP_PCIX_SIZEOF_V2	PCI_CAP_PCIX_SIZEOF_V1

Works for me, will fix.  Thanks,

Alex

