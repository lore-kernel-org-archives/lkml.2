Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2AWDAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 22:00:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47810 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab2AWDAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 22:00:04 -0500
Date: Mon, 23 Jan 2012 13:59:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: linux-next: build failure after merge of the final tree (nfs tree
 related)
Message-Id: <20120123135942.3e991094b91d9087d2ba81ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Jan_2012_13_59_42_+1100_i5wUYMg/2V_gyD/m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Jan_2012_13_59_42_+1100_i5wUYMg/2V_gyD/m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

net/sunrpc/svcsock.c: In function 'svc_setup_socket':
net/sunrpc/svcsock.c:1412:40: error: 'struct sock_common' has no member nam=
ed 'skc_net'

This build has CONFIG_NET_NS unset.

Caused by commit eff9c3383687 ("SUNRPC: pass network namespace to service
registering routines").

I applied this (suboptimal) patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 23 Jan 2012 13:55:01 +1100
Subject: [PATCH] SUNRPC: fixup for namespace changes

Fixes this build error when CONFIG_NET_NS is not set:

net/sunrpc/svcsock.c: In function 'svc_setup_socket':
net/sunrpc/svcsock.c:1412:40: error: 'struct sock_common' has no member nam=
ed 'skc_net'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/sunrpc/svcsock.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index e8af0c9..4d02d1a 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -41,6 +41,7 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <net/tcp_states.h>
+#include <net/net_namespace.h>
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
=20
@@ -1409,7 +1410,13 @@ static struct svc_sock *svc_setup_socket(struct svc_=
serv *serv,
=20
 	/* Register socket with portmapper */
 	if (*errp >=3D 0 && pmap_register)
-		*errp =3D svc_register(serv, sock->sk->sk_net, inet->sk_family,
+		*errp =3D svc_register(serv,
+#ifdef CONFIG_NET_NS
+				     sock->sk->sk_net,
+#else
+				     &init_net,
+#endif
+				     inet->sk_family,
 				     inet->sk_protocol,
 				     ntohs(inet_sk(inet)->inet_sport));
=20
--=20
1.7.9.rc0.23.g7e521

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_Jan_2012_13_59_42_+1100_i5wUYMg/2V_gyD/m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHM0eAAoJEECxmPOUX5FEP/sQAKXX9+MUWz7nJvw7fIOcbTtj
Ufb8ppw3/M+KPbAj/PgpNSjENudS55/juVQxw5YHmVbVKXpQkFd/Jdw8pA/nSGjl
DShj02Wjjp9hKHS/g9OFzzJye1eS2bxfr98e7NZxPWR0PstGOFL/iyjymFsZdiab
cIgLpnSLlSjxOn18vwstfxn5LGtQFhYDNGLphGbnEkC6OEDgiKmgcieHUfqrDaeo
G+ttofKLgXyEOhMqSP/r7rzopHVIAXJEeSJRcnXgcRxn5YQugjyUyBBAW6fHw7xf
Yv9jNscswFlZ3mziVPYDskbpCCLOIzNUJSk+GbT0XYryNZ9d21Mc37hRjO1N9Kg9
LoFr6XfdDut73wkSusm8hgmOYEIS3y88YWOlW53gkXYTsjqCWcfSYYCJnqedNy+8
Mpj8dxkte0M3+8xN/7KSaqsPKZXY/Idpn+WhdXsE1Jsk4JeLx9NbpZfIvUsl3/Rj
74aP1qXHsuXdB+wdvH0IMqp4lbDJh2xEPdwjSp7iWJ/LV6xo67jvTFMXkhoWDSFi
A0GifsBoPeDgUyu31c6QWIdSzxVIBlI4TI+tjIh5ma8BdoMxMHLjOyryg9O3Xk6K
t4HCTboersG3wgQxjupxeabKd7pcPF63UhewMXXwhqxIxY+SnpnJqI+l24UgtP1i
kJ/YYYtkUUQ4JDty7iKj
=CaBY
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Jan_2012_13_59_42_+1100_i5wUYMg/2V_gyD/m--
