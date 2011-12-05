Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab1LEXEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:04:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776Ab1LEXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:03:07 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=T5PD5_YhWd8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=LuxQ-7HEAAAA:8 a=PuvxfXWCAAAA:8 a=pwlSjyV6AAAA:8 a=CjxXgO3LAAAA:8 a=37rDS-QxAAAA:8 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=-tqMmDk9ICWpGX07DfgA:9 a=8x_8ht5-I51uKuksZsgA:7 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=Bm8BtE0CId0A:10 a=o70cNcPx40UA:10 a=_1CdXZwv0MQA:10 a=rC2wZJ5BpNYA:10 a=6uQODOVjHeUA:10 a=UTB_XpHje0EA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=5EbIWr0yzBYrA5ZIeMcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111205230303.833140083@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 18:00:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hans Schillstrom <hans@schillstrom.com>,
        Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>
Subject: [PATCH RT 09/12 rc3] slab, lockdep: Fix silly bug
References: <20111205230046.736851081@goodmis.org>
Content-Disposition: inline; filename=0009-slab-lockdep-Fix-silly-bug.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Commit 30765b92 ("slab, lockdep: Annotate the locks before using
them") moves the init_lock_keys() call from after g_cpucache_up =3D
FULL, to before it. And overlooks the fact that init_node_lock_keys()
tests for it and ignores everything !FULL.

Introduce a LATE stage and change the lockdep test to be <LATE.

Cc: stable@kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hans Schillstrom <hans@schillstrom.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-mm@kvack.org
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-gadqbdfxorhia1w5ewmoiodd@git.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/slab.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 015cd76..433b9a2 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -594,6 +594,7 @@ static enum {
 	PARTIAL_AC,
 	PARTIAL_L3,
 	EARLY,
+	LATE,
 	FULL
 } g_cpucache_up;
=20
@@ -670,7 +671,7 @@ static void init_node_lock_keys(int q)
 {
 	struct cache_sizes *s =3D malloc_sizes;
=20
-	if (g_cpucache_up !=3D FULL)
+	if (g_cpucache_up < LATE)
 		return;
=20
 	for (s =3D malloc_sizes; s->cs_size !=3D ULONG_MAX; s++) {
@@ -1725,6 +1726,8 @@ void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
=20
+	g_cpucache_up =3D LATE;
+
 	/* Annotate slab for lockdep -- annotate the malloc caches */
 	init_lock_keys();
=20
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3U2oAAoJEIy3vGnGbaoAEFYP/1BvpfHZ9O9irTl1k36AAWM7
v8ZpZ8sxClYd25BDIfwA4gTaT3RKrJjsi2HZcd/lGYWRaZmktTR4YMZCgDdrLcYl
oqVx6oelp54rb6pDgm6ydbpf8cqHBHzY+e5feud8tvZyZglILknha1Gfv2QMSs1/
GpGs19ypQRI+oWGp68b4R2znn+b5qubewmRXsmnNAb6iZGiYD3yf3Zsh3iV3HTY0
3q2S4zFx/1LhhcEyuD7NLKHrhrfp6jYCZhRLnzIZNbxHMagvywQ161TGtNpaK6bx
h7AthQ3xXzUbJhPj7A5bLPuXxu2SsfbjFicp491liYr/nLUoQkbKKqedpGbQCiMR
6aLwPmD2PCPne4gdzxzE2YdLpsPdelN6jEVamhfS1QfOarLZpe5O6XThiMWiAR7A
VSh+HJhZw/1kvA3lkTKKEx0XfDL8mqkmGAlANNA7EwsyifGBjbZ3x4oJ2cjjVJ7e
ZSQtSHi8j23SwsZ0Cqz0suHBdV0dY1+wd0hBdbdnLloyeMIgU3/j3gth9L37bIsB
PWyQxG4r/eL8Oim7XiUI0qax1NgabxtazLg6Lp+DtsW0gH0XF2qBd/2e/VywVWa5
XExM+9K7aeL7xeKdxC4LWaXemyZD8OiGpN/b4PxelxO3Qm90WMf81Igz0CuiYhEO
p3ogUs4dsSj2nTkCUv6M
=vK3a
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
