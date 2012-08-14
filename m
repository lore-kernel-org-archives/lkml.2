Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2HNBq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:46:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44750 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754622Ab2HNBqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:46:25 -0400
Message-ID: <1344908771.824.156.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH V2 06/18] Tools: hv: Further refactor
 kvp_get_ip_address()
From: Ben Hutchings <ben@decadent.org.uk>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Date: Tue, 14 Aug 2012 02:46:11 +0100
In-Reply-To: <1344877627-21779-6-git-send-email-kys@microsoft.com>
References: <1344877584-21738-1-git-send-email-kys@microsoft.com>
	 <1344877627-21779-1-git-send-email-kys@microsoft.com>
	 <1344877627-21779-6-git-send-email-kys@microsoft.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BenmZAdiE66SSBmRexQv"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BenmZAdiE66SSBmRexQv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 10:06 -0700, K. Y. Srinivasan wrote:
> In preparation for making kvp_get_ip_address() more generic, factor out
> the code for handling IP addresses.
>=20
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: Olaf Hering <olaf@aepfle.de>
> Reviewed-by: Ben Hutchings <ben@decadent.org.uk>

I looked at your last patch set, so in a sense these have been reviewed
by me.  But the 'Reviewed-by' line in a commit message means the
reviewer thinks it's OK; the reviewer must say that, and I didn't.

Ben.

