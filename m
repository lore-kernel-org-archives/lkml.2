Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab1J3AKt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 20:10:49 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:42797 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547Ab1J3AKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 20:10:48 -0400
Date: Sun, 30 Oct 2011 02:10:00 +0200
From: Ivan Djelic <ivan.djelic@parrot.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "mikedunn@newsguy.com" <mikedunn@newsguy.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] mtd/docg3: add ECC correction code
Message-ID: <20111030000959.GA12624@parrot.com>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
 <1319824292-11085-13-git-send-email-robert.jarzmik@free.fr>
 <20111029085248.GA12046@parrot.com>
 <8739ebbvow.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8739ebbvow.fsf@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 05:37:35PM +0100, Robert Jarzmik wrote:
> >> +static struct bch_control *docg3_bch;
> >
> > Why not putting this into your struct docg3, instead of adding a global var ?
> Because I have multiple floors (ie. 4 floors for example), which are split into
> 4 different devices. If I put that in docg3 structures (ie. the 4 allocated
> structures, each for one floor), I'd either have to :
>  - allocate 4 different bch "engines"
>  - or count docg3 releases and release the bch at the last kfree(docg3), which
>  makes me have another global variable.

OK, got it; using a struct to hold all your common vars (docg3_floors,
docg3_bch, ...) and hook that to your platform data instead of docg3_floors
would still be a bit cleaner I think, but no big deal.

> What I'm a bit afraid of is my poor understanding of the hardware ECC engine. I
> know that the write part is correct (ie. ECC calculation), but I'm a bit
> confused by the read part.
> 
> What wories me is that the hardware ECC got back while reading (ie. what I
> called calc_ecc) is always 00:00:00:00:00:00:00 when I read data (because I
> don't have bitflips on my flash). This looks to me more a "syndrom" than a
> "calc_ecc".

OK, I'll try to clarify that. The hardware ECC engine divides a huge polynomial
(520*8 = 4160 bits) by a generator polynomial and computes a 56-bit remainder.
So this remainder (let's call it R) depends only on 520 input data bytes.

- during a write operation: input data is what you write to the controller,
you get R from the ecc engine and this is what you write to oob[8..14].

- during a read operation: the ecc engine computes R on 520 input bytes read
from flash (this is calc_ecc), and also reads oob[8..14] (this is recv_ecc,
previously programmed during the write operation).
Then the ecc engine computes calc_ecc^recv_ecc, and this is what you get from
the ecc registers. And as long as there is no bitflip, its all 00s (because
calc_ecc=recv_ecc).

> To be sure, I could write a page of 512 bytes + 16 bytes, where the BCH would be
> forced (and incorrect), to check what the hardware generator gives me back. I'd
> like you to help me, ie:
>  - tell me what to write to the first 512 bytes (only 0, all 0 but one byte to
>  1, other ...)
>  - I think I'll write 8 bytes to 0x01 for the first 8 OOB bytes (Hamming false
>  but I won't care)
>  - tell me what to write to the 7 BCH ECC

OK, this is really simple:

1. Prepare a buffer of 520 bytes of data, containing pseudo-random bytes or
any pattern you like. Let's call this buffer 'ref_buf'.

2. Program 'ref_buf' to a nand page; you will write ecc bytes to oob during
that operation; let's call those ecc bytes 'ref_ecc'.

3. Now, you are ready to perform corruption tests:

 3.1 Make a copy of 'ref_buf' in which you flip 1, 2, 3 or 4 bits selected
     at random.

 3.2 Program this corrupt buffer, _but_ write 'ref_ecc' to oob instead of hw
     generated ecc bytes.

 3.3 Read page back: you should get exactly 'ref_buf', and the errorpos[]
     array of corrected bits should match your flip bits.

After step 3.2, your flash is exactly in the same state as if it had produced
the bitflips itself.

Repeat steps 3.1 to 3.3 on a large enough set of random vectors to convince
yourself that your code works (be careful not to wear out your device,
though :-). You should also try a few 5-bit corruptions and see failures, just
to verify that your corruptions have some effect.

In theory, testing the BCH algorithm like you did should be enough, but real
hardware tests are helpful to verify that the entire system behaves as
expected.

Hope that helps,
BR,
--
Ivan
