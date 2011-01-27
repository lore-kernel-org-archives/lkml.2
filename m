Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab1A0PVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:21:08 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39678 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1A0PVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=C51lf5kZ7NmhrB8MOHjtijp4IphuYJjkaNUhy+tMEZfcPAYRP9rXVsXnxJIErGlK/2
         5RmE/hvla1EmycDB/GjDjVqEd5Zcnp/me+uySC8f0S39P+AjPDANvhasHGPvGMJ+TSYq
         PyQ9OxntA1tr26maf7mDVqPi+IKICw82cVWeE=
Date: Thu, 27 Jan 2011 17:20:57 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: skb_split in tcp_retransmit_skb question
Message-ID: <20110127152057.GA4153@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

Suppose we have the following scenario:

tcp_write_timer ->
 tcp_retransmit_skb

in tcp_retransmit_skb we have `if (skb->len > cur_mss)' evaluted to true, w=
hich leads
to tcp_fragment(sk, skb, cur_mss, cur_mss) call. tcp_fragment calls skb_spl=
it(skb, buff, len)
which, in turn, calls skb_split_no_header(skb, skb1, len, pos), where we ha=
ve
`skb_shinfo(skb)->nr_frags++' while in `for (i =3D 0; i < nfrags; i++)' loo=
p.

Now we fall back to:=20
  tcp_retransmit_skb ->
   tcp_transmit_skb ->
    pskb_copy(skb, gfp_mask)

In pskb_copy we perform iteration on nr_frags:=20

 729     if (skb_shinfo(skb)->nr_frags) {
 730         int i;
 731         for (i =3D 0; i < skb_shinfo(skb)->nr_frags; i++) {
 732             skb_shinfo(n)->frags[i] =3D skb_shinfo(skb)->frags[i];
 733             get_page(skb_shinfo(n)->frags[i].page);
 734         }
 735         skb_shinfo(n)->nr_frags =3D i;
 736     }

The problem here is that nr_frags was increased in skb_split, yet new page =
was not allocated.
So, get_page(skb_shinfo(n)->frags[i].page) is actually get_page(NULL):

	mov (%rdx), %eax
	where %rdx is 0x00

Please correct me if I'm missing something.


	Sergey

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk1BjVkACgkQfKHnntdSXjStEQQAtGoCtmpqSH6kCkKWJnFZZudH
cClpseWSBenwbOxsJS6qZ9F3KYAcuBHT9PwFPR8N+kNpkTEBqqTXrq3KJ4lIXRUe
zMllGljq15rKk3tuXgJUsrgRMT3ovx/Y0PBe5pR5pubO5NWn2dSEfwvZxPG9+ueM
TXf0AZlr4wpyNfALUjE=
=Be4S
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
