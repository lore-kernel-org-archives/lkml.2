Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab0FURC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:02:58 -0400
Received: from bamako.nerim.net ([62.4.17.28]:56056 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab0FURC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:02:56 -0400
Date: Mon, 21 Jun 2010 19:02:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: ben-linux@fluff.org, hsweeten@visionengravers.com,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c/mips: Fix error return codes from Sibyte i2c bus
 driver
Message-ID: <20100621190252.2adc6bd8@hyperion.delvare>
In-Reply-To: <1277056673-4305-1-git-send-email-guenter.roeck@ericsson.com>
References: <1277056673-4305-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Sun, 20 Jun 2010 10:57:53 -0700, Guenter Roeck wrote:
> Sibyte i2c bus driver returns non-descriptive error values.
> Update to return error values as defined in Documentation/i2c/fault-codes.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  drivers/i2c/busses/i2c-sibyte.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-sibyte.c b/drivers/i2c/busses/i2c-sibyte.c
> index 3d76a18..329cbee 100644
> --- a/drivers/i2c/busses/i2c-sibyte.c
> +++ b/drivers/i2c/busses/i2c-sibyte.c
> @@ -94,7 +94,7 @@ static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
>  		}
>  		break;
>  	default:
> -		return -1;      /* XXXKW better error code? */
> +		return -EOPNOTSUPP;
>  	}
>  
>  	while (csr_in32(SMB_CSR(adap, R_SMB_STATUS)) & M_SMB_BUSY)
> @@ -104,7 +104,7 @@ static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
>  	if (error & M_SMB_ERROR) {
>  		/* Clear error bit by writing a 1 */
>  		csr_out32(M_SMB_ERROR, SMB_CSR(adap, R_SMB_STATUS));
> -		return -1;      /* XXXKW better error code? */
> +		return -ENXIO;
>  	}
>  
>  	if (data_bytes == 1)

Definitely an improvement. However, returning -ENXIO on all errors
seems wrong. This error value should only be returned on missing ack
from the slave on address byte. Isn't it possible to distinguish
between different error kinds? M_SMB_ERROR_TYPE seems promising, but
one would need to look up the datasheet (which I don't have) to
discover its meaning.

-- 
Jean Delvare
