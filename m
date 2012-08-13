Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2HMXwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 19:52:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab2HMXww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 19:52:52 -0400
Date: Tue, 14 Aug 2012 09:52:40 +1000
From: NeilBrown <neilb@suse.de>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH] md/linear: rcu_dereference outside read-lock section
Message-ID: <20120814095240.66d30903@notabene.brown>
In-Reply-To: <1344892092-13686-1-git-send-email-yefremov.denis@gmail.com>
References: <1344892092-13686-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sZu7htboQz06eJPgrKJALLD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sZu7htboQz06eJPgrKJALLD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Aug 2012 01:08:12 +0400 Denis Efremov <yefremov.denis@gmail.com>
wrote:

> According to the comment in linear_stop function
> rcu_dereference in linear_start and linear_stop functions
> occurs under reconfig_mutex. The patch represents this
> agreement in code and prevents lockdep complaint.
>=20
> Found by Linux Driver Verification project (linuxtesting.org)
>=20
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  drivers/md/linear.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index fa211d8..093f3e4 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -244,7 +244,8 @@ static int linear_add(struct mddev *mddev, struct md_=
rdev *rdev)
>  	if (!newconf)
>  		return -ENOMEM;
> =20
> -	oldconf =3D rcu_dereference(mddev->private);
> +	oldconf =3D rcu_dereference_protected(mddev->private,
> +					    lockdep_is_held(&mddev->reconfig_mutex));
>  	mddev->raid_disks++;
>  	rcu_assign_pointer(mddev->private, newconf);
>  	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
> @@ -256,7 +257,9 @@ static int linear_add(struct mddev *mddev, struct md_=
rdev *rdev)
> =20
>  static int linear_stop (struct mddev *mddev)
>  {
> -	struct linear_conf *conf =3D mddev->private;
> +	struct linear_conf *conf =3D
> +		rcu_dereference_protected(mddev->private,
> +					  lockdep_is_held(&mddev->reconfig_mutex));
> =20
>  	/*
>  	 * We do not require rcu protection here since


Applied, thanks.

NeilBrown

--Sig_/sZu7htboQz06eJPgrKJALLD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCmTSDnsnt1WYoG5AQIzxg//awAi/Ha1S9wqEs0Tg5BI/bGRssRYPPeA
3SM7LdMQmsvSiOMcaZTdsFvhwYzNgRqIjjf4bjGFrmZAfmQo+ZXeneV1UAu3wMtR
WV343jxzBfYlVS8j84r5zqEYVcRa11OmmoXYV46StFB5HNgt1BJBZp4kaQeQ5jTH
Ho2cmevt2nxPTUYZzyn4CZgmwF9Ur08ciFytiPf6cmBsNtW1DTdcp/4MCbSUTPM2
1D2squvYkE9t2MNR9JPJxVztgccc2URaPPgjp2nRgHQ2zGmRvMLDe6UTFk6InxXN
0xjk2E1uKj1pgexb6ZhB0tt0Nahpa4jfXY61n9eU00W/DuiYFKED7cooCxDZRGn7
H8YR1mfkZFxCNClBmwWhlWaNGb9Li3fwtUEI4sqxwWs8ixFSr9IrnaZvKgOjlYNh
xpihqkUuYSIIcJDakFZXWH5JUNcarJ82QiAHtp4cYP/XUMlo+zkYpcIqMYdYW4Ez
vEug9t0FCJlyHJuGaf38ydsnTplzun3l/yIGSbD0zmaV83reoCboY+260AT6uTrK
n8FC2wLItCOBNhbAj1bMrU8JeVrjYlmjic2SusdSSMPVRDrMBzJ20LfCT9sZGVRE
3W2slStdhWpadGkokWRuBZK/uu+4IwC5QPx7Kc3psr7lLPTFyPZmJPt01nnBsXE8
uazkzZYs6ks=
=yde4
-----END PGP SIGNATURE-----

--Sig_/sZu7htboQz06eJPgrKJALLD--
