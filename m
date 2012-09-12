Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2ILNoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:44:05 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:57054 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab2ILNoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:44:01 -0400
Date: Wed, 12 Sep 2012 16:39:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Cleanup the omap2_mcspi_txrx_dma
 function
Message-ID: <20120912133925.GP5732@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347345800-4116-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/6IVfYouxg+lu1D"
Content-Disposition: inline
In-Reply-To: <1347345800-4116-1-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5/6IVfYouxg+lu1D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2012 at 12:13:20PM +0530, Shubhrajyoti D wrote:
> Currently in omap2_mcspi_txrx_dma the tx and the rx support is
> interleaved. Make the rx related code in omap2_mcspi_rx_dma
> and the tx related code omap2_mcspi_tx_dma and call the functions.
>=20
> While at it remove the braces in the if statements which has only
> one line.
> Also fix ["foo * bar" to "foo *bar"] warn for the rx and tx variables.
>=20
> Only a cleanup no functional change.
>=20
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

I just tested this on my pandaboard by shorting out MISO and MOSI (since
panda doesn't have any clients on spi bus) and using spidev:

#  ./spidev_test -D /dev/spidev
spi mode: 0
bits per word: 8
max speed: 500000 Hz (500 KHz)

FF FF FF FF FF FF=20
40 00 00 00 00 95=20
FF FF FF FF FF FF=20
FF FF FF FF FF FF=20
FF FF FF FF FF FF=20
DE AD BE EF BA AD=20
F0 0D

=2E/spidev_test -D /dev/spidev -s 24000000
spi mode: 0
bits per word: 8
max speed: 24000000 Hz (24000 KHz)

FF FF FF FF FF FF=20
40 00 00 00 00 95=20
FF FF FF FF FF FF=20
FF FF FF FF FF FF=20
FF FF FF FF FF FF=20
DE AD BE EF BA AD=20
F0 0D

seems to be working fine (at least from my quick tests)

Tested-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/spi/spi-omap2-mcspi.c |  256 +++++++++++++++++++++++------------=
------
>  1 files changed, 144 insertions(+), 112 deletions(-)
>=20
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index 1c1dd34..dd8fc88 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -315,49 +315,27 @@ static void omap2_mcspi_tx_callback(void *data)
>  	omap2_mcspi_set_dma_req(spi, 0, 0);
>  }
> =20
> -static unsigned
> -omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
> +static void omap2_mcspi_tx_dma(struct spi_device *spi,
> +				struct spi_transfer *xfer,
> +				struct dma_slave_config cfg)
>  {
>  	struct omap2_mcspi	*mcspi;
> -	struct omap2_mcspi_cs	*cs =3D spi->controller_state;
>  	struct omap2_mcspi_dma  *mcspi_dma;
>  	unsigned int		count;
> -	int			word_len, element_count;
> -	int			elements =3D 0;
> -	u32			l;
>  	u8			* rx;
>  	const u8		* tx;
>  	void __iomem		*chstat_reg;
> -	struct dma_slave_config	cfg;
> -	enum dma_slave_buswidth width;
> -	unsigned es;
> +	struct omap2_mcspi_cs	*cs =3D spi->controller_state;
> =20
>  	mcspi =3D spi_master_get_devdata(spi->master);
>  	mcspi_dma =3D &mcspi->dma_channels[spi->chip_select];
> -	l =3D mcspi_cached_chconf0(spi);
> +	count =3D xfer->len;
> =20
> +	rx =3D xfer->rx_buf;
> +	tx =3D xfer->tx_buf;
>  	chstat_reg =3D cs->base + OMAP2_MCSPI_CHSTAT0;
> =20
> -	if (cs->word_len <=3D 8) {
> -		width =3D DMA_SLAVE_BUSWIDTH_1_BYTE;
> -		es =3D 1;
> -	} else if (cs->word_len <=3D 16) {
> -		width =3D DMA_SLAVE_BUSWIDTH_2_BYTES;
> -		es =3D 2;
> -	} else {
> -		width =3D DMA_SLAVE_BUSWIDTH_4_BYTES;
> -		es =3D 4;
> -	}
> -
> -	memset(&cfg, 0, sizeof(cfg));
> -	cfg.src_addr =3D cs->phys + OMAP2_MCSPI_RX0;
> -	cfg.dst_addr =3D cs->phys + OMAP2_MCSPI_TX0;
> -	cfg.src_addr_width =3D width;
> -	cfg.dst_addr_width =3D width;
> -	cfg.src_maxburst =3D 1;
> -	cfg.dst_maxburst =3D 1;
> -
> -	if (xfer->tx_buf && mcspi_dma->dma_tx) {
> +	if (mcspi_dma->dma_tx) {
>  		struct dma_async_tx_descriptor *tx;
>  		struct scatterlist sg;
> =20
> @@ -368,7 +346,7 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct s=
pi_transfer *xfer)
>  		sg_dma_len(&sg) =3D xfer->len;
> =20
>  		tx =3D dmaengine_prep_slave_sg(mcspi_dma->dma_tx, &sg, 1,
> -			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +		DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  		if (tx) {
>  			tx->callback =3D omap2_mcspi_tx_callback;
>  			tx->callback_param =3D spi;
> @@ -377,8 +355,50 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct =
spi_transfer *xfer)
>  			/* FIXME: fall back to PIO? */
>  		}
>  	}
> +	dma_async_issue_pending(mcspi_dma->dma_tx);
> +	omap2_mcspi_set_dma_req(spi, 0, 1);
> =20
> -	if (xfer->rx_buf && mcspi_dma->dma_rx) {
> +	wait_for_completion(&mcspi_dma->dma_tx_completion);
> +	dma_unmap_single(mcspi->dev, xfer->tx_dma, count,
> +			 DMA_TO_DEVICE);
> +
> +	/* for TX_ONLY mode, be sure all words have shifted out */
> +	if (rx =3D=3D NULL) {
> +		if (mcspi_wait_for_reg_bit(chstat_reg,
> +					OMAP2_MCSPI_CHSTAT_TXS) < 0)
> +			dev_err(&spi->dev, "TXS timed out\n");
> +		else if (mcspi_wait_for_reg_bit(chstat_reg,
> +					OMAP2_MCSPI_CHSTAT_EOT) < 0)
> +			dev_err(&spi->dev, "EOT timed out\n");
> +	}
> +}
> +
> +static unsigned
> +omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
> +				struct dma_slave_config cfg,
> +				unsigned es)
> +{
> +	struct omap2_mcspi	*mcspi;
> +	struct omap2_mcspi_dma  *mcspi_dma;
> +	unsigned int		count;
> +	u32			l;
> +	int			elements =3D 0;
> +	int			word_len, element_count;
> +	struct omap2_mcspi_cs	*cs =3D spi->controller_state;
> +	mcspi =3D spi_master_get_devdata(spi->master);
> +	mcspi_dma =3D &mcspi->dma_channels[spi->chip_select];
> +	count =3D xfer->len;
> +	word_len =3D cs->word_len;
> +	l =3D mcspi_cached_chconf0(spi);
> +
> +	if (word_len <=3D 8)
> +		element_count =3D count;
> +	else if (word_len <=3D 16)
> +		element_count =3D count >> 1;
> +	else /* word_len <=3D 32 */
> +		element_count =3D count >> 2;
> +
> +	if (mcspi_dma->dma_rx) {
>  		struct dma_async_tx_descriptor *tx;
>  		struct scatterlist sg;
>  		size_t len =3D xfer->len - es;
> @@ -393,108 +413,120 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, stru=
ct spi_transfer *xfer)
>  		sg_dma_len(&sg) =3D len;
> =20
>  		tx =3D dmaengine_prep_slave_sg(mcspi_dma->dma_rx, &sg, 1,
> -			DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +				DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT |
> +				DMA_CTRL_ACK);
>  		if (tx) {
>  			tx->callback =3D omap2_mcspi_rx_callback;
>  			tx->callback_param =3D spi;
>  			dmaengine_submit(tx);
>  		} else {
> -			/* FIXME: fall back to PIO? */
> -		}
> -	}
> -
> -	count =3D xfer->len;
> -	word_len =3D cs->word_len;
> -
> -	rx =3D xfer->rx_buf;
> -	tx =3D xfer->tx_buf;
> -
> -	if (word_len <=3D 8) {
> -		element_count =3D count;
> -	} else if (word_len <=3D 16) {
> -		element_count =3D count >> 1;
> -	} else /* word_len <=3D 32 */ {
> -		element_count =3D count >> 2;
> -	}
> -
> -	if (tx !=3D NULL) {
> -		dma_async_issue_pending(mcspi_dma->dma_tx);
> -		omap2_mcspi_set_dma_req(spi, 0, 1);
> -	}
> -
> -	if (rx !=3D NULL) {
> -		dma_async_issue_pending(mcspi_dma->dma_rx);
> -		omap2_mcspi_set_dma_req(spi, 1, 1);
> -	}
> -
> -	if (tx !=3D NULL) {
> -		wait_for_completion(&mcspi_dma->dma_tx_completion);
> -		dma_unmap_single(mcspi->dev, xfer->tx_dma, count,
> -				 DMA_TO_DEVICE);
> -
> -		/* for TX_ONLY mode, be sure all words have shifted out */
> -		if (rx =3D=3D NULL) {
> -			if (mcspi_wait_for_reg_bit(chstat_reg,
> -						OMAP2_MCSPI_CHSTAT_TXS) < 0)
> -				dev_err(&spi->dev, "TXS timed out\n");
> -			else if (mcspi_wait_for_reg_bit(chstat_reg,
> -						OMAP2_MCSPI_CHSTAT_EOT) < 0)
> -				dev_err(&spi->dev, "EOT timed out\n");
> +				/* FIXME: fall back to PIO? */
>  		}
>  	}
> =20
> -	if (rx !=3D NULL) {
> -		wait_for_completion(&mcspi_dma->dma_rx_completion);
> -		dma_unmap_single(mcspi->dev, xfer->rx_dma, count,
> -				 DMA_FROM_DEVICE);
> -		omap2_mcspi_set_enable(spi, 0);
> +	dma_async_issue_pending(mcspi_dma->dma_rx);
> +	omap2_mcspi_set_dma_req(spi, 1, 1);
> =20
> -		elements =3D element_count - 1;
> +	wait_for_completion(&mcspi_dma->dma_rx_completion);
> +	dma_unmap_single(mcspi->dev, xfer->rx_dma, count,
> +			 DMA_FROM_DEVICE);
> +	omap2_mcspi_set_enable(spi, 0);
> =20
> -		if (l & OMAP2_MCSPI_CHCONF_TURBO) {
> -			elements--;
> +	elements =3D element_count - 1;
> =20
> -			if (likely(mcspi_read_cs_reg(spi, OMAP2_MCSPI_CHSTAT0)
> -				   & OMAP2_MCSPI_CHSTAT_RXS)) {
> -				u32 w;
> -
> -				w =3D mcspi_read_cs_reg(spi, OMAP2_MCSPI_RX0);
> -				if (word_len <=3D 8)
> -					((u8 *)xfer->rx_buf)[elements++] =3D w;
> -				else if (word_len <=3D 16)
> -					((u16 *)xfer->rx_buf)[elements++] =3D w;
> -				else /* word_len <=3D 32 */
> -					((u32 *)xfer->rx_buf)[elements++] =3D w;
> -			} else {
> -				dev_err(&spi->dev,
> -					"DMA RX penultimate word empty");
> -				count -=3D (word_len <=3D 8)  ? 2 :
> -					(word_len <=3D 16) ? 4 :
> -					/* word_len <=3D 32 */ 8;
> -				omap2_mcspi_set_enable(spi, 1);
> -				return count;
> -			}
> -		}
> +	if (l & OMAP2_MCSPI_CHCONF_TURBO) {
> +		elements--;
> =20
>  		if (likely(mcspi_read_cs_reg(spi, OMAP2_MCSPI_CHSTAT0)
> -				& OMAP2_MCSPI_CHSTAT_RXS)) {
> +				   & OMAP2_MCSPI_CHSTAT_RXS)) {
>  			u32 w;
> =20
>  			w =3D mcspi_read_cs_reg(spi, OMAP2_MCSPI_RX0);
>  			if (word_len <=3D 8)
> -				((u8 *)xfer->rx_buf)[elements] =3D w;
> +				((u8 *)xfer->rx_buf)[elements++] =3D w;
>  			else if (word_len <=3D 16)
> -				((u16 *)xfer->rx_buf)[elements] =3D w;
> +				((u16 *)xfer->rx_buf)[elements++] =3D w;
>  			else /* word_len <=3D 32 */
> -				((u32 *)xfer->rx_buf)[elements] =3D w;
> +				((u32 *)xfer->rx_buf)[elements++] =3D w;
>  		} else {
> -			dev_err(&spi->dev, "DMA RX last word empty");
> -			count -=3D (word_len <=3D 8)  ? 1 :
> -				 (word_len <=3D 16) ? 2 :
> -			       /* word_len <=3D 32 */ 4;
> +			dev_err(&spi->dev, "DMA RX penultimate word empty");
> +			count -=3D (word_len <=3D 8)  ? 2 :
> +				(word_len <=3D 16) ? 4 :
> +				/* word_len <=3D 32 */ 8;
> +			omap2_mcspi_set_enable(spi, 1);
> +			return count;
>  		}
> -		omap2_mcspi_set_enable(spi, 1);
>  	}
> +	if (likely(mcspi_read_cs_reg(spi, OMAP2_MCSPI_CHSTAT0)
> +				& OMAP2_MCSPI_CHSTAT_RXS)) {
> +		u32 w;
> +
> +		w =3D mcspi_read_cs_reg(spi, OMAP2_MCSPI_RX0);
> +		if (word_len <=3D 8)
> +			((u8 *)xfer->rx_buf)[elements] =3D w;
> +		else if (word_len <=3D 16)
> +			((u16 *)xfer->rx_buf)[elements] =3D w;
> +		else /* word_len <=3D 32 */
> +			((u32 *)xfer->rx_buf)[elements] =3D w;
> +	} else {
> +		dev_err(&spi->dev, "DMA RX last word empty");
> +		count -=3D (word_len <=3D 8)  ? 1 :
> +			 (word_len <=3D 16) ? 2 :
> +		       /* word_len <=3D 32 */ 4;
> +	}
> +	omap2_mcspi_set_enable(spi, 1);
> +	return count;
> +}
> +
> +static unsigned
> +omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
> +{
> +	struct omap2_mcspi	*mcspi;
> +	struct omap2_mcspi_cs	*cs =3D spi->controller_state;
> +	struct omap2_mcspi_dma  *mcspi_dma;
> +	unsigned int		count;
> +	u32			l;
> +	u8			*rx;
> +	const u8		*tx;
> +	struct dma_slave_config	cfg;
> +	enum dma_slave_buswidth width;
> +	unsigned es;
> +
> +	mcspi =3D spi_master_get_devdata(spi->master);
> +	mcspi_dma =3D &mcspi->dma_channels[spi->chip_select];
> +	l =3D mcspi_cached_chconf0(spi);
> +
> +
> +	if (cs->word_len <=3D 8) {
> +		width =3D DMA_SLAVE_BUSWIDTH_1_BYTE;
> +		es =3D 1;
> +	} else if (cs->word_len <=3D 16) {
> +		width =3D DMA_SLAVE_BUSWIDTH_2_BYTES;
> +		es =3D 2;
> +	} else {
> +		width =3D DMA_SLAVE_BUSWIDTH_4_BYTES;
> +		es =3D 4;
> +	}
> +
> +	memset(&cfg, 0, sizeof(cfg));
> +	cfg.src_addr =3D cs->phys + OMAP2_MCSPI_RX0;
> +	cfg.dst_addr =3D cs->phys + OMAP2_MCSPI_TX0;
> +	cfg.src_addr_width =3D width;
> +	cfg.dst_addr_width =3D width;
> +	cfg.src_maxburst =3D 1;
> +	cfg.dst_maxburst =3D 1;
> +
> +	rx =3D xfer->rx_buf;
> +	tx =3D xfer->tx_buf;
> +
> +	count =3D xfer->len;
> +
> +	if (tx !=3D NULL)
> +		omap2_mcspi_tx_dma(spi, xfer, cfg);
> +
> +	if (rx !=3D NULL)
> +		return omap2_mcspi_rx_dma(spi, xfer, cfg, es);
> +
>  	return count;
>  }
> =20
> --=20
> 1.7.5.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--5/6IVfYouxg+lu1D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQUJCNAAoJEIaOsuA1yqRErNoP/2p+ztAnpF3eeV/ZpMmEorrG
ieW+KT9XUFFNKZl4dLphnsRJOsQLesCeZoN6W04yVGYWLB4u6rWztKNyPspEdm0n
kioVE9v54xh+2WLF26G4pZwb1qwVXkVy4OswAuhSrSViTA9nN4wKwhQEjKJDWAmv
VaSZWdPrGRjtRPHLAYj9mRiKO572XFiNSmvQIQyo9GBCfck1HL0dujqaCnGex4Qn
3cSGLkSf9PWtlVKGjmO+Qys2q12Y1qXUTdyUZsqx69MIAqC78/pBTTMcxuzJ/V3p
sYBJi6vmTk/mIgBirX4esI9FtdSULPXKeO5GJTqITvllT1CtiAfzbiWdow8EQJr/
hzczLSva3qOkTB0MqH3+YoWHZmK0XxPTZ4VeNLQLE8vlTGfNq4+sAkD/U6JEhwZP
89ejpBCx2+N3bG++yRC+YdHSlUlzkOxksR5ZfVcPYhNNGPQmhnqGwbi8gqpzp5fH
IyonPzejXZ7pWgseF/N9t9Z0RNlacUrddLHgbjW5E2pfrw/FoazlN4kOXyhvK01Z
6boqB7m3rBQfh9e3N7GmrmQbDrZu7D/8dDvRLe7W3M0rZUEk73hR+yXBNBzAEbCM
EZOOu3E2Grtrwi4ZJcGdutvj9HUlJRiLDHHP2kglUsFtl51Bthp+7JG7ghde1oK7
0TIMJ3SKvucDULGK42xr
=TSAm
-----END PGP SIGNATURE-----

--5/6IVfYouxg+lu1D--
