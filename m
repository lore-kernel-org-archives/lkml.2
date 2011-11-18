Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab1KRDaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 22:30:20 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37698 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab1KRDaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 22:30:18 -0500
Date: Fri, 18 Nov 2011 14:30:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Dave Young <dyoung@redhat.com>
Subject: linux-next: manual merge of the tty tree with the tty.current tree
Message-Id: <20111118143010.4a6c9eb17b86d24b9ebe706b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_Nov_2011_14_30_10_+1100_ehQFfplVDQuw2u0n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Nov_2011_14_30_10_+1100_ehQFfplVDQuw2u0n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/tty_ldisc.c between commits df92d0561de3 ("TTY: ldisc, allow
waiting for ldisc arbitrarily long") and 0c73c08ec73d ("TTY: ldisc, wait
for ldisc infinitely in hangup") from the tty.current tree and commits
66ef27c3fd0e ("tty_ldisc: remove unnecessary negative return check for
wait_event_timeout") and 8b3ffa173ffa ("TTY: ldisc, remove some unneeded
includes") from the tty tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/tty_ldisc.c
index 8e0924f,174db3b..0000000
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@@ -24,19 -16,8 +16,9 @@@
  #include <linux/device.h>
  #include <linux/wait.h>
  #include <linux/bitops.h>
- #include <linux/delay.h>
  #include <linux/seq_file.h>
-=20
  #include <linux/uaccess.h>
- #include <asm/system.h>
-=20
- #include <linux/kbd_kern.h>
- #include <linux/vt_kern.h>
- #include <linux/selection.h>
-=20
- #include <linux/kmod.h>
- #include <linux/nsproxy.h>
 +#include <linux/ratelimit.h>
 =20
  /*
   *	This guards the refcounted line discipline lists. The lock
@@@ -553,13 -533,11 +535,11 @@@ static void tty_ldisc_flush_works(struc
   *	Wait for the line discipline to become idle. The discipline must
   *	have been halted for this to guarantee it remains idle.
   */
 -static int tty_ldisc_wait_idle(struct tty_struct *tty)
 +static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
  {
 -	int ret;
 +	long ret;
  	ret =3D wait_event_timeout(tty_ldisc_idle,
 -			atomic_read(&tty->ldisc->users) =3D=3D 1, 5 * HZ);
 +			atomic_read(&tty->ldisc->users) =3D=3D 1, timeout);
- 	if (ret < 0)
- 		return ret;
  	return ret > 0 ? 0 : -EBUSY;
  }
 =20

--Signature=_Fri__18_Nov_2011_14_30_10_+1100_ehQFfplVDQuw2u0n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOxdFCAAoJEECxmPOUX5FEn/sP/3Hz4odSgvha8j8KT+zrUO6/
PVW+KRTvLzTgPNDvt1wkaZs1HsW5KZBhDRlwqhIapGnurWqOYAeahT73neqh7Wi6
PJ2XAy24Q97LYxmnDL99MEo07nvEgWQO0DfjgIEe0KniqfPRLoBGVa8BvDy734av
HJ3BpfCdW0LTy+t4eHkYWTVIvi9eZmqYJIRdXjjfJtsWYrjKZboI1JoFM/E2eRoW
PqLhoUrU/6OI2FjWFByjMZPHFR8cXYxCodueRGjZD3fyrZxnySCwG2urQzVzuWmk
LdpUfP0AiZFBVTtLA6k5o2IhwPGrj9UIP+mdnhPgEN8IiUZR8fjwFmPFCEJsVnuf
cQFEPl6Y3rsWOAXk4oO+aZ5yO12PZyNbKWr+TBhlYYvgON7f5SpSKZ98N65YvLYZ
mwLiSBfeYOQl3jqh4H2vv1kOoaM3gEuIxlxxIn2LI88a4u0WaoOixY/anVJMfWIA
NyT9jqvB/mlYHlYXYBl+s01NJE5aVzAhR+CbH9qSrTyLzCPc+r1eJF7mXttFCJln
6NTXgHo/si3K8nzlRO86f842rm8Lo63kSE7OIkBrtDKOUyMmFgEEydOnPEKyLLIL
Q+gs7CdwLihGfrXE9qvwweMdRFu+yz6UrcJ+7OnVrMKrFKEOJFOe8J/rzTLgfnzd
AZA3iZg/5cQ3f8Rtu6mm
=dzzJ
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Nov_2011_14_30_10_+1100_ehQFfplVDQuw2u0n--
