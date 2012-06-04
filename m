Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2FDE7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:59:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47522 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2FDE66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:58:58 -0400
Date: Mon, 4 Jun 2012 14:58:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120604145851.2c6bb0e1492ee41a6764f7cd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Jun_2012_14_58_51_+1000_+mnB.Qbbi=zMI+0i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jun_2012_14_58_51_+1000_+mnB.Qbbi=zMI+0i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in kernel/fork.c
between commit touching paths: ("fork: call complete_vfork_done() after
clearing child_tid and flushing rss-counters") from Linus' tree and
commit "mm: correctly synchronize rss-counters at exit/exec" from the
akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/fork.c
index 095a951,30e9ee8..0000000
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@@ -808,11 -811,12 +808,19 @@@ void mm_release(struct task_struct *tsk
  	}
 =20
  	/*
+ 	 * Final rss-counter synchronization. After this point there must be
+ 	 * no pagefaults into this mm from the current context.  Otherwise
+ 	 * mm->rss_stat will be inconsistent.
+ 	 */
+ 	if (mm)
+ 		sync_mm_rss(mm);
++
++	/*
 +	 * All done, finally we can wake up parent and return this mm to him.
 +	 * Also kthread_stop() uses this completion for synchronization.
 +	 */
 +	if (tsk->vfork_done)
 +		complete_vfork_done(tsk);
  }
 =20
  /*

--Signature=_Mon__4_Jun_2012_14_58_51_+1000_+mnB.Qbbi=zMI+0i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPzECLAAoJEECxmPOUX5FEdDEP/0BZMAIPlEHrRZCbQN+d2H0y
XsbeAeQxpYj+u0hSzNwrBFh9frA4Wja80OBtEZy0RI4kEfbsZge8LmFYwnXMIrR/
dADjh+f0AyUh0LljdO4jPWfz5HhVMBj/3GcindaZ+7HtdqqijCNcAo9lyqENdPv9
vUM3h9bE6f4ckDMLROZivfBw2OaN6tNatXdVm1wIsJl7JPpRujsK2Hg1W6MQTVaL
t3BYR4A23lAy/8r7T96uBlcfrp0RtEsOZWr7kXOaPMgyZ3WGu2QwXHYZQQ8ZI/hz
h39M153QfL+aoFhicC/5s5E/zup87AQdc+cYaFK0P314QdcwXMCu2rJrWVodKg2W
cxINGwu0e+VoGUL99b5dldHOAQ6mwdg/w0AvyCG++GFT+LY83++rcnkk20OokR6i
kLkEHheZtzI0xFDf0gl0A+ATM6OIwj0xnMK/I4y5qu4YaNG4/a6HEcFDTMZ4NqN3
XbMLKSD5q8e3E3YwY0nhfA5BvzGIZZbHlfzo7fNd4VVASaJiqVsDUKUwLjY6JTnU
+30BxWF0hp6J2WeI3Dqwn4dxAR0nvpxFrvTbZVa5XltOMEWPljLFY1Fih5RseMzv
8kO8MQRr96OdYbPe+sWyxFApWtoA2IaUJ4Mz2UxXDbZ3W2yBnprtlcoydL/f+Saf
3mquEHI7hI2+Sv/RW6/x
=S67h
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jun_2012_14_58_51_+1000_+mnB.Qbbi=zMI+0i--
