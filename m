Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197Ab2BJVBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:01:00 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:35061 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759113Ab2BJVAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:00:51 -0500
Date: Fri, 10 Feb 2012 13:00:29 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] PCI: only enable pci realloc when SRIOV bar is not
 assigned
Message-ID: <20120210130029.44d2a823@jbarnes-desktop>
In-Reply-To: <1328424908-6385-10-git-send-email-yinghai@kernel.org>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
	<1328424908-6385-10-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_6IeE_hVtx2YvmdFS1c=ZLy"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_6IeE_hVtx2YvmdFS1c=ZLy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Feb 2012 22:55:08 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> If bios does not assign those BAR or wrong address, then kernel will
> try to do pci realloc.
>=20
> in that case, user still can use pci=3Drealloc=3Doff to override it.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |   28 ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 9526038..520f256 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -1293,6 +1293,31 @@ static bool __init pci_realloc_enabled(void)
>  	return pci_realloc_enable >=3D enable_yes_user;
>  }
> =20
> +static void __init pci_realloc_detect(void)
> +{
> +	struct pci_dev *dev =3D NULL;
> +
> +	if (pci_realloc_enable !=3D enable_not_set)
> +		return;
> +
> +#ifdef CONFIG_PCI_IOV
> +	for_each_pci_dev(dev) {
> +		int i;
> +
> +		for (i =3D PCI_IOV_RESOURCES; i <=3D PCI_IOV_RESOURCE_END; i++) {
> +			struct resource *r =3D &dev->resource[i];
> +
> +			/* Not assigned, or rejected by kernel */
> +			if (r->flags && !r->start) {
> +				pci_realloc_enable =3D enable_yes_detected;
> +
> +				return;
> +			}
> +		}
> +	}
> +#endif
> +}
> +
>  /*
>   * first try will not touch pci bridge res
>   * second  and later try will clear small leaf bridge res
> @@ -1314,6 +1339,7 @@ pci_assign_unassigned_resources(void)
>  	int pci_try_num =3D 1;
> =20
>  	/* don't realloc if asked to do so */
> +	pci_realloc_detect();
>  	if (pci_realloc_enabled()) {
>  		int max_depth =3D pci_get_max_depth();
> =20
> @@ -1348,6 +1374,8 @@ again:
>  	if (tried_times >=3D pci_try_num) {
>  		if (pci_realloc_enable =3D=3D enable_not_set)
>  			printk(KERN_INFO "Some pci devices resources are not assigned, please=
 try to boot with pci=3Drealloc\n");
> +		else if (pci_realloc_enable =3D=3D enable_yes_detected)
> +			printk(KERN_INFO "Automatically enabled pci realloc, if you have prob=
lem, please try to boot with pci=3Drealloc=3Doff\n");
> =20
>  		free_list(&fail_head);
>  		goto enable_and_dump;

Not sure I like this one either.  Distros will want to enable IOV by
default, but in most configs users still won't use it, and many BIOSes
won't bother to allocate IOV space.  So defaulting to trying to do so
will likely cause a lot of unnecessary re-allocation.

So distro guidance would be appreciated here for the default behavior.
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/_6IeE_hVtx2YvmdFS1c=ZLy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNYVtAAoJEIEoDkX4Qk9h5X4P/iRqZRAm0pOQzkmxb+Lvk1ph
ji52XpGOALbgpPjs20+RhqwDDp4c3+tsKBy8WuDzLpVxo0nMhMTDc6UweC8bMKHj
K4g8geMFZOC6bj9DL3QwP6BPKiwlSP6fyCbSsvUwsmvli8xHl2tgIcqahVj0qhfv
hLxHr4yD40UoF8vGQzoH8qfLep6WBpvT9yY8U/ccEtGwNqGC79FTqgwnceaL6BrE
aOtcYIBXx/FTRygUxEeI3Y15hGOG3Jl6Ls0I+REWR+KNj7MTo+az5x6OTDv4q7NA
GmB54VKQna1Bl1bkiWAjNkNmyRDuzFlvGHDUNyT9TLCcprpp7zS3J4EQl23HrsoP
cobdfUhQkHugEYbgbU2OWE2ecD2LK7Sitbq8yirR/7ASz2RBQIr1eTcyrwHiSzwJ
ECLySRjP3sVJd6FAxzJPRiMOR6Z9qMHldKr/D/5pgWvLm2qz8WYgW33mS6A8X8zD
sU31yl1xOb8e3USVZWlAP12Ddjy/pniAkdWvJxjDqnJkv0xHrUA3JfBSSI8dGv9S
N+qMuFrt6FT7MibZwsJjuwrUA57qOTEDQA1Gox5fOrSzYha1TpyS6CYJgQFzqAyY
X8a43lN0cj2N/4R0pmbsk1sMnW36b8A6a6lk3DLnFQyL4ZUUjgpyMBHulUcOnqlJ
k1N74ERUCewnyyzJoVmW
=MMzw
-----END PGP SIGNATURE-----

--Sig_/_6IeE_hVtx2YvmdFS1c=ZLy--
