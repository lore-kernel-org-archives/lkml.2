Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2F0O7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:59:11 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:43040 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab2F0O7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:59:09 -0400
Date: Wed, 27 Jun 2012 16:58:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8 v3] i2c: i801: optimize waiting for HWPEC to finish
Message-ID: <20120627165848.5a080673@endymion.delvare>
In-Reply-To: <1340805255-8041-3-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-3-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Wed, 27 Jun 2012 21:54:09 +0800, Daniel Kurtz wrote:
> When a transaction has finished (including the PEC), the SMBus controller
> sets the INTR bit.
> Slightly optimize the polling loop by reading status before the first
> sleep.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index 51e11eb..8b74e1e 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -291,11 +291,11 @@ static void i801_wait_hwpec(struct i801_priv *priv)
>  	int timeout = 0;
>  	int status;
>  
> -	do {
> +	status = inb_p(SMBHSTSTS(priv));
> +	while ((!(status & SMBHSTSTS_INTR)) && (timeout++ < MAX_RETRIES)) {
>  		usleep_range(250, 500);
>  		status = inb_p(SMBHSTSTS(priv));
> -	} while ((!(status & SMBHSTSTS_INTR))
> -		 && (timeout++ < MAX_RETRIES));
> +	}
>  
>  	if (timeout > MAX_RETRIES)
>  		dev_dbg(&priv->pci_dev->dev, "PEC Timeout!\n");

Hmm, I would be very cautious here. Deep memories whisper to me
that we have sometimes done it that way in the past due to hardware
bugs. I think it was for the PIIX4 and not the 82801, but I wouldn't be
surprised if early 82801 chips had some hardware bugs as well.

Also note that optimizing the polling code isn't a priority when you're
about to enable interrupts for most chips supported by the driver. If
anything, leaving the polling code unchanged for now could even be a
goal, to make sure that users can disable interrupts if that doesn't
work for them, and things keep working as before.

Plus, PEC isn't used that much (neither you nor me can test it). And
lastly, are you really certain that there is a benefit? Are you sure
that the SMBus controller is always faster to receive and process the
PEC byte than the CPU is to reach the INTR check?

Unless you have actual numbers showing a significant improvement, I'd
rather postpone this change.

-- 
Jean Delvare
