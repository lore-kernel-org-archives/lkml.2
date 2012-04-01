Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2DAVYF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:24:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58330 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947Ab2DAVYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:24:03 -0400
Message-ID: <1333315428.3500.396.camel@deadeye>
Subject: Re: [ 131/149] NFSv4.1: Fix layoutcommit error handling
From: Ben Hutchings <ben@decadent.org.uk>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@linuxfoundation.org>
Date: Sun, 01 Apr 2012 22:23:48 +0100
In-Reply-To: <20120330194901.854267285@linuxfoundation.org>
References: <20120330194901.854267285@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-x5qV6M9HUd6O8Tuw/mEp"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-x5qV6M9HUd6O8Tuw/mEp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-30 at 12:50 -0700, Greg KH wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
>=20
> commit e59d27e05a6435f8c04d5ad843f37fa795f2eaaa upstream.
>=20
> Firstly, task->tk_status will always return negative error values,
> so the current tests for 'NFS4ERR_DELEG_REVOKED' etc. are all being
> ignored.
> Secondly, clean up the code so that we only need to test
> task->tk_status once!
>=20
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  fs/nfs/nfs4proc.c |   25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>=20
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -5983,21 +5983,22 @@ nfs4_layoutcommit_done(struct rpc_task *
>  		return;
> =20
>  	switch (task->tk_status) { /* Just ignore these failures */
> -	case NFS4ERR_DELEG_REVOKED: /* layout was recalled */
> -	case NFS4ERR_BADIOMODE:     /* no IOMODE_RW layout for range */
> -	case NFS4ERR_BADLAYOUT:     /* no layout */
> -	case NFS4ERR_GRACE:	    /* loca_recalim always false */
> +	case -NFS4ERR_DELEG_REVOKED: /* layout was recalled */
> +	case -NFS4ERR_BADIOMODE:     /* no IOMODE_RW layout for range */
> +	case -NFS4ERR_BADLAYOUT:     /* no layout */
> +	case -NFS4ERR_GRACE:	    /* loca_recalim always false */
>  		task->tk_status =3D 0;
> -	}
> -
> -	if (nfs4_async_handle_error(task, server, NULL) =3D=3D -EAGAIN) {
> -		rpc_restart_call_prepare(task);
> -		return;
> -	}
> -
> -	if (task->tk_status =3D=3D 0)
> +		break;

It loooks like the previous intent was that for all those specific error
codes we would end up calling nfs_post_op_update_inode_force_wcc().
That didn't happen because of the incorrectly signed error codes.  But
it still won't happen now, because of this break.  Do we really want to
break here or fall through past 'case 0'?

Ben.

> +	case 0:
>  		nfs_post_op_update_inode_force_wcc(data->args.inode,
>  						   data->res.fattr);
> +		break;
> +	default:
> +		if (nfs4_async_handle_error(task, server, NULL) =3D=3D -EAGAIN) {
> +			rpc_restart_call_prepare(task);
> +			return;
> +		}
> +	}
>  }
> =20
>  static void nfs4_layoutcommit_release(void *calldata)

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--=-x5qV6M9HUd6O8Tuw/mEp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT3jHZOe/yOyVhhEJAQqRew//b4wqwYBp+1V0HtNIUaMyPlEi1t2uB5d1
GLBMEJTWc8RGJe5K/LNyArJuQsJu0o2ykZy9eIuwsNXlDWcGmusm3d43J8bEiB6F
sWaT6auSvV3V0JR5DpdwO1BrggAZ7Sv6OUOMXdbz7dZZA/4YUmGh1eWMud0arOQL
eKr1gVQ7N7CyHlh0KVdqrpzfQqxQ5GOsPZtl/Zwcdn+zkXToEh8tGTZBtTMFq93D
VXmp/C/c4YeUyBzIaqZiPDlTjNJGBObTS86dRnJGJHlVaXQN8mW9Y4Xai9ppOUVh
8HS/B3GS47WrO5JqSNCWCbN9LjGe2ydSngCWO9fVbCLKV5GBZ5Y3gZOtp2p1vZJ7
B/kCps4IAB0FboYSIHIpxR4MUp6Qluje5lInQpVS0Iah0RqlXT6XFCH7JqGNIoGV
AAPJFx5COq010PrDg4DASEfzpQoPFeYZhbJIKUhvITYfhNw9x1Rtu1TMN36rl22W
UQgZnyJ5Y92+BTmLgj96YA0euD5slW/v/zukGU5xpvBwNJAqwhxyYzT3B5bdTsM8
8gZMCjwLKm8pCpYLgOvWaBnuPBgXdSE8QczyRPi8OZgcGtwq1jIZ6NpmzzgELVn2
+qZ6SABO+Ot6PcurAYJGOnxHUsgnoXt96pUjUXS89Zcav7UxfCksZk383f5/T3CQ
A82NvFL89p4=
=85im
-----END PGP SIGNATURE-----

--=-x5qV6M9HUd6O8Tuw/mEp--
