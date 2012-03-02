Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab2CBRUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:20:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38096 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2CBRUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:20:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of slyich@gmail.com designates 10.213.19.83 as permitted sender) smtp.mail=slyich@gmail.com; dkim=pass header.i=slyich@gmail.com
Date: Fri, 2 Mar 2012 20:24:21 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Glauber Costa <glommer@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCHv 2] tcp: properly initialize tcp memory limits part 2
 (fix nfs regression)
Message-ID: <20120302202421.753b36bc@sf.home>
In-Reply-To: <4F509150.5060904@redhat.com>
References: <1330675173-18968-1-git-send-email-slyich@gmail.com>
	<4F509150.5060904@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bI_Plm/eG5_5ZOHWj55DqAo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bI_Plm/eG5_5ZOHWj55DqAo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> > The change looks like a typo (division flipped to multiplication):
> >> limit =3D nr_free_buffer_pages() / 8;
> >> limit =3D nr_free_buffer_pages()<<  (PAGE_SHIFT - 10);
>=20
> Hi, thanks for the reporting. It's not a typo. It was previously:=20
> sysctl_tcp_mem[1] << (PAGE_SHIFT -  7). Looks like we need to do the=20
> limit check before shift the value. Please try the following patch, thank=
s.

Still does not help. I test it by checking sha1sum of a large file over NFS
(small files seem to work simetimes):

    $ strace sha1sum /gentoo/distfiles/gcc-4.6.2.tar.bz2=20
    ...
    open("/gentoo/distfiles/gcc-4.6.2.tar.bz2", O_RDONLY
    <HUNG>
After a certain timeout dmesg gets odd spam:
[  314.848094] nfs: server vmhost not responding, still trying
[  314.848134] nfs: server vmhost not responding, still trying
[  314.848145] nfs: server vmhost not responding, still trying
[  314.957047] nfs: server vmhost not responding, still trying
[  314.957066] nfs: server vmhost not responding, still trying
[  314.957075] nfs: server vmhost not responding, still trying
[  314.957085] nfs: server vmhost not responding, still trying
[  314.957100] nfs: server vmhost not responding, still trying
[  314.958023] nfs: server vmhost not responding, still trying
[  314.958035] nfs: server vmhost not responding, still trying
[  314.958044] nfs: server vmhost not responding, still trying
[  314.958054] nfs: server vmhost not responding, still trying

looks like bogus messages. Might be relevant to mishandled timings
somewhere else or a bug in nfs code.

> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 22ef5f9..4035aab 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3299,8 +3299,8 @@ void __init tcp_init(void)
>=20
>          tcp_init_mem(&init_net);
>          /* Set per-socket limits to no more than 1/128 the pressure=20
> threshold */
> -       limit =3D nr_free_buffer_pages() << (PAGE_SHIFT - 10);
> -       limit =3D max(limit, 128UL);
> +       limit =3D nr_free_buffer_pages() / 8;
> +       limit =3D max(limit, 128UL) << (PAGE_SHIFT - 7);
>          max_share =3D min(4UL*1024*1024, limit);
>=20
>          sysctl_tcp_wmem[0] =3D SK_MEM_QUANTUM;
>=20
>=20
>=20


--=20

  Sergei

--Sig_/bI_Plm/eG5_5ZOHWj55DqAo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk9RAkwACgkQcaHudmEf86rz/gCfWiVShYHe8d5fxe7GN4o/C/O2
TwYAn0GugtZNsGcdaNAXQEoh/o6zihbK
=Y0Sa
-----END PGP SIGNATURE-----

--Sig_/bI_Plm/eG5_5ZOHWj55DqAo--
