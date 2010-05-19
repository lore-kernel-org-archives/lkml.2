Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0ESVCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:02:05 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41389 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0ESVCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:02:01 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2010 17:02:01 EDT
Date: Wed, 19 May 2010 22:56:53 +0200
From: Pierre Ossman <pierre-list@ossman.eu>
To: linux-kernel@vger.kernel.org
Subject: Strange read data corruption on ext4/LVM/md
Message-ID: <20100519225653.1fedb453@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-29783-1274302616-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-29783-1274302616-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

I recently upgrade the storage stack here, and now I'm getting these
weird, intermittent read errors. Nothing complains anywhere, I only
notice that data is corrupt (man am I glad some formats have CRC
checks).

The errors come and go, and re-reading the same file eventually gets
the correct data (have to get it out of the page cache first though).

Unfortunately I changed a bit too many pieces at the same time, so I'm
not sure where things are breaking. I went from ext3 on md, to ext4 on
LVM on md on new harddrives.

Still, I managed to catch a hexdump of one of these corruptions.
Perhaps someone can spot something familiar in it that reveals the
source of the issue:

--- good	2010-05-19 22:49:00.992620437 +0200
+++ bad	2010-05-19 22:48:16.928619828 +0200
@@ -1429750,13 +1429750,13 @@
 015d0f50  75 ed d6 51 51 08 06 a3  8e 1f 70 aa 34 b9 74 7a  |u..QQ.....p.4=
.tz|
 015d0f60  ff 63 a2 5d 12 79 f6 ec  8a 13 32 51 1b e9 d0 9e  |.c.].y....2Q.=
...|
 015d0f70  2f 8f f1 0c 3f 95 a4 ce  09 c4 dd 5e 9e 10 d9 98  |/...?......^.=
