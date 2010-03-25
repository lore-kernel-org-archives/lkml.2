Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0CYQ0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:26:47 -0400
Received: from relais.videotron.ca ([24.201.245.36]:38007 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab0CYQ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:26:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 25 Mar 2010 12:26:17 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: dwmw2@infradead.org, akpm@linux-foundation.org,
       u.kleine-koenig@pengutronix.de, simon.kagstrom@netinsight.net,
       linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MTD: Fix Orion NAND driver compilation with ARM OABI
In-reply-to: <20100325152505.17612.40158.stgit@pauliusz>
Message-id: <alpine.LFD.2.00.1003251225500.694@xanadu.home>
References: <20100325152505.17612.40158.stgit@pauliusz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Paulius Zaleckas wrote:

> We must tell GCC to use even register for variable passed
> to ldrd instruction. Without this patch GCC 4.2.1 puts this
> variable to r2/r3 on EABI and r3/r4 on OABI, so force it to
> r2/r3. This does not change anything when EABI and OABI
> compilation works OK.
> 
> Without this patch and with OABI I get:
>   CC      drivers/mtd/nand/orion_nand.o
> /tmp/ccMkwOCs.s: Assembler messages:
> /tmp/ccMkwOCs.s:63: Error: first destination register must be even -- `ldrd r3,[ip]'
> make[5]: *** [drivers/mtd/nand/orion_nand.o] Error 1
> 
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>

Acked-by: Nicolas Pitre <nico@fluxnic.net>

> ---
> 
>  drivers/mtd/nand/orion_nand.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
> index f59c074..d60fc57 100644
> --- a/drivers/mtd/nand/orion_nand.c
> +++ b/drivers/mtd/nand/orion_nand.c
> @@ -60,7 +60,13 @@ static void orion_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
>  	}
>  	buf64 = (uint64_t *)buf;
>  	while (i < len/8) {
> -		uint64_t x;
> +		/*
> +		 * Since GCC has no proper constraint (PR 43518)
> +		 * force x variable to r2/r3 registers as ldrd instruction
> +		 * requires first register to be even.
> +		 */
> +		register uint64_t x asm ("r2");
> +
>  		asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));
>  		buf64[i++] = x;
>  	}
> 
