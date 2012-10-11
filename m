Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2JKF2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:28:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45726 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab2JKF23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:28:29 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Ivan Djelic <ivan.djelic@parrot.com>
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
Subject: RE: [PATCH 4/4] mtd: nand: omap2: Add data correction support
Thread-Topic: [PATCH 4/4] mtd: nand: omap2: Add data correction support
Thread-Index: AQHNoXboDgXHKDcq00CaQ0Yo4e+M+penmT6AgAFWaxCAAWegIIAAE5sAgAZaH5CAAa98AIABGncg
Date: Thu, 11 Oct 2012 05:27:13 +0000
Deferred-Delivery: Thu, 11 Oct 2012 05:27:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9CB751@DBDE01.ent.ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
 <1349274589-11389-5-git-send-email-avinashphilip@ti.com>
 <20121003192044.GB27502@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9B8A65@DBDE01.ent.ti.com>
 <20121005142338.GA7199@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9CA829@DBDE01.ent.ti.com>
 <20121010170806.GB13585@parrot.com>
In-Reply-To: <20121010170806.GB13585@parrot.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 22:38:06, Ivan Djelic wrote:
> On Tue, Oct 09, 2012 at 01:36:50PM +0100, Philip, Avinash wrote:
> (...)
> > > There are at least 2 potential problems when reading an erased page with bitflips:
> > > 
> > > 1. bitflip in data area and no bitflip in spare area (all 0xff)
> > > Your code will not perform any ECC correction.
> > > UBIFS does not like finding bitflips in empty pages, see for instance
> > > http://lists.infradead.org/pipermail/linux-mtd/2012-March/040328.html.
> > 
> > In case of error correction using ELM, syndrome vector calculated after reading
> > Data area & OOB area. So handling of erased page requires a software workaround.
> > I am planning something as follows.
> > 
> > I will first check calculated ecc, which would be zero for non error pages.
> > Then I would check 0xFF in OOB area (for erased page) by checking number of
> > bit zeros in OOB area.  If it is 0xFF (number of bit zero count is zero),
> > set entire page as 0xFF if number of bit zeros is less than max bit flips
> > (8 or 4) by counting the number of bit zero's in data area.
> > 
> > This logic is implemented in fsmc_nand.c
> > 
> > See commit
> > mtd: fsmc: Newly erased page read algorithm implemented
> > 
> > > 
> > > 2. bitflip in ECC bytes in spare area
> > > Your code will report an uncorrectable error upon reading; if this happens while reading a partially programmed UBI block,
> > > I guess you will lose data.
> > 
> > In case of uncorrectable errors due to bit flips in spare area,
> > I can go on checking number of bit zero's in data area + OOB area
> > are less than max bit flips (8 or 4), I can go on setting the entire
> > page as 0xFF.
> > 
> 
> OK, sounds reasonable.
> Another simple strategy could use the fact that you add a 14th zero byte to
> the 13 BCH bytes for RBL compatibility:

RBL compatibility (14th byte) is applicable only for BCH8 ecc scheme.

So I am planning adding an extra byte (0) for BCH4 ecc scheme. So with this
we can go for same approaches in BCH4 & BCH8 ecc scheme.

If I understood correctly, software BCH ecc scheme is modifying calculated
ecc data to handle bit flips in erased pages.

If that is the only reason, whether same logic can go for same ECC calculation
(remove modification of calculated ecc in case of software ecc correction)
by adding an extra byte (0) in spare area to handle erased pages.

So can you share if I am missing something?

> 
> Upon reading:
>  - if this 14th byte is zero (*) => page was programmed: perform ECC
>    correction as usual
>  - else, page was not programmed: do not perform ECC, read entire data+spare
>    area, and set it to 0xff if less than 8 or 4 (max bitflips) zero bits
>    were found
> 
> (*) for robustness to bitflip in 14th byte, replace condition
> "14th byte is zero" by e.g. "14th byte has less than 4 bits set to 1".
> 
> What do you think ?

This seems logically good.

Thanks
Avinash

> 
> BR,
> --
> Ivan
> 

