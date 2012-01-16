Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2APQi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:38:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab2APQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:38:25 -0500
X-Authority-Analysis: v=2.0 cv=Hf6Wv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=tOaN0rH9Jc8A:10 a=5SG0PmZfjMsA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=8T59DR07AAAA:8 a=Tty9oNO6AAAA:8 a=7OJHxkdX_Whk8ZaePHcA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=0kPLrQdw3YYA:10 a=ZJsSJEh0OMWAqQ8mdRMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326731899.7642.155.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL v2][v3.3] tracepoints/module: Fix disabling
 tracepoints with taint CRAP or OOT
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ben Hutchings <ben@decadent.org.uk>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Date: Mon, 16 Jan 2012 11:38:19 -0500
In-Reply-To: <20120116072456.GA15641@elte.hu>
References: <1326658250.7642.136.camel@gandalf.stny.rr.com>
	 <20120116072456.GA15641@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-moBkQmA1E5IKx3zaLtXa"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-moBkQmA1E5IKx3zaLtXa
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-01-16 at 08:24 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> >  	/*
> >  	 * We skip modules that tain the kernel, especially those with differ=
ent
>=20
> While touching this commit we might as well fix the typo here?
>=20
> >  	 * module header (for forced load), to make sure we don't cause a cra=
sh.
>=20
> ... and the second typo as well?
>=20
> > +	 * Staging and out-of-tree modules are fine.
> >  	 */
>=20
> I'd phrase it as 'out-of-tree GPL modules'.

Thanks!

Updated:

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent-2

Head SHA1: c10076c4304083af15a41f6bc5e657e781c1f9a6


Steven Rostedt (1):
      tracepoints/module: Fix disabling tracepoints with taint CRAP or OOT

----
 kernel/tracepoint.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)
---------------------------
commit c10076c4304083af15a41f6bc5e657e781c1f9a6
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Jan 13 21:40:59 2012 -0500

    tracepoints/module: Fix disabling tracepoints with taint CRAP or OOT
   =20
    Tracepoints are disabled for tainted modules, which is usually because =
the
    module is either proprietary or was forced, and we don't want either of=
 them
    using kernel tracepoints.
   =20
    But, a module can also be tainted by being in the staging directory or
    compiled out of tree. Either is fine for use with tracepoints, no need
    to punish them.  I found this out when I noticed that my sample trace e=
vent
    module, when done out of tree, stopped working.
   =20
    Cc: stable@vger.kernel.org # 3.2
    Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Cc: Ben Hutchings <ben@decadent.org.uk>
    Cc: Dave Jones <davej@redhat.com>
    Cc: Greg Kroah-Hartman <gregkh@suse.de>
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index db110b8..f1539de 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -634,10 +634,11 @@ static int tracepoint_module_coming(struct module *mo=
d)
 	int ret =3D 0;
=20
 	/*
-	 * We skip modules that tain the kernel, especially those with different
-	 * module header (for forced load), to make sure we don't cause a crash.
+	 * We skip modules that taint the kernel, especially those with different
+	 * module headers (for forced load), to make sure we don't cause a crash.
+	 * Staging and out-of-tree GPL modules are fine.
 	 */
-	if (mod->taints)
+	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
 		return 0;
 	mutex_lock(&tracepoints_mutex);
 	tp_mod =3D kmalloc(sizeof(struct tp_module), GFP_KERNEL);


--=-moBkQmA1E5IKx3zaLtXa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPFFJ8AAoJEIy3vGnGbaoA69oQAI05WyAz9ViAaa33x8paBs2m
zISOa8uIe0cgEKXvN/w0sYPCReDy47oZJCMvLFlwppWkRW3QbsDlZmFqd7IeKCpV
xKMNZUO06EYt4R8w2KUrQIkwFeBSAYYLqVBjt+GUHwza+d2CH4pf9iHymNhnVT8o
rvkz+MYxP+lHTWfEZsBxrM0Fd5e87cTVnAsY7IgGtaZlkQaXzuZpcdE6TcB17msS
pb2bH6CQ5yxkka8o4GelKH/ulVp8Pku62GuWOD+Gi1KRYN5OD5pV7SXayuZfTcsL
Oo8+/Ak80h84cezvlsTsSY3NJJiKz8zX0WgBPTS8oMGfj1nrX/VZinO1PfPgvHPj
ONEtagzxEBjVkQm+ykDjJuL4XRVE5J46cWJxsXIxR9gxRw3wToTl1F7svl+5Ea1U
dEA3ITcH3Kz4gjJLdGv9dvS11rjiwUhmAa0o5r5Huh9Hs82PTM2ajhJ6CX3UMIlz
K6jN7ph26+WnbNBjCgXWcpVwulsxv+EKSHINZa8HFb8Yk6LFaWm5Vca57qjVFQ+7
q1jJHUar29uhUB0qAPaL1rf/2tuZDM15X1O2VVurFVr5Gdx92lzh2lfmB0dZXp+X
nC8ebKy7NdSGadW8gQija9iQKspWL6EYUo5/zNRGGJG8QPyGh7lO6nDbS00O+EKt
yDppgY8/5ioh8Ktl3YpQ
=iICq
-----END PGP SIGNATURE-----

--=-moBkQmA1E5IKx3zaLtXa--

