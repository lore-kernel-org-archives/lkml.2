Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0IAPFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:05:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44479 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab0IAPFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=sLmgniQ3pnUgY206FVAERrOsj+NJ61dfOGwDeT2TGqqjKDH2NIeh4Q+zSpetnumIkq
         EsmvHo1h6a2hicDCyVuLgC5l8VY9i7A2KCcuFsV0OCRTvydrx1xbmuzT6nFdYoJGhotP
         27qpYOZAVYonr1p4xa/9pfxnJYF8PoUsD3Rj8=
Date: Wed, 1 Sep 2010 17:05:04 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
Message-ID: <20100901150504.GA3091@del.dom.local>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
 <4AUWBNzTkbD.A.ey.cGueMB@chimera>
 <courier.4C7C99F2.00001F74@fs.ru.acad.bg>
 <20100831192659.GA3093@del.dom.local>
 <1283338251.2556.124.camel@edumazet-laptop>
 <20100901112026.GA9468@ff.dom.local>
 <1283349461.2556.333.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1283349461.2556.333.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 03:57:41PM +0200, Eric Dumazet wrote:
> Le mercredi 01 septembre 2010 ?? 11:20 +0000, Jarek Poplawski a écrit :
> > On Wed, Sep 01, 2010 at 12:50:51PM +0200, Eric Dumazet wrote:
> > > Plamen, could you test following patch ?
> > > 
> > > I reproduced problem on a dev machine and following patch cured it.
> > > 
> > > Thanks
> > > 
> > > [PATCH] gro: fix different skb headrooms
> > > 
> > > packets entering GRO might have different headrooms, even for a given
> > > flow (because of implementation details in drivers, like copybreak).
> > > We cant force drivers to deliver packets with a fixed headroom.
> > > 
> > > 1) fix skb_segment()
> > > 
> > > skb_segment() makes the false assumption headrooms of fragments are same
> > > than the head. When CHECKSUM_PARTIAL is used, this can give csum_start
> > > errors, and crash later in skb_copy_and_csum_dev()
> > 
> > Eric, probably I missed something, but since the same test as in
> > skb_copy_and_csum_dev() gave different result a bit earlier on exactly
> > the same skb, I've suspected some sharing (or use after free)
> > problems, so I'm not sure your current diagnose can explain this.
> > (Unless this old test was dismissed later.)
> 
> Oh, this is because your patch had an error for the gso part that read :
> 
> -               rc = ops->ndo_start_xmit(nskb, dev);
> +               if (skb_csum_start_bug(skb, 50)) {
> +                       kfree_skb(skb);
> +                       rc = NETDEV_TX_OK;
> +               } else
> +                       rc = ops->ndo_start_xmit(nskb, dev);
> +
>                 if (unlikely(rc != NETDEV_TX_OK)) {
>                         if (rc & ~NETDEV_TX_MASK)
>                                 goto out_kfree_gso_skb;
> 
> You called skb_csum_start_bug(skb, 50) instead of
> skb_csum_start_bug(nskb, 50)
> 
> Hope this clarify a bit ;)

All clear! Sorry for the false alarm!

Thanks,
Jarek P.
