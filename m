Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab2K3UeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:34:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40405 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2K3UeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:34:04 -0500
From: "Andrianov, Vitaly" <vitalya@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-keystone@list.ti.com - Linux developers for Keystone family of
	devices (May contain non-TIers)" <linux-keystone@list.ti.com>
CC: "Chemparathy, Cyril" <cyril@ti.com>
Subject: RE: [PATCH] drivers: cma: fix addressing on PAE machines
Thread-Topic: [PATCH] drivers: cma: fix addressing on PAE machines
Thread-Index: AQHNzvpklyG8DSzNVEuxTXCQ+cG3bJgC3YeA///3vQA=
Date: Fri, 30 Nov 2012 20:33:52 +0000
Message-ID: <C279DA448D408F43B343F09155C1EE9B0C223C7E@DFLE09.ent.ti.com>
References: <1354280283-28365-1-git-send-email-vitalya@ti.com>
 <xa1tk3t36sq4.fsf@mina86.com>
In-Reply-To: <xa1tk3t36sq4.fsf@mina86.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAUKYAGB024745



> -----Original Message-----
> From: Michal Nazarewicz [mailto:mpn@google.com] On Behalf Of Michal
> Nazarewicz
> Sent: Friday, November 30, 2012 10:01 AM
> To: Andrianov, Vitaly; m.szyprowski@samsung.com;
> kyungmin.park@samsung.com; arnd@arndb.de; linux-kernel@vger.kernel.org;
> linux-keystone@list.ti.com - Linux developers for Keystone family of
> devices (May contain non-TIers)
> Cc: Andrianov, Vitaly; Chemparathy, Cyril
> Subject: Re: [PATCH] drivers: cma: fix addressing on PAE machines
> 
> 
> On Fri, Nov 30 2012, Vitaly Andrianov <vitalya@ti.com> wrote:
> > This patch fixes a couple of bugs that otherwise impair CMA
> > functionality on PAE machines:
> >
> >   - alignment must be a 64-bit type when running on systems with 64-
> bit
> >     physical addresses.  If this is not the case, the limit
> calculation thunks
> >     allocations down to an address range < 4G.
> >
> >   - The allocated range check is removed. On 32bit ARM kernel with
> LPAE
> >     enabled the base may be allocated outside the fist 4GB of
> physical
> >     memory (keystone SoC for example).
> >
> > Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> > Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> 
> To be consistent, you should also change the type in:
> 
> static long size_cmdline = -1;
> static const unsigned long size_bytes = CMA_SIZE_MBYTES * SZ_1M; static
> unsigned long __init __maybe_unused cma_early_percent_memory(void)
> 
> and in
> 
> void __init dma_contiguous_reserve(phys_addr_t limit)
> 

Can you elaborate why we need to change type for size? 

> > ---
> >  drivers/base/dma-contiguous.c |    6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/drivers/base/dma-contiguous.c
> > b/drivers/base/dma-contiguous.c index 9a14694..7936b2e 100644
> > --- a/drivers/base/dma-contiguous.c
> > +++ b/drivers/base/dma-contiguous.c
> > @@ -234,7 +234,7 @@ int __init dma_declare_contiguous(struct device
> *dev, unsigned long size,
> >  				  phys_addr_t base, phys_addr_t limit)  {
> >  	struct cma_reserved *r = &cma_reserved[cma_reserved_count];
> > -	unsigned long alignment;
> > +	phys_addr_t alignment;
> >
> >  	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
> >  		 (unsigned long)size, (unsigned long)base, @@ -271,10 +271,6
> @@ int
> > __init dma_declare_contiguous(struct device *dev, unsigned long size,
> >  		if (!addr) {
> >  			base = -ENOMEM;
> >  			goto err;
> > -		} else if (addr + size > ~(unsigned long)0) {
> > -			memblock_free(addr, size);
> > -			base = -EINVAL;
> > -			goto err;
> >  		} else {
> >  			base = addr;
> >  		}
> > --
> > 1.7.9.5
> >
> 
> --
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  MichaÅ‚ â€œmina86â€ Nazarewicz    (o o)
> ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

Thanks,
Vitaly
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
