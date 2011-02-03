Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab1BCPUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:20:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33446 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab1BCPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=V1GyjLXbEcdP+pU+Yk904cH5un1YNnW429LwC8xeFR5yNWoknf27XTnTE7HnDt+/IH
         v6eAh+m5ssbNy+58D5OIxfPcBuNv5P/9QTysjIDa05WZHHZD5xnScDD4OGZNnIlwLQ4J
         jHtOan8GZvq2/xZcw8ioFA0uW7r58pm5+F5Lk=
Message-ID: <4D4AC7C0.4050608@gmail.com>
Date: Thu, 03 Feb 2011 07:20:32 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Chou <thomas@wytron.com.tw>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v4] spi: add OpenCores tiny SPI driver
References: <1295925450-28550-1-git-send-email-thomas@wytron.com.tw> <1296729466-2936-1-git-send-email-thomas@wytron.com.tw>
In-Reply-To: <1296729466-2936-1-git-send-email-thomas@wytron.com.tw>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 02:37 AM, Thomas Chou wrote:
> This patch adds support of OpenCores tiny SPI driver.
>
> http://opencores.org/project,tiny_spi
>

> +static int tiny_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
> +{
> +	struct tiny_spi *hw = tiny_spi_to_hw(spi);
> +	const u8 *txp = t->tx_buf;
> +	u8 *rxp = t->rx_buf;
> +	unsigned int i;
> +
> +	if (hw->irq>= 0) {
> +		/* use intrrupt driven data transfer */
> +		hw->len = t->len;
> +		hw->txp = t->tx_buf;
> +		hw->rxp = t->rx_buf;
> +		hw->txc = 0;
> +		hw->rxc = 0;
> +
> +		/* send the first byte */
> +		if (t->len>  1) {
> +			writeb(hw->txp ? *hw->txp++ : 0,
> +			       hw->base + TINY_SPI_TXDATA);
> +			hw->txc++;
> +			writeb(hw->txp ? *hw->txp++ : 0,
> +			       hw->base + TINY_SPI_TXDATA);
> +			hw->txc++;
> +			writeb(TINY_SPI_STATUS_TXR, hw->base + TINY_SPI_STATUS);
> +		} else {
> +			writeb(hw->txp ? *hw->txp++ : 0,
> +			       hw->base + TINY_SPI_TXDATA);
> +			hw->txc++;
> +			writeb(TINY_SPI_STATUS_TXE, hw->base + TINY_SPI_STATUS);
> +		}
> +
> +		wait_for_completion(&hw->done);
> +	} else if (txp&&  rxp) {
> +		/* we need to tighten the transfer loop */
> +		writeb(*txp++, hw->base + TINY_SPI_TXDATA);
> +		if (t->len>  1) {
> +			writeb(*txp++, hw->base + TINY_SPI_TXDATA);
> +			for (i = 2; i<  t->len; i++) {
> +				u8 rx, tx = *txp++;
> +				while (!(readb(hw->base + TINY_SPI_STATUS)&
> +					 TINY_SPI_STATUS_TXR))
> +					cpu_relax();

Putting the read status, cpu releax in an inline function would make this 
function a lot easier to read.

> +				rx = readb(hw->base + TINY_SPI_TXDATA);
> +				writeb(tx, hw->base + TINY_SPI_TXDATA);
> +				*rxp++ = rx;
> +			}
> +			while (!(readb(hw->base + TINY_SPI_STATUS)&
> +				 TINY_SPI_STATUS_TXR))
> +				cpu_relax();
> +			*rxp++ = readb(hw->base + TINY_SPI_TXDATA);
> +		}
> +		while (!(readb(hw->base + TINY_SPI_STATUS)&
> +			 TINY_SPI_STATUS_TXE))
> +			cpu_relax();
> +		*rxp++ = readb(hw->base + TINY_SPI_RXDATA);
> +	} else if (rxp) {
> +		writeb(0, hw->base + TINY_SPI_TXDATA);
> +		if (t->len>  1) {
> +			writeb(0,
> +			       hw->base + TINY_SPI_TXDATA);
> +			for (i = 2; i<  t->len; i++) {
> +				u8 rx;
> +				while (!(readb(hw->base + TINY_SPI_STATUS)&
> +					 TINY_SPI_STATUS_TXR))
> +					cpu_relax();
> +				rx = readb(hw->base + TINY_SPI_TXDATA);
> +				writeb(0,
> +				       hw->base + TINY_SPI_TXDATA);
> +				*rxp++ = rx;
> +			}
> +			while (!(readb(hw->base + TINY_SPI_STATUS)&
> +				 TINY_SPI_STATUS_TXR))
> +				cpu_relax();
> +			*rxp++ = readb(hw->base + TINY_SPI_TXDATA);
> +		}
> +		while (!(readb(hw->base + TINY_SPI_STATUS)&
> +			 TINY_SPI_STATUS_TXE))
> +			cpu_relax();
> +		*rxp++ = readb(hw->base + TINY_SPI_RXDATA);
> +	} else if (txp) {
> +		writeb(*txp++, hw->base + TINY_SPI_TXDATA);
> +		if (t->len>  1) {
> +			writeb(*txp++, hw->base + TINY_SPI_TXDATA);
> +			for (i = 2; i<  t->len; i++) {
> +				u8 tx = *txp++;
> +				while (!(readb(hw->base + TINY_SPI_STATUS)&
> +					 TINY_SPI_STATUS_TXR))
> +					cpu_relax();
> +				writeb(tx, hw->base + TINY_SPI_TXDATA);
> +			}
> +		}
> +		while (!(readb(hw->base + TINY_SPI_STATUS)&
> +			 TINY_SPI_STATUS_TXE))
> +			cpu_relax();
> +	} else {
> +		writeb(0, hw->base + TINY_SPI_TXDATA);
> +		if (t->len>  1) {
> +			writeb(0,
> +			       hw->base + TINY_SPI_TXDATA);
> +			for (i = 2; i<  t->len; i++) {
> +				while (!(readb(hw->base + TINY_SPI_STATUS)&
> +					 TINY_SPI_STATUS_TXR))
> +					cpu_relax();
> +				writeb(0,
> +				       hw->base + TINY_SPI_TXDATA);
> +			}
> +		}
> +		while (!(readb(hw->base + TINY_SPI_STATUS)&
> +			 TINY_SPI_STATUS_TXE))
> +			cpu_relax();
> +	}
> +	return t->len;
> +}
