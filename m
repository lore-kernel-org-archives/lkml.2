Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2GaEYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:24:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48660 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2GaEYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:24:53 -0400
Date: Tue, 31 Jul 2012 14:24:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        Mel Gorman <mgorman@suse.de>
Subject: linux-next: manual merge of the akpm tree with the nfs tree
Message-Id: <20120731142441.0d01100f9d050ec6e479c923@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jul_2012_14_24_41_+1000_.h4LwnBao9kjuBYr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Jul_2012_14_24_41_+1000_.h4LwnBao9kjuBYr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
net/sunrpc/xprtsock.c between commit 5cf02d09b50b ("nfs: skip commit in
releasepage if we're freeing memory for fs-related reasons") from the nfs
tree and commit "nfs: enable swap on NFS" from the akpm tree.

Just context changes?  I fixed it up (I think - see below) and can carry
the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/sunrpc/xprtsock.c
index 9266794,83bb0eb..0000000
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@@ -1927,9 -1925,47 +1927,48 @@@ static void xs_local_setup_socket(struc
  out:
  	xprt_clear_connecting(xprt);
  	xprt_wake_pending_tasks(xprt, status);
 +	current->flags &=3D ~PF_FSTRANS;
  }
 =20
+ #ifdef CONFIG_SUNRPC_SWAP
+ static void xs_set_memalloc(struct rpc_xprt *xprt)
+ {
+ 	struct sock_xprt *transport =3D container_of(xprt, struct sock_xprt,
+ 			xprt);
+=20
+ 	if (xprt->swapper)
+ 		sk_set_memalloc(transport->inet);
+ }
+=20
+ /**
+  * xs_swapper - Tag this transport as being used for swap.
+  * @xprt: transport to tag
+  * @enable: enable/disable
+  *
+  */
+ int xs_swapper(struct rpc_xprt *xprt, int enable)
+ {
+ 	struct sock_xprt *transport =3D container_of(xprt, struct sock_xprt,
+ 			xprt);
+ 	int err =3D 0;
+=20
+ 	if (enable) {
+ 		xprt->swapper++;
+ 		xs_set_memalloc(xprt);
+ 	} else if (xprt->swapper) {
+ 		xprt->swapper--;
+ 		sk_clear_memalloc(transport->inet);
+ 	}
+=20
+ 	return err;
+ }
+ EXPORT_SYMBOL_GPL(xs_swapper);
+ #else
+ static void xs_set_memalloc(struct rpc_xprt *xprt)
+ {
+ }
+ #endif
+=20
  static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket=
 *sock)
  {
  	struct sock_xprt *transport =3D container_of(xprt, struct sock_xprt, xpr=
t);
@@@ -1970,7 -2009,8 +2012,9 @@@ static void xs_udp_setup_socket(struct=20
  	if (xprt->shutdown)
  		goto out;
 =20
 +	current->flags |=3D PF_FSTRANS;
+ 	if (xprt->swapper)
+ 		current->flags |=3D PF_MEMALLOC;
 =20
  	/* Start by resetting any existing state */
  	xs_reset_transport(transport);
@@@ -1990,7 -2030,7 +2034,8 @@@
  out:
  	xprt_clear_connecting(xprt);
  	xprt_wake_pending_tasks(xprt, status);
+ 	tsk_restore_flags(current, pflags, PF_MEMALLOC);
 +	current->flags &=3D ~PF_FSTRANS;
  }
 =20
  /*
@@@ -2116,7 -2159,8 +2164,9 @@@ static void xs_tcp_setup_socket(struct=20
  	if (xprt->shutdown)
  		goto out;
 =20
 +	current->flags |=3D PF_FSTRANS;
+ 	if (xprt->swapper)
+ 		current->flags |=3D PF_MEMALLOC;
 =20
  	if (!sock) {
  		clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
@@@ -2167,7 -2211,7 +2217,8 @@@
  	case -EINPROGRESS:
  	case -EALREADY:
  		xprt_clear_connecting(xprt);
+ 		tsk_restore_flags(current, pflags, PF_MEMALLOC);
 +		current->flags &=3D ~PF_FSTRANS;
  		return;
  	case -EINVAL:
  		/* Happens, for instance, if the user specified a link
@@@ -2180,7 -2224,7 +2231,8 @@@ out_eagain
  out:
  	xprt_clear_connecting(xprt);
  	xprt_wake_pending_tasks(xprt, status);
+ 	tsk_restore_flags(current, pflags, PF_MEMALLOC);
 +	current->flags &=3D ~PF_FSTRANS;
  }
 =20
  /**

--Signature=_Tue__31_Jul_2012_14_24_41_+1000_.h4LwnBao9kjuBYr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQF14JAAoJEECxmPOUX5FEvJ8QAJRe/SBD0/NWuvHTFFLK61fV
s0a+82IEUip1YfUQbjPJtRKiNlmQaV99k1pI73N3tjMUkhDiLJ0oqS1SsF9Gz2FB
M6ZcLSOqiw65LwTSGwwjPkDkuQrjXk3b3Cfmpa4EfMvHPqC6w1BjWZut/N+RgPMZ
OajCHOD7nulHDJSipJ/0JGFpu6RnpTQccgKzwMTVAnZlw0Ds9OtHed7aOZo3FChr
KtMVJaOJO3N/fjtDGlqtHVc7COTFprI4Acdk1hGQO9NRGVNhQFoDqJ5b9knpM4DF
AK54CYTTsfHLBHa53hDGO5ifbmM35JE6eodZOyG1ohOu1TKO4gPRtGEbX4AVs/nK
X5KTtphLcpjONPpKzwaelU/F0pOUVBso997Ej51+tUlQxFlDkHsDqDRPZpBm1Aws
k+IYjkP1HoxahuLdExO1mnVFZQzbusD3NQbBRsIm2a1kPAMGk1JFlLUlkpHu0Gy4
sxOfTPY1vlwCWF2tTL/bE+Rt39MLQuqf7FKyYq/UnmYK/81rJwi2z6cJQW5GB3Nr
R9x0b3GbhJWzSAr3dGzTpbyHPWOs4ey7/+oZY/XfgtDXDsqAAZZ4T7AT9Ao/hT7p
DrBQOxkI2FAkeTck8R4jYD2hd7I4jTAsvQTkqwO04Z2SN32tXmzIbYrgLP2bTQ9p
jeBWqQmFSg+3eQ+CmYGK
=Z9MA
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jul_2012_14_24_41_+1000_.h4LwnBao9kjuBYr--
