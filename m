Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1IFWqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 18:46:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45655 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754537Ab1IFWqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 18:46:23 -0400
Date: Tue, 6 Sep 2011 23:45:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan McGee <dpmcgee@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] pata_sis: enable MWDMA for UDMA 133 chipset
Message-ID: <20110906234531.5b79867f@lxorguk.ukuu.org.uk>
In-Reply-To: <1315343358-12391-1-git-send-email-dpmcgee@gmail.com>
References: <1315343358-12391-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Sep 2011 16:09:18 -0500
Dan McGee <dpmcgee@gmail.com> wrote:

> This ports the timing values over from the old IDE driver into the new
> PATA-based one. The comment was lying when it stated the old driver was
> not MWDMA capable.

The comment was correct when the driver work was done, but Bartlomiej
then sorted out the old driver.

> 
> Boot tested on actual hardware using 'libata.force=mwdma2'.

Excellent - looks good to me.

> 
> Signed-off-by: Dan McGee <dpmcgee@gmail.com>
> ---
>  drivers/ata/pata_sis.c |   27 +++++++++++++++++----------
>  1 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
> index 810b7d6..9f11a8e 100644
> --- a/drivers/ata/pata_sis.c
> +++ b/drivers/ata/pata_sis.c
> @@ -293,14 +293,14 @@ static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
>  	u32 t1;
>  	int speed = adev->pio_mode - XFER_PIO_0;
>  
> -	const u32 timing133[] = {
> +	static const u32 timing133[] = {
>  		0x28269000,	/* Recovery << 24 | Act << 16 | Ini << 12 */
>  		0x0C266000,
>  		0x04263000,
>  		0x0C0A3000,
>  		0x05093000
>  	};
> -	const u32 timing100[] = {
> +	static const u32 timing100[] = {
>  		0x1E1C6000,	/* Recovery << 24 | Act << 16 | Ini << 12 */
>  		0x091C4000,
>  		0x031C2000,
> @@ -485,21 +485,28 @@ static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
>  	int port;
>  	u32 t1;
>  
> -	/* bits 4- cycle time 8 - cvs time */
> -	static const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
> -	static const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
> -
>  	port = sis_port_base(adev);
>  	pci_read_config_dword(pdev, port, &t1);
>  
>  	if (adev->dma_mode < XFER_UDMA_0) {
> +		/* Recovery << 24 | Act << 16 | Ini << 12, like PIO modes */
> +		static const u32 timing_u100[] = { 0x19154000, 0x06072000, 0x04062000 };
> +		static const u32 timing_u133[] = { 0x221C6000, 0x0C0A3000, 0x05093000 };
> +		int speed = adev->dma_mode - XFER_MW_DMA_0;
> +		t1 &= 0xC0C00FFF;
> +		/* disable UDMA */
>  		t1 &= ~0x00000004;
> -		/* FIXME: need data sheet to add MWDMA here. Also lacking on
> -		   ide/pci driver */
> +		if (t1 & 0x08)
> +			t1 |= timing_u133[speed];
> +		else
> +			t1 |= timing_u100[speed];
>  	} else {
> +		/* bits 4- cycle time 8 - cvs time */
> +		static const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
> +		static const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
>  		int speed = adev->dma_mode - XFER_UDMA_0;
> -		/* if & 8 no UDMA133 - need info for ... */
>  		t1 &= ~0x00000FF0;
> +		/* enable UDMA */
>  		t1 |= 0x00000004;
>  		if (t1 & 0x08)
>  			t1 |= timing_u133[speed];
> @@ -620,7 +627,7 @@ static const struct ata_port_info sis_info100_early = {
>  static const struct ata_port_info sis_info133 = {
>  	.flags		= ATA_FLAG_SLAVE_POSS,
>  	.pio_mask	= ATA_PIO4,
> -	/* No MWDMA */
> +	.mwdma_mask	= ATA_MWDMA2,
>  	.udma_mask	= ATA_UDMA6,
>  	.port_ops	= &sis_133_ops,
>  };


-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
