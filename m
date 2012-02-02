Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2BBWEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:04:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab2BBWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:04:46 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0ow4NSV8tcgA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=90nuPZvPFKVeRhH3AUgA:9 a=VfCIdguN_6SRdkgrMkEA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=CpzJxFncoB6UKQXOGoUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328220280.5882.122.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 02 Feb 2012 17:04:40 -0500
In-Reply-To: <1328193068.5882.95.camel@gandalf.stny.rr.com>
References: <20120128160925.275163704@goodmis.org>
	 <20120130144857.GA22013@elte.hu>
	 <1327936060.22710.165.camel@gandalf.stny.rr.com>
	 <20120131194813.GA12074@elte.hu>
	 <1328072925.5882.57.camel@gandalf.stny.rr.com>
	 <20120201080539.GA11770@elte.hu>
	 <1328109697.5882.65.camel@gandalf.stny.rr.com>
	 <20120202135154.GA10315@elte.hu> <4F2A9960.2090500@zytor.com>
	 <1328193068.5882.95.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ujoafQ9IkE9LF6wn1TDV"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ujoafQ9IkE9LF6wn1TDV
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-02-02 at 09:31 -0500, Steven Rostedt wrote:

> This code died on "enabling" the nop. I think the code now enables some
> nops by default on boot up, which doesn't expect to see the
> "default_nop".
>=20

Ah, we do have jump labels that are default on. I'm still not triggering
these, I'm not sure why. Perhaps a command line difference?

Anyway, this should fix the bug:

-- Steve


Ingo,

Please pull the latest tip/perf/jump-label-4 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/jump-label-4

Head SHA1: 7bbd9688727dd30cd44b90b3c9c35f0f66af77ff


Steven Rostedt (1):
      x86/jump labels: Handle initialization of enabled nops

----
 arch/x86/kernel/jump_label.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
---------------------------
commit 7bbd9688727dd30cd44b90b3c9c35f0f66af77ff
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Feb 2 16:55:43 2012 -0500

    x86/jump labels: Handle initialization of enabled nops
   =20
    When jump labels are initialized at boot up, they are compared
    to the default_nop before switching to the ideal nop.
   =20
    But if a jump label is enabled by default on start up, the
    enabled code does not test against the default nop, only the
    ideal nop. But as this jump label has not been converted to the
    ideal nop, it fails the check, and will crash the box.
   =20
    The enabled path needs to be aware of initialization too.
   =20
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 2839524..d560c80 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -66,7 +66,8 @@ static void __jump_label_transform(struct jump_entry *ent=
ry,
 			code.jump_short =3D 0xeb;
 			code.offset =3D entry->target - (entry->code + 2);
 			/* Check for overflow ? */
-		} else if (memcmp(ip, ideal_nop, 5) =3D=3D 0) {
+		} else if ((!init && memcmp(ip, ideal_nop, 5) =3D=3D 0) ||
+			   (init && memcmp(ip, default_nop, 5) =3D=3D 0)) {
 			size =3D JUMP_LABEL_NOP_SIZE;
 			code.jump =3D 0xe9;
 			code.offset =3D entry->target - (entry->code + size);


--=-ujoafQ9IkE9LF6wn1TDV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPKwh5AAoJEIy3vGnGbaoACkQP/0BtEOY0M0n6UgoclKSfeF6V
1iTY8htPtWM1IYVSTtqo3uula6t2Q043jJU2jOQwMNLFurV1O6XFJsjZIRaCdPAj
Jj6LJLseMp9u2MT9XR9ZbU3HORrva1A44/wHYkdhNwIrK2ogcNv9PYT4tXXjKKy2
cVyrG/cS6wMRGuvBh+312HbbMZzs7g7DmssKMDwRhtS+odB7M+csuqmQSOmIeD64
lDaxkftZG2mb0OVtBJ7TH+7COPZUcoajUGsqvZ11Em6nFa6jKeqJfDJsQRgvm0xo
Bkoke30nVAu2RI3oN7+qQMkw66/q0+2pmTZK/NpjJRZLpoxCQ51f8/SSFX4dlalw
sV5UJBiwUVFIkTSQ09UVmbXjLUh55qGq04ysZU9aEiAj47WorkwbVbWkCSNOQ60m
5qb8HX56lRb5+GmpNL/l/rJc+GRJ76rdfIlZ6nBWNHwLTaqm0s0nm5m0M9N/Xl1Y
s/My0Bdtp2yOjNi/InQpxWJ6RyNVCzWUo9tJnaR27oK6WF4ETbYLIFT5cimD53Xn
or6TgL46YXWA5ZD7p1klO5rZ+HNeOXMUxeqzv7bu7q2Y1rWnTuEy2UULUKieUGBh
06mVYbdlsYXDBy7/lPPS1gYnxk8ZcDszIYeeKVXFJ1UjzgcH4h9XZQ4FzdTPbkmj
rCA0F4E0Wgn7NEoVTI2F
=Y0wn
-----END PGP SIGNATURE-----

--=-ujoafQ9IkE9LF6wn1TDV--

