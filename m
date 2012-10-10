Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2JJRIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:08:16 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:56770 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449Ab2JJRIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:08:09 -0400
Date: Wed, 10 Oct 2012 19:08:06 +0200
From: Ivan Djelic <ivan.djelic@parrot.com>
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 4/4] mtd: nand: omap2: Add data correction support
Message-ID: <20121010170806.GB13585@parrot.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
 <1349274589-11389-5-git-send-email-avinashphilip@ti.com>
 <20121003192044.GB27502@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9B8A65@DBDE01.ent.ti.com>
 <20121005142338.GA7199@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9CA829@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9CA829@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 01:36:50PM +0100, Philip, Avinash wrote:
(...)
> > There are at least 2 potential problems when reading an erased page with bitflips:
> > 
> > 1. bitflip in data area and no bitflip in spare area (all 0xff)
> > Your code will not perform any ECC correction.
> > UBIFS does not like finding bitflips in empty pages, see for instance
> > http://lists.infradead.org/pipermail/linux-mtd/2012-March/040328.html.
> 
> In case of error correction using ELM, syndrome vector calculated after reading
> Data area & OOB area. So handling of erased page requires a software workaround.
> I am planning something as follows.
> 
> I will first check calculated ecc, which would be zero for non error pages.
> Then I would check 0xFF in OOB area (for erased page) by checking number of
> bit zeros in OOB area.  If it is 0xFF (number of bit zero count is zero),
> set entire page as 0xFF if number of bit zeros is less than max bit flips
> (8 or 4) by counting the number of bit zero's in data area.
> 
> This logic is implemented in fsmc_nand.c
> 
> See commit
> mtd: fsmc: Newly erased page read algorithm implemented
> 
> > 
> > 2. bitflip in ECC bytes in spare area
> > Your code will report an uncorrectable error upon reading; if this happens while reading a partially programmed UBI block,
> > I guess you will lose data.
> 
> In case of uncorrectable errors due to bit flips in spare area,
> I can go on checking number of bit zero's in data area + OOB area
> are less than max bit flips (8 or 4), I can go on setting the entire
> page as 0xFF.
> 

OK, sounds reasonable.
Another simple strategy could use the fact that you add a 14th zero byte to
the 13 BCH bytes for RBL compatibility:

Upon reading:
 - if this 14th byte is zero (*) => page was programmed: perform ECC
   correction as usual
 - else, page was not programmed: do not perform ECC, read entire data+spare
   area, and set it to 0xff if less than 8 or 4 (max bitflips) zero bits
   were found

(*) for robustness to bitflip in 14th byte, replace condition
"14th byte is zero" by e.g. "14th byte has less than 4 bits set to 1".

What do you think ?

BR,
--
Ivan
