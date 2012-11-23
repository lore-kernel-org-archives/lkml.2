Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2KWAXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:23:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab2KWAXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:23:32 -0500
Date: Fri, 23 Nov 2012 11:23:09 +1100
From: NeilBrown <neilb@suse.de>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>, util-linux@vger.kernel.org
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: util-linux bug: was Re: [PATCH 00/16 v3] f2fs: introduce
 flash-friendly file system
Message-ID: <20121123112309.52429ceb@notabene.brown>
In-Reply-To: <1352634168.1893.9.camel@kjgkr>
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
	<201211021439.02797.Martin@lichtvoll.de>
	<CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com>
	<201211101933.38434.Martin@lichtvoll.de>
	<8A3372F6-6294-404E-909B-3FDE0C2368B7@dubeyko.com>
	<1352634168.1893.9.camel@kjgkr>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zwDmrvrVbAkMEsgIf90jZqU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zwDmrvrVbAkMEsgIf90jZqU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 11 Nov 2012 20:42:48 +0900 Jaegeuk Kim <jaegeuk.kim@gmail.com> wrot=
e:

> 2012-11-11 (=EC=9D=BC), 00:55 +0300, Vyacheslav Dubeyko:
> > Hi,
> >=20
> > On Nov 10, 2012, at 9:33 PM, Martin Steigerwald wrote:
> >=20
> > [snip]
> > >=20
> > > merkaba:~> mkfs.f2fs /dev/sdb1
> > > Info: sector size =3D 512
> > > Info: total sectors =3D 4093951 (in 512bytes)
> > > Info: zone aligned segment0 blkaddr: 256
> > > Info: This device doesn't support TRIM
> > > Info: format successful
> > > merkaba:~> mount /dev/sdb1 /mnt/zeit
> > > mount: you must specify the filesystem type
> > > merkaba:~#32> mount -t f2fs /dev/sdb1 /mnt/zeit
> > > merkaba:~> df -hT /mnt/zeit
> > > Dateisystem    Typ  Gr=C3=B6=C3=9Fe Benutzt Verf. Verw% Eingeh=C3=A4n=
gt auf
> > > /dev/sdb1      f2fs  2,0G    147M  1,8G    8% /mnt/zeit
> > >=20
> >=20
> > Do you really have trouble with f2fs mount without definition of filesy=
stem type? If so, it is a bug.
>=20
> Could you explain this bug in mor)e detail?
> Or, can anyone comment this?
>=20
> Actually, I've looking at the *mount* in linux-utils.
> I suspect something does not support f2fs in linux-utils.
>=20

This is a bug in util-linux.

If 'blkid' doesn't recognise the filesystem, mount reads /etc/filesystems
and tries everything listed there.  If that file ends with a '*', it should
read /proc/filesystems and try everything else listed that (that doesn't
start with 'nodev').

However it currently ignores the '*' and just adds everything
from /proc/filesystems.  So the list it uses will have a '*' in the
middle, which will be before 'f2fs' appears.

When it tries each filesystem type in turn, it will abort if it get any err=
or
other than EINVAL.
When it tries with filesystem type '*' it gets 'ENODEV' and so gives up.

The following patch (against git://github.com/karelzak/util-linux.git) fixes
it for me,  though I suspect it should possible ignore 'ENODEV' too -
otherwise if /etc/filesystems contains an invalid filesystem name, it will
silently ignore all others.

As a quick hack, just add 'f2fs' to /etc/filesystems

NeilBrown



Signed-off-by: NeilBrown <neilb@suse.de>
diff --git a/libmount/src/utils.c b/libmount/src/utils.c
index 624633d..054f266 100644
--- a/libmount/src/utils.c
+++ b/libmount/src/utils.c
@@ -462,6 +462,10 @@ static int get_filesystems(const char *filename, char =
***filesystems, const char
 			continue;
 		if (sscanf(line, " %128[^\n ]\n", name) !=3D 1)
 			continue;
+		if (strcmp(name, "*") =3D=3D 0) {
+			rc =3D 1;=09
+			break;
+		}
 		if (pattern && !mnt_match_fstype(name, pattern))
 			continue;
 		rc =3D add_filesystem(filesystems, name);
@@ -486,7 +490,7 @@ int mnt_get_filesystems(char ***filesystems, const char=
 *pattern)
 	*filesystems =3D NULL;
=20
 	rc =3D get_filesystems(_PATH_FILESYSTEMS, filesystems, pattern);
-	if (rc)
+	if (rc !=3D 1)
 		return rc;
 	return get_filesystems(_PATH_PROC_FILESYSTEMS, filesystems, pattern);
 }

--Sig_/zwDmrvrVbAkMEsgIf90jZqU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK7B7Tnsnt1WYoG5AQJZdA//fjRxZmzxfVRm7rwWJYLtYriTvaSoVD2b
FdmvQLCM4a0xvzfS0AVd5ON67hyfBjG+E1mncVmQgq80KQUzddEHrXqelAJi/L5Q
EZzVXy0XiHdqXCYWmavz07nnY3lIx+/I7ermKR7qxvb0bRNRuc3xV/be3opPBqq7
/aJhqlOjD0k9PH8f+5ubgQsue7SB/ase4Gv8P1RL3C9B2sI/wHqD6MgJ11I76lr1
kRSMFZnmzdrLG0A+G1xAzx56exguWseujumQBv83H0+8eMrkcKR233E9WyNpRdsf
MNI87RtXakl0VjiU5UwI2PuJJt809kQspRc6WhzDc7WK2nAEmX0Eh+DSSJBOwaqf
8ZGs76EWSOj4q3+s36tUu9nVNffOzqnwi4fafcIGfG7FIHyUXAzOpKjN1O7BLrNZ
xpV35iXYDws0yRtKfP0BKDYkjMoQOu82sYvXaa6ojk3pEQY81ioksr2lmR9RPBA+
4paqsmQtxHf0zc+f+HTs40VlSTJjxGJJcAg7WP8rIsxenSYIpWKE3fQiV8xxkvvy
FOwr24mqGKEz4Nk+JhsRdQTLeeif1linSL7GTWonnIgKRPyOaHHPUx907RvocA+N
B6CEsA2rCMIU1WRAEMMmOiNm5b5J7/Vq7o+4uyw3ngdbYUElJncFvy/941WHtl/w
RdaMLw74h8w=
=L1YM
-----END PGP SIGNATURE-----

--Sig_/zwDmrvrVbAkMEsgIf90jZqU--
