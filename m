Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2FIJn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 05:43:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56393 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab2FIJn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 05:43:26 -0400
Date: Sat, 9 Jun 2012 11:43:13 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shmulik Ladkani <shmulik@jungo.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org, Mike Dunn <mikedunn@newsguy.com>,
        linux-kernel@vger.kernel.org, Ivan Djelic <ivan.djelic@parrot.com>
Subject: Re: [PATCH] mtd: nand: Properly initialize 'mtd->bitflip_threshold'
 prior 'scan_bbt()' is invoked
Message-ID: <20120609094313.GB30400@pengutronix.de>
References: <20120608182906.57b4844a@halley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608182906.57b4844a@halley>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:42:30 up 209 days, 17:29, 20 users,  load average: 1.89, 4.30,
 2.86
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 06:29:06PM +0300, Shmulik Ladkani wrote:
> As of edbc454 [mtd: driver _read() returns max_bitflips; mtd_read()
> returns -EUCLEAN], 'mtd->bitflip_threshold' must be set for mtd devices
> having ECC, prior any 'mtd_read()' call.
> Otherwise, 'mtd_read()' will falsely return -EUCLEAN.
> 
> Normally, 'mtd->bitflip_threshold' is initialized when the MTD is added.
> 
> However, this is too late for NAND MTDs, as 'scan_bbt()' is invoked
> prior the existing initialization of 'mtd->bitflip_threshold'.
> 
> This is a problem since 'scan_bbt()' calls 'mtd_read()', in the case
> of a flash-based bad block table.
> It resulted in a falsely reported bitflips indication during BBT read,
> which lead to constant scrubbing of the flash BBT blocks.
> 
> Initialize 'mtd->bitflip_threshold' to its default value (if not already
> set by the driver), prior invocation of 'scan_bbt()'.
> 
> Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> ---
> - The issue was introduced in 3.5-rc1 and needs to be merged before 3.5
> - Sascha, I've credited you as the reporter, is that ok?

Sure, that's ok.

> - Sascha, care to test and verify it works for your system?

Yes, this puts my system back to work

Tested-by: Sascha Hauer <s.hauer@pengutronix.de>


> 
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 61805e7..0a8724e 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -3484,6 +3484,13 @@ int nand_scan_tail(struct mtd_info *mtd)
>  	/* propagate ecc info to mtd_info */
>  	mtd->ecclayout = chip->ecc.layout;
>  	mtd->ecc_strength = chip->ecc.strength;
> +	/*
> +	 * Initialize bitflip_threshold to its default prior scan_bbt() call.
> +	 * scan_bbt() might invoke mtd_read(), thus bitflip_threshold must be
> +	 * properly set.
> +	 */
> +	if (!mtd->bitflip_threshold)
> +		mtd->bitflip_threshold = mtd->ecc_strength;
>  
>  	/* Check, if we should skip the bad block table scan */
>  	if (chip->options & NAND_SKIP_BBTSCAN)
> -- 
> 1.7.5.4
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
