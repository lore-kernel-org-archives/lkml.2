Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab1J2Ixf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 04:53:35 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:45325 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab1J2Ixd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 04:53:33 -0400
Date: Sat, 29 Oct 2011 10:52:48 +0200
From: Ivan Djelic <ivan.djelic@parrot.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "mikedunn@newsguy.com" <mikedunn@newsguy.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] mtd/docg3: add ECC correction code
Message-ID: <20111029085248.GA12046@parrot.com>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
 <1319824292-11085-13-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1319824292-11085-13-git-send-email-robert.jarzmik@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 06:51:31PM +0100, Robert Jarzmik wrote:
>  
> +/**
> + * struct docg3_bch - BCH engine
> + */
> +static struct bch_control *docg3_bch;

Why not putting this into your struct docg3, instead of adding a global var ?

> +static int doc_ecc_bch_fix_data(struct docg3 *docg3, void *buf, u8 *calc_ecc)
> +{
> +	u8 ecc[DOC_ECC_BCH_T + 1];

Should be 'u8 ecc[DOC_ECC_BCH_SIZE];'

> +	int errorpos[DOC_ECC_BCH_T + 1], i, numerrs;

Using 'errorpos[DOC_ECC_BCH_T]' is fine, no need for '+ 1'.

(...)

> +
> +	for (i = 0; i < DOC_ECC_BCH_SIZE; i++)
> +		ecc[i] = bitrev8(calc_ecc[i]);
> +	numerrs = decode_bch(docg3_bch, NULL, DOC_ECC_BCH_COVERED_BYTES,
> +			     NULL, ecc, NULL, errorpos);
> +	if (numerrs < 0)
> +		return numerrs;

Maybe do something like 'printk(KERN_ERR "ecc unrecoverable error\n");' when
numerrs < 0 ?

(...)

> +	for (i = 0; i < numerrs; i++)
> +		change_bit(errorpos[i], buf);

'buf' holds the buffer of read data (512 + 7 + 1 bytes); hence you should
change the above code into something like:

	for (i = 0; i < numerrs; i++)
		if (errorpos[i] < DOC_ECC_BCH_COVERED_BYTES*8)
			/* error is located in data, correct it */
			change_bit(errorpos[i], buf);
	        /* else error in ecc bytes, no data change needed */

otherwise 'change_bit' will be out of bounds when a bitflip occurs in ecc
bytes. Note that we still need to report bitflips in that case, to let upper
layers scrub them.

(...)
> +	docg3_bch = init_bch(DOC_ECC_BCH_M, DOC_ECC_BCH_T,
> +			     DOC_ECC_BCH_PRIMPOLY);
> +	if (!docg3_bch)
> +		goto nomem2;

Just a side note: if you need to get maximum performance from the BCH library,
you can set fixed values for M and T in your Kconfig, with something like:

 config MTD_DOCG3
        tristate "M-Systems Disk-On-Chip G3"
	select BCH
        ---help---
          This provides an MTD device driver for the M-Systems DiskOnChip
          G3 devices.

if MTD_DOCG3
config BCH_CONST_M
	default 14
config BCH_CONST_T
	default 4
endif


The only drawback is that it won't work if you select your DOCG3 driver and, at
the same time, other MTD drivers that also use fixed, but different parameters.

(...)
> @@ -1660,6 +1717,7 @@ static int __exit docg3_release(struct platform_device *pdev)
>  			doc_release_device(docg3_floors[floor]);
>  
>  	kfree(docg3_floors);
> +	kfree(docg3_bch);

This should be 'free_bch(docg3_bch)'.

Otherwise it looks OK to me; did you test BCH correction by simulating
corruptions (of 1-4 bits, and also 5 bits to trigger failures) in nand data ?

Best Regards,
--
Ivan
