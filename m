Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab1J2Qhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 12:37:47 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:49913 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933470Ab1J2Qhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 12:37:46 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Ivan Djelic <ivan.djelic@parrot.com>
Cc: "dwmw2\@infradead.org" <dwmw2@infradead.org>,
        "dedekind1\@gmail.com" <dedekind1@gmail.com>,
        "mikedunn\@newsguy.com" <mikedunn@newsguy.com>,
        "linux-mtd\@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] mtd/docg3: add ECC correction code
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
	<1319824292-11085-13-git-send-email-robert.jarzmik@free.fr>
	<20111029085248.GA12046@parrot.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sat, 29 Oct 2011 18:37:35 +0200
In-Reply-To: <20111029085248.GA12046@parrot.com> (Ivan Djelic's message of
	"Sat, 29 Oct 2011 10:52:48 +0200")
Message-ID: <8739ebbvow.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Djelic <ivan.djelic@parrot.com> writes:

> On Fri, Oct 28, 2011 at 06:51:31PM +0100, Robert Jarzmik wrote:
>>  
>> +/**
>> + * struct docg3_bch - BCH engine
>> + */
>> +static struct bch_control *docg3_bch;
>
> Why not putting this into your struct docg3, instead of adding a global var ?
Because I have multiple floors (ie. 4 floors for example), which are split into
4 different devices. If I put that in docg3 structures (ie. the 4 allocated
structures, each for one floor), I'd either have to :
 - allocate 4 different bch "engines"
 - or count docg3 releases and release the bch at the last kfree(docg3), which
 makes me have another global variable.


>
>> +static int doc_ecc_bch_fix_data(struct docg3 *docg3, void *buf, u8 *calc_ecc)
>> +{
>> +	u8 ecc[DOC_ECC_BCH_T + 1];
>
> Should be 'u8 ecc[DOC_ECC_BCH_SIZE];'
OK, I'll amend it.

>
>> +	int errorpos[DOC_ECC_BCH_T + 1], i, numerrs;
>
> Using 'errorpos[DOC_ECC_BCH_T]' is fine, no need for '+ 1'.
OK, got it.

>> +
>> +	for (i = 0; i < DOC_ECC_BCH_SIZE; i++)
>> +		ecc[i] = bitrev8(calc_ecc[i]);
>> +	numerrs = decode_bch(docg3_bch, NULL, DOC_ECC_BCH_COVERED_BYTES,
>> +			     NULL, ecc, NULL, errorpos);
>> +	if (numerrs < 0)
>> +		return numerrs;
>
> Maybe do something like 'printk(KERN_ERR "ecc unrecoverable error\n");' when
> numerrs < 0 ?
That will be too verbose. As there are special partitions where the ECC is not
used that way (ie. SAFTL partitions I don't understand well yet), the ECC is
always wrong there.
Moreover, the error is reported as EBADMSG later (in doc_read), making the
information available to userland.

>
> (...)
>
>> +	for (i = 0; i < numerrs; i++)
>> +		change_bit(errorpos[i], buf);
>
> 'buf' holds the buffer of read data (512 + 7 + 1 bytes); hence you should
> change the above code into something like:
>
> 	for (i = 0; i < numerrs; i++)
> 		if (errorpos[i] < DOC_ECC_BCH_COVERED_BYTES*8)
> 			/* error is located in data, correct it */
> 			change_bit(errorpos[i], buf);
> 	        /* else error in ecc bytes, no data change needed */
>
> otherwise 'change_bit' will be out of bounds when a bitflip occurs in ecc
> bytes. Note that we still need to report bitflips in that case, to let upper
> layers scrub them.
Ah OK, I wasn't aware of that. I'll amend the code, thanks.

>
> (...)
>> +	docg3_bch = init_bch(DOC_ECC_BCH_M, DOC_ECC_BCH_T,
>> +			     DOC_ECC_BCH_PRIMPOLY);
>> +	if (!docg3_bch)
>> +		goto nomem2;
>
> Just a side note: if you need to get maximum performance from the BCH library,
> you can set fixed values for M and T in your Kconfig, with something like:
>
>  config MTD_DOCG3
>         tristate "M-Systems Disk-On-Chip G3"
> 	select BCH
>         ---help---
>           This provides an MTD device driver for the M-Systems DiskOnChip
>           G3 devices.
>
> if MTD_DOCG3
> config BCH_CONST_M
> 	default 14
> config BCH_CONST_T
> 	default 4
> endif
>
>
> The only drawback is that it won't work if you select your DOCG3 driver and, at
> the same time, other MTD drivers that also use fixed, but different
> parameters.
Oh, that seems nice. As I'm working with a smartphone, there is only one mtd
inside, so the speed-up will be nice.

>
> (...)
>> @@ -1660,6 +1717,7 @@ static int __exit docg3_release(struct platform_device *pdev)
>>  			doc_release_device(docg3_floors[floor]);
>>  
>>  	kfree(docg3_floors);
>> +	kfree(docg3_bch);
>
> This should be 'free_bch(docg3_bch)'.
Right.

>
> Otherwise it looks OK to me; did you test BCH correction by simulating
> corruptions (of 1-4 bits, and also 5 bits to trigger failures) in nand data ?
I did test the algorithm, yes.
To be more precise, I tested your last BCH encoding algorithm (emulate_docg4_hw)
which gives exactly the same ECC.

I then flipped 2 bits (buf[0] ^= 0x01 and buf[1] ^= 0x02), and got correct
errorpos (ie. 0 and 10 IIRC).

The thing I didn't check is the decode_bch() call with the hardware calculated
ECC. I tried on my PC:
  decode_bch(bch, data, 520, ecc, NULL, NULL, errorpos);
  => this *does* work
while in the kernel I did:
  decode_bch(docg3_bch, NULL, DOC_ECC_BCH_COVERED_BYTES,
			     NULL, ecc, NULL, errorpos);
  => this might work...

What I'm a bit afraid of is my poor understanding of the hardware ECC engine. I
know that the write part is correct (ie. ECC calculation), but I'm a bit
confused by the read part.

What wories me is that the hardware ECC got back while reading (ie. what I
called calc_ecc) is always 00:00:00:00:00:00:00 when I read data (because I
don't have bitflips on my flash). This looks to me more a "syndrom" than a
"calc_ecc".

To be sure, I could write a page of 512 bytes + 16 bytes, where the BCH would be
forced (and incorrect), to check what the hardware generator gives me back. I'd
like you to help me, ie:
 - tell me what to write to the first 512 bytes (only 0, all 0 but one byte to
 1, other ...)
 - I think I'll write 8 bytes to 0x01 for the first 8 OOB bytes (Hamming false
 but I won't care)
 - tell me what to write to the 7 BCH ECC

That way, I could provide you the result and you could tell me if
doc_ecc_bch_fix_data() is correct or not. Would you agree to spend some time on
that ?

Cheers.

--
Robert
