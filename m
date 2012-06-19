Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2FSOng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:43:36 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:39400 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab2FSOne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:43:34 -0400
Date: Tue, 19 Jun 2012 16:42:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Subject: Re: [PATCH 1/3] i2c: i801: refactor
 i801_block_transaction_byte_by_byte
Message-ID: <20120619164257.51fbfb08@endymion.delvare>
In-Reply-To: <1325847502-17841-2-git-send-email-djkurtz@chromium.org>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
	<1325847502-17841-2-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Sorry for the very late reply, I'm only reviewing this patch series now.

On Fri,  6 Jan 2012 18:58:20 +0800, Daniel Kurtz wrote:
> 1) As a slight optimization, pull some logic out of the byte loop during
> byte-by-byte transactions by just setting the I801_LAST_BYTE bit, as
> defined in the i801 (PCH) datasheet, when reading the last byte of a
> byte-by-byte I2C_SMBUS_READ.

I agree it's much cleaner, and certainly more efficient too.

> 2) Clear INTR after clearing BYTE_DONE per ICH10 datasheet [1] pg. 711:
> 
>   When the last byte of a block message is received, the host controller
> sets DS. However, it does not set the INTR bit (and generate another
> interrupt) until DS is cleared. Thus, for a block message of n bytes,
> the ICH10 will generate n+1 interrupts.

Interesting. I wonder if this could explain the lockups we were seeing
when we first tried to convert the driver to use interrupts many years
ago.

How does this interact with hwpec? The driver already waits for INTR in
that case. Should this be dropped now, or do we really need to do it
twice?

> 3) If DEV_ERR is set in polling loop, abort the transaction and return
> -ENXIO to the caller. DEV_ERR is set if the device does not respond with
> an acknowledge, and the SMBus controller times out (minimum 25ms).

I agree, modulo comments below.

Overall I like these changes much. But I would recommend not mixing
code cleanups (point 1 above) with behavioral changes (points 2 and 3).
It's a lot easier to review, test, bisect and backport patches when
each patch does juts one thing.

> 
> [1] http://www.intel.com/content/dam/doc/datasheet/io-controller-hub-10-family-datasheet.pdf
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |   45 ++++++++++++++++++++++++----------------
>  1 files changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index ab26840d..f3418cf 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -116,8 +116,7 @@
>  #define I801_PROC_CALL		0x10	/* unimplemented */
>  #define I801_BLOCK_DATA		0x14
>  #define I801_I2C_BLOCK_DATA	0x18	/* ICH5 and later */
> -#define I801_BLOCK_LAST		0x34
> -#define I801_I2C_BLOCK_LAST	0x38	/* ICH5 and later */
> +#define I801_LAST_BYTE		0x20
>  #define I801_START		0x40
>  #define I801_PEC_EN		0x80	/* ICH3 and later */
>  
> @@ -320,7 +319,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
>  	}
>  
>  	status = i801_transaction(priv, I801_BLOCK_DATA | ENABLE_INT9 |
> -				  I801_PEC_EN * hwpec);
> +				  (hwpec ? I801_PEC_EN : 0));
>  	if (status)
>  		return status;
>  
> @@ -336,6 +335,10 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
>  	return 0;
>  }
>  
> +/*
> + * i2c write uses cmd=I801_BLOCK_DATA, I2C_EN=1
> + * i2c read uses cmd=I801_I2C_BLOCK_DATA
> + */
>  static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
>  					       union i2c_smbus_data *data,
>  					       char read_write, int command,
> @@ -358,19 +361,15 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
>  		outb_p(data->block[1], SMBBLKDAT(priv));
>  	}
>  
> +	if (command == I2C_SMBUS_I2C_BLOCK_DATA &&
> +	    read_write == I2C_SMBUS_READ)
> +		smbcmd = I801_I2C_BLOCK_DATA;
> +	else
> +		smbcmd = I801_BLOCK_DATA;
> +
>  	for (i = 1; i <= len; i++) {
> -		if (i == len && read_write == I2C_SMBUS_READ) {
> -			if (command == I2C_SMBUS_I2C_BLOCK_DATA)
> -				smbcmd = I801_I2C_BLOCK_LAST;
> -			else
> -				smbcmd = I801_BLOCK_LAST;
> -		} else {
> -			if (command == I2C_SMBUS_I2C_BLOCK_DATA
> -			 && read_write == I2C_SMBUS_READ)
> -				smbcmd = I801_I2C_BLOCK_DATA;
> -			else
> -				smbcmd = I801_BLOCK_DATA;
> -		}
> +		if (i == len && read_write == I2C_SMBUS_READ)
> +			smbcmd |= I801_LAST_BYTE;
>  		outb_p(smbcmd | ENABLE_INT9, SMBHSTCNT(priv));
>  
>  		if (i == 1)
> @@ -382,8 +381,9 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
>  		do {
>  			msleep(1);
>  			status = inb_p(SMBHSTSTS(priv));
> -		} while ((!(status & SMBHSTSTS_BYTE_DONE))
> -			 && (timeout++ < MAX_TIMEOUT));
> +		} while (!(status & SMBHSTSTS_BYTE_DONE) &&
> +			 !(status & SMBHSTSTS_DEV_ERR) &&

I think the following would be more efficient?

		} while (!(status & (SMBHSTSTS_BYTE_DONE | SMBHSTSTS_DEV_ERR)) &&

I am also curious why we wouldn't check for other error flags, in
particular SMBHSTSTS_FAILED and SMBHSTSTS_BUS_ERR? It might be a good
use case for STATUS_FLAGS.

> +			 timeout++ < MAX_TIMEOUT);
>  
>  		result = i801_check_post(priv, status, timeout > MAX_TIMEOUT);
>  		if (result < 0)
> @@ -414,8 +414,17 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
>  			outb_p(data->block[i+1], SMBBLKDAT(priv));
>  
>  		/* signals SMBBLKDAT ready */
> -		outb_p(SMBHSTSTS_BYTE_DONE | SMBHSTSTS_INTR, SMBHSTSTS(priv));
> +		outb_p(SMBHSTSTS_BYTE_DONE, SMBHSTSTS(priv));
> +	}
> +
> +	/* Wait for command-completion interrupt so we can clear it */
> +	timeout = 0;
> +	status = inb_p(SMBHSTSTS(priv));
> +	while (!(status & SMBHSTSTS_INTR) && timeout++ < MAX_TIMEOUT) {
> +		msleep(1);

This should be usleep_range(250, 500) these days.

> +		status = inb_p(SMBHSTSTS(priv));
>  	}

I think it would make sense to have (at least) a debug message here if
we hit the timeout, as we do in i801_wait_hwpec() for example.

> +	outb_p(SMBHSTSTS_INTR, SMBHSTSTS(priv));
>  
>  	return 0;
>  }


-- 
Jean Delvare
