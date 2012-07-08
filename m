Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2GHLyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 07:54:19 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:14067 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2GHLyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 07:54:00 -0400
Date: Sun, 8 Jul 2012 13:53:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8 v3] i2c: i801: enable irq for byte_by_byte
 transactions
Message-ID: <20120708135337.4fb879b2@endymion.delvare>
In-Reply-To: <1340805255-8041-9-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-9-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more note...

On Wed, 27 Jun 2012 21:54:15 +0800, Daniel Kurtz wrote:
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> (...)
> +static void i801_isr_byte_done(struct i801_priv *priv)
> +{
> +	/* For SMBus block reads, length is first byte read */
> +	if (priv->is_read && ((priv->cmd & 0x1c) == I801_BLOCK_DATA) &&
> +	    (priv->count == 0)) {
> +		priv->len = inb_p(SMBHSTDAT0(priv));
> +		if (priv->len < 1 || priv->len > I2C_SMBUS_BLOCK_MAX) {
> +			dev_err(&priv->pci_dev->dev,
> +				"Illegal SMBus block read size %d\n",
> +				priv->len);
> +			/* FIXME: Recover */
> +			priv->len = I2C_SMBUS_BLOCK_MAX;
> +		} else {
> +			dev_dbg(&priv->pci_dev->dev,
> +				"SMBus block read size is %d\n",
> +				priv->len);
> +		}
> +		priv->data[-1] = priv->len;
> +	} else if (priv->is_read) {
> +		priv->data[priv->count++] = inb(SMBBLKDAT(priv));
> +		/* Set LAST_BYTE for last byte of read transaction */
> +		if (priv->count == priv->len - 1)
> +			priv->cmd |= SMBHSTCNT_LAST_BYTE;
> +		outb_p(priv->cmd, SMBHSTCNT(priv));

This register write doesn't seem to be needed, except when
SMBHSTCNT_LAST_BYTE must be added.

> +	} else if (priv->count < priv->len - 1) {
> +		/* Write next byte, except for IRQ after last byte */
> +		outb_p(priv->data[++priv->count], SMBBLKDAT(priv));
> +		outb_p(priv->cmd, SMBHSTCNT(priv));

Same here. I know we do write to SMBHSTCNT after for every byte in
i801_block_transaction_byte_by_byte(), that must be the reason why you
did it in the interrupt path too, but I don't know why we did that and
I don't think we actually had to.

-- 
Jean Delvare
