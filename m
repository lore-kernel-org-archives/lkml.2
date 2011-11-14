Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab1KNBOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 20:14:42 -0500
Received: from smtp.newsguy.com ([74.209.136.69]:65507 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab1KNBOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 20:14:41 -0500
Message-ID: <4EC0794B.3010604@newsguy.com>
Date: Sun, 13 Nov 2011 18:13:31 -0800
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110917 Lightning/1.0b3pre Thunderbird/3.1.12
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, dedekind1@gmail.com
Subject: Re: [PATCH v2 13/16] mtd/docg3: add ECC correction code
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr> <1320912342-30147-14-git-send-email-robert.jarzmik@free.fr> <4EBECDCB.306@newsguy.com> <87mxc0ia3e.fsf@free.fr>
In-Reply-To: <87mxc0ia3e.fsf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2011 02:35 AM, Robert Jarzmik wrote:
> Mike Dunn <mikedunn@newsguy.com> writes:
>
>>
>> Where do you check for reads of a blank page?
> On stack frame above. Look at doc_read_oob():
> 		if ((block0 >= DOC_LAYOUT_BLOCK_FIRST_DATA) &&
> 		    (eccconf1 & DOC_ECCCONF1_BCH_SYNDROM_ERR) &&
> 		    (eccconf1 & DOC_ECCCONF1_PAGE_IS_WRITTEN) &&
>                                 \---> this is the key
> 		    (ops->mode != MTD_OPS_RAW) &&
> 		    (nbdata == DOC_LAYOUT_PAGE_SIZE)) {
> 			ret = doc_ecc_bch_fix_data(docg3, buf, hwecc);
>
> Here you see that I'll make the error correction only if the page was written
> before. If it's blank, I continue reading without attempting ECC correction.


G4 probably has this capability too.  If so, I'll be improving my blank page
detection.  I *really* have to go through your driver in its entirety to see
what other insights you have.  Currently getting pulled in multiple directions.


>> Not specifically related to this patch, but... are you sure you want to
>> initialize the ecc on every read?  I'm sure it's not necessary; you can just
>> leave it on; maybe turn it off if doing raw reads.  I know this is the case for
>> both the P3 and G4 when running under PalmOS / TrueFFS library.  I notice that
>> this function has delays and polls the status register in between calls to
>> cpu_relax(), so the performance hit is probably not insignificant, especiallu
>> when done for every 512 byte page.
> Well, that's some info.
> And yes, it adds some latency.
> Now for the necessity, I'm not fully convinced. I know that the ECC register is
> set up differently for reads and writes (that's the
> DOC_ECCCONF0_READ_MODE). When doc_read_oob() is called, I don't know if the
> previous action was a read or a write ...
>
> What I could do to improve performance would be to store in the docg3 private
> data if last action was a read or a write, and perform the doc_*_page_ecc_init()
> only if action changes. What do you think ?
>


Never mind.  Sorry.  I was thinking DOC_ECCCONF1, which I write to during
initialization to (I believe) enable ecc.  Anyway, you have a better handle on
the internals of the chip than I do.  I'm still looking forward to comparing
your code to my old P3 test code (which mostly just parrots what I observed
during operation).  Until then I'll keep my opinions on register sequences, etc,
to myself!'

Good job!

Mike

