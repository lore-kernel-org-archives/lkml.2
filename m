Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0FOWXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 18:23:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:37443 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751833Ab0FOWXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 18:23:13 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX1+XNCM/UMuXQDn8sHX5vr1VEEe/Q5r4XuCxGBlk1x
	aYuR0Ig9flBcYt
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [PATCH] drivers/staging/batman-adv: Use (pr|netdev)_<level> macro helpers
Date: Wed, 16 Jun 2010 00:23:02 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, Marek Lindner <lindner_marek@yahoo.de>,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
       Andrew Lunn <andrew@lunn.ch>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       devel <devel@driverdev.osuosl.org>, b.a.t.m.a.n@lists.open-mesh.net,
       linux-kernel@vger.kernel.org
References: <1275498615.23599.12.camel@Joe-Laptop.home> <1275509466.23599.43.camel@Joe-Laptop.home>
In-Reply-To: <1275509466.23599.43.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9410837.8cLyrOzzOb";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201006160023.04296.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9410837.8cLyrOzzOb
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Joe Perches wrote:
> Compile tested only
>=20
> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Remove "batman-adv:" from format strings
> Use pr_<level>
> Use netdev_<level>
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

=46ound some time to play a little bit around with your patch and noticed t=
hat
it crashes the kernel. I did my tests using following "interesting" part:

[....]
> @@ -152,18 +155,18 @@ static ssize_t store_vis_mode(struct kobject *kobj,
> struct attribute *attr, if (buff[count - 1] =3D=3D '\n')
>  			buff[count - 1] =3D '\0';
>=20
> -		printk(KERN_INFO "batman-adv:Invalid parameter for 'vis mode' setting =
on mesh %s received: %s\n",
> -		       net_dev->name, buff);
> +		netdev_info(net_dev, "Invalid parameter for 'vis mode' setting on mesh=
 received: %s\n",
> +			    buff);
>  		return -EINVAL;
>  	}
>=20
>  	if (atomic_read(&bat_priv->vis_mode) =3D=3D vis_mode_tmp)
>  		return count;
>=20
> -	printk(KERN_INFO "batman-adv:Changing vis mode from: %s to: %s on mesh:=
 %s\n",
> -	       atomic_read(&bat_priv->vis_mode) =3D=3D VIS_TYPE_CLIENT_UPDATE ?
> -	       "client" : "server", vis_mode_tmp =3D=3D VIS_TYPE_CLIENT_UPDATE ?
> -	       "client" : "server", net_dev->name);
> +	netdev_info(net_dev, "Changing vis mode from: %s to: %s on mesh\n",
> +		    atomic_read(&bat_priv->vis_mode) =3D=3D VIS_TYPE_CLIENT_UPDATE ?
> +		    "client" : "server",
> +		    vis_mode_tmp =3D=3D VIS_TYPE_CLIENT_UPDATE ? "client" : "server");
>=20
>  	atomic_set(&bat_priv->vis_mode, (unsigned)vis_mode_tmp);
>  	return count;
[...]

I compiled the module and loaded it using `insmod batman-adv.ko`. This will
create some files in /sys. Just changed the vis mode to server using:

echo 0 > /sys/class/net/bat0/mesh/vis_mode

And then it will crash at that netdev_info call.

The problem seems to be that dev_printk is used by netdev_printk (which is
used by netdev_info). netdev_printk will add (netdev)->dev.parent as second
parameter of dev_printk (and parent is NULL in our case). This macro will n=
ow
call dev_driver_string with NULL as parameter and just dereference this nul=
l pointer.

Maybe it is related to something else, but at least I think that this could=
 be
the cause of the crash.

Best regards,
	Sven

--nextPart9410837.8cLyrOzzOb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJMF/1HAAoJEF2HCgfBJntGp4EQAM0w9doUEOLbqwNi2UYnIfe0
1VFfvrBdiB2MmrXBbDXMdg+APoUUZ8f+9aO6rnrZXbKBGJcac6uDoT4BgDBid46Y
A/ua9r4uUrwfg9Od1QlCDrnHKmsrzHdOIACF7GnPNRk5j42FU0siySVWq5PxIDLE
e+GFuB/2BLl16ip/c+mW/sqoXlOfT4Btat2kOlmMkByPJBHB+HF9gQ4XY0IwREzZ
qrAE318v9ILDVxZFfGxuSNnCheVzsE/PkXExvD+T5ldzfAKwnjEtjzTq/T8kUF/b
imcBdQa/jD/i5ddr/FYmTy+wVQqIOCspUsJrlVARrELBsIgWchIkZCM7Q7xmJpc2
XcwQW2Z1FInxIUCnWm4PVfbao751NjGgV+OmwHWBpxphgrqhekGv77K1qL7H7XFV
jSbMOGpTkV95E8VmIwlMgHdxDNFZopHzER4whXjdmjbJ+13ywQRKvbuUxkSYp8TH
W5dl5DxAGpzhjO3erg+cHi1jnTDM7Od27IDZDKLWG5FhtI4jBboqfENXRnRAERWe
fWj4QPQvAjw593BDXRBlTTzHlBA/+Y6wOiyLT3AKf7gnUiswZgb85T6NQbEcw2Su
PLmVa8oZVseoVnAOMAH6+STvUVpJpW4umUZREsC3Zsyvwzjb7trCZm/8x3EziMnz
3jjZsKr1OUF7dJYA6QY4
=TzFV
-----END PGP SIGNATURE-----

--nextPart9410837.8cLyrOzzOb--
