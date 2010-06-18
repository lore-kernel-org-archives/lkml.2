Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab0FRUyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:54:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38340 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0FRUyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:54:16 -0400
Date: Fri, 18 Jun 2010 22:54:01 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: John Ogness <john.ogness@linutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Ivo Clarysse <ivo.clarysse@gmail.com>
Subject: Re: [PATCH 4/5] mtd: mxc_nand fixups
Message-ID: <20100618205401.GA12115@pengutronix.de>
References: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:51:29 up 11 days, 13:19, 26 users,  load average: 0.15, 0.13,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added Ivo to Cc]

On Fri, Jun 18, 2010 at 07:01:34PM +0200, John Ogness wrote:
> This patch reverts the driver to enabling/disabling the NFC interrupt
> mask rather than enabling/disabling the system interrupt. This cleans
> up the driver so that it doesn't rely on interrupts being disabled
> within the interrupt handler.

This behaviour was introduced in
a47bfd2eb66837653dc3b42541dfe4283dd41251 mxc_nand: support i.MX21

I guess this won't work on i.MX21.

Sascha

> 
> The patch is against linux-next 20100618.
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>
> ---
>  drivers/mtd/nand/mxc_nand.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> Index: linux-next-20100618/drivers/mtd/nand/mxc_nand.c
> ===================================================================
> --- linux-next-20100618.orig/drivers/mtd/nand/mxc_nand.c
> +++ linux-next-20100618/drivers/mtd/nand/mxc_nand.c
> @@ -173,8 +173,11 @@ static const char *part_probes[] = { "Re
>  static irqreturn_t mxc_nfc_irq(int irq, void *dev_id)
>  {
>  	struct mxc_nand_host *host = dev_id;
> +	uint16_t tmp;
>  
> -	disable_irq_nosync(irq);
> +	tmp = readw(host->regs + NFC_CONFIG1);
> +	tmp |= NFC_INT_MSK; /* disable NFC interrupts */
> +	writew(tmp, host->regs + NFC_CONFIG1);
>  
>  	wake_up(&host->irq_waitq);
>  
> @@ -192,7 +195,9 @@ static void wait_op_done(struct mxc_nand
>  	if (useirq) {
>  		if ((readw(host->regs + NFC_CONFIG2) & NFC_INT) == 0) {
>  
> -			enable_irq(host->irq);
> +			tmp = readw(host->regs + NFC_CONFIG1);
> +			tmp  &= ~NFC_INT_MSK;   /* enable NFC interrupts */
> +			writew(tmp, host->regs + NFC_CONFIG1);
>  
>  			wait_event(host->irq_waitq,
>  				readw(host->regs + NFC_CONFIG2) & NFC_INT);
> @@ -846,7 +851,7 @@ static int __init mxcnd_probe(struct pla
>  
>  	host->irq = platform_get_irq(pdev, 0);
>  
> -	err = request_irq(host->irq, mxc_nfc_irq, IRQF_DISABLED, DRIVER_NAME, host);
> +	err = request_irq(host->irq, mxc_nfc_irq, 0, DRIVER_NAME, host);
>  	if (err)
>  		goto eirq;
>  
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