> ---
>  tools/hv/hv_kvp_daemon.c |   94 ++++++++++++++++++++--------------------=
-----
>  1 files changed, 42 insertions(+), 52 deletions(-)
>=20
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 3af37f0..3dc989f 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -491,17 +491,50 @@ done:
>  	return;
>  }
> =20
> +static int kvp_process_ip_address(void *addrp,
> +				int family, char *buffer,
> +				int length,  int *offset)
> +{
> +	struct sockaddr_in *addr;
> +	struct sockaddr_in6 *addr6;
> +	int addr_length;
> +	char tmp[50];
> +	const char *str;
> +
> +	if (family =3D=3D AF_INET) {
> +		addr =3D (struct sockaddr_in *)addrp;
> +		str =3D inet_ntop(family, &addr->sin_addr, tmp, 50);
> +		addr_length =3D INET_ADDRSTRLEN;
> +	} else {
> +		addr6 =3D (struct sockaddr_in6 *)addrp;
> +		str =3D inet_ntop(family, &addr6->sin6_addr.s6_addr, tmp, 50);
> +		addr_length =3D INET6_ADDRSTRLEN;
> +	}
> +
> +	if ((length - *offset) < addr_length + 1)
> +		return 1;
> +	if (str =3D=3D NULL) {
> +		strcpy(buffer, "inet_ntop failed\n");
> +		return 1;
> +	}
> +	if (*offset =3D=3D 0)
> +		strcpy(buffer, tmp);
> +	else
> +		strcat(buffer, tmp);
> +	strcat(buffer, ";");
> +
> +	*offset +=3D strlen(str) + 1;
> +	return 0;
> +}
> +
>  static int
>  kvp_get_ip_address(int family, char *if_name, int op,
>  		 void  *out_buffer, int length)
>  {
>  	struct ifaddrs *ifap;
>  	struct ifaddrs *curp;
> -	int ipv4_len =3D strlen("255.255.255.255") + 1;
> -	int ipv6_len =3D strlen("ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff")+1;
>  	int offset =3D 0;
>  	const char *str;
> -	char tmp[50];
>  	int error =3D 0;
>  	char *buffer;
>  	struct hv_kvp_ipaddr_value *ip_buffer;
> @@ -556,55 +589,12 @@ kvp_get_ip_address(int family, char *if_name, int o=
p,
>  			continue;
>  		}
> =20
> -		if ((curp->ifa_addr->sa_family =3D=3D AF_INET) &&
> -			((family =3D=3D AF_INET) || (family =3D=3D 0))) {
> -			struct sockaddr_in *addr =3D
> -			(struct sockaddr_in *) curp->ifa_addr;
> -
> -			str =3D inet_ntop(AF_INET, &addr->sin_addr, tmp, 50);
> -			if (str =3D=3D NULL) {
> -				strcpy(buffer, "inet_ntop failed\n");
> -				error =3D 1;
> -				goto getaddr_done;
> -			}
> -			if (offset =3D=3D 0)
> -				strcpy(buffer, tmp);
> -			else
> -				strcat(buffer, tmp);
> -			strcat(buffer, ";");
> -
> -			offset +=3D strlen(str) + 1;
> -			if ((length - offset) < (ipv4_len + 1))
> -				goto getaddr_done;
> -
> -		} else if ((family =3D=3D AF_INET6) || (family =3D=3D 0)) {
> -
> -			/*
> -			 * We only support AF_INET and AF_INET6
> -			 * and the list of addresses is separated by a ";".
> -			 */
> -			struct sockaddr_in6 *addr =3D
> -				(struct sockaddr_in6 *) curp->ifa_addr;
> -
> -			str =3D inet_ntop(AF_INET6,
> -					&addr->sin6_addr.s6_addr,
> -					tmp, 50);
> -			if (str =3D=3D NULL) {
> -				strcpy(buffer, "inet_ntop failed\n");
> -				error =3D 1;
> -				goto getaddr_done;
> -			}
> -			if (offset =3D=3D 0)
> -				strcpy(buffer, tmp);
> -			else
> -				strcat(buffer, tmp);
> -			strcat(buffer, ";");
> -			offset +=3D strlen(str) + 1;
> -			if ((length - offset) < (ipv6_len + 1))
> -				goto getaddr_done;
> -
> -		}
> -
> +		error =3D kvp_process_ip_address(curp->ifa_addr,
> +						curp->ifa_addr->sa_family,
> +						buffer,
> +						length, &offset);
> +		if (error)
> +			goto getaddr_done;
> =20
>  		curp =3D curp->ifa_next;
>  	}

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-BenmZAdiE66SSBmRexQv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCmt5Oe/yOyVhhEJAQpZBw//XjX7bZ9b63r3yO1ViyV95FJfj3kW8Pt1
KBCUYhghB0hmuFD+QSzqalyGjydLbxEyhSgpcmwl6Q+gq2kSpuDLIgKiK0Mperst
n5N9y5XHUTzWnxTQrXH8nfoYInZQVDCPl+n3WXh4D2Qmo4Iwx7P1RZACHxye3DiQ
76me3Rw3VFBp34LmAPbiIeG+zMWAjEB0X5a8FdWs62X6MTfyN7gxhwzP3Wx1Onzk
OFydvKpLhI3ddwmiaKccm6kU3qs9Kp/8ZHbNruyxIEr35nkjOcqbPLrJX/60mDVi
wrZ6Asytq9xPVDCRtBQm2S0UOhMWjut5OL0QInp9hAlCHVf2IzqW3H5TF7ZtGwRT
muPokJsOPAqUmH6SvtKpkf4+7RmKGffWyFoxe7+suMNDzFVPXmQwz1qk8Do3yGgq
MRSsXCl9wU43aqCDOShRlRhtFxqj3exvUVGCvn3J0iHi/P2B/wUAM3dZrV+HcWU6
wDiFMQ/RA38bFod4PcPQ3YL84cvxIhpOl9/PxJf/E5pKRzWlb3+TUqqRIyhRyV7W
xOEYBeiEDXRRw21t2bdH4Lt4P00l/AX5Te2T7Q45OpSfA7qQe3nXbKogxyx0mOSx
+XZe8US7DBS5Z9IL611xKpSd0FDoxLGA4oPbEMqFf+purnJGPev4tCHTx5g6+WtJ
BYQ/ZuXTJTg=
=CUtE
-----END PGP SIGNATURE-----

--=-BenmZAdiE66SSBmRexQv--
