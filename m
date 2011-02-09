Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1BIJLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:11:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab1BIJLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:11:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=sTAnHiYfsEJ1D+rFwo91eDu7zt7Lb4LB4bWdnrAYlVX9tYwdJvig5Ik8adfwNwjkUD
         blHEhpbJaWkV+U0Q0v8W+A1kUkjlb3Eb8g6I2coI7bxXLEaWwdrC4GCijah8QBpH8QSi
         kPOurSdWrjbtGdt947cVsEgKX2WZZiUx52JrE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 21/20] ata_piix: add new PIIX_FLAG_* flags
Date: Wed, 9 Feb 2011 10:10:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <201102081652.36752.bzolnier@gmail.com> <AANLkTikyV579TRSMw_g_rTB7C641fWbdSELP9mpa30bG@mail.gmail.com> <4D518BBC.8050904@ru.mvista.com>
In-Reply-To: <4D518BBC.8050904@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <201102091010.24914.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:

> Bartlomiej Zolnierkiewicz wrote:
> 
> >>> Turn open-coded checks in piix_set_timings() into PIIX_FLAG_* flags
> >>> per suggestion from Alan Cox.
> >>> Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> >>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> [...]
> 
> >>> Index: b/drivers/ata/ata_piix.c
> >>> ===================================================================
> >>> --- a/drivers/ata/ata_piix.c
> >>> +++ b/drivers/ata/ata_piix.c
> >>> @@ -133,6 +133,8 @@ enum {
> >>>        PIIX_FLAG_CHECKINTR     = (1 << 28), /* make sure PCI INTx enabled
> >>> */
> >>>        PIIX_FLAG_SIDPR         = (1 << 29), /* SATA idx/data pair regs */
> >>> +       PIIX_FLAG_NO_SITRE      = (1 << 30), /* no SITRE register */
> 
> >>   The register in question is called SIDETIM, SITRE is a bit that enables
> >> its use.
> 
> > ICH4-M databook that I have at hand (Intel IDE PRM seems to be gone
> > from Intel's website, though I'm sure I have a backup _somewhere_) it
> > is called SLV_IDETIM so lets just stick with the current naming for
> > now..
> 
>     Why not just say that SITRE is a bit, not register? :-)

Good point.. :-)

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2 21/20] ata_piix: add new PIIX_FLAG_* flags

Turn open-coded checks in piix_set_timings() into PIIX_FLAG_* flags
per suggestion from Alan Cox.

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
On top of https://lkml.org/lkml/2011/2/8/97 patchset.

v2: s/SITRE register/SITRE bit/ per Sergei's comment

 drivers/ata/ata_piix.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -133,6 +133,8 @@ enum {
 
 	PIIX_FLAG_CHECKINTR	= (1 << 28), /* make sure PCI INTx enabled */
 	PIIX_FLAG_SIDPR		= (1 << 29), /* SATA idx/data pair regs */
+	PIIX_FLAG_NO_SITRE	= (1 << 30), /* no SITRE bit */
+	PIIX_FLAG_RADISYS	= (1 << 31), /* host is Radisys R82600 */
 
 	PIIX_PATA_FLAGS		= ATA_FLAG_SLAVE_POSS,
 	PIIX_SATA_FLAGS		= ATA_FLAG_SATA | PIIX_FLAG_CHECKINTR,
@@ -698,7 +700,7 @@ static struct ata_port_info piix_port_in
 
 	[oldpiix_pata] =
 	{
-		.flags		= PIIX_PATA_FLAGS,
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_NO_SITRE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.port_ops	= &oldpiix_pata_ops,
@@ -706,7 +708,8 @@ static struct ata_port_info piix_port_in
 
 	[radisys_pata] =
 	{
-		.flags		= PIIX_PATA_FLAGS,
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_NO_SITRE |
+				  PIIX_FLAG_RADISYS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.udma_mask	= ATA_UDMA24_ONLY,
@@ -859,10 +862,8 @@ static void piix_set_timings(struct ata_
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned long flags;
 	unsigned int is_slave	= (adev->devno != 0);
-	unsigned int is_radisys	= (dev->vendor == PCI_VENDOR_ID_RADISYS &&
-				   dev->device == 0x8201);
-	unsigned int has_sitre	= (dev->vendor != PCI_VENDOR_ID_INTEL ||
-				   dev->device != 0x1230) && !is_radisys;
+	unsigned int is_radisys	= (ap->flags & PIIX_FLAG_RADISYS) ? 1 : 0;
+	unsigned int has_sitre	= (ap->flags & PIIX_FLAG_NO_SITRE) ? 0 : 1;
 	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
 	unsigned int slave_port	= 0x44;
 	u16 master_data;
