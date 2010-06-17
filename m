Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab0FQOms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:42:48 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2273 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0FQOmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:42:46 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Michael Chan" <mchan@broadcom.com>
To: "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
       "'davem@davemloft.net'" <davem@davemloft.net>
cc: "JBottomley@Novell.com" <JBottomley@Novell.com>,
       "vapier@gentoo.org" <vapier@gentoo.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Jun 2010 07:42:29 -0700
Subject: Re: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
Thread-Topic: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
Thread-Index: AcsOJkDMIdw3844bScGMb1hnrLyYcwABLX0g
Message-ID: <C27F8246C663564A84BB7AB3439772421B79CBCA22@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20100617230435J.fujita.tomonori@lab.ntt.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 6004EBDF20S160702127-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:

> On Thu, 17 Jun 2010 06:30:39 -0700
> "Michael Chan" <mchan@broadcom.com> wrote:
>
> > James Bottomley wrote:
> >
> > > On Thu, 2010-06-17 at 05:54 -0700, Michael Chan wrote:
> > > > This prefetch improves performance noticeably when the driver is
> > > > handling incoming 64-byte packets at a sustained rate.
> > >
> > > So why not do it unconditionally?  The worst that can happen
> > > is that you
> > > pull in a stale cache line which will get cleaned in the
> > > dma_sync, thus
> > > slightly degrading performance on incoherent architectures.
> >
> > The original patch was an unconditional prefetch.  There was
> > some discussion that it might not be correct if the DMA wasn't
> > sync'ed yet on some archs.  If the concensus is that it is ok to
> > do so, that would be the simplest solution.
>
> As James said, it just adds useless prefetch on incoherent
> architectures. sync_single_for_cpu is called later so we can see the
> correct data. One useless prefetch is unlikely to lead performance
> drop.
>
> You might prefer this v2.

Yes, thanks.
Acked-by: Michael Chan <mchan@broadcom.com>

>
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH v2] bnx2: fix dma_get_ops compilation breakage
>
> This removes dma_get_ops() prefetch optimization in bnx2.
>
> bnx2 uses dma_get_ops() to see if dma_sync_single_for_cpu() is
> noop. bnx2 does prefetch if it's noop.
>
> But dma_get_ops() isn't available on all the architectures (only the
> architectures that uses dma_map_ops struct have it). Using
> dma_get_ops() in drivers leads to compilation breakage on many
> archtectures.
>
> This patch removes dma_get_ops() and changes bnx2 to do prefetch on
> all the architectures. This adds useless prefetch on incoherent
> architectures but this is harmless. It is also unlikely to cause the
> performance drop.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/net/bnx2.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
> index 949d7a9..85f1692 100644
> --- a/drivers/net/bnx2.c
> +++ b/drivers/net/bnx2.c
> @@ -3099,12 +3099,10 @@ bnx2_rx_int(struct bnx2 *bp, struct
> bnx2_napi *bnapi, int budget)
>               skb = rx_buf->skb;
>               prefetchw(skb);
>
> -             if (!get_dma_ops(&pdev->dev)->sync_single_for_cpu) {
> -                     next_rx_buf =
> -                             &rxr->rx_buf_ring[
> -
> RX_RING_IDX(NEXT_RX_BD(sw_cons))];
> -                     prefetch(next_rx_buf->desc);
> -             }
> +             next_rx_buf =
> +
> &rxr->rx_buf_ring[RX_RING_IDX(NEXT_RX_BD(sw_cons))];
> +             prefetch(next_rx_buf->desc);
> +
>               rx_buf->skb = NULL;
>
>               dma_addr = dma_unmap_addr(rx_buf, mapping);
> --
> 1.6.5
>
>
>

