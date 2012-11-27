Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab2K0JIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:08:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52681 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab2K0JIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:08:31 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH v2 0/3] mtd: nand: OMAP: ELM error correction support
 for BCH ecc
Thread-Topic: [PATCH v2 0/3] mtd: nand: OMAP: ELM error correction support
 for BCH ecc
Thread-Index: AQHNtzjAYJXEaMIpjk+PG7tWZP2/spfqfEcAgAaEjeCAAudd0IABibAAgABzjZCAB6apQA==
Date: Tue, 27 Nov 2012 09:07:00 +0000
Deferred-Delivery: Tue, 27 Nov 2012 09:06:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9F0484@DBDE01.ent.ti.com>
References: <1351667307-447-1-git-send-email-avinashphilip@ti.com>
	 <1352978534.2221.33.camel@sauron.fi.intel.com>
	  <518397C60809E147AF5323E0420B992E3E9EC70D@DBDE01.ent.ti.com>
 <1353581032.2701.34.camel@sauron.fi.intel.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAR98c1R032144

On Thu, Nov 22, 2012 at 20:06:41, Philip, Avinash wrote:
> On Thu, Nov 22, 2012 at 16:13:52, Artem Bityutskiy wrote:
> > On Wed, 2012-11-21 at 07:01 +0000, Philip, Avinash wrote:
> > > > I am not sure how this dependency has to be handled for this series,
> > > > let me know whether you still want it to be made over l2-mtd?
> > > 
> > > Artem,
> > > 
> > > Is it possible for you to give ack for these patches so that these patches
> > > can go in Tony's tree where Omap-gpmc changes are present?
> > 
> > I would prefer if people like Ivan could take a look at this first.
> 
> Ok.

Ivan/Artem,

Any comments in this patch series?
I hope ELM support can get in 3.8.

> 
> > 
> > Also, I am not sure this is a good idea. Or at least we should agree on
> > some common strategy for bit-flips in the erased areas:
> > 
> > "+ * 1. If page is erased, check with standard ecc vector (ecc vector
> > + * for erased page to find any bit flip). If check fails, bit flip
> > + * is present in erased page. Count the bit flips in erased page and
> > + * if it falls under correctable level, report page with 0xFF and
> > + * update the correctable bit information."
> > 
> 
> Idea here is to make faster scanning of erased page without bit flips.
> For omap nand driver ecc reported by hardware is non-zero and non 0xff.
> So comparing with the standard vector for erased page and skipping error
> correction for erased page without bit flips.
> 
> Strategy for bit flips in erased page bit flips, can be
> 1. Don't make as erased page and mark it as bad.
> 2. Report the erased page with correctable bit flip if it falls under
>    correctable level. Report the page with erased page with correctable
>    errors.
> Is the concern is here with erased page with correctable error?
> I think as error is under correctable level, we still can use the page.
> May be we can think of limiting the check to half of correctable level?
> 
> I would go for option 2, see discussion [1].
>  
> Option 2 adopted in this patch series.
> 
> > Basically, you are working-around JFFS2 limitations.
> > 
> > Do you suggest we do this in all the drivers?
> 
> I am not sure how the situation handled in other drivers.
> This depends on the platforms. This method can be adopted for
> platforms where ecc reported non-zero & non 0xff with erased page.

Any comments?

Thanks
Avinash

> 
> > 
> > If we want to do this, may be we better do this in higher level, common
> > to all drivers?
> > 
> 
> I doubt how we handle in higher level with existing MTD setup.
> Issues I am seeing on implementing at higher layer is
> 1. Calculation of standard ecc vector for erased page.
> 2. Skipping ecc error correction, as currently error correction in
>    .read_page()
>  Can be handled by adding common .read_page() method on certain flag,
>  populated for platform specific.
> 
> 1. http://lists.infradead.org/pipermail/linux-mtd/2011-April/034604.html
> 
> Thanks
> Avinash
> 
> > -- 
> > Best Regards,
> > Artem Bityutskiy
> > 
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
