Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1KLSuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 13:50:40 -0500
Received: from smtp.newsguy.com ([74.209.136.69]:52492 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab1KLSui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 13:50:38 -0500
Message-ID: <4EBECDCB.306@newsguy.com>
Date: Sat, 12 Nov 2011 11:49:31 -0800
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110917 Lightning/1.0b3pre Thunderbird/3.1.12
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/16] mtd/docg3: add ECC correction code
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr> <1320912342-30147-14-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1320912342-30147-14-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 12:05 AM, Robert Jarzmik wrote:
>  
> +if MTD_DOCG3
> +config BCH_CONST_M
> +	default 14
> +config BCH_CONST_T
> +	default 4
> +endif


It might be better to let the user set this in the kernel config.  Doing it here
precludes the use of the algorithm by any other module that needs to use it with
different parameters.


>  
>  /**
> + * doc_correct_data - Fix if need be read data from flash
> + * @docg3: the device
> + * @buf: the buffer of read data (512 + 7 + 1 bytes)
> + * @hwecc: the hardware calculated ECC.
> + *         It's in fact recv_ecc ^ calc_ecc, where recv_ecc was read from OOB
> + *         area data, and calc_ecc the ECC calculated by the hardware generator.
> + *
> + * Checks if the received data matches the ECC, and if an error is detected,
> + * tries to fix the bit flips (at most 4) in the buffer buf.  As the docg3
> + * understands the (data, ecc, syndroms) in an inverted order in comparison to
> + * the BCH library, the function reverses the order of bits (ie. bit7 and bit0,
> + * bit6 and bit 1, ...) for all ECC data.
> + *
> + * The hardware ecc unit produces oob_ecc ^ calc_ecc.  The kernel's bch
> + * algorithm is used to decode this.  However the hw operates on page
> + * data in a bit order that is the reverse of that of the bch alg,
> + * requiring that the bits be reversed on the result.  Thanks to Ivan
> + * Djelic for his analysis.
> + *
> + * Returns number of fixed bits (0, 1, 2, 3, 4) or -EBADMSG if too many bit
> + * errors were detected and cannot be fixed.
> + */
> +static int doc_ecc_bch_fix_data(struct docg3 *docg3, void *buf, u8 *hwecc)


Nit: function name in comment is inconsistent with its actual name.


> +{
> +	u8 ecc[DOC_ECC_BCH_SIZE];
> +	int errorpos[DOC_ECC_BCH_T], i, numerrs;
> +
> +	for (i = 0; i < DOC_ECC_BCH_SIZE; i++)
> +		ecc[i] = bitrev8(hwecc[i]);
> +	numerrs = decode_bch(docg3_bch, NULL, DOC_ECC_BCH_COVERED_BYTES,
> +			     NULL, ecc, NULL, errorpos);
> +	BUG_ON(numerrs == -EINVAL);
> +	if (numerrs < 0)
> +		goto out;
> +
> +	for (i = 0; i < numerrs; i++)
> +		errorpos[i] = (errorpos[i] & ~7) | (7 - (errorpos[i] & 7));


There's that unexplained cryptic step again :-)


> +	for (i = 0; i < numerrs; i++)
> +		if (errorpos[i] < DOC_ECC_BCH_COVERED_BYTES*8)
> +			/* error is located in data, correct it */
> +			change_bit(errorpos[i], buf);
> +out:
> +	doc_dbg("doc_ecc_bch_fix_data: flipped %d bits\n", numerrs);
> +	return numerrs;
> +}


Where do you check for reads of a blank page?  When an erased page is read,
uncorrectible ecc errors will occur (at least).  You can compare the bytes read
from the hw ecc to those generated when a bank page is read to determine if the
page is indeed blank.  At Ivan's suggestion, I went a step further and used oob
byte 15 as a "programmed flag", which is used to determine if a page has been
written or not.  This is then used as a secondary check for a blank page read,
which will avoid the situation where a blank page is read but not detected
because a genuine bit flip occurred when reading a blank page.  In that case the
hw ecc will not generate the usual blank page values.  (You can have a look at
correct_data() in the latest G4 driver patch to see what I'm talking about.)


> +
> +
> +/**
>   * doc_read_page_prepare - Prepares reading data from a flash page
>   * @docg3: the device
>   * @block0: the first plane block index on flash memory
> @@ -762,7 +816,7 @@ static int doc_read_oob(struct mtd_info *mtd, loff_t from,
>  	u8 *oobbuf = ops->oobbuf;
>  	u8 *buf = ops->datbuf;
>  	size_t len, ooblen, nbdata, nboob;
> -	u8 calc_ecc[DOC_ECC_BCH_SIZE], eccconf1;
> +	u8 hwecc[DOC_ECC_BCH_SIZE], eccconf1;
>  
>  	if (buf)
>  		len = ops->len;
> @@ -797,7 +851,7 @@ static int doc_read_oob(struct mtd_info *mtd, loff_t from,
>  		ret = doc_read_page_prepare(docg3, block0, block1, page, ofs);
>  		if (ret < 0)
>  			goto err;
> -		ret = doc_read_page_ecc_init(docg3, DOC_ECC_BCH_COVERED_BYTES);
> +		ret = doc_read_page_ecc_init(docg3, DOC_ECC_BCH_TOTAL_BYTES);


Not specifically related to this patch, but... are you sure you want to
initialize the ecc on every read?  I'm sure it's not necessary; you can just
leave it on; maybe turn it off if doing raw reads.  I know this is the case for
both the P3 and G4 when running under PalmOS / TrueFFS library.  I notice that
this function has delays and polls the status register in between calls to
cpu_relax(), so the performance hit is probably not insignificant, especiallu
when done for every 512 byte page.


>  		if (ret < 0)
>  			goto err_in_read;
>  		ret = doc_read_page_getbytes(docg3, nbdata, buf, 1);
> @@ -811,7 +865,7 @@ static int doc_read_oob(struct mtd_info *mtd, loff_t from,
>  		doc_read_page_getbytes(docg3, DOC_LAYOUT_OOB_SIZE - nboob,
>  				       NULL, 0);
>  
> -		doc_get_hw_bch_syndroms(docg3, calc_ecc);
> +		doc_get_hw_bch_syndroms(docg3, hwecc);


Another nit (also not specifically related to this patch): bad name for this
function.  The ecc being read is not the BCH syndrome, as we now know.  This is
a pet peeve of mine; M-sys abused that word by misapplying it to the byts read
from the ecc hw, which confused the hell out of me as I tried to understand what
the hw was generating.


Otherwise, looks correct.  And if it's passing nandtest we know it works!

Mike

