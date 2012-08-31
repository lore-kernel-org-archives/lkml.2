Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab2HaKiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 06:38:55 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:50900
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab2HaKix convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 06:38:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I542M1432Izz1202hzz8275ch8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220hbe9i1155h)
From: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
To: Liu Qiang-B32616 <B32616@freescale.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dan.j.williams@gmail.com" <dan.j.williams@gmail.com>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: Li Yang-R58472 <r58472@freescale.com>,
        Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
Thread-Topic: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
Thread-Index: AQHNdguqCb6kg8ccq0eFzI8Qh3DpXZdyVvuwgAFcbICAABX48A==
Date: Fri, 31 Aug 2012 10:38:46 +0000
Message-ID: <FD18E5D573A8AB48A365D4D78185DE992E9EFF@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1344500448-10927-1-git-send-email-qiang.liu@freescale.com>
 <FD18E5D573A8AB48A365D4D78185DE992E5C0D@039-SN1MPN1-001.039d.mgd.msft.net>
 <BCB48C05FCE8BC4D9E61E841ECBE6DB70FDB13@039-SN2MPN1-011.039d.mgd.msft.net>
In-Reply-To: <BCB48C05FCE8BC4D9E61E841ECBE6DB70FDB13@039-SN2MPN1-011.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.171.73.48]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2012 06:08:05 +0300, Liu Qiang-B32616 <B32616@freescale.com>
wrote:
> > -----Original Message-----
> > From: Geanta Neag Horia Ioan-B05471
> > Sent: Thursday, August 30, 2012 10:23 PM
> > To: Liu Qiang-B32616; linux-crypto@vger.kernel.org;
> > dan.j.williams@gmail.com; herbert@gondor.hengli.com.au;
> > davem@davemloft.net; linux-kernel@vger.kernel.org; linuxppc-
> > dev@lists.ozlabs.org
> > Cc: Li Yang-R58472; Phillips Kim-R1AAHA; vinod.koul@intel.com;
> > dan.j.williams@intel.com; arnd@arndb.de; gregkh@linuxfoundation.org; Liu
> > Qiang-B32616
> > Subject: RE: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
> >
> > On Thu, 9 Aug 2012 11:20:48 +0300, qiang.liu@freescale.com wrote:
> > > From: Qiang Liu <qiang.liu@freescale.com>
> > >
> > > Expose Talitos's XOR functionality to be used for RAID parity
> > > calculation via the Async_tx layer.
> > >
> > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > Cc: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Dipen Dudhat <Dipen.Dudhat@freescale.com>
> > > Signed-off-by: Maneesh Gupta <Maneesh.Gupta@freescale.com>
> > > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > > Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> > > Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> > > ---
> > >  drivers/crypto/Kconfig   |    9 +
> > >  drivers/crypto/talitos.c |  413
> > ++++++++++++++++++++++++++++++++++++++++++++++
> > >  drivers/crypto/talitos.h |   53 ++++++
> > >  3 files changed, 475 insertions(+), 0 deletions(-)
> >

> > > +static int talitos_alloc_chan_resources(struct dma_chan *chan)
> > > +{
> > > +	struct talitos_xor_chan *xor_chan;
> > > +	struct talitos_xor_desc *desc;
> > > +	LIST_HEAD(tmp_list);
> > > +	int i;
> > > +
> > > +	xor_chan = container_of(chan, struct talitos_xor_chan, common);
> > > +
> > > +	if (!list_empty(&xor_chan->free_desc))
> > > +		return xor_chan->total_desc;
> > > +
> > > +	for (i = 0; i < TALITOS_MAX_DESCRIPTOR_NR; i++) {
> > > +		desc = talitos_xor_alloc_descriptor(xor_chan,
> > > +				GFP_KERNEL | GFP_DMA);
> >
> > talitos_xor_alloc_descriptor() is called here without holding
> > the xor_chan->desc_lock and it increments xor_chan->total_desc.
> > Isn't this an issue ?
> 
> No, please refer to the code as below,
> +	list_add_tail(&desc->node, &tmp_list);
> 
> The list is temporary list, it will be merged to xor_chan->free_desc in next step, here is protected
> by lock,
> +	spin_lock_bh(&xor_chan->desc_lock);
> +	list_splice_init(&tmp_list, &xor_chan->free_desc);
> +	spin_unlock_bh(&xor_chan->desc_lock);

I was not referring to the list, but to xor_chan->total_desc variable.
The following access:
talitos_alloc_chan_resources()->talitos_xor_alloc_descriptor()->total_desc++
is not protected by the xor_chan->desc_lock.

