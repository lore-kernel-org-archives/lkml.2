Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab2KUGoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 01:44:54 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:58676 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2KUGox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 01:44:53 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Wed, 21 Nov 2012 07:44:50 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v3] devtmpfs: mount with noexec and nosuid
Message-ID: <20121121064450.GB3620@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Kees Cook <keescook@chromium.org>,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	ellyjones@chromium.org, Kay Sievers <kay@vrfy.org>
References: <20121120215059.GA1859@www.outflux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20121120215059.GA1859@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-11-20 Tuesday at 13:50 -0800 Kees Cook wrote:
> Since devtmpfs is writable, make the default noexec,nosuid as well. This
> protects from the case of a privileged process having an arbitrary file
> write flaw and an argumentless arbitrary execution (i.e. it would lack
> the ability to run "mount -o remount,exec,suid /dev").
>=20
> Rather than relying on userspace "mount -o remount,noexec,nosuid /dev",
> accomplish this from the kernel. This means no additional exec during
> (potentially time-sensitive) boot is needed. The kernel is responsible
> for this mount, so the mount flags should be configurable.
>=20
> Cc: ellyjones@chromium.org
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Roland Eggner <edvx1@systemanalysen.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
>=20
> ---
> v3:
> - use a single define for the mount flags, suggested by Greg K.H.
> v2:
> - use CONFIG_DEVTMPFS_SAFE to wrap the logic.
> ---
>  drivers/base/Kconfig    |   12 ++++++++++++
>  drivers/base/devtmpfs.c |   11 +++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index b34b5cd..a37fcf2 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -56,6 +56,18 @@ config DEVTMPFS_MOUNT
>  	  rescue mode with init=3D/bin/sh, even when the /dev directory
>  	  on the rootfs is completely empty.
> =20
> +config DEVTMPFS_SAFE

Can we afford 2 additional characters and name it =E2=80=9CDEVTMPFS_NOEXEC=
=E2=80=9D?

> +	bool "Use nosuid,noexec mount options on devtmpfs"
> +	depends on DEVTMPFS
> +	help
> +	  This instructs the kernel to include the MS_NOEXEC and
> +	  MS_NOSUID mount flags when mounting devtmpfs. This prevents
> +	  certain kinds of code-execution attacks on embedded platforms.
> +
> +	  Notice: If enabled, things like /dev/mem cannot be mmapped
> +	  with the PROT_EXEC flag. This can break, for example, non-KMS
> +	  video drivers.
Proposal:
	help
	  This instructs the kernel to include the MS_NOEXEC and MS_NOSUID mount
	  flags when mounting devtmpfs.
	  In-kernel separation of executable and non-executable code combined
	  with a proper executability policy is a basic technique to protect
	  against exploits by buggy or malicious code or hardware errors.  In
	  terms of overhead it is a low-cost-high-effect technique especially on
	  platforms with dedicated hardware support, e.g. x86_64 (look for "NX"
	  feature in BIOS settings).  Mounting devtmpfs with MS_NOEXEC flag is
	  an essential building-block for this security technique.

	  Notice:  If enabled, software which depends on execution of
	  runtime-generated code can only be used with restricted feature set or
	  not at all, e.g. proprietary video drivers, JIT-compilers, most modern
	  web browsers.  The grsecurity-patchset provides exception mechanisms to
	  solve this problem for e.g. desktop systems.

	  For server and embedded systems with HA-requirements consider Y.
	  For desktop systems say N unless you know what you do.

Apart from that =E2=80=A6
Acked-by: Roland Eggner

> +
>  config STANDALONE
>  	bool "Select only drivers that don't need compile-time external firmwar=
e" if EXPERIMENTAL
>  	default y
> diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
> index 147d1a4..e44ca1d 100644
> --- a/drivers/base/devtmpfs.c
> +++ b/drivers/base/devtmpfs.c
> @@ -25,6 +25,12 @@
>  #include <linux/slab.h>
>  #include <linux/kthread.h>
> =20
> +#ifdef CONFIG_DEVTMPFS_SAFE
> +# define DEVTMPFS_MFLAGS	(MS_SILENT | MS_NOEXEC | MS_NOSUID)
> +#else
> +# define DEVTMPFS_MFLAGS	MS_SILENT
> +#endif
> +
>  static struct task_struct *thread;
> =20
>  #if defined CONFIG_DEVTMPFS_MOUNT
> @@ -347,7 +353,8 @@ int devtmpfs_mount(const char *mntdir)
>  	if (!thread)
>  		return 0;
> =20
> -	err =3D sys_mount("devtmpfs", (char *)mntdir, "devtmpfs", MS_SILENT, NU=
LL);
> +	err =3D sys_mount("devtmpfs", (char *)mntdir, "devtmpfs",
> +			DEVTMPFS_MFLAGS, NULL);
>  	if (err)
>  		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
>  	else
> @@ -372,7 +379,7 @@ static int devtmpfsd(void *p)
>  	*err =3D sys_unshare(CLONE_NEWNS);
>  	if (*err)
>  		goto out;
> -	*err =3D sys_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, options);
> +	*err =3D sys_mount("devtmpfs", "/", "devtmpfs", DEVTMPFS_MFLAGS, option=
s);
>  	if (*err)
>  		goto out;
>  	sys_chdir("/.."); /* will traverse into overmounted root */
> --=20
> 1.7.9.5
>=20
>=20
> --=20
> Kees Cook
> Chrome OS Security

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCseGEACgkQdN/hKfT7G/IN7QCguvn4NLfVAjUu5rnmEKXnrzWI
hAgAn399v0sGkK8ubx4SSugOUMVDVxu9
=SLAG
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
