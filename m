Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1KMKf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 05:35:29 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:59400 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab1KMKf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 05:35:27 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mike Dunn <mikedunn@newsguy.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/16] mtd/docg3: add ECC correction code
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
	<1320912342-30147-14-git-send-email-robert.jarzmik@free.fr>
	<4EBECDCB.306@newsguy.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 13 Nov 2011 11:35:17 +0100
In-Reply-To: <4EBECDCB.306@newsguy.com> (Mike Dunn's message of "Sat, 12 Nov
	2011 11:49:31 -0800")
Message-ID: <87mxc0ia3e.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Dunn <mikedunn@newsguy.com> writes:

> On 11/10/2011 12:05 AM, Robert Jarzmik wrote:
>>  
>> +if MTD_DOCG3
>> +config BCH_CONST_M
>> +	default 14
>> +config BCH_CONST_T
>> +	default 4
>> +endif
>
>
> It might be better to let the user set this in the kernel config.  Doing it here
> precludes the use of the algorithm by any other module that needs to use it with
> different parameters.
You're right.
I'll shift that to mioa701 board code, where I'm sure no other BCH is necessary.

>> +static int doc_ecc_bch_fix_data(struct docg3 *docg3, void *buf, u8 *hwecc)
> Nit: function name in comment is inconsistent with its actual name.
Good catch. Will fix.
>> +	for (i = 0; i < numerrs; i++)
>> +		if (errorpos[i] < DOC_ECC_BCH_COVERED_BYTES*8)
>> +			/* error is located in data, correct it */
>> +			change_bit(errorpos[i], buf);
>> +out:
>> +	doc_dbg("doc_ecc_bch_fix_data: flipped %d bits\n", numerrs);
>> +	return numerrs;
>> +}
>
>
> Where do you check for reads of a blank page?
On stack frame above. Look at doc_read_oob():
		if ((block0 >= DOC_LAYOUT_BLOCK_FIRST_DATA) &&
		    (eccconf1 & DOC_ECCCONF1_BCH_SYNDROM_ERR) &&
		    (eccconf1 & DOC_ECCCONF1_PAGE_IS_WRITTEN) &&
                                \---> this is the key
		    (ops->mode != MTD_OPS_RAW) &&
		    (nbdata == DOC_LAYOUT_PAGE_SIZE)) {
			ret = doc_ecc_bch_fix_data(docg3, buf, hwecc);

Here you see that I'll make the error correction only if the page was written
before. If it's blank, I continue reading without attempting ECC correction.

> Not specifically related to this patch, but... are you sure you want to
> initialize the ecc on every read?  I'm sure it's not necessary; you can just
> leave it on; maybe turn it off if doing raw reads.  I know this is the case for
> both the P3 and G4 when running under PalmOS / TrueFFS library.  I notice that
> this function has delays and polls the status register in between calls to
> cpu_relax(), so the performance hit is probably not insignificant, especiallu
> when done for every 512 byte page.
Well, that's some info.
And yes, it adds some latency.
Now for the necessity, I'm not fully convinced. I know that the ECC register is
set up differently for reads and writes (that's the
DOC_ECCCONF0_READ_MODE). When doc_read_oob() is called, I don't know if the
previous action was a read or a write ...

What I could do to improve performance would be to store in the docg3 private
data if last action was a read or a write, and perform the doc_*_page_ecc_init()
only if action changes. What do you think ?

> Another nit (also not specifically related to this patch): bad name for this
> function.  The ecc being read is not the BCH syndrome, as we now know.  This is
> a pet peeve of mine; M-sys abused that word by misapplying it to the byts read
> from the ecc hw, which confused the hell out of me as I tried to understand what
> the hw was generating.
Yes, I'll change the name to hw_ecc or something like that.

Thanks for the review.

-- 
Robert
