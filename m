Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2JKJHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:07:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51970 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab2JKJHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:07:03 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Ivan Djelic <ivan.djelic@parrot.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Mohammed, Afzal" <afzal@ti.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 4/4] mtd: nand: omap2: Add data correction support
Thread-Topic: [PATCH 4/4] mtd: nand: omap2: Add data correction support
Thread-Index: AQHNoXboDgXHKDcq00CaQ0Yo4e+M+penmT6AgAFWaxCAAWegIIAAE5sAgAZaH5CAAa98AIABGncg///k1ICAAGJcoA==
Date: Thu, 11 Oct 2012 09:05:38 +0000
Deferred-Delivery: Thu, 11 Oct 2012 09:05:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9CB982@DBDE01.ent.ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
 <1349274589-11389-5-git-send-email-avinashphilip@ti.com>
 <20121003192044.GB27502@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9B8A65@DBDE01.ent.ti.com>
 <20121005142338.GA7199@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9CA829@DBDE01.ent.ti.com>
 <20121010170806.GB13585@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9CB751@DBDE01.ent.ti.com>
 <20121011082149.GA15609@parrot.com>
In-Reply-To: <20121011082149.GA15609@parrot.com>
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

On Thu, Oct 11, 2012 at 13:51:49, Ivan Djelic wrote:
> On Thu, Oct 11, 2012 at 06:27:13AM +0100, Philip, Avinash wrote:
> (...)
> > > Another simple strategy could use the fact that you add a 14th zero byte to
> > > the 13 BCH bytes for RBL compatibility:
> > 
> > RBL compatibility (14th byte) is applicable only for BCH8 ecc scheme.
> > 
> > So I am planning adding an extra byte (0) for BCH4 ecc scheme. So with this
> > we can go for same approaches in BCH4 & BCH8 ecc scheme.
> > 
> > If I understood correctly, software BCH ecc scheme is modifying calculated
> > ecc data to handle bit flips in erased pages.
> > 
> > If that is the only reason, whether same logic can go for same ECC calculation
> > (remove modification of calculated ecc in case of software ecc correction)
> > by adding an extra byte (0) in spare area to handle erased pages.
> > 
> > So can you share if I am missing something?
> 
> Yes, the only reason why a constant polynomial is added to hw-generated ECC
> bytes is to transparently handle bitflips in erased pages.
> Handling erased pages this way has several benefits over the zero byte hack:
> - cleaner code, no checking of the zero byte
> - no expensive scan of data+spare area when reading an erased block: this
>   step can significantly slow down the initial UBI scan (lots of erased
>    pages to read)

Thanks for raising this point.
In order to reduce scan time of data+spare area when reading an erased block,
we can follow below steps

1. Create a standard ecc vector for erased page & check against it with calculated
   ecc of erased page.
2. If the vectors won't match, go for counting bit flips in erased page.
3. Again filtering of erased page can done by checking zero at fixed locations
   in spare area.
Note:
Reading of bits in erased page should done only for pages having bitflips.

> - no need to worry about the (very unlikely) possibility of having more
>   than 4 bitflips in the zero byte
> 
> OTOH, having the same ECC codes for both ELM and non-ELM chips with RBL
> compatibility sounds nice and would also simplify things.
> Note: on platforms where we use SW BCH correction, we also use the
> MLC OMAP boot mode, which is more robust and not compatible
> with 8-bit/4-bit BCH layouts.
> 
> I don't know which way is better for the OMAP community:
> 1. Unifying ECC modes = loosing the constant polynomial benefits,
>    but gaining RBL compat and simplifying code
> 2. Keeping separate ECC modes = code bloat
> 
> Tony, do you have an opinion on this ?
> 
> BTW, Afzal is submitting a series of patches [1] which are not
> compatible with your series; is there any plan to merge your patches ?

My next series will be on top Afzal's changes.

Thanks
Avinash

> 
> BR,
> --
> Ivan
> 
> [1] http://lists.infradead.org/pipermail/linux-mtd/2012-October/044374.html
> 

