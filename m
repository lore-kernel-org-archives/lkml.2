Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1ICFcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 01:32:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55617 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1ICFcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 01:32:04 -0400
Subject: Re: [PATCH 3/3] Input: cyttsp - add support for Cypress TTSP
 touchscreen SPI bus interface
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kevin McNeely <kev@cypress.com>, Henrik Rydberg <rydberg@euromail.se>,
        Srikar <ext-srikar.1.bhavanarayana@nokia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110822024412.GC17891@core.coreip.homeip.net>
References: <1313812912-2848-1-git-send-email-martinez.javier@gmail.com>
	 <1313812912-2848-4-git-send-email-martinez.javier@gmail.com>
	 <20110822024412.GC17891@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Sep 2011 07:31:58 +0200
Message-ID: <1315027918.11839.10.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

On Sun, 2011-08-21 at 19:44 -0700, Dmitry Torokhov wrote:
> Hi Javier,
> 
> > +
> > +	memset((void *)xfer, 0, sizeof(xfer));
> > +	spi_message_init(&msg);
> > +	xfer[0].tx_buf = wr_buf;
> > +	xfer[0].rx_buf = rd_buf;
> 
> Since we are setting both TX and RX buffer here does this mean that the
> device will not work with controllers in half-duplex mode? What is the
> amount of data that will be placed in rd_buf?
> 

Both TX and RX buffers are set because Cypress requires full duplex
operation always.

> > +	retval = spi_sync_tmo(ts, &msg);
> > +	if (retval < 0) {
> > +		dev_dbg(ts->ops.dev, "%s: spi sync error %d, len=%d, op=%d\n",
> > +			__func__, retval, xfer[1].len, op);
> > +		retval = 0;
> 
> Why do we ignore the error?
> 

Fixed: In next version a following ACK check code return the status to
the cyttsp core so it can retry after waiting with an msleep() call.

> > +	}
> > +
> > +	if (op == CY_SPI_RD_OP) {
> > +		if ((rd_buf[CY_SPI_SYNC_BYTE] == CY_SPI_SYNC_ACK1) &&
> > +			(rd_buf[CY_SPI_SYNC_BYTE+1] == CY_SPI_SYNC_ACK2))
> > +			retval = 0;
> 
> What about write operation? Does the device send anything in rd_buf for
> write command?
> 

Fixed: Both read and write operations check the ACK bytes now.

> > +
> > +	if (op == CY_SPI_RD_OP) {
> > +		for (tries = CY_NUM_RETRY; tries; tries--) {
> > +			retval = cyttsp_spi_xfer_(op, ts, reg, buf, length);
> > +			if (retval == 0)
> > +				break;
> > +			else
> > +				msleep(20);
> 
> Why do we need retry in SPI case but do not need it when device is
> connected via I2C? And not on writes?
> 

Fixed: The retries now are made in the cyttsp core so it works both for
SPI and I2C.

> > +
> > +	if (retval == -EIO)
> > +		return 0;
> 
> Why is -EIO special?
> 

Fixed: Now special EIO has been fixed to show meaning.

> > +	else
> > +		return retval;
> > +}
> > +
> 
> Thanks.
> 
> -- 
> Dmitry

Best regards,

Javier Martinez Canillas

