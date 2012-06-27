Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2F0Qv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:51:57 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:39225 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab2F0Qvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:51:55 -0400
Date: Wed, 27 Jun 2012 18:51:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8 v3] i2c: i801: check and return errors during
 byte-by-byte transfers
Message-ID: <20120627185136.315e6625@endymion.delvare>
In-Reply-To: <1340805255-8041-5-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-5-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 21:54:11 +0800, Daniel Kurtz wrote:
> If an error is detected in the polling loop, abort the transaction and
> return an error code.
> 
>  * DEV_ERR is set if the device does not respond with an acknowledge, and
> the SMBus controller times out (minimum 25ms).
>  * BUS_ERR is set if a bus arbitration collision is detected.  In other
> words, when the SMBus controller tries to generate a START condition, but
> detects that the SMBDATA is being held low, usually by another SMBus/I2C
> master.
>  * FAILED is only set if a the transaction is set by software (using the
> SMBHSTCNT KILL bit).

Not quite sure what you mean with "set by software". Other than this,
patch looks good, applied, thanks.

> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index 6a53338..ba56b74 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -131,9 +131,11 @@
>  #define SMBHSTSTS_INTR		0x02
>  #define SMBHSTSTS_HOST_BUSY	0x01
>  
> -#define STATUS_FLAGS		(SMBHSTSTS_BYTE_DONE | SMBHSTSTS_FAILED | \
> -				 SMBHSTSTS_BUS_ERR | SMBHSTSTS_DEV_ERR | \
> -				 SMBHSTSTS_INTR)
> +#define STATUS_ERROR_FLAGS	(SMBHSTSTS_FAILED | SMBHSTSTS_BUS_ERR | \
> +				 SMBHSTSTS_DEV_ERR)
> +
> +#define STATUS_FLAGS		(SMBHSTSTS_BYTE_DONE | SMBHSTSTS_INTR | \
> +				 STATUS_ERROR_FLAGS)
>  
>  /* Older devices have their ID defined in <linux/pci_ids.h> */
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS	0x1c22
> @@ -385,7 +387,7 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
>  		do {
>  			usleep_range(250, 500);
>  			status = inb_p(SMBHSTSTS(priv));
> -		} while ((!(status & SMBHSTSTS_BYTE_DONE))
> +		} while (!(status & (SMBHSTSTS_BYTE_DONE | STATUS_ERROR_FLAGS))
>  			 && (timeout++ < MAX_RETRIES));
>  
>  		result = i801_check_post(priv, status, timeout > MAX_RETRIES);


-- 
Jean Delvare
