Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1LUMkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:40:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1LUMiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:09 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=JG1FVspKDdwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=gYW187jjCfz5JYbgbYEA:9 a=vEAVRaOM_NFpSNILjf0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=zJU8nkk0pp0fKLpTfcQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123806.926622890@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/16] ftrace: Use bsearch to find record ip
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-Use-bsearch-to-find-record-ip.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Now that each set of pages in the function list are sorted by
ip, we can use bsearch to find a record within each set of pages.
This speeds up the ftrace_location() function by magnitudes.

For archs (like x86) that need to add a breakpoint at every function
that will be converted from a nop to a callback and vice versa,
the breakpoint callback needs to know if the breakpoint was for
ftrace or not. It requires finding the breakpoint ip within the
records. Doing a linear search is extremely inefficient. It is
a must to be able to do a fast binary search to find these locations.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   38 +++++++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2d6f8bc..dcd3a81 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -22,6 +22,7 @@
 #include <linux/hardirq.h>
 #include <linux/kthread.h>
 #include <linux/uaccess.h>
+#include <linux/bsearch.h>
 #include <linux/module.h>
 #include <linux/ftrace.h>
 #include <linux/sysctl.h>
@@ -1300,6 +1301,19 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned lon=
g ip)
 		}				\
 	}
=20
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
 /**
  * ftrace_location - return true if the ip giving is a traced location
  * @ip: the instruction pointer to check
@@ -1313,11 +1327,17 @@ int ftrace_location(unsigned long ip)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
+	struct dyn_ftrace key;
=20
-	do_for_each_ftrace_rec(pg, rec) {
-		if (rec->ip =3D=3D ip)
+	key.ip =3D ip;
+
+	for (pg =3D ftrace_pages_start; pg; pg =3D pg->next) {
+		rec =3D bsearch(&key, pg->records, pg->index,
+			      sizeof(struct dyn_ftrace),
+			      ftrace_cmp_recs);
+		if (rec)
 			return 1;
-	} while_for_each_ftrace_rec();
+	}
=20
 	return 0;
 }
@@ -3587,18 +3607,6 @@ static void ftrace_swap_recs(void *a, void *b, int s=
ize)
 	*recb =3D t;
 }
=20
-static int ftrace_cmp_recs(const void *a, const void *b)
-{
-	const struct dyn_ftrace *reca =3D a;
-	const struct dyn_ftrace *recb =3D b;
-
-	if (reca->ip > recb->ip)
-		return 1;
-	if (reca->ip < recb->ip)
-		return -1;
-	return 0;
-}
-
 static int ftrace_process_locs(struct module *mod,
 			       unsigned long *start,
 			       unsigned long *end)
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMvAAoJEIy3vGnGbaoAj1YP/1pK+OKS3CcF/pf7JhSCotQs
nDEIyMLH3ODRvMzaKIKfpDyAyFDNJt4e/uKofVDn0sh0b/P5+c2PKiF4Z/KlKcau
mFaYD/MD9/M/rWbQ04RFkebCmTMxxoLTshvYnHoa0SC6yFsi9xt5a6S3hPm6hFTy
edniYfQqbfUFO5ppeaYBE6XU+veMKCxdNo75zi3phGM7XWfbFsu89083IgfSeN3E
cWvcOiIbslIpw0zCUfsCasuwlKsBgwXPmu0x53KmkorS4BiAZVKMETNkog+6xWOZ
Tf/6E819fgbFhYy6cJT2AaM7UMdBHV5TzcfX+1OzZHxUoZui2VknV+TmJa760IZE
wafNmIDUJ/XoL1KnppfMmojGm4ec633OlYR+2GR+SeSYz49FhTdUs5TC9csXPj/P
0nU1iqk8VgtdvOPGueZ2E5Zq6kg423ESJwLhe3cC5MeSbq3gxSZb3YHOpB9MwWb4
dX+pcgdF9S/4GNxZXXFa/aBrwHvf8fAo+Xhj4rzPAbh7sqBhUc0uDDDqaOzHkKcP
UH3gBRZwVyH1RxSjrzf/kWqynDPb1NFNyih/eA9GXf5RR7rgcNneh6eRyD5C9V6r
dRF1emR68TAdjz5xsCQ7tYjxALsvgHwOU9My5/DFnaxAnb1lyF20LyYBIcLy9TpN
mgu0piOs4Jvy4KzRn6eW
=cnuF
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
