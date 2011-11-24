Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1KXHpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:45:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46397 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1KXHpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:45:34 -0500
Date: Thu, 24 Nov 2011 01:45:26 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, ecryptfs@vger.kernel.org
Subject: Re: [GIT PULL] eCryptfs fixes for 3.2-rc3
Message-ID: <20111124074526.GA3652@boyd>
References: <20111123222555.GA1094@boyd>
 <CA+55aFyZvp=SsBG=SroMDLMEFGgazK1EM3b-Fejpgwf41+_e3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <CA+55aFyZvp=SsBG=SroMDLMEFGgazK1EM3b-Fejpgwf41+_e3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2011-11-23 14:56:23, Linus Torvalds wrote:
> On Wed, Nov 23, 2011 at 2:25 PM, Tyler Hicks <tyhicks@canonical.com> wrot=
e:
> >
> > Tyler Hicks (3):
> > =A0 =A0 =A0eCryptfs: Flush file in vma close
>=20
> I'm not hugely happy with this one.
>=20
> The commit message says:
>=20
>     Dirty pages weren't being written back when an mmap'ed eCryptfs file =
was
>     closed before the mapping was unmapped. Since f_ops->flush() is not
>     called by the munmap() path, the lower file was simply being released.
>     This patch flushes the eCryptfs file in the vm_ops->close() path.
>=20
> Fair enough - you've debugged the problem. You're misusing the ->flush
> thing which only gets called at close time, rather than flushing
> things at ->release time. But why?
>=20
> "->flush()" is very special, and is literally meant for things that
> need to wait at close time. A file descriptor may be flushed many
> times for a single open (because it was dup'ed etc), and yes, if it is
> closed before mmap, it will be flushed before the mmap is done. The
> "flush()" is basically attached to a particular fd - useful mainly for
> things like special devices that actually want to delay the close
> (serial lines etc).
>=20
> But the fundamental issue is that I don't think cryptfs should be
> using "flush". The file is still *open* when "flush()" is called.
> That's the fundamental reason for the bug, I think.
>=20
> cryptfs should flush the encrypted information at *release* time, not
> "flush" time. And that would have avoided the bug with mmap, because
> release gets called on the very last internal reference count drop of
> the 'struct file' - so it gets called after the last close *and*
> munmap.
>=20
> Is there some reason I am missing that cryptfs has to use flush?

I don't think so. I had actually eyed moving the flush to
ecryptfs_release() but went this route, instead.

>=20
> I'm doing the pull, but I really think that this is papering over the
> *real* bug, which was the use of 'flush' in the first place.

Thanks for doing the pull. The patch gets the job done, but I'm now in
agreement that this should be handled in ecryptfs_release().

It will likely be a few days before I can get to it (due to the
holiday), but I'll get a patch ready for review and test.

>=20
> In general, I'd urge people to *not* use "->flush" at all as a
> "correctness issue". It's useful to return EIO to "close()" and to be
> *polite* (ie the return value of "flush()" will be returned to user
> space at close time), but it really should be seen as a "we try to
> flush now to try to give user space nice error reports where
> possible", but it's important to understand that it's not the last
> close, and if you rely on it for correctness, you're doing something
> wrong. It's "release()" that is the "get rid of all your state now",
> and is about correctness. "flush" is purely about being polite.

But it *could* be the last close, so it seems that using flush() for
politeness *and* release() for correctness is not an option.
Theoretically, flush() could fail, followed by a successful release(),
resulting in close() returning an error when it shouldn't since the
return value of release() is ignored.

>=20
> ecryptfs seems to have relied on it for correctness. Not good.
>=20
>                        Linus

I appreciate the review!

Tyler

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOzfYWAAoJENaSAD2qAscKltEP/1RpbjDGf/Cv4JtbxUvcQL5i
5yDQ+xqqjIy6rkBms3WCruWk3tz1yTV3IR9odmRvCaVVFWp6I4k7sIFmLGPV/T9V
61zRiAAZSKNQVlXqb2eFj3SAgl4cine9frZFGOtzi5jO5bzm8Jw1NZdnk+J/tocC
dOV+ckPiyYg8pCJTkMLevYxaPYJ+Zm5iLxaAuHMRrPu1fINyKjqyvtREtDqOIV7T
sAkGC64nqZ+rAHuJcpdw7UT3n+OaAp8yrKRi8FyNM/Mvv1cdXOWAxxMsYZ79FNRR
FdUqs+mh7U4YZeuNSCbSJ0qUXyrlmWWi9gn3UGlyiMNXT/nKZ7IVlsvUQJWs+c9g
x1EE67NicPYld5L5kreaFqmTyWvdxyoXMWz5UbfiqjPSrothVNo2wHnTt1hmJBB4
QZ9c5prPl5a33oxoMVS5m4+nH5RVJ6Ju+bzuJpPpk3IGJ1wOgOTWmk7vgIrxtpXA
KF5v+S6DYb1Anudfjv6gYTAPwwiaDTSrfk0L0iI37EPCUd7isfuYoiG/8PFZPY2p
KM3G97eVSRDiDXyASdVPqph/qcfTmgFxB7n5vPmcofzoJkQKyZeSUf1Li8cPZQYU
yeJ/MWPlYbTkyslt1yqhluSxhN/lyNLa2lKjZxNTaUWgfkvs3tyjhZ2EGqJZslDP
T0FNyWiuS9XAFjzlgKXF
=Xz2F
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
