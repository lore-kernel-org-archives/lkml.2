Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1LZSRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 13:17:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54353 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1LZSRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 13:17:06 -0500
Date: Mon, 26 Dec 2011 19:17:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: fix regression in PIO case
In-Reply-To: <4EF8B42C.2020402@lwfinger.net>
Message-ID: <alpine.DEB.2.00.1112261909550.12108@axis700.grange>
References: <alpine.DEB.2.00.1112261608140.12108@axis700.grange> <alpine.DEB.2.00.1112261824000.12108@axis700.grange> <4EF8B42C.2020402@lwfinger.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:DXGNtZRUZbZ7rzStX+trAKrMyBMd6ntwWYNrpNTSCXI
 OaEJeN9iQ77x2gdaRsHt5JsQScasZf/F/jN/jbNRG8a2oHO459
 Y9T5+LFT83c0ku02pdgkKTOD+ZcR0XDl2NXxz5Loh5884DbX/t
 KMzT4wITAc1YaiLQrqvov+1s9tGfl3d6stg9+J7wF5YT4YWDfB
 bED8gVWUNXOGfcWHk8QhbCgIpgELgQ3kaXzqp3fDB/lLSSogys
 R3fWjagVT2nI9gFppTP4pryRWURF+qio9JT1VoNZMqws1u6VLp
 9hraXpEhZfzYe1rOEJ/Ezl4/4NBhXxF9AroskUMi3v9UKcmr7G
 NBp9C+xUV5KrAZKAynG2hMNT9tsHhLYjnz3TeZ/YRpqTl0pBov
 RCxWvhbIPWxhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Dec 2011, Larry Finger wrote:

> On 12/26/2011 11:28 AM, Guennadi Liakhovetski wrote:
> > This patch fixes the regression, introduced by
> > 
> > commit 17030f48e31adde5b043741c91ba143f5f7db0fd
> > From: Rafa³ Mi³ecki<zajec5@gmail.com>
> > Date: Thu, 11 Aug 2011 17:16:27 +0200
> > Subject: [PATCH] b43: support new RX header, noticed to be used in 598.314+
> > fw
> > 
> > in PIO case.
> > 
> > Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> > ---
> > diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
> > index ce8a4bd..b64b64c 100644
> > --- a/drivers/net/wireless/b43/pio.c
> > +++ b/drivers/net/wireless/b43/pio.c
> > @@ -617,9 +617,19 @@ static bool pio_rx_frame(struct b43_pio_rxqueue *q)
> >   	const char *err_msg = NULL;
> >   	struct b43_rxhdr_fw4 *rxhdr =
> >   		(struct b43_rxhdr_fw4 *)wl->pio_scratchspace;
> > +	size_t rxhdr_size = sizeof(*rxhdr);
> > 
> >   	BUILD_BUG_ON(sizeof(wl->pio_scratchspace)<  sizeof(*rxhdr));
> > -	memset(rxhdr, 0, sizeof(*rxhdr));
> > +	switch (dev->fw.hdr_format) {
> > +	case B43_FW_HDR_410:
> > +	case B43_FW_HDR_351:
> > +		rxhdr_size -= sizeof(rxhdr->format_598) -
> > +			sizeof(rxhdr->format_351);
> > +		break;
> > +	case B43_FW_HDR_598:
> > +		break;
> > +	}
> 
> I do not think the above will work for format_410. By my count, the format_410
> struct is 4 bytes longer than the format_351 struct.

I think you're looking at struct b43_txhdr, whereas the problem is in 
struct b43_rxhdr_fw4.

Thanks
Guennadi

> 
> Even if it does work, I suggest using the following:
> 
> 	size_t rxhdr_size;
> 
>    	BUILD_BUG_ON(sizeof(wl->pio_scratchspace)<  sizeof(*rxhdr));
> 	switch (dev->fw.hdr_format) {
> 	case B43_FW_HDR_351:
> 		rxhdr_size = sizeof(rxhdr->format_351);
> 		break;
> 	case B43_FW_HDR_410:
> etc.
> 
> 
> Larry
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
