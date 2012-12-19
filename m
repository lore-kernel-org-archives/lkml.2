Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2LSAzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:55:55 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59755 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2LSAzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:55:52 -0500
Date: Wed, 19 Dec 2012 11:55:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: linux-next: build failure after merge of the fsnotify tree
Message-Id: <20121219115543.c76d0f1ecc12a54438151865@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Dec_2012_11_55_43_+1100_OJ/HWctrC_m_LiwM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Dec_2012_11_55_43_+1100_OJ/HWctrC_m_LiwM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the fsnotify tree, today's linux-next build
(powerpc_ppc64_defconfig) failed like this:

fs/notify/fdinfo.c: In function 'show_fdinfo':
fs/notify/fdinfo.c:30:18: error: 'struct fsnotify_group' has no member name=
d 'mark_lock'
fs/notify/fdinfo.c:36:20: error: 'struct fsnotify_group' has no member name=
d 'mark_lock'

Caused by commit 986ab09807ca ("fsnotify: use a mutex instead of a
spinlock to protect a groups mark list") interacting with commit
be77196b809c ("fs, notify: add procfs fdinfo helper") from Linus' tree
(via Andrew' tree).

I added the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 19 Dec 2012 11:53:20 +1100
Subject: [PATCH] fsnotify: cope with change from spinlock to mutex

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/notify/fdinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 514c4b8..238a593 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -27,13 +27,13 @@ static int show_fdinfo(struct seq_file *m, struct file =
*f,
 	struct fsnotify_mark *mark;
 	int ret =3D 0;
=20
-	spin_lock(&group->mark_lock);
+	mutex_lock(&group->mark_mutex);
 	list_for_each_entry(mark, &group->marks_list, g_list) {
 		ret =3D show(m, mark);
 		if (ret)
 			break;
 	}
-	spin_unlock(&group->mark_lock);
+	mutex_unlock(&group->mark_mutex);
 	return ret;
 }
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__19_Dec_2012_11_55_43_+1100_OJ/HWctrC_m_LiwM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ0RCPAAoJEECxmPOUX5FEjFEP/R7xBsT/hpTTbpGzgZ68qBhx
7UU4iB77wVU7gUCNJeg32kpjAEcBpnmrjl9wY/C0K3dJYRAhlKQgRS9bbAtJIgyz
VIm8JalwX3KTIYvaVFWamvXD2PASzcW+xfTw2SbgptoIo5zo8ovNUFZFDJqSdo40
hcOkZTWAZCMCMDcm36DP9MOX9jLHqyX/dPAVNMkuBQUjEgEIWBRBRDYJnDsENpDm
fumXFhkL9VcBME48FXNwzN0ffm2GD1QqQ0UFJRa3VByPyGaHi2W/riMMcooXpb21
2P6nHCPw2Jj2Jsj6M5SFs9Wrj87R73DmNnyeWDJi8kQEzgeN8rNty8aQI359Y3cN
jK/8RLKiXEqVdvfYZcqsCN83lPL50wktVd8fB6qwGkXs3H5ebDb7faqXA5Tn9XLR
tAFvZg0k8+QvtkNBl7sF3L3CMa35vrICCysE91X2/cNWvjY/lG/9DwIjzrdUcoyV
gf37pDUhCLPOmWnPb5a4kqxk15u+YMSJmXsHedfPBaivVZV+B654XgMpIe8ZQFKJ
gXefCWzm52n2vOpnMiW069dP/EcPWdGKDMsKJt9iKnugYNyFQZXHrZuK9rp8aS2x
ZgQmlXPDUUgIlkoLhACw5GMdKObNOgAYVOHt1YZmt3IL9QIo53vQr2XSI9yaWHU5
PvLQEIcltzBHydLUI6XP
=pzGp
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Dec_2012_11_55_43_+1100_OJ/HWctrC_m_LiwM--