...|
-015d0f80  86 db a6 48 e1 11 64 f3  dd c6 68 95 f5 41 28 e6  |...H..d...h..=
A(.|
-015d0f90  1a 59 4e ad 53 bc d8 55  56 26 09 bd 66 52 27 67  |.YN.S..UV&..f=
R'g|
-015d0fa0  e8 59 24 35 fe 74 c6 59  cb 23 4b 4c a1 ce 9b ab  |.Y$5.t.Y.#KL.=
...|
-015d0fb0  d8 0b 22 31 9e c5 e5 89  b7 c0 87 d0 6d b9 6f 28  |.."1........m=
.o(|
-015d0fc0  22 a5 3a 2c 96 88 a5 5e  12 4c e4 ab 3d ab e5 27  |".:,...^.L..=
=3D..'|
-015d0fd0  58 17 c6 ff f6 66 02 e9  b2 6c f9 de d3 44 e5 6d  |X....f...l...=
D.m|
-015d0fe0  62 21 75 d2 04 94 82 d8  42 02 07 b3 a0 f4 eb 2b  |b!u.....B....=
..+|
+015d0f80  2b 53 f6 39 fa 9a 71 df  d0 0e 7d 09 44 20 42 0c  |+S.9..q...}.D=
 B.|
+015d0f90  fa 0e 0b 71 36 19 8d d0  ed 7f c6 7f 47 8d 88 78  |...q6.......G=
..x|
+015d0fa0  2e 23 ab b2 8a c5 e0 b0  45 36 0c a7 f4 c4 19 7b  |.#......E6...=
..{|
+015d0fb0  d2 fe 6f 99 b0 b9 08 c4  6b 42 62 50 9b ab 75 cc  |..o.....kBbP.=
.u.|
+015d0fc0  3a 91 3e 4f b4 d0 68 5a  03 76 fc e4 ad 47 ed b3  |:.>O..hZ.v...=
G..|
+015d0fd0  59 04 f5 93 eb 3d fa ca  5a dc 2c 6c dd 5e da d8  |Y....=3D..Z.,=
l.^..|
+015d0fe0  71 30 75 89 12 99 a7 aa  42 02 07 b3 a0 f4 eb 2b  |q0u.....B....=
..+|
 015d0ff0  55 7f 14 78 fe de b6 65  1d 9a 24 da 32 8b 69 17  |U..x...e..$.2=
.i.|
 015d1000  9c 27 64 a1 70 c5 48 bd  3e 6b ce 35 8d aa a9 5f  |.'d.p.H.>k.5.=
.._|
 015d1010  7b 14 3e b0 58 1a 7f f3  77 02 bd bc dc fe 23 46  |{.>.X...w....=
.#F|
@@ -2232310,13 +2232310,13 @@
 0220ff50  ca a7 a7 ae b6 15 a6 6d  e5 37 20 0e 60 85 14 d6  |.......m.7 .`=
...|
 0220ff60  af f2 9d 02 79 a5 ad 94  3a fa 15 66 d0 58 52 0c  |....y...:..f.=
XR.|
 0220ff70  b1 e3 6e 5e f2 ea b3 f1  a7 10 3d eb 2b c7 df c7  |..n^......=3D=
.+...|
-0220ff80  f5 77 7e 7c 6e 09 be 03  d7 a1 af b1 31 d4 4f 77  |.w~|n.......1=
.Ow|
-0220ff90  da bc 16 95 45 4f 64 97  b5 95 c9 c5 ee 76 31 2b  |....EOd......=
v1+|
-0220ffa0  dc 58 88 90 52 8e 93 cd  9f 33 74 61 34 a6 8e 0a  |.X..R....3ta4=
...|
-0220ffb0  3e 62 8f ad d5 7b 50 ea  3b 96 72 8e 35 6a 5a 21  |>b...{P.;.r.5=
jZ!|
-0220ffc0  16 f4 60 ed ae 2f e8 c5  df 5f aa 15 cd 49 c1 f4  |..`../..._...=
I..|
-0220ffd0  b4 0b 2c 0a b4 15 82 0c  e6 74 84 e6 5e d8 89 8b  |..,......t..^=
...|
-0220ffe0  96 08 f2 e3 3e 88 79 89  9b ba b5 72 1e 93 5c 51  |....>.y....r.=
.\Q|
+0220ff80  e7 3b 47 3d ae 02 53 d4  1a d0 24 9a 69 c6 81 8a  |.;G=3D..S...$=
.i...|
+0220ff90  82 1f 4e 6b 76 de 84 da  07 5d f2 89 50 9c 01 89  |..Nkv....]..P=
...|
+0220ffa0  d6 03 bb 7d 15 5a 39 05  c7 ee 4e 51 4b a9 84 1c  |...}.Z9...NQK=
...|
+0220ffb0  19 da 5e d8 95 2a 36 a5  cc 59 02 69 d6 11 e4 43  |..^..*6..Y.i.=
..C|
+0220ffc0  5d 36 50 a0 ed 95 42 24  eb 9b e8 e7 ad 9d 23 9a  |]6P...B$.....=
.#.|
+0220ffd0  d5 cb 32 2b e0 37 16 36  96 b8 9a 01 d5 00 eb 86  |..2+.7.6.....=
...|
+0220ffe0  09 db 97 5b 76 ed 0b 4f  9b ba b5 72 1e 93 5c 51  |...[v..O...r.=
.\Q|
 0220fff0  40 1b 68 c7 fc a8 8a 1b  16 7c 89 15 85 dc 26 df  |@.h......|...=
.&.|
 02210000  66 51 51 a5 45 4a 6c 9d  9a 98 a8 ba 72 39 77 47  |fQQ.EJl.....r=
9wG|
 02210010  54 d0 30 94 ea 3b c0 24  12 fc cd db 64 c4 f7 71  |T.0..;.$....d=
..q|

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-29783-1274302616-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkv0UJcACgkQ7b8eESbyJLjEQQCg5Vh5a6BJG0RRmsME6iZLW4rH
/qAAoM9jLj7JTeIleBZJMKFrKXdQIqCj
=PVI/
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-29783-1274302616-0001-2--
