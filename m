Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab2GFWvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:51:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab2GFWvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:51:11 -0400
Date: Sat, 7 Jul 2012 08:51:03 +1000
From: NeilBrown <neilb@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH] MFD: twl-core: move device_init_wakeup to after
 platform_device_add.
Message-ID: <20120707085103.7b1a51ec@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FzB3P.31BHtTq=w7qVSh96N"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FzB3P.31BHtTq=w7qVSh96N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



device_init_wakeup uses the dev_name() of the device to set the
name of the wakeup_source which appears in
/sys/kernel/debug/wakeup_sources.

For a platform device, that name is not set until platform_device_add
calls dev_set_name.

So the call to device_init_wakeup() must be after the call to
platform_device_add().
Making this change causes correct names to appear in the
wakeup_sources file.


Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 6fc90be..b012efd 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -568,7 +568,6 @@ add_numbered_child(unsigned chip, const char *name, int=
 num,
 		goto err;
 	}
=20
-	device_init_wakeup(&pdev->dev, can_wakeup);
 	pdev->dev.parent =3D &twl->client->dev;
=20
 	if (pdata) {
@@ -593,6 +592,8 @@ add_numbered_child(unsigned chip, const char *name, int=
 num,
 	}
=20
 	status =3D platform_device_add(pdev);
+	if (status =3D=3D 0)
+		device_init_wakeup(&pdev->dev, can_wakeup);
=20
 err:
 	if (status < 0) {

--Sig_/FzB3P.31BHtTq=w7qVSh96N
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/dr1znsnt1WYoG5AQJBlQ//Tr7CxCNid9BXVqBxbJWQdDzEpXJ7bvt+
oRFA9lRidhHrQtXfH4eaeBfvQv5PIj3goktfWXAt8D/ZbNDNsBoDL/WfWI1IxDnw
1G3pmLlC2LbhYRd3/iYhF6um00WZ2MKBmTqgrLLeX/FQAywdhC/WtW+b7+NfEKjb
iOb6NoqITaCV4ZHazoiW0SjeHb8o0pzYWw7OQCJTWB4rd1S7x2sXHmhBwD6hM6RK
/cn10pmNMvi6J4R74WgfVDnpzFexd5HLQtjinz308K/vIpUc5VDq0r549xa9qWfB
U/+I+lwaO51046ISKfbzaBfTpqaiqTb4plmu0rAtgsS1ha8ZXfr/KKpeXYkFTsUE
Th7jF6CMU2H2SBJAbZQ+jfg/cpVzpAnkL/drP0/WFTqzS/xLiOLIK0Sdu1mwcntb
9b4TSVDr6TuKiQHlKh1a9RTYSvdgv6leqqZMoI1LwVzfTtQJzYir+kncfuxE5iK6
SF+ws2EtpaWcrwaIdy5elleUDY+oVSKn6VTJNrbylmdRjRMUnUj2yVQPoQTC99Qw
RZOZhVjnBWs+gzWZL9iOcobUFyi6xK8iw5n6E1uiu3wu/t3GBXmJ2nj/yO+Jk6N3
5eIV6xMAWuH2JeGkOjWGHo1ECQjo3nXNyfUmIY4LjCRFzo0KN+x3bKHQKXL26ZWb
dEFQ/+bMv5k=
=0/8b
-----END PGP SIGNATURE-----

--Sig_/FzB3P.31BHtTq=w7qVSh96N--
