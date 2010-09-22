Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0IVEoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 00:44:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59872 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab0IVEoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 00:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FimVB6cATGe5ymOta78hfCgXMIyJZWm2cUE+4yvD8GNOql4pAQq92z8wWdzY6godLs
         5VJ11NDPL/TfGsSsuxqohfWEP4txvg+33QC6Kun+RtAus/3fLK9a0CiGGzuaSImTlRFO
         lZmLyeIBHH1RuQOfA2MeR142ybpRHLnZrbGrc=
Subject: Re: [PATCH] ip : take care of last fragment in ip_append_data
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: nbowler@elliptictech.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20100921.163856.71124744.davem@davemloft.net>
References: <1285013853.2323.148.camel@edumazet-laptop>
	 <1285018272.2323.243.camel@edumazet-laptop>
	 <1285049787.2323.797.camel@edumazet-laptop>
	 <20100921.163856.71124744.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 06:44:06 +0200
Message-ID: <1285130646.6378.45.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 21 septembre 2010 à 16:38 -0700, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 21 Sep 2010 08:16:27 +0200
> 
> > [PATCH] ip : take care of last fragment in ip_append_data
> > 
> > While investigating a bit, I found ip_fragment() slow path was taken
> > because ip_append_data() provides following layout for a send(MTU +
> > N*(MTU - 20)) syscall :
> > 
> > - one skb with 1500 (mtu) bytes
> > - N fragments of 1480 (mtu-20) bytes (before adding IP header)
> > last fragment gets 17 bytes of trail data because of following bit:
> > 
> > 	if (datalen == length + fraggap)
> > 		alloclen += rt->dst.trailer_len;
> > 
> > Then esp4 adds 16 bytes of data (while trailer_len is 17... hmm...
> > another bug ?)
> > 
> > In ip_fragment(), we notice last fragment is too big (1496 + 20) > mtu,
> > so we take slow path, building another skb chain.
> > 
> > In order to avoid taking slow path, we should correct ip_append_data()
> > to make sure last fragment has real trail space, under mtu...
> > 
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> This patch largely looks fine, but:
> 
> 1) I want to find out where that "17" tailer_len comes from before
>    applying this, that doesn't make any sense.
> 
> 2) Even with #1 addressed, this function is tricky so I want to review
>    this patch some more.



The "17" (instead of probable 16 need) comes from :

net/ipv4/esp4.c line 599 :

x->props.trailer_len = align + 1 + crypto_aead_authsize(esp->aead);

In my Nick ipsec script case, 
crypto_aead_blocksize(aead) = 16, 
crypto_aead_authsize(esp->aead) = 0

-> align = 16
trailer_len = 16 + 1 + 0;

I am not sure we need the "+ 1", but I know nothing about this stuff.

Same in net/ipv6/esp6.c ?


Anyway the last frag problem is for packets with lengths :
 MTU + N*(MTU - 20) + LAST

LAST being from [(MTU - trailer_len) ... MTU], not only MTU as I wrote
in changelog



