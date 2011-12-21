Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1LUMl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:41:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1LUMiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:08 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=llnN2uCRXZcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=HaAtnEYgZqD3JPeOQS4A:9 a=sMBSqHLdOlolvgEogr0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=cofXZ-XSsf9AwzsFZsoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123806.306638433@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/16] ftrace: Sort the mcount records on each page
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0007-ftrace-Sort-the-mcount-records-on-each-page.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Sort records by ip locations of the ftrace mcount calls on each of the
set of pages in the function list. This helps in localizing cache
usuage when updating the function locations, as well as gives us
the ability to quickly find an ip location in the list.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 366d788..2d6f8bc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -27,6 +27,7 @@
 #include <linux/sysctl.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/sort.h>
 #include <linux/list.h>
 #include <linux/hash.h>
 #include <linux/rcupdate.h>
@@ -3575,6 +3576,29 @@ static __init int ftrace_init_dyn_debugfs(struct den=
try *d_tracer)
 	return 0;
 }
=20
+static void ftrace_swap_recs(void *a, void *b, int size)
+{
+	struct dyn_ftrace *reca =3D a;
+	struct dyn_ftrace *recb =3D b;
+	struct dyn_ftrace t;
+
+	t =3D *reca;
+	*reca =3D *recb;
+	*recb =3D t;
+}
+
+static int ftrace_cmp_recs(const void *a, const void *b)
+{
+	const struct dyn_ftrace *reca =3D a;
+	const struct dyn_ftrace *recb =3D b;
+
+	if (reca->ip > recb->ip)
+		return 1;
+	if (reca->ip < recb->ip)
+		return -1;
+	return 0;
+}
+
 static int ftrace_process_locs(struct module *mod,
 			       unsigned long *start,
 			       unsigned long *end)
@@ -3638,6 +3662,11 @@ static int ftrace_process_locs(struct module *mod,
 	/* These new locations need to be initialized */
 	ftrace_new_pgs =3D pg;
=20
+	/* Make each individual set of pages sorted by ips */
+	for (; pg; pg =3D pg->next)
+		sort(pg->records, pg->index, sizeof(struct dyn_ftrace),
+		     ftrace_cmp_recs, ftrace_swap_recs);
+
 	/*
 	 * We only need to disable interrupts on start up
 	 * because we are modifying code that an interrupt
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMuAAoJEIy3vGnGbaoA5YUP/iOaY38+duq/Y64zPGjE/Vji
IYPFdZem5sDH++mb4LZzdgs2VI+fQ+lsaMaf/4htPPkbdDSSzB+CFxNAP5EvjuED
Sm/s/b/sOlz4BEGZ26Jh0wCXQxxbUEQId43u1L9VZxyR3G9tNPoA5iE6GGpfKBGt
PozEzlDSYUZU4Fe9d5maDg4MRRUhHuMRpNd5kOzKcCjHeyZXufbjpoB8yX3XXWPb
KAOy6k/VSSlwt5EZikq2X3PkwlPHJQrPisCvfJe7hrWi+LykXYwiNmf3nHfPC/aP
l7FceHkHospqGDLEi5oIJcquThtmqdKFAYM4JvufAOjSC5uRyRZWypbn/MyTJGd7
ALpR4aojUU4iKgUiJHA70uiEgRH12ls8T2eQM5tru7VxCyCKubzF1qNe24ns8vcA
c9V9klaPOw2Nya9N9WXvTha4A89NSiUjvgSa27ps0XbHc/nLH0c/2j28YE/7ZdyF
HYEYwM7YISaQ8cEhQ8xzLPDEdPCLmltKygj2trLg+670Fiv9yNytKc43wjlXmBM3
1dyY/rqjr6eBm5II/fdG/9dTUKSE7fpyUU0Ylof+OM0Io8v/ShVJvsDfCZWQgavo
WuDLsip+Pz2B6XPCHrP3504Ox7Xrc4suDS8P+coYjf94LX2DPzxQ9amDXclXA1Km
R5nLi1LEYRPZSxp1Xgay
=/YDN
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
