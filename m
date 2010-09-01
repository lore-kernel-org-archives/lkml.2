Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0IAN5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:57:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33817 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab0IAN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:57:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gkgfaKQCuZbTEYdE1w2rvcBBZ/Aah2NvuGz+XGjYiW44Wd22O3IHx8cqWbBN9awhPD
         cs4R3wkTjsXoLVDZTX9cI5XkXU48az/ecLK1gVgOkAM6iMKHAkBiOlVeFn85lR+PnU7T
         oxZZ+cdlHEGUY+gdANh1JDB44zfNRPVwUQX2I=
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
In-Reply-To: <20100901112026.GA9468@ff.dom.local>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	 <4AUWBNzTkbD.A.ey.cGueMB@chimera> <courier.4C7C99F2.00001F74@fs.ru.acad.bg>
	 <20100831192659.GA3093@del.dom.local>
	 <1283338251.2556.124.camel@edumazet-laptop>
	 <20100901112026.GA9468@ff.dom.local>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 15:57:41 +0200
Message-ID: <1283349461.2556.333.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 septembre 2010 à 11:20 +0000, Jarek Poplawski a écrit :
> On Wed, Sep 01, 2010 at 12:50:51PM +0200, Eric Dumazet wrote:
> > Plamen, could you test following patch ?
> > 
> > I reproduced problem on a dev machine and following patch cured it.
> > 
> > Thanks
> > 
> > [PATCH] gro: fix different skb headrooms
> > 
> > packets entering GRO might have different headrooms, even for a given
> > flow (because of implementation details in drivers, like copybreak).
> > We cant force drivers to deliver packets with a fixed headroom.
> > 
> > 1) fix skb_segment()
> > 
> > skb_segment() makes the false assumption headrooms of fragments are same
> > than the head. When CHECKSUM_PARTIAL is used, this can give csum_start
> > errors, and crash later in skb_copy_and_csum_dev()
> 
> Eric, probably I missed something, but since the same test as in
> skb_copy_and_csum_dev() gave different result a bit earlier on exactly
> the same skb, I've suspected some sharing (or use after free)
> problems, so I'm not sure your current diagnose can explain this.
> (Unless this old test was dismissed later.)

Oh, this is because your patch had an error for the gso part that read :

-               rc = ops->ndo_start_xmit(nskb, dev);
+               if (skb_csum_start_bug(skb, 50)) {
+                       kfree_skb(skb);
+                       rc = NETDEV_TX_OK;
+               } else
+                       rc = ops->ndo_start_xmit(nskb, dev);
+
                if (unlikely(rc != NETDEV_TX_OK)) {
                        if (rc & ~NETDEV_TX_MASK)
                                goto out_kfree_gso_skb;

You called skb_csum_start_bug(skb, 50) instead of
skb_csum_start_bug(nskb, 50)

Hope this clarify a bit ;)

Thanks


