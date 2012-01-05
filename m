Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab2AEEYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 23:24:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50636 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab2AEEYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 23:24:08 -0500
Date: Thu, 5 Jan 2012 15:24:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: linux-next: build failure after merge of the selinux tree
Message-Id: <20120105152400.8ea64cf56587bac73d27c474@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_15_24_00_+1100_9C1K3sPUjHJyI4L="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_15_24_00_+1100_9C1K3sPUjHJyI4L=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the selinux tree, today's linux-next build (x86_64
allmodconfig) failed like this:

crypto/crypto_user.c: In function 'crypto_user_rcv_msg':
crypto/crypto_user.c:385:2: error: implicit declaration of function 'securi=
ty_netlink_recv' [-Werror=3Dimplicit-function-declaration]

Caused by commit f452f33b1f3a ("security: remove the
security_netlink_recv hook as it is equivalent to capable()") interacting
with commit a38f7907b926 ("crypto: Add userspace configuration API")
which was added to Linus' tree before v3.2-rc1.

I applied the following (supplied) fix as a merge fix.

From: Eric Paris <eparis@redhat.com>
Subject: selinux tree pull for 2012-01-05, known build issue
Date: Wed, 04 Jan 2012 17:47:18 -0500

I updated my SELinux tree which is based on 3.1.  I know there is a
build problem after it is merged with current Linus.  The following
patch is also needed as the security function is removed by my tree, but
this caller was added by someone else.  I figured you could carry this
patch and I'd make sure Linus does the same when he merges...

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 0605a2b..c7e5b66 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -382,7 +382,7 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, str=
uct nlmsghdr *nlh)
 	type -=3D CRYPTO_MSG_BASE;
 	link =3D &crypto_dispatch[type];
=20
-	if (security_netlink_recv(skb, CAP_NET_ADMIN))
+	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
=20
 	if ((type =3D=3D (CRYPTO_MSG_GETALG - CRYPTO_MSG_BASE) &&


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Jan_2012_15_24_00_+1100_9C1K3sPUjHJyI4L=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBSXgAAoJEECxmPOUX5FEW3AP/3kaxdExNHn1R2MDSnf2ZC1l
GHmOtXflbL6LNppQNIHOWUfsorA/+pvz8hk5v9qHOjOLt9O9Jk5fN8SHrhv5R1UF
yTcKLbRxBtl/RAZzr/aAp6tDR1TZxaQsfw4kB6H9DNxpWrGbY7dKvZU5uzLzJ5wu
GKevqFvM73x01I/J75Jr2qxsWZMfEH9pSDzMuhn4xNEca4/5Oj3a1Bn+PrgujxCM
8/upmOxqgz/MJdeLl989tv8E4OalhhmPSGHPmq4MdFWsMUmq6kukHCSWJE4fCIyU
gg3AKy3v0ZjtWcnYQhXYvoQDf7me0tNeJPv79YpTrplV2R0wgEwGETEqIrLnoZnA
AKQo55FHfYaAeLkdyJI9OW5kdrDe/atpoNX739TyQOMYSSnu/9p7mvGoq4RAu/lt
ZeClZj1MEsJdNp7S/hx848FEgkqABZskv3ou2o2QSPqou/6/sLGzXJkyvi12cNdO
1cIthsOCXpNCCaGFadMCTIto6KuxLVqlxvy9ItbiPWnyGpYVA/+cv/V0CKQQjbqH
g5clfNjzEdjm3W6NSX48FtM6v6OxZIbs9F30THMPThwIvD2iz5xCgRdZYpxhOk4H
sM9+lVUu0TZVZWr+qRpmjUZPR8DYyqa5wdhadd+LCbKglEwmr+QnHx0dUls6UXmZ
G8RXM2iHVTkzVzFjCb3c
=gVth
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_15_24_00_+1100_9C1K3sPUjHJyI4L=--
