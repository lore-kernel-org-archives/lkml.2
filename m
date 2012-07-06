Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab2GFAWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:22:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35903 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab2GFAWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:22:00 -0400
Date: Fri, 6 Jul 2012 10:21:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Modra <amodra@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@bakeyournoodle.com
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120706102151.fd4f769cf2aa3f753ad178bf@canb.auug.org.au>
In-Reply-To: <20120705094348.GA5805@bubble.grove.modra.org>
References: <20120705183345.ee84ec1048a19aa1c7129578@canb.auug.org.au>
	<20120705094348.GA5805@bubble.grove.modra.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jul_2012_10_21_51_+1000_c3i3wsaq89+ttzC2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jul_2012_10_21_51_+1000_c3i3wsaq89+ttzC2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Thu, 5 Jul 2012 19:13:48 +0930 Alan Modra <amodra@gmail.com> wrote:
>
> On Thu, Jul 05, 2012 at 06:33:45PM +1000, Stephen Rothwell wrote:
> > powerpc64-linux-ld: drivers/built-in.o: In function `.gpiochip_is_reque=
sted':
> > (.text+0x4): sibling call optimization to `_savegpr0_29' does not allow=
 automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sib=
ling-calls, or make `_savegpr0_29' extern
> >=20
> > I got more than 60000 of these messages before I killed the link. :-(  I
> > am not sure what has changed to do this, but it may have been masked for
> > the past few releases due to other linking problems.
>=20
> Let me guess.  You're using bleeding edge gcc but not binutils.

powerpc-linux-gcc (GCC) 4.6.3
GNU ld (GNU Binutils) 2.22

both built from upstream sources (by Tony).

> a) Recent gcc has fixed prologue and epilogue generation which now
>    properly makes use of out-of-line register save and restore
>    functions when compiling with -Os.
> b) Recent ld doesn't emit out-of-line save/restore function for ld -r,
>    but yours does.  You need my 2012-06-22 patch.
> c) Kernel uses ld -r for packaging.
>=20
> (b) and (c) together mean you get a definition for _savegpr0_29 munged
> together with other functions.  That's bad.  If _savegpr0_29 wasn't
> emitted until the final link stage then it would be in a code section
> containing just save/restore functions.  ld will analyse that section
> and notice the absense of toc relocations; functions therein don't
> use the toc and can thus be called from any toc group without needing
> a toc adjusting stub.  In your case _savegpr0_29 is in a section that
> has toc relocations (from normal compiled code), so ld decides that
> any function in that section must have a proper value for the toc
> register.  But calls to _savegpr0_29 don't have a following nop to
> overwrite with a toc restore insn, hence the ld error.
>=20
> Score another black mark for ld -r.

OK, the new toolchain may be the problem.  I changed from:

powerpc-linux-gcc (GCC) 4.6.0
GNU ld (GNU Binutils) 2.21

on June 20 and the current errors may have been masked an early bailout
after getting theses errors:

powerpc64-linux-ld: arch/powerpc/net/built-in.o: In function `bpf_slow_path=
_word':
(.text+0x90): sibling call optimization to `skb_copy_bits' does not allow a=
utomatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibli=
ng-calls, or make `skb_copy_bits' extern

which have now been fixed.  So would a simple patch that puts the
_savegpr etc functions in their own section (defined how?) fix this for
us?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Jul_2012_10_21_51_+1000_c3i3wsaq89+ttzC2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9i+fAAoJEECxmPOUX5FEOMgP/ijIt1Lh89k4j0+RLLWWVD91
c3rFYyfZtZtodbrbVyw0v+rcuKLgzU8iwK2bQy7L0BxUqWCfj6Xhq67WF/DaODqh
VTPsoHxZvb4bQ+rrkqEC4HE6toO6WpwDSdLr7l7b/zVZgJk2Ld9j1RmA6BOujhd5
qt7FijVs7aw1971WXQugTkls8nd+eVqiwp/Jfil0pwHjB+lGJU5wLloapogLODLz
XKHbGb4ZlaKM8q2fYxzQ2hne2a025M3d+KLS7Xv5N4IpjUO8i/YrOyBLBJaLs0EO
/2ZQLh5d3kMfSYElphmKw63ywGuff+BLm7kRtWW1uXqGzIKKR+nxysy5uHEKhMQT
dCmcGQ1M3b/WHskV4Jnhb9drEMP0M+VhepHQMTKdXW/ZMJwcXSUlPgS0BEIuDy12
JAUbQW4E1ZJIEi3BXcJYUwqT+evObMLycJuI56Qh0Y8daGotmBg1zWyQCihhOXpM
sNCL6Tw7pxEAJNA5ipEPqKxWGs2UjAtkDgqU4+XRWwILmUQrcjV1B+d6YSNQB+Uz
5OSzeda8gtybOGa3dwlieaYyhRvCed3uNv36XCDLo03BQC6KWrNGlUNl8QfZzPFb
VJCJJSUENgUierclZQuiN7WPICTFe7eCTqqGokrSzrq672jAkiVvH0tDMSYSbynH
ARCi3tzHWuLszyWAieNX
=SZkg
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jul_2012_10_21_51_+1000_c3i3wsaq89+ttzC2--
