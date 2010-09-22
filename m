Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0IVAAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 20:00:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60079 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0IVAAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 20:00:37 -0400
From: James Hogan <james@albanarts.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fbmem: Fix fb_read, fb_write unaligned accesses.
Date: Wed, 22 Sep 2010 01:00:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-56.fc13.x86_64; KDE/4.4.5; x86_64; ; )
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Dave Airlie <airlied@redhat.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        James Simmons <jsimmons@infradead.org>
References: <201009180123.48303.james@albanarts.com> <20100921161950.b7f45273.akpm@linux-foundation.org>
In-Reply-To: <20100921161950.b7f45273.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2702498.Moc59V2gJj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009220100.27090.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2702498.Moc59V2gJj
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Wednesday 22 September 2010 00:19:50 Andrew Morton wrote:
> On Sat, 18 Sep 2010 01:23:47 +0100
>=20
> James Hogan <james@albanarts.com> wrote:
> > Apologies for corrupted patch. I'll try again.
> > Comments? I'd also appreciate if somebody familiar with sbus on sparc
> > could check this patch is sane since I know virtually nothing about sbus
> > and am not in a position to compile for sparc, let alone test on it:
> >=20
> > fb_{read,write} access the framebuffer using lots of fb_{read,write}l's
> > but don't check that the file position is aligned which can cause
> > problems on some architectures which do not support unaligned accesses.
>=20
> What are these "problems"?

On the arch I hit this on (which isn't in tree) I experienced a fault at th=
e=20
point of the unaligned write in kernel code, but this is only because=20
unaligned access checking is switched on which isn't always possible=20
(otherwise the write would have just silently failed/done something else). =
It=20
terminated the program, but didn't cause any other problems.
Documentation/unaligned-memory-access.txt also mentions that some=20
architectures raise exceptions that can't be worked around, or fail silentl=
y=20
and may actually perform different writes to the one requested.

> I'd have thought they would be fairly fatal, in which case this is a
> high-priority patch.  But I'd also have thought that the problems would
> have been noted before now.

The common way to access the framebuffer is by mmapping it into userland, s=
o I=20
don't think the read/write syscalls are commonly used on it, and in any cas=
e=20
colour data tends to be naturally aligned so unaligned writes would be=20
uncommon.

>=20
> So I assume that you're doing something which nobody has done before.
>=20
> Confused.  Help?

The actualy case that hit this is admitedly rather silly. I did a quick tes=
t=20
of the framebuffer by typing this at a shell:
yes > /dev/fb0
I'd have to check it again to see exactly how lots of 2 byte writes ("y\n")=
=20
ended up unaligned, but at the point of the crash the dest pointer was=20
definitely unaligned (the hex address ended in a 5) and the patch fixed it =
for=20
me.

Hope that helps.

Cheers
James

--nextPart2702498.Moc59V2gJj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEABECAAYFAkyZRxoACgkQ4hGc8zKz77AB2wCfcDWZPNY8ahrE0xeJqyhBcJQn
OpwAn1q/4BPkHaTE2TlDYwCPc+jn/OQu
=1C06
-----END PGP SIGNATURE-----

--nextPart2702498.Moc59V2gJj--
