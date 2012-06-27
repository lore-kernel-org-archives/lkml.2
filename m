Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab2F0RBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:01:30 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:14577 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab2F0RB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:01:29 -0400
Date: Wed, 27 Jun 2012 19:01:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8 v3] i2c: i801: rename some SMBHSTCNT bit constants
Message-ID: <20120627190103.29245704@endymion.delvare>
In-Reply-To: <1340805255-8041-6-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-6-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 21:54:12 +0800, Daniel Kurtz wrote:
> Rename the SMBHSTCNT register bit access constants to match the style of
> other register bits.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index ba56b74..c57bb0c 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -102,9 +102,6 @@
>  #define SMBAUXCTL_CRC		1
>  #define SMBAUXCTL_E32B		2
>  
> -/* kill bit for SMBHSTCNT */
> -#define SMBHSTCNT_KILL		2
> -
>  /* Other settings */
>  #define MAX_RETRIES		400
>  #define ENABLE_INT9		0	/* set to 0x01 to enable - untested */
> @@ -117,9 +114,13 @@
>  #define I801_PROC_CALL		0x10	/* unimplemented */
>  #define I801_BLOCK_DATA		0x14
>  #define I801_I2C_BLOCK_DATA	0x18	/* ICH5 and later */
> -#define I801_LAST_BYTE		0x20
> -#define I801_START		0x40
> -#define I801_PEC_EN		0x80	/* ICH3 and later */
> +
> +/* I801 Host Control register bits */
> +#define SMBHSTCNT_INTREN	0x01
> +#define SMBHSTCNT_KILL		0x02
> +#define SMBHSTCNT_LAST_BYTE	0x20
> +#define SMBHSTCNT_START		0x40
> +#define SMBHSTCNT_PEC_EN	0x80	/* ICH3 and later */
>  
>  /* I801 Hosts Status register bits */
>  #define SMBHSTSTS_BYTE_DONE	0x80
> @@ -289,7 +290,7 @@ static int i801_transaction(struct i801_priv *priv, int xact)
>  
>  	/* the current contents of SMBHSTCNT can be overwritten, since PEC,
>  	 * INTREN, SMBSCMD are passed in xact */
> -	outb_p(xact | I801_START, SMBHSTCNT(priv));
> +	outb_p(xact | SMBHSTCNT_START, SMBHSTCNT(priv));
>  
>  	/* We will always wait for a fraction of a second! */
>  	do {
> @@ -324,7 +325,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
>  	}
>  
>  	status = i801_transaction(priv, I801_BLOCK_DATA | ENABLE_INT9 |
> -				  I801_PEC_EN * hwpec);
> +				  SMBHSTCNT_PEC_EN * hwpec);

Would be the right time to change this to a saner construct as your
original patch set was doing.

>  	if (status)
>  		return status;
>  
> @@ -375,11 +376,11 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
>  
>  	for (i = 1; i <= len; i++) {
>  		if (i == len && read_write == I2C_SMBUS_READ)
> -			smbcmd |= I801_LAST_BYTE;
> +			smbcmd |= SMBHSTCNT_LAST_BYTE;
>  		outb_p(smbcmd | ENABLE_INT9, SMBHSTCNT(priv));
>  
>  		if (i == 1)
> -			outb_p(inb(SMBHSTCNT(priv)) | I801_START,
> +			outb_p(inb(SMBHSTCNT(priv)) | SMBHSTCNT_START,
>  			       SMBHSTCNT(priv));
>  
>  		/* We will always wait for a fraction of a second! */

Other than this, looks good, applied.

-- 
Jean Delvare
