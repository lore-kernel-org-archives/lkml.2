Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0L1Rmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:42:43 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47035 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844Ab0L1Rml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:42:41 -0500
X-Sasl-enc: CbUmcdTKTf57laa0C0ejQUp/zMc7zcsbeQ3hnECuWXRD 1293558161
Message-ID: <4D1A2185.2010700@imap.cc>
Date: Tue, 28 Dec 2010 18:42:29 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: gigaset307x-common@lists.sourceforge.net, Hansjoerg Lipp <hjlipp@web.de>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ISDN, Gigaset: Fix memory leak in do_disconnect_req()
References: <alpine.LNX.2.00.1012262053130.20797@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1012262053130.20797@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6ED4AC468D182965E55F7FDA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6ED4AC468D182965E55F7FDA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Quite correct. Thanks for finding and fixing this.

Am 26.12.2010 20:59 schrieb Jesper Juhl:
> Hi,
>=20
> In drivers/isdn/gigaset/capi.c::do_disconnect_req() we will leak the=20
> memory allocated (with kmalloc) to 'b3cmsg' if the call to alloc_skb() =

> fails.
>=20
> ...
> 		b3cmsg =3D kmalloc(sizeof(*b3cmsg), GFP_KERNEL);
> 	allocation here ------^
> 		if (!b3cmsg) {
> 			dev_err(cs->dev, "%s: out of memory\n", __func__);
> 			send_conf(iif, ap, skb, CAPI_MSGOSRESOURCEERR);
> 			return;
> 		}
> 		capi_cmsg_header(b3cmsg, ap->id, CAPI_DISCONNECT_B3, CAPI_IND,
> 				 ap->nextMessageNumber++,
> 				 cmsg->adr.adrPLCI | (1 << 16));
> 		b3cmsg->Reason_B3 =3D CapiProtocolErrorLayer1;
> 		b3skb =3D alloc_skb(CAPI_DISCONNECT_B3_IND_BASELEN, GFP_KERNEL);
> 		if (b3skb =3D=3D NULL) {
> 			dev_err(cs->dev, "%s: out of memory\n", __func__);
> 			send_conf(iif, ap, skb, CAPI_MSGOSRESOURCEERR);
> 			return;
> 	leak here ------^
> ...
>=20
> This leak is easily fixed by just kfree()'ing the memory allocated to=20
> 'b3cmsg' right before we return. The following patch does that.
>=20
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Tilman Schmidt <tilman@imap.cc>

> ---
>  capi.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
>   compile tested only since I have no way to actually test this.
>=20
> diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
> index bcc174e..658e75f 100644
> --- a/drivers/isdn/gigaset/capi.c
> +++ b/drivers/isdn/gigaset/capi.c
> @@ -1900,6 +1900,7 @@ static void do_disconnect_req(struct gigaset_capi=
_ctr *iif,
>  		if (b3skb =3D=3D NULL) {
>  			dev_err(cs->dev, "%s: out of memory\n", __func__);
>  			send_conf(iif, ap, skb, CAPI_MSGOSRESOURCEERR);
> +			kfree(b3cmsg);
>  			return;
>  		}
>  		capi_cmsg2message(b3cmsg,
>=20
>=20

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig6ED4AC468D182965E55F7FDA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0aIY0ACgkQQ3+did9BuFvleACgiOKWRS7raoY1QYHk4Jk9AJCe
N1kAn2sLz7Vatn9ZDrIv2k/nX4MWJm0B
=BQbd
-----END PGP SIGNATURE-----

--------------enig6ED4AC468D182965E55F7FDA--
