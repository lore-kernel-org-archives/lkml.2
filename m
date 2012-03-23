Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2CWEvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:51:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41878 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2CWEv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:51:26 -0400
Date: Fri, 23 Mar 2012 15:51:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20120323155114.a1779aa050fa05f6191b7dae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__23_Mar_2012_15_51_14_+1100_i1kR3JcG2ml00I9e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Mar_2012_15_51_14_+1100_i1kR3JcG2ml00I9e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpu/drm/radeon/si_blit_shaders.c:252:1: error: implicit declaration=
 of function 'BUILD_BUG_ON_ZERO' [-Werror=3Dimplicit-function-declaration]
drivers/gpu/drm/radeon/si_blit_shaders.c:252:1: error: initializer element =
is not constant

Caused by commit 48c0c902e2e6 ("drm/radeon/kms: add support for CP setup
on SI") from Linus' tree interacting with commit 6c03438edeb5 ("kernel.h:
doesn't explicitly use bug.h, so don't include it").

ARRAY_SIZE in kernel.h uses __must_be_array from compiler{-ggc,-intel}.h
which uses BUILD_BUG_ON_ZERO ...  I don;t know if we want to include
bug.h in compiler.h ...

So, for today, I have added the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 23 Mar 2012 15:47:07 +1100
Subject: [PATCH] kernel.h: using ARRAY_SIZE needs to include bug.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/radeon/si_blit_shaders.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/si_blit_shaders.c b/drivers/gpu/drm/rad=
eon/si_blit_shaders.c
index a7124b4..ec415e7 100644
--- a/drivers/gpu/drm/radeon/si_blit_shaders.c
+++ b/drivers/gpu/drm/radeon/si_blit_shaders.c
@@ -25,6 +25,7 @@
  */
=20
 #include <linux/types.h>
+#include <linux/bug.h>
 #include <linux/kernel.h>
=20
 const u32 si_default_state[] =3D
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__23_Mar_2012_15_51_14_+1100_i1kR3JcG2ml00I9e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPbAFCAAoJEECxmPOUX5FEJugP/0puxg0VA8eRFC1gJ2DCodDN
sqrIhgI+SFzOI1wdsR9pzxwKGQ2h9wLzeoIoP+cb0Bkn6IVT1zM9HfEOnM1KUAsm
iKvHT1VzGNgYUNheog1qlngj+petAyvyvulIJHOi9DH9E8KMo0dvZ4N3S2HmAWfu
4/sVrvK+Z+Vo0VW+xanO2YSNgSaoyYdDIZtLx8eSFsCTvFtRqj0SybffbFLJ+rsf
9lrDusrzk0EPT0mmnsifAsjfWJRegaltEzBKCwYXQq5zd0F0vw9V9tASdEjAVNXE
D1shLZH60KQUxzliY7wGmaXSyYc5pE3XJ/ss35CXFF2cz2K4DHVc13ESsMh7dKs1
KQ45bNA2qH+VuDfdbhnJ0ptMitxT+a2L/+gSKti0E4Qw41r+eJwRe7dry9X94zJx
qslM3wkQIjdjO8yGI/QCIXHNBB7SJ/tke3TFT4SQdbmtFsLYgjbX9u9/4IDi0D0A
gAvd3+OTWHukVRMyBql9YotzKIhOsPwO5IpLt9PK0vE2P6TPlqiii54A1s+AqkKS
RwQFeSPY2EZH1ljxZOumyqO2gEKQf84WaMqk6smR7NUg0xka7Yp0NIFc9pXZJpuy
8Ny5ixKhzVYVRFnxpGCLdMRYJaXDSTdYUOOyIgQLpNHP/Z9Q8WuVyyDfx7QKZt8B
TroylV053PLoP1jYPc+U
=cO/x
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Mar_2012_15_51_14_+1100_i1kR3JcG2ml00I9e--
