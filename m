Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1IWXcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:32:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54349 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1IWXcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:32:08 -0400
Date: Fri, 23 Sep 2011 17:32:04 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Michael Thalmeier <michael.thalmeier@hale.at>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: detect wrong transfer->len values
Message-ID: <20110923233204.GJ24631@ponder.secretlab.ca>
References: <1316779158-12578-1-git-send-email-michael.thalmeier@hale.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316779158-12578-1-git-send-email-michael.thalmeier@hale.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 01:59:18PM +0200, Michael Thalmeier wrote:
> From: Helmut Raiger <helmut.raiger@hale.at>
> 
> 
> Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
> ---
>  drivers/spi/spi.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 4d1b9f5..70adac3 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -760,6 +760,17 @@ EXPORT_SYMBOL_GPL(spi_setup);
>  static int __spi_async(struct spi_device *spi, struct spi_message *message)
>  {
>  	struct spi_master *master = spi->master;
> +	struct spi_transfer *xfer;
> +
> +	/* check if number of bytes relates to bits per word mode */
> +	list_for_each_entry(xfer, &message->transfers, transfer_list) {
> +		u8 bpw = xfer->bits_per_word ?
> +				xfer->bits_per_word : spi->bits_per_word;
> +
> +		if ((bpw == 16 && (xfer->len & 1)) ||
> +			(bpw == 32 && (xfer->len & 3)))
> +			return -EINVAL;
> +	}

Rather than turning this into a hard fail; you should make it a
WARN_ONCE().  I wouldn't be surprised if a lot of drivers have the bad
behaviour, and applying this patch could have far reaching
consequences, including boards failing to boot.

g.

>  
>  	/* Half-duplex links include original MicroWire, and ones with
>  	 * only one data pin like SPI_3WIRE (switches direction) or where
> @@ -768,7 +779,6 @@ static int __spi_async(struct spi_device *spi, struct spi_message *message)
>  	 */
>  	if ((master->flags & SPI_MASTER_HALF_DUPLEX)
>  			|| (spi->mode & SPI_3WIRE)) {
> -		struct spi_transfer *xfer;

Unrelated change?

>  		unsigned flags = master->flags;
>  
>  		list_for_each_entry(xfer, &message->transfers, transfer_list) {
> -- 
> 1.7.6.2
> 
> 
> 
> --
> Scanned by MailScanner.
> 
