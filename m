Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1KMKS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 05:18:29 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:54821 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab1KMKS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 05:18:27 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mike Dunn <mikedunn@newsguy.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/16] mtd/docg3: add OOB layout to mtdinfo
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
	<1320912342-30147-8-git-send-email-robert.jarzmik@free.fr>
	<4EBECB89.2020102@newsguy.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 13 Nov 2011 11:18:16 +0100
In-Reply-To: <4EBECB89.2020102@newsguy.com> (Mike Dunn's message of "Sat, 12
	Nov 2011 11:39:53 -0800")
Message-ID: <87vcqoiavr.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Dunn <mikedunn@newsguy.com> writes:

> On 11/10/2011 12:05 AM, Robert Jarzmik wrote:
>> +static struct nand_ecclayout docg3_oobinfo = {
>> +	.eccbytes = 8,
>> +	.eccpos = {7, 8, 9, 10, 11, 12, 13, 14},
>> +	.oobfree = {{0, 7}, {15, 1} },
>> +	.oobavail = 8,
>> +};
>> +

I took a different approach.  I check an internal docg3 register to see if the
page was written. Or I could had have checked the Hamming code, as I don't think
it can be 0xff whatever the pagesize 7 bytes values.

The reason behind is that the Hamming code is Ham(64, 57), ie. Ham(2^6,
2^6-6-1). The means the 6 bits are enough to cover all codewords possibilities,
and 0xff is not one of them.

So unless a bitflip in Hamming code, 0xff in it means blank page. And I think
the ECC engine is even smarter, with the ECCCONF1_PAGE_IS_WRITTEN.

>
> Just FYI, per Ivan's suggestion, I changed this to use the last oob byte as a
> "page programmed" flag for the purpose of detecting bit flips when reading a
> blank page.  Maybe something to keep in mind.  You can have a look at the latest
> G4 driver patch to see exactly how I use it.
I personally think this should be provided by the MTD API. A function
is_page_blank(ofs) could tell if the page was written or not. Now if the
function is NULL, the upper layer (UBIFS, ...) could decide _by itself_ to
assign a free OOB byte to that meaning. But IMHO it's not the drivers duty to
take these decisions to restrict the OOB, let it be done at an upper level.

Cheers.

-- 
Robert
