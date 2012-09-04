Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab2IDUqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:46:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab2IDUqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:46:02 -0400
Date: Wed, 5 Sep 2012 06:45:43 +1000
From: NeilBrown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Namjae Jeon <linkinjeon@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 4/5] fat: eliminate orphaned inode number allocation
Message-ID: <20120905064543.4b3a3245@notabene.brown>
In-Reply-To: <20120904192509.GD29369@fieldses.org>
References: <1346774312-8142-1-git-send-email-linkinjeon@gmail.com>
	<87mx15910k.fsf@devron.myhome.or.jp>
	<87fw6x90o3.fsf@devron.myhome.or.jp>
	<20120904183815.GA29369@fieldses.org>
	<87y5kp7gsq.fsf@devron.myhome.or.jp>
	<20120904192509.GD29369@fieldses.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NtXvJm2+9ZQdXDy.ebtASDQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NtXvJm2+9ZQdXDy.ebtASDQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 4 Sep 2012 15:25:09 -0400 "J. Bruce Fields" <bfields@fieldses.org>
wrote:

> On Wed, Sep 05, 2012 at 04:02:13AM +0900, OGAWA Hirofumi wrote:
> > "J. Bruce Fields" <bfields@fieldses.org> writes:
> >=20
> > > On Wed, Sep 05, 2012 at 02:07:40AM +0900, OGAWA Hirofumi wrote:
> > >> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> > >>=20
> > >> > Namjae Jeon <linkinjeon@gmail.com> writes:
> > >> >
> > >> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> > >> >>
> > >> >> Maintain a list of inode(i_pos) numbers of orphaned inodes (i.e t=
he
> > >> >> inodes that have been unlinked but still having open file
> > >> >> descriptors).At file/directory creation time, skip using such i_p=
os
> > >> >> values.Removal of the i_pos from the list is done during inode ev=
iction.
> > >> >
> > >> > What happens if the directory (has busy entries) was completely re=
moved?
> > >> >
> > >> >
> > >> > And Al's point is important for NFS too. If you want stable ino fo=
r NFS,
> > >> > you never can't change it.
> > >>=20
> > >> s/never can't/never can/
> > >
> > > If vfat exports aren't fixable, maybe we should just remove that
> > > feature?
> > >
> > > I'm afraid that having unfixable half-working vfat exports is just an
> > > attractive nuisance that causes users and developers to waste their
> > > time....
> >=20
> > In historically, it was introduced by Neil Brown, when nfs export
> > interface was rewritten (I'm not sure what was intended).
> >=20
> > Personally, I'm ok to remove it though, it is really personal
> > opinion. The state would be rather I don't have strong opinion to
> > remove.
>=20
> Neil, any opinion?
>=20
> If we can document circumstances under which nfs exports of fat
> filesystems are reliable, fine.
>=20
> Otherwise I'd rather just be clear that we don't support it.
>=20
> --b.


I think that is important to maintain support for NFS export of VFAT on a
best-effort basis.  We can't provide 100% guarantees of all NFS semantics b=
ut
that doesn't prevent it from being of real practical benefit to people.

If the usage pattern is "open/read/close" or "open/write/close" while no
other client is accessing the filesystem and while the server is not under
aggressive memory pressure, then it should work quite reliably.

If you rename files while they are open, have lots of file concurrently ope=
n,
allow the server to experience high memory pressure (e.g. reading/writing
multiple files that are bigger than memory) etc etc then things can start to
fail.

VFAT is widely used as a file-transfer protocol.  If you use NFS/VFAT in th=
at
way it works fine.  If you try to use it as a general file access protocol,
that is when you hit problems.

The patch series tries to make inode number stable across reboot.  I think
this is not worth the effort as you won't make VFAT access more reliable,
you'll just make it fail differently.

The only real answer to more reliable NFS access to VFAT is the NFSv4 conce=
pt
of volatile file handles.  Unfortunately NFSv4 hasn't yet specified these
with sufficient precision to actually use them.

So if anyone wants to improve VFAT/NFS, I suggest that the first step is to
work with the NFSV4-WG to get an implementable specification.  Good luck wi=
th
that.

NeilBrown

--Sig_/NtXvJm2+9ZQdXDy.ebtASDQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUEZodznsnt1WYoG5AQIYOQ/9Hp2IuQK18NkBPqOkmpP2j3nEtOfIFEwf
pcX0HuoS0BqiimB6fKjYA7jT10Ht9nuxhG7fEzXklgXE+9PiB6E/EFt1H50glfI/
mzyBCxBZvqnbgnfW5uKepPexVL+n/loMIahbLrfViuGjssvcFnssi7rOE6Cml9eg
Ao6SR7+R82c7Jb1Ev3b2O+nGeuXn9XS48oH+Gr80dClSUf0u2LUiZTDjKzPCOY3K
1UCvdxMUj6CumCyVY8xIBqunTDBly5yt0L/ckR5tvm/t0GNOb6kLekfs1/wAM1es
VyE6l3/b3bezDco+/OELw7Z4UKeTl/yDIDl8ndO5beXpWbekX3gLSaDsCcKo7GyW
DJshMh1jLV1Z+hJm8nFEEQDU0xZ/ciir5qnilceIXyWYZ9foR8lJXST0jN+it/uH
c7Th7FNPVhrc9pYt0oeBlzdYFBdyWou8jejvgdIIfkOGIR7eUlasINOdBECT/OnS
2t8BMfz3CBEUAj2qgXac5M/1CDAEnLl5Eji8hhnvLOEJrtFel9sIk6JhjRnUvpFM
P91XuHXF85Dm+IqNpGVK0+dSOcdOd59ohPfqE2IgW1FteNli5dAhoGUVyAVm0bXk
Bg1ao/8HiZNyPX9dtfbHCdh/ZwpXsG6UBjpaEMpXeJ6D1R5nGelpU+TKEbPxw5/Z
NUb0OvkPeQk=
=wBue
-----END PGP SIGNATURE-----

--Sig_/NtXvJm2+9ZQdXDy.ebtASDQ--
