Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2F0QHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:07:49 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:9906 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2F0QHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:07:47 -0400
Date: Wed, 27 Jun 2012 18:07:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8 v3] i2c: i801: check INTR after every transaction
Message-ID: <20120627180724.762f854a@endymion.delvare>
In-Reply-To: <1340805255-8041-4-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-4-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 21:54:10 +0800, Daniel Kurtz wrote:
> Per ICH10 datasheet [1] pg. 711, after completing a block transaction,
> INTR should be checked & cleared separately, only after BYTE_DONE is
> first cleared:
> 
>   When the last byte of a block message is received, the host controller
> sets DS. However, it does not set the INTR bit (and generate another
> interrupt) until DS is cleared. Thus, for a block message of n bytes,
> the ICH10 will generate n+1 interrupts.
> 
> [1] http://www.intel.com/content/dam/doc/datasheet/io-controller-hub-10-family-datasheet.pdf
> 
> Currently, the INTR bit was only checked & cleared separately if the PEC
> was used.
> This patch checks and clears INTR at the very end of every successful
> transaction, regardless of whether the PEC is used.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |   46 ++++++++++++++++++++--------------------
>  1 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index 8b74e1e..6a53338 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -257,6 +257,24 @@ static int i801_check_post(struct i801_priv *priv, int status, int timeout)
>  	return result;
>  }
>  
> +/* wait for INTR bit as advised by Intel */
> +static void i801_wait_intr(struct i801_priv *priv)
> +{
> +	int timeout = 0;
> +	int status;
> +
> +	status = inb_p(SMBHSTSTS(priv));
> +	while ((!(status & SMBHSTSTS_INTR)) && (timeout++ < MAX_RETRIES)) {
> +		usleep_range(250, 500);
> +		status = inb_p(SMBHSTSTS(priv));
> +	}

Per my comment on previous patch, I've swapped the logic here to be in
line with what we had before. I have no objection to trying this change
again, but later, and only if you have actual numbers to back it up.

> +
> +	if (timeout > MAX_RETRIES)
> +		dev_dbg(&priv->pci_dev->dev, "INTR Timeout!\n");
> +
> +	outb_p(status, SMBHSTSTS(priv));

Wouldn't it be more correct to only write the INTR bit? Writing back
the whole 8 bits frightens me a little especially because of bit
INUSE_STS. If we ever want to support this feature, I think we have to
first ban writing back the whole status to register HST_STS. And this
is the only place where we still do AFAICS.

(This isn't a regression from your patch, the old code was already
doing that, but it might be the opportunity to fix it.)

-- 
Jean Delvare
