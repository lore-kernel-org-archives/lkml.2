Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0IPUPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:15:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33761 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab0IPUP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:15:29 -0400
Date: Thu, 16 Sep 2010 14:15:26 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: christophe leroy <christophe.leroy@c-s.fr>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] spi_mpc8xxx: fix buffer overrun when sending
 only/receiving only more than PAGE_SIZE bytes
Message-ID: <20100916201526.GB11972@angua.secretlab.ca>
References: <20100916070525.4882CC7391@messagerie.si.c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916070525.4882CC7391@messagerie.si.c-s.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 09:05:25AM +0200, christophe leroy wrote:
> This patch applies to 2.6.34.7 and 2.6.35.4
> It fixes an issue when sending only or receiving only more than PAGE_SIZE bytes
> 
> Signed-off-by: christophe leroy <christophe.leroy@c-s.fr>

applied to merge-spi branch, thanks.

g.

> 
> diff -urN c/drivers/spi/spi_mpc8xxx.c d/drivers/spi/spi_mpc8xxx.c
> --- c/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:44:03.000000000 +0200
> +++ d/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:44:14.000000000 +0200
> @@ -393,11 +393,17 @@
>  
>  	xfer_ofs = mspi->xfer_in_progress->len - mspi->count;
>  
> -	out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma + xfer_ofs);
> +	if (mspi->rx_dma == mspi->dma_dummy_rx)
> +		out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma);
> +	else
> +		out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma + xfer_ofs);
>  	out_be16(&rx_bd->cbd_datlen, 0);
>  	out_be16(&rx_bd->cbd_sc, BD_SC_EMPTY | BD_SC_INTRPT | BD_SC_WRAP);
>  
> -	out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma + xfer_ofs);
> +	if (mspi->tx_dma == mspi->dma_dummy_tx)
> +		out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma);
> +	else
> +		out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma + xfer_ofs);
>  	out_be16(&tx_bd->cbd_datlen, xfer_len);
>  	out_be16(&tx_bd->cbd_sc, BD_SC_READY | BD_SC_INTRPT | BD_SC_WRAP |
>  				 BD_SC_LAST);
