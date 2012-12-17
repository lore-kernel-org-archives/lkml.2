Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2LQR6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:58:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33020 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2LQR6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:58:44 -0500
Date: Mon, 17 Dec 2012 17:58:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        linux-samsung-soc@vger.kernel.org, jonas.gorski@gmail.com,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        ben-linux@fluff.org, baohua.song@csr.com, linux-tegra@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] spi: remove check for bits_per_word on transfer
Message-ID: <20121217175826.GU14363@n2100.arm.linux.org.uk>
References: <1355766718-2040-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355766718-2040-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:21:57PM +0530, Laxman Dewangan wrote:
> When spi client does the spi transfer and does not sets
> the bits_per_word for each transfer then set it as default
> of spi device in spi core before calling low level transfer.

Err, sorry?  To me, the above doesn't make too much sense when considering
what's in the patch.  Please can you improve the description?  Thanks.

> 
> Removing the similar code from different low level drivers as
> it its duplicate checks and it is no more require.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> This is the continuation of feedback got from Jonas on
> change
> spi: make sure all transfer has bits_per_word set
> where I made the change in only tegra slink driver.
> This patch remove the similar code form all drivers.
> 
>  drivers/spi/spi-altera.c        |    2 +-
>  drivers/spi/spi-bfin-sport.c    |    3 +--
>  drivers/spi/spi-bfin5xx.c       |    3 +--
>  drivers/spi/spi-bitbang.c       |    6 +++---
>  drivers/spi/spi-clps711x.c      |    2 +-
>  drivers/spi/spi-coldfire-qspi.c |    3 +--
>  drivers/spi/spi-ep93xx.c        |    2 +-
>  drivers/spi/spi-s3c64xx.c       |    2 +-
>  drivers/spi/spi-sirf.c          |    3 +--
>  drivers/spi/spi-tegra20-slink.c |    9 +++------
>  drivers/spi/spi-txx9.c          |    6 ++----
>  11 files changed, 16 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/spi/spi-altera.c b/drivers/spi/spi-altera.c
> index 5e7314a..a537f8d 100644
> --- a/drivers/spi/spi-altera.c
> +++ b/drivers/spi/spi-altera.c
> @@ -134,7 +134,7 @@ static int altera_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
>  	hw->tx = t->tx_buf;
>  	hw->rx = t->rx_buf;
>  	hw->count = 0;
> -	hw->bytes_per_word = (t->bits_per_word ? : spi->bits_per_word) / 8;
> +	hw->bytes_per_word = t->bits_per_word / 8;
>  	hw->len = t->len / hw->bytes_per_word;
>  
>  	if (hw->irq >= 0) {
> diff --git a/drivers/spi/spi-bfin-sport.c b/drivers/spi/spi-bfin-sport.c
> index ac7ffca..39b0d17 100644
> --- a/drivers/spi/spi-bfin-sport.c
> +++ b/drivers/spi/spi-bfin-sport.c
> @@ -416,8 +416,7 @@ bfin_sport_spi_pump_transfers(unsigned long data)
>  	drv_data->cs_change = transfer->cs_change;
>  
>  	/* Bits per word setup */
> -	bits_per_word = transfer->bits_per_word ? :
> -		message->spi->bits_per_word ? : 8;
> +	bits_per_word = transfer->bits_per_word;
>  	if (bits_per_word % 16 == 0)
>  		drv_data->ops = &bfin_sport_transfer_ops_u16;
>  	else
> diff --git a/drivers/spi/spi-bfin5xx.c b/drivers/spi/spi-bfin5xx.c
> index 0429d83..7d7c991 100644
> --- a/drivers/spi/spi-bfin5xx.c
> +++ b/drivers/spi/spi-bfin5xx.c
> @@ -642,8 +642,7 @@ static void bfin_spi_pump_transfers(unsigned long data)
>  	drv_data->cs_change = transfer->cs_change;
>  
>  	/* Bits per word setup */
> -	bits_per_word = transfer->bits_per_word ? :
> -		message->spi->bits_per_word ? : 8;
> +	bits_per_word = transfer->bits_per_word;
>  	if (bits_per_word % 16 == 0) {
>  		drv_data->n_bytes = bits_per_word/8;
>  		drv_data->len = (transfer->len) >> 1;
> diff --git a/drivers/spi/spi-bitbang.c b/drivers/spi/spi-bitbang.c
> index 8b3d8ef..61beaec 100644
> --- a/drivers/spi/spi-bitbang.c
> +++ b/drivers/spi/spi-bitbang.c
> @@ -69,7 +69,7 @@ static unsigned bitbang_txrx_8(
>  	unsigned		ns,
>  	struct spi_transfer	*t
>  ) {
> -	unsigned		bits = t->bits_per_word ? : spi->bits_per_word;
> +	unsigned		bits = t->bits_per_word;
>  	unsigned		count = t->len;
>  	const u8		*tx = t->tx_buf;
>  	u8			*rx = t->rx_buf;
> @@ -95,7 +95,7 @@ static unsigned bitbang_txrx_16(
>  	unsigned		ns,
>  	struct spi_transfer	*t
>  ) {
> -	unsigned		bits = t->bits_per_word ? : spi->bits_per_word;
> +	unsigned		bits = t->bits_per_word;
>  	unsigned		count = t->len;
>  	const u16		*tx = t->tx_buf;
>  	u16			*rx = t->rx_buf;
> @@ -121,7 +121,7 @@ static unsigned bitbang_txrx_32(
>  	unsigned		ns,
>  	struct spi_transfer	*t
>  ) {
> -	unsigned		bits = t->bits_per_word ? : spi->bits_per_word;
> +	unsigned		bits = t->bits_per_word;
>  	unsigned		count = t->len;
>  	const u32		*tx = t->tx_buf;
>  	u32			*rx = t->rx_buf;
> diff --git a/drivers/spi/spi-clps711x.c b/drivers/spi/spi-clps711x.c
> index 1366c46..a11cbf0 100644
> --- a/drivers/spi/spi-clps711x.c
> +++ b/drivers/spi/spi-clps711x.c
> @@ -68,7 +68,7 @@ static int spi_clps711x_setup_xfer(struct spi_device *spi,
>  				   struct spi_transfer *xfer)
>  {
>  	u32 speed = xfer->speed_hz ? : spi->max_speed_hz;
> -	u8 bpw = xfer->bits_per_word ? : spi->bits_per_word;
> +	u8 bpw = xfer->bits_per_word;
>  	struct spi_clps711x_data *hw = spi_master_get_devdata(spi->master);
>  
>  	if (bpw != 8) {
> diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
> index 58466b8..7b5cc9e 100644
> --- a/drivers/spi/spi-coldfire-qspi.c
> +++ b/drivers/spi/spi-coldfire-qspi.c
> @@ -329,8 +329,7 @@ static int mcfqspi_transfer_one_message(struct spi_master *master,
>  		mcfqspi_cs_select(mcfqspi, spi->chip_select, cs_high);
>  
>  		mcfqspi_wr_qir(mcfqspi, MCFQSPI_QIR_SPIFE);
> -		if ((t->bits_per_word ? t->bits_per_word :
> -					spi->bits_per_word) == 8)
> +		if (t->bits_per_word == 8)
>  			mcfqspi_transfer_msg8(mcfqspi, t->len, t->tx_buf,
>  					t->rx_buf);
>  		else
> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index acb1e19..aecbff1 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -446,7 +446,7 @@ static inline int bits_per_word(const struct ep93xx_spi *espi)
>  	struct spi_message *msg = espi->current_msg;
>  	struct spi_transfer *t = msg->state;
>  
> -	return t->bits_per_word ? t->bits_per_word : msg->spi->bits_per_word;
> +	return t->bits_per_word;
>  }
>  
>  static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index 4dd7b7c..ab0c0e4 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -697,7 +697,7 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
>  		INIT_COMPLETION(sdd->xfer_completion);
>  
>  		/* Only BPW and Speed may change across transfers */
> -		bpw = xfer->bits_per_word ? : spi->bits_per_word;
> +		bpw = xfer->bits_per_word;
>  		speed = xfer->speed_hz ? : spi->max_speed_hz;
>  
>  		if (xfer->len % (bpw / 8)) {
> diff --git a/drivers/spi/spi-sirf.c b/drivers/spi/spi-sirf.c
> index e0f43a5..7506667 100644
> --- a/drivers/spi/spi-sirf.c
> +++ b/drivers/spi/spi-sirf.c
> @@ -382,8 +382,7 @@ spi_sirfsoc_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
>  
>  	sspi = spi_master_get_devdata(spi->master);
>  
> -	bits_per_word = t && t->bits_per_word ? t->bits_per_word :
> -		spi->bits_per_word;
> +	bits_per_word = (t) ? t->bits_per_word : spi->bits_per_word;
>  	hz = t && t->speed_hz ? t->speed_hz : spi->max_speed_hz;
>  
>  	/* Enable IO mode for RX, TX */
> diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
> index 651167f..7a95bdd 100644
> --- a/drivers/spi/spi-tegra20-slink.c
> +++ b/drivers/spi/spi-tegra20-slink.c
> @@ -284,8 +284,7 @@ static unsigned tegra_slink_calculate_curr_xfer_param(
>  	unsigned max_len;
>  	unsigned total_fifo_words;
>  
> -	bits_per_word = t->bits_per_word ? t->bits_per_word :
> -						spi->bits_per_word;
> +	bits_per_word = t->bits_per_word;
>  	tspi->bytes_per_word = (bits_per_word - 1) / 8 + 1;
>  
>  	if (bits_per_word == 8 || bits_per_word == 16) {
> @@ -378,8 +377,7 @@ static unsigned int tegra_slink_read_rx_fifo_to_client_rxbuf(
>  	} else {
>  		unsigned int bits_per_word;
>  
> -		bits_per_word = t->bits_per_word ? t->bits_per_word :
> -						tspi->cur_spi->bits_per_word;
> +		bits_per_word = t->bits_per_word;
>  		for (count = 0; count < rx_full_count; count++) {
>  			x = tegra_slink_readl(tspi, SLINK_RX_FIFO);
>  			for (i = 0; (i < tspi->bytes_per_word); i++)
> @@ -444,8 +442,7 @@ static void tegra_slink_copy_spi_rxbuf_to_client_rxbuf(
>  		unsigned int x;
>  		unsigned int rx_mask, bits_per_word;
>  
> -		bits_per_word = t->bits_per_word ? t->bits_per_word :
> -						tspi->cur_spi->bits_per_word;
> +		bits_per_word = t->bits_per_word;
>  		rx_mask = (1 << bits_per_word) - 1;
>  		for (count = 0; count < tspi->curr_dma_words; count++) {
>  			x = tspi->rx_dma_buf[count];
> diff --git a/drivers/spi/spi-txx9.c b/drivers/spi/spi-txx9.c
> index d5a3cbb..550b5f4 100644
> --- a/drivers/spi/spi-txx9.c
> +++ b/drivers/spi/spi-txx9.c
> @@ -189,9 +189,8 @@ static void txx9spi_work_one(struct txx9spi *c, struct spi_message *m)
>  		unsigned int len = t->len;
>  		unsigned int wsize;
>  		u32 speed_hz = t->speed_hz ? : spi->max_speed_hz;
> -		u8 bits_per_word = t->bits_per_word ? : spi->bits_per_word;
> +		u8 bits_per_word = t->bits_per_word;
>  
> -		bits_per_word = bits_per_word ? : 8;
>  		wsize = bits_per_word >> 3; /* in bytes */
>  
>  		if (prev_speed_hz != speed_hz
> @@ -316,9 +315,8 @@ static int txx9spi_transfer(struct spi_device *spi, struct spi_message *m)
>  	/* check each transfer's parameters */
>  	list_for_each_entry (t, &m->transfers, transfer_list) {
>  		u32 speed_hz = t->speed_hz ? : spi->max_speed_hz;
> -		u8 bits_per_word = t->bits_per_word ? : spi->bits_per_word;
> +		u8 bits_per_word = t->bits_per_word;
>  
> -		bits_per_word = bits_per_word ? : 8;
>  		if (!t->tx_buf && !t->rx_buf && t->len)
>  			return -EINVAL;
>  		if (bits_per_word != 8 && bits_per_word != 16)
> -- 
> 1.7.1.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
