Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab2CURax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:30:53 -0400
Received: from sous-sol.org ([216.99.217.87]:33204 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032Ab2CURav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:30:51 -0400
Date: Wed, 21 Mar 2012 10:30:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] Support M95040 SPI EEPROM
Message-ID: <20120321173022.GF12101@sequoia.sous-sol.org>
References: <1332343445-17104-1-git-send-email-meltedpianoman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332343445-17104-1-git-send-email-meltedpianoman@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ivo Sieben (meltedpianoman@gmail.com) wrote:
> Updated the generic SPI EEPROM driver AT25 for support of address bit A8
> in the instruction byte. Certain EEPROMS (like M95040 from ST) have a 512
> Byte size but use only one address byte (A0 to A7) for addressing. For the
> extra address bit A8 bit 3 of the instruction byte is used. This instruction
> bit is threated as don't care for other AT25 like chips

The AT25 datasheet lists that bit in READ and PROGRAM(write) as don't
care, and the MV950x0 datasheet says just what you've said above (BTW,
it's "treated" not "threated").  How confident are you that this logic
will not cause problems for existing non-MV95040 chips?  I'm unfamiliar
with this driver and SPI, so it's not entirely clear how addrlen is
known and size.

For example, random glance and I found a device that uses bit3 on READ
to implement a FAST_READ, however it's addrlen is 3 bytes.


> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
> ---
>  drivers/misc/eeprom/at25.c |   31 ++++++++++++++++++++++++++++---
>  1 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
> index c627e41..907aecc 100644
> --- a/drivers/misc/eeprom/at25.c
> +++ b/drivers/misc/eeprom/at25.c
> @@ -50,6 +50,7 @@ struct at25_data {
>  #define	AT25_SR_BP1	0x08
>  #define	AT25_SR_WPEN	0x80		/* writeprotect enable */
>  
> +#define	AT25_INSTR_A8	0x08		/* Address bit 8 in instruction */

Perhaps a bit more detail here, Address bit 8 may be stored in bit 3 of
instruction byte for read or write...

>  #define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
>  
> @@ -75,6 +76,7 @@ at25_ee_read(
>  	ssize_t			status;
>  	struct spi_transfer	t[2];
>  	struct spi_message	m;
> +	u8			instr;
>  
>  	if (unlikely(offset >= at25->bin.size))
>  		return 0;
> @@ -84,7 +86,18 @@ at25_ee_read(
>  		return count;
>  
>  	cp = command;
> -	*cp++ = AT25_READ;
> +
> +	/*
> +	 * Certain EEPROMS (like M95040 from ST) have a 512 Byte size
> +	 * but use only one address byte (A0 to A7) for addressing. For
> +	 * the extra address bit A8 bit 3 of the instruction byte is
> +	 * used. This instruction bit is threated as don't care for
> +	 * other AT25 like chips.
> +	 */
> +	instr = AT25_READ;
> +	if ((at25->addrlen == 1) && (offset >= 256))
> +		instr |= AT25_INSTR_A8;
> +	*cp++ = instr;

I suppose this works because below offset is truncated to u8.

		*cp++ = offset >> 0;


>  	/* 8/16/24-bit address is written MSB first */
>  	switch (at25->addrlen) {
> @@ -167,14 +180,14 @@ at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
>  	/* For write, rollover is within the page ... so we write at
>  	 * most one page, then manually roll over to the next page.
>  	 */
> -	bounce[0] = AT25_WRITE;
>  	mutex_lock(&at25->lock);
>  	do {
>  		unsigned long	timeout, retries;
>  		unsigned	segment;
>  		unsigned	offset = (unsigned) off;
> -		u8		*cp = bounce + 1;
> +		u8		*cp = bounce;
>  		int		sr;
> +		u8		instr;
>  
>  		*cp = AT25_WREN;
>  		status = spi_write(at25->spi, cp, 1);
> @@ -184,6 +197,18 @@ at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
>  			break;
>  		}
>  
> +		/*
> +		 * Certain EEPROMS (like M95040 from ST) have a 512 Byte size
> +		 * but use only one address byte (A0 to A7) for addressing. For
> +		 * the extra address bit A8 bit 3 of the instruction byte is
> +		 * used. This instruction bit is threated as don't care for
> +		 * other AT25 like chips.
> +		 */
> +		instr = AT25_WRITE;
> +		if ((at25->addrlen == 1) && (offset >= 256))
> +			instr |= AT25_INSTR_A8;
> +		*cp++ = instr;
> +

This looks correct to me, AT25_WREN issued in bounce[0] now, then reuse
it to send AT25_WRITE, addr, data...

>  		/* 8/16/24-bit address is written MSB first */
>  		switch (at25->addrlen) {
>  		default:	/* case 3 */
