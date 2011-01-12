Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1ALSqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:46:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51178 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1ALSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:45:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CwBBT2GiC+wNDzTCI3rCX0TvIefe38vrqRtQG4P2PEtm6tcru7+ETqtyL2xvC8bkPG
         MPCe42I9gB21MPTOvMhZ4or1VzxoP3289ZEcTLsHM/FMkIqt09c9gOGcn938qSpLJEuS
         IREpMGN8uvOHHBOkPhwUM8p9xDtny5maIAG0M=
Date: Wed, 12 Jan 2011 10:45:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kevin McNeely <kev@cypress.com>
Cc: David Brown <davidb@codeaurora.org>, Trilok Soni <tsoni@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Henrik Rydberg <rydberg@euromail.se>, Alan Cox <alan@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v4 3/3] 3/3 spi: Cypress TTSP G3 SPI Device Driver
Message-ID: <20110112184550.GB9168@core.coreip.homeip.net>
References: <kev@cypress.com>
 <1294188847-24728-3-git-send-email-kev@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294188847-24728-3-git-send-email-kev@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Tue, Jan 04, 2011 at 04:54:06PM -0800, Kevin McNeely wrote:
> +
> +static int spi_sync_tmo(struct cyttsp_spi *ts, struct spi_message *message)
> +{
> +	DECLARE_COMPLETION_ONSTACK(done);
> +	int status;
> +
> +	message->complete = spi_complete;
> +	message->context = &done;
> +	status = spi_async(ts->spi_client, message);
> +	if (status == 0) {
> +		int ret = wait_for_completion_interruptible_timeout(&done, HZ);
> +		if (!ret) {
> +			dev_dbg(ts->ops.dev, "%s: timeout\n", __func__);
> +			status = -EIO;

I do not believe we can do this and simply abort outstanding SPI
transfer. What if we unload the driver and destroy the device and then
SPI master will come around? And it does not look like SPI subsystem
allows to cancel outstanding requests...

Have you actually seen timeouts firing? Why isn't the same needed for
I2C interface?

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

I am a bit confused here. First of all we do retries in
cyttsp_spi_xfer(). Then cyttsp_core does retry transfer as well (but i2c
methods do not retry). Can we settle on retrying in one place only?

> +
> +static s32 ttsp_spi_tch_ext(void *handle, void *values)
> +{
> +	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
> +	int retval = 0;
> +
> +	/*
> +	 * TODO: Add custom touch extension handling code here
> +	 * set: retval < 0 for any returned system errors,
> +	 *	retval = 0 if normal touch handling is required,
> +	 *	retval > 0 if normal touch handling is *not* required
> +	 */
> +
> +	if (!ts || !values)
> +		retval = -EINVAL;
> +
> +	return retval;

I question the utility of "per bus" extended touch handling. I can see
it being supplied from platform data but niot by interface code.

BTW, no need to resubmit patches not, it is just a discussion...

Thanks.

-- 
Dmitry
