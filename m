Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2ILJpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:45:12 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:29211
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218Ab2ILJpJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:45:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz1432Izz1202h1d1ah1d2ahzz17326ah8275eha1495iz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdhbe9i1155h)
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Dan Williams <djbw@fb.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Jiang <dave.jiang@gmail.com>
Subject: RE: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
Thread-Topic: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
Thread-Index: AQHNdgub00M+ZZ203UWQ+rzcgDFksJd3LRUAgAL+X1CAAUVXgIALLGUQ
Date: Wed, 12 Sep 2012 09:45:05 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB710E9A7@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1344500448-10927-1-git-send-email-qiang.liu@freescale.com>
	<CAA9_cmdqmuhAcaqfkjvKSpsTL350BAJcY8pn6U=SJ9Nok1-XuA@mail.gmail.com>
	<BCB48C05FCE8BC4D9E61E841ECBE6DB70FFB67@039-SN2MPN1-011.039d.mgd.msft.net>
 <CAA9_cmfT1R2+r9_8g0giMJz+wvrNce6T6GPDpvUTtcA-UyAZNQ@mail.gmail.com>
In-Reply-To: <CAA9_cmfT1R2+r9_8g0giMJz+wvrNce6T6GPDpvUTtcA-UyAZNQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.99]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Will this engine be coordinating with another to handle memory copies?
> >>  The dma mapping code for async_tx/raid is broken when dma mapping
> >> requests overlap or cross dma device boundaries [1].
> >>
> >> [1]: http://marc.info/?l=linux-arm-kernel&m=129407269402930&w=2
> > Yes, it needs fsl-dma to handle memcpy copies.
> > I read your link, the unmap address is stored in talitos hwdesc, the
> address will be unmapped when async_tx ack this descriptor, I know fsl-
> dma won't wait this ack flag in current kernel, so I fix it in fsl-dma
> patch 5/8. Do you mean that?
> 
> Unfortunately no.  I'm open to other suggestions. but as far as I can
> see it requires deeper changes to rip out the dma mapping that happens
> in async_tx and the automatic unmapping done by drivers.  It should
> all be pushed to the client (md).
> 
> Currently async_tx hides hardware details from md such that it doesn't
> even care if the operation is offloaded to hardware at all, but that
> takes things too far.  In the worst case an copy->xor chain handled by
> multiple channels results in :
> 
> 1/ dma_map(copy_chan...)
> 2/ dma_map(xor_chan...)
> 3/ <exec copy>
> 4/ dma_unmap(copy_chan...)
> 5/ <exec xor> <---initiated by the copy_chan
> 6/ dma_unmap(xor_chan...)
> 
> Step 2 violates the dma api since the buffers belong to the xor_chan
> until unmap.  Step 5 also causes the random completion context of the
> copy channel to bleed into submission context of the xor channel which
> is problematic.  So the order needs to be:
> 
> 1/ dma_map(copy_chan...)
> 2/ <exec copy>
> 3/ dma_unmap(copy_chan...)
> 4/ dma_map(xor_chan...)
> 5/ <exec xor> <--initiated by md in a static context
> 6/ dma_unmap(xor_chan...)
> 
> Also, if xor_chan and copy_chan lie with the same dma mapping domain
> (iommu or parent device) then we can map the stripe once and skip the
> extra maintenance for the duration of the chain of operations.  This
> dumps a lot of hardware details on md, but I think it is the only way
> to get consistent semantics when arbitrary offload devices are
> involved.
Thanks for your answer and links, I did some investigate these days,

first, powerpc processor should be hardware assured cache coherency, it should
be ok for hardware when in step 5 (but I will avoid map same address on different
device).

second, I have a workaround to make dma_map/unmap by order when using 2 different
device to offload, I will submit next descriptor until current descriptor complete,
        if (submit->flags & ASYNC_TX_ACK)
                async_tx_ack(tx);
        if (depend_tx)
                async_tx_ack(depend_tx);

+       /* do more check to support 2 devices offload? */
+       if (dma_wait_for_async_tx(tx) == DMA_ERROR)
+               panic("%s: DMA_ERROR waiting for tx\n", __func__);
}
EXPORT_SYMBOL_GPL(async_tx_submit);

Also use your example, 
1/ dma_map(copy_chan...)
2/ tx->submit(tx); async_tx_ack(tx);
3/ dma_unmap(copy_chan...)
4/ dma_map(xor_chan...)
5/ <exec xor> <-- initialized by tx->submit(tx);
6/ dma_unmap(xor_chan...)

Under this way, actually dma_run_dependency() is useless, so this can make sure copy
and xor with same page processed by order, and only one descriptor per channel is
served. dma_unmap in driver is controlled by client (tx->flags)

How's you thinking or any suggestions? I test it on our powerpc, I don't know whether
it does work on other architecture.

Thanks.

> 
> --
> Dan


