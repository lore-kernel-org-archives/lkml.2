Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946066Ab2ERNMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:12:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933721Ab2ERNKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:53 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=1_hdgFqO5gIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=_IGxp2mfFUYWymhGOywA:9 a=9GTYEX1tESxK75rzqtoA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=1xYCUaPE22q-fCWBymAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131049.947535513@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/15] ftrace: Sort all function addresses, not just per page
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-Sort-all-function-addresses-not-just-per-page.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Instead of just sorting the ip's of the functions per ftrace page,
sort the entire list before adding them to the ftrace pages.

This will allow the bsearch algorithm to be sped up as it can
also sort by pages, not just records within a page.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    2 +-
 kernel/trace/ftrace.c             |   34 ++++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinu=
x.lds.h
index 8aeadf6..4e2e1cc 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -486,8 +486,8 @@
 	CPU_DISCARD(init.data)						\
 	MEM_DISCARD(init.data)						\
 	KERNEL_CTORS()							\
-	*(.init.rodata)							\
 	MCOUNT_REC()							\
+	*(.init.rodata)							\
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()						\
 	DEV_DISCARD(init.rodata)					\
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cf81f27..53ed01e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3666,15 +3666,27 @@ static __init int ftrace_init_dyn_debugfs(struct de=
ntry *d_tracer)
 	return 0;
 }
=20
-static void ftrace_swap_recs(void *a, void *b, int size)
+static int ftrace_cmp_ips(const void *a, const void *b)
 {
-	struct dyn_ftrace *reca =3D a;
-	struct dyn_ftrace *recb =3D b;
-	struct dyn_ftrace t;
+	const unsigned long *ipa =3D a;
+	const unsigned long *ipb =3D b;
=20
-	t =3D *reca;
-	*reca =3D *recb;
-	*recb =3D t;
+	if (*ipa > *ipb)
+		return 1;
+	if (*ipa < *ipb)
+		return -1;
+	return 0;
+}
+
+static void ftrace_swap_ips(void *a, void *b, int size)
+{
+	unsigned long *ipa =3D a;
+	unsigned long *ipb =3D b;
+	unsigned long t;
+
+	t =3D *ipa;
+	*ipa =3D *ipb;
+	*ipb =3D t;
 }
=20
 static int ftrace_process_locs(struct module *mod,
@@ -3693,6 +3705,9 @@ static int ftrace_process_locs(struct module *mod,
 	if (!count)
 		return 0;
=20
+	sort(start, count, sizeof(*start),
+	     ftrace_cmp_ips, ftrace_swap_ips);
+
 	pg =3D ftrace_allocate_pages(count);
 	if (!pg)
 		return -ENOMEM;
@@ -3740,11 +3755,6 @@ static int ftrace_process_locs(struct module *mod,
 	/* These new locations need to be initialized */
 	ftrace_new_pgs =3D pg;
=20
-	/* Make each individual set of pages sorted by ips */
-	for (; pg; pg =3D pg->next)
-		sort(pg->records, pg->index, sizeof(struct dyn_ftrace),
-		     ftrace_cmp_recs, ftrace_swap_recs);
-
 	/*
 	 * We only need to disable interrupts on start up
 	 * because we are modifying code that an interrupt
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpaAAoJEIy3vGnGbaoA2UwQAOS4UeDY+P6tA6JLUsDvSBc+
udcxqIfC8Key7fxtGFvas2qUi6SXcXtTAHWykLLYLvKIhJGT9Hmv5QCTUHY87EOK
ybpD2TqQbtl/K7Ifyi6OPEXdNgc+x6w7FukykVFljAcFOf9yRQu72yyWXrWR5ErM
swkxzPKRE7Mg+chXNZZzntaQ6fODIqNmsKcDeZlPvHy33S1pa9/922LMFBA0luZr
1PXRK3g46Cc+xGHU4ceNOuJ5X9zvgIj00cFJyTe7T22ab2+iLzfcoUDlJlUa0TlI
GUtIfFEtQY35ugQvpQFVjcXr5Lh35sPXt8ex9xt5rNE+pM1g51gZSTWPYJJe0xAO
K4FdgUKkd7EF4wQSg8Skf3lN3Xt7w4szOhyV+DmvX1iHaJQ7OrTjsB7cfeB7Z2sB
rZlS4lmk/ZjYDUxACwek/2T8x5KK/XfI7pCo1+bcK6UriogestC0annA/rr5B3Ql
lhSUsqQQZGbI9uD28kJORNyTIlNfDqk88rIXsmXHFCqRGHSh0E0s3rSd3bWzzn5a
v+QZTirLhE6ihESikVpwNrFnRY8VJFLvv5GbANXvrKX1hDgkGC8MEPrOD6dMq3a6
bJcl3Xehuwa+hNu/JP9HaBuawxty/t7EKs71Y4d0DjC1dQBQxYjPtfp37lU9MQhU
T4ls80Nq5mzdi/GYBF7a
=hCcd
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
