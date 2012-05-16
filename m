Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab2EPVDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 17:03:13 -0400
Received: from ngcobalt07.manitu.net ([217.11.48.107]:38936 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2EPVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 17:03:12 -0400
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Wed, 16 May 2012 23:03:05 +0200
From: Roland Eggner <edvx1@systemanalysen.net>
To: =?utf-8?B?QmrDtnJu?= Christoph <einkaufenbc09@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: jbd2 slowing down file copies even though no journaling
 file system is used
Message-ID: <20120516210305.GB1500@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: =?utf-8?B?QmrDtnJu?= Christoph <einkaufenbc09@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <CAHOpdHWMcV6LjpaEhk27ULkz-wGUD0-pNH=PC+ahDn47VQ+qmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <CAHOpdHWMcV6LjpaEhk27ULkz-wGUD0-pNH=PC+ahDn47VQ+qmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bj=C3=B6rn!

=E2=80=9CCc: LKML=E2=80=9D added =E2=80=A6 sorry for the duplicate to your =
personal address.


On 2012-05-13 Sun 01:21, Bj=C3=B6rn Christoph wrote:
> I have very slow and non-consistant transfer rates when copying files to =
Linux.
>=20
> My system:
> Ubuntu 12.04 Server x64 (same issue with Debian Squeez), 2 Gb RAM, AMD
> 240e processor
>=20
> Hard disks:
> 1 * 500 Gb Seagate Momentus XT Hybrid HDD
> 6 * 1.5 - 2 TB Samsung HDD
>=20
> The Momentus contains the OS in an encrypted LWM (dm-crypt) - one ext2
> for booting, one ext2 and one LVM partition (all primary).
>=20
> The other bigger hard disks each contain one encrypted Truecrypt
> partition. Most are with ext4, one is with ext3. I join them to one
> folder using "union-fs" (read only).
>=20
> I use samba for transfer of data from my Windows 7 PC's.
>=20
> The files stored are usually around 20 Gb in size (movies), and I
> don't really care much about journaling and integrity (most partitions
> are mounted read-only anyways as they are full ;) )
>=20
> ------------
> The good scenario
>=20
> Copying files FROM the server to a Windows client is really OK
> performance wise. I see a 50% network utilization (1 Gbit network) and
> it's quite constant around 46 Mb/sec.
>=20
> =E2=80=A6 =E2=80=A6
>=20
> ------------
> The bad scenario:
>=20
> I do also have to transfer data to this server. And here comes the proble=
m.
>=20
> I copy the file to a specific hard disk / samba share (not to the union-f=
s).
>=20
> And here, the data transfer is just impossibly slow.
>=20
> Now before we end up in "it's encryption", let me say this is not the
> case and why:
>=20
> I have one standard ext2 partition on the Momentus (300 Gb), ext2 has
> no journaling (which I really don't require).
>=20
> I copy the file to the ext2 partition. Average transfer rate around 29
> Mb/sec. However, there are a lot of spikes in the network transfer.
> Peak at around 35% and it goes down to 20% in a wave form with
> sometimes even 0% transfer.
> =E2=80=A6 =E2=80=A6


I guess, your write performance problem is related to a large amount of tri=
ple
indirect blocks and high file fragmentation:


(1)  Are you aware of the fundamental difference between blocklist filesyst=
ems
(ext2, ext3) and extent based filesystems (ext4 with option extents enabled,
XFS, JFS, =E2=80=A6)?

If not, imagine the huge metadata overhead of reading a 20G sized file stor=
ed
in millions of triple indirect blocks (=3D pointers to pointers to pointers=
 to
blocks), compared to reading the same 20G sized file stored in just 10 exte=
nts.


(2)  Did you check =E2=80=9Ctind blocks=E2=80=9D and =E2=80=9Cnon-contiguou=
s files=E2=80=9D in the output of
fsck command?  If you want further help, please post output of df and fsck.
df output shows in the first column the device names to use for fsck comman=
d:

df -BG -T                =20
sudo fsck -C 0 -f -n /dev/yourdevice


(3)  Did you create your ext4-filesystems by using mkfs.ext4 or by conversi=
on
of ext3 filesystems?  In the latter case, did you run following commands
(partition backup recommended prior to first trial)?

sudo tune2fs -O extents /dev/yourdevice
sudo tune2fs -I 256     /dev/yourdevice

Note, that enabling extents affects only files written in the future, not
already written files.  Thus a "backup - mkfs.ext4 - restore"-cycle is
preferable.  Related documentation e.g.:

http://kernel.org/doc/Documentation/filesystems/ext4.txt
man tune2fs
man mkfs.ext4


Background:

6 years ago I compared Linux filesystems and encountered this case:
(a)  ext3 filesystem size some 20G, holding a few files with size 0.5G =E2=
=80=A6 4G.
e2fsck required almost 1 hour for checking.
(b)  XFS filesystem on the very same partition, holding exactly the same
fileset.  xfs_check completed within a few seconds.

Since then and after some other considerations I use XFS for all my plain a=
nd
encrypted Linux filesystems.  My shell prompt automatically calls a script
=E2=80=9Ccooked=E2=80=9D by me, which executes sync as soon as cpuload drop=
s to idle or nearly
idle.  This protects my filesystems against the famous =E2=80=9Czero-sized =
files
problem=E2=80=9D of XFS after power interruptions, without any noticeable p=
erformance
downsides.

In terms of file fragmentation XFS most likely surpasses every other file-
system, particularly in nearly full conditions.  For your use case with =E2=
=80=9Cmost
partitions are mounted read-only anyways as they are full=E2=80=9D this sou=
nds
attractive, or what would you say?

http://en.wikipedia.org/wiki/XFS#Extent_based_allocation
http://kernel.org/doc/Documentation/filesystems/xfs.txt
http://xfs.org/index.php/XFS

--=20
Regards
Roland

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk+0FgkACgkQdN/hKfT7G/JV1ACcChJXyDIZprQZHv8eZk6ZkBD7
EHoAoIEhn8eQ1ob1dF5ziDBdiq9jm1/b
=DMKh
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
