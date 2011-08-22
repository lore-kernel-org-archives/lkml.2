Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1HVCoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 22:44:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64791 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1HVCoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 22:44:19 -0400
Date: Sun, 21 Aug 2011 19:44:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Kevin McNeely <kev@cypress.com>, Henrik Rydberg <rydberg@euromail.se>,
        Srikar <ext-srikar.1.bhavanarayana@nokia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Input: cyttsp - add support for Cypress TTSP
 touchscreen SPI bus interface
Message-ID: <20110822024412.GC17891@core.coreip.homeip.net>
References: <1313812912-2848-1-git-send-email-martinez.javier@gmail.com>
 <1313812912-2848-4-git-send-email-martinez.javier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313812912-2848-4-git-send-email-martinez.javier@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On Sat, Aug 20, 2011 at 12:01:52AM -0400, Javier Martinez Canillas wrote:
> +
> +static int cyttsp_spi_xfer_(u8 op, struct cyttsp_spi *ts,
> +			    u8 reg, u8 *buf, int length)
> +{
> +	struct spi_message msg;
> +	struct spi_transfer xfer[2];
> +	u8 *wr_buf = ts->wr_buf;
> +	u8 *rd_buf = ts->rd_buf;
> +	int retval;
> +
> +	if (length > CY_SPI_DATA_SIZE) {
> +		dev_dbg(ts->ops.dev, "%s: length %d is too big.\n",
> +			__func__, length);
> +		return -EINVAL;
> +	}
> +
> +	memset(wr_buf, 0, CY_SPI_DATA_BUF_SIZE);
> +	memset(rd_buf, 0, CY_SPI_DATA_BUF_SIZE);
> +
> +	wr_buf[0] = 0x00; /* header byte 0 */
> +	wr_buf[1] = 0xFF; /* header byte 1 */
> +	wr_buf[2] = reg;  /* reg index */
> +	wr_buf[3] = op;   /* r/~w */
> +	if (op == CY_SPI_WR_OP)
> +		memcpy(wr_buf + CY_SPI_CMD_BYTES, buf, length);
> +
> +	memset((void *)xfer, 0, sizeof(xfer));
> +	spi_message_init(&msg);
> +	xfer[0].tx_buf = wr_buf;
> +	xfer[0].rx_buf = rd_buf;

Since we are setting both TX and RX buffer here does this mean that the
device will not work with controllers in half-duplex mode? What is the
amount of data that will be placed in rd_buf?

> +	if (op == CY_SPI_WR_OP) {
> +		xfer[0].len = length + CY_SPI_CMD_BYTES;
> +		spi_message_add_tail(&xfer[0], &msg);
> +	} else if (op == CY_SPI_RD_OP) {
> +		xfer[0].len = CY_SPI_CMD_BYTES;
> +		spi_message_add_tail(&xfer[0], &msg);
> +
> +		xfer[1].rx_buf = buf;
> +		xfer[1].len = length;
> +		spi_message_add_tail(&xfer[1], &msg);
> +	}
> +
> +	retval = spi_sync_tmo(ts, &msg);
> +	if (retval < 0) {
> +		dev_dbg(ts->ops.dev, "%s: spi sync error %d, len=%d, op=%d\n",
> +			__func__, retval, xfer[1].len, op);
> +		retval = 0;

Why do we ignore the error?

> +	}
> +
> +	if (op == CY_SPI_RD_OP) {
> +		if ((rd_buf[CY_SPI_SYNC_BYTE] == CY_SPI_SYNC_ACK1) &&
> +			(rd_buf[CY_SPI_SYNC_BYTE+1] == CY_SPI_SYNC_ACK2))
> +			retval = 0;

What about write operation? Does the device send anything in rd_buf for
write command?

> +		else {
> +			int i;
> +			for (i = 0; i < (CY_SPI_CMD_BYTES); i++)
> +				dev_dbg(ts->ops.dev,
> +					"%s: test rd_buf[%d]:0x%02x\n",
> +					__func__, i, rd_buf[i]);
> +			for (i = 0; i < (length); i++)
> +				dev_dbg(ts->ops.dev,
> +					"%s: test buf[%d]:0x%02x\n",
> +					__func__, i, buf[i]);
> +			retval = 1;
> +		}
> +	}
> +	return retval;
> +}
> +
> +static int cyttsp_spi_xfer(u8 op, struct cyttsp_spi *ts,
> +			    u8 reg, u8 *buf, int length)
> +{
> +	int tries;
> +	int retval;
> +
> +	if (op == CY_SPI_RD_OP) {
> +		for (tries = CY_NUM_RETRY; tries; tries--) {
> +			retval = cyttsp_spi_xfer_(op, ts, reg, buf, length);
> +			if (retval == 0)
> +				break;
> +			else
> +				msleep(20);

Why do we need retry in SPI case but do not need it when device is
connected via I2C? And not on writes?

> +		}
> +	} else {
> +		retval = cyttsp_spi_xfer_(op, ts, reg, buf, length);
> +	}
> +
> +	return retval;
> +}
> +
> +static s32 ttsp_spi_read_block_data(void *handle, u8 addr,
> +				    u8 length, void *data)
> +{
> +	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
> +	int retval;
> +
> +	retval = cyttsp_spi_xfer(CY_SPI_RD_OP, ts, addr, data, length);
> +	if (retval < 0)
> +		dev_dbg(ts->ops.dev,  "%s: ttsp_spi_read_block_data failed\n",
> +			__func__);
> +
> +	/*
> +	 * Do not print the above error if the data sync bytes were not found.
> +	 * This is a normal condition for the bootloader loader startup and need
> +	 * to retry until data sync bytes are found.
> +	 */
> +	if (retval > 0)
> +		retval = -1;	/* now signal fail; so retry can be done */
> +
> +	return retval;
> +}
> +
> +static s32 ttsp_spi_write_block_data(void *handle, u8 addr,
> +				     u8 length, const void *data)
> +{
> +	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
> +	int retval;
> +
> +	retval = cyttsp_spi_xfer(CY_SPI_WR_OP, ts, addr, (void *)data, length);
> +	if (retval < 0)
> +		dev_dbg(ts->ops.dev, "%s: ttsp_spi_write_block_data failed\n",
> +			__func__);
> +
> +	if (retval == -EIO)
> +		return 0;

Why is -EIO special?

> +	else
> +		return retval;
> +}
> +

Thanks.

-- 
Dmitry
