Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab2IUJhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:37:52 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:35931 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932609Ab2IUJhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:37:43 -0400
Date: Fri, 21 Sep 2012 12:32:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 03/25] userns: Convert usb functionfs to use kuid/kgid
 where appropriate
Message-ID: <20120921093252.GA15626@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
 <1348141326-23355-3-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <1348141326-23355-3-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 20, 2012 at 04:41:44AM -0700, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
>=20
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/f_fs.c |   23 ++++++++++++++++-------
>  init/Kconfig              |    1 -
>  2 files changed, 16 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 8adc79d..f9ee4e0 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -220,8 +220,8 @@ struct ffs_data {
>  	/* File permissions, written once when fs is mounted */
>  	struct ffs_file_perms {
>  		umode_t				mode;
> -		uid_t				uid;
> -		gid_t				gid;
> +		kuid_t				uid;
> +		kgid_t				gid;
>  	}				file_perms;
> =20
>  	/*
> @@ -1143,10 +1143,19 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_d=
ata *data, char *opts)
>  			break;
> =20
>  		case 3:
> -			if (!memcmp(opts, "uid", 3))
> -				data->perms.uid =3D value;
> +			if (!memcmp(opts, "uid", 3)) {
> +				data->perms.uid =3D make_kuid(current_user_ns(), value);
> +				if (!uid_valid(data->perms.uid)) {
> +					pr_err("%s: unmapped value: %lu\n", opts, value);
> +					return -EINVAL;
> +				}
> +			}
>  			else if (!memcmp(opts, "gid", 3))
> -				data->perms.gid =3D value;
> +				data->perms.gid =3D make_kgid(current_user_ns(), value);
> +				if (!gid_valid(data->perms.gid)) {
> +					pr_err("%s: unmapped value: %lu\n", opts, value);
> +					return -EINVAL;
> +				}
>  			else
>  				goto invalid;
>  			break;
> @@ -1175,8 +1184,8 @@ ffs_fs_mount(struct file_system_type *t, int flags,
>  	struct ffs_sb_fill_data data =3D {
>  		.perms =3D {
>  			.mode =3D S_IFREG | 0600,
> -			.uid =3D 0,
> -			.gid =3D 0
> +			.uid =3D GLOBAL_ROOT_UID,
> +			.gid =3D GLOBAL_ROOT_GID,
>  		},
>  		.root_mode =3D S_IFDIR | 0500,
>  	};
> diff --git a/init/Kconfig b/init/Kconfig
> index 633bde2..e7e0cc1 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -932,7 +932,6 @@ config UIDGID_CONVERTED
>  	depends on NET_9P =3D n
> =20
>  	# Filesystems
> -	depends on USB_FUNCTIONFS =3D n
>  	depends on DEVTMPFS =3D n
>  	depends on XENFS =3D n
> =20
> --=20
> 1.7.5.4
>=20

--=20
balbi

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQXDREAAoJEIaOsuA1yqREQVQQAKge0VRPy0D6c1gZ26nDY6sX
LSkYo611fbmQaJqwli8uGGoFRjWOJpvzXrRY+ZtIO7RsSsSH818S+3KYK2PiaoSW
BrqS/hnSomgZVX05DrPimBMF1T9jijY+pBxlGEFixJbI/kLSc5vt29myKDxwTxch
Tk9AYEDL2JCIhO5y/gLYEghY5a8AaoVRiRi/raP7YfgvBLuiMSw/LZ1EH21OYWN9
mQNG1tx8XdpDfjNICENVgLHJvgMD++YWU8rT+6UyJZZSfCHHhIY06yJkIH2x1J3A
zUm1Nwj9PWl+Ci+JnKWiKpZAFnps3+JN30bfjWIP8XEBSlaRoUcQg6aGzBN3bLfU
EF6KRZZNPR/yVjq8CSjReFiIx5S/+fY16CKZEr6GBSxqSzNtMiAQ4yWKQniHku4V
zZq/APK+MuqadKWqj3lAQ+kyZy1tObhgwUvWuK18j4MdYseiQXD5mmKlNtPyVJ3I
rja8nWd9QxZd4MMSDPHQ493OzCbf6ouaM3MYdu22FM2RM9vdoirWJnImYV/3mCtn
AoP0Nhr4Ef+GkFuTW/HL0RyVp2irrgHhcT/v1h2Hj+AGAgwWtzVNBqhiGZATFZWM
hiXijVWXKfL25EBNlL724excHtQGbhPTQ+a6t7hRQuMzCWAMHAJlk2IdWIFFubuA
ZMyItkYrusjH3zFkW5In
=kvb2
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
