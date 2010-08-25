Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0HYFzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 01:55:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55105 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0HYFzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 01:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CV/ii/Zt13h4uu/bjKZPmlPBmvg4XeDIxRlJvPq5uhD4KO3HWSttX7+iqfeTIXHgNV
         h0c+V41ppDGX90A168JE3L/laupB3RuVpxb9I2ttNEJHif9EtU3Wamc0kTvMYm+L9dHB
         Xeb++1J4O+ngREJ5XsYbWBIs09DEO9y7vDS0k=
Subject: Re: RFC: MTU for serving NFS on Infiniband
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Marc Aurele La France <tsi@ualberta.ca>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <20100824153920.63360072@s6510>
References: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca>
	 <20100823080543.319143e3@nehalam>
	 <alpine.WNT.2.00.1008240856170.2000@cluij.ucs.ualberta.ca>
	 <1282672647.2302.15.camel@achroite.uk.solarflarecom.com>
	 <alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca>
	 <1282688441.22839.34.camel@localhost>  <20100824153920.63360072@s6510>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 07:54:58 +0200
Message-ID: <1282715698.2467.681.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 août 2010 à 15:39 -0700, Stephen Hemminger a écrit :

> IF NFS server is smart enough to generate:
>    Header (skb) + one or more pages in fragment list
> then IP fragmentation could do fragmentation by allocating
> new headers skb (small) and assigning the same pages to
> multiple skb's using page ref count.
> 
> It obviously isn't working that way.
> 

It is, but ip_append_data() is allocating a huge head if MTU is huge.

NFS is trying to build paged skb, to avoid order-X allocations (X > 0)

> The whole problem is moot because NFS over UDP has known data corruption
> issues in the face of packet loss.  The sequence number of the IP fragment
> can easily wrap around causing old data to be grouped with new data and
> the UDP checksum is so weak that the resulting UDP packet will be consumed by the NFS
> client ans passed to the user application as corrupted disk block.
> 
> DON'T USE NFS OVER UDP!

But Marc point is using a big MTU, so that no IP fragmentation is
needed.

All UDP applications using MSG_MORE will hit the order-2 allocations if
MTU=9000 for example...



