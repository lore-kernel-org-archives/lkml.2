Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2DZChN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:37:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2DZChJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:37:09 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=q_glbGhIPWYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=_IGxp2mfFUYWymhGOywA:9 a=9GTYEX1tESxK75rzqtoA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=adWdUm4Z51LiVkSNnZQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426023706.696930048@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 22:29:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/6][RFC] ftrace: Sort all function addresses, not just per page
References: <20120426022922.683707508@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Sort-all-function-addresses-not-just-per-page.patch
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
index 0fa92f6..6a19e81 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3688,15 +3688,27 @@ static __init int ftrace_init_dyn_debugfs(struct de=
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
@@ -3715,6 +3727,9 @@ static int ftrace_process_locs(struct module *mod,
 	if (!count)
 		return 0;
=20
+	sort(start, count, sizeof(*start),
+	     ftrace_cmp_ips, ftrace_swap_ips);
+
 	pg =3D ftrace_allocate_pages(count);
 	if (!pg)
 		return -ENOMEM;
@@ -3762,11 +3777,6 @@ static int ftrace_process_locs(struct module *mod,
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
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmLTSAAoJEIy3vGnGbaoAs2cQAN5/xNmEf4pzQuyz/+EbLFve
6hD175ksBMdODpGuVS1Y6ccWDSd8B6aIpMVgnLuOzTVRzybOOk4pjysCzqTsExTs
cIziP4xM8nOqpxb+Lx2v79dCV85QgUAcaic8dRoA/QktmieTOxvZq5lTH0ksUgRR
8A+uPKOwjsy4pmphDbso/UH7ip0C7oXPSj4Am3sM9QO+SetZ4Ms4wb7um8kDIrHx
ht9Gm2LUsaP/3USnjFtFL7hGY59p+rXZhdY1MnZJbUWRAUIy7vSdieoS9dMzLh6I
A819eXV1cMSqrYTTqdJ9eDSLOw3Kb/Iwx4wmEoveGDMlLOuqjVIA/PGTHaiylN50
SydgvI48vdmondIcVXChU/fCsVKG3abPEGKvZWfG/ULjOes7OcTWcGda8IRr+Sb1
eqHPjNuWrqGiTKbOPmOyciUijwvN5BxypqqstjHn/z84pPEAzOPfDztdeNj6gi81
iRTa/JIti9sWz3r9cnVA1ulEnsU5bEWaEi8v23c7UgAnpzBksVsh39FbpIhhUzyd
csKSQkL9e58/KSFen9EvQCyVb2uUQVTG1JikQZ4ZNRdG4ThzaDVyT4eYpl6eltez
HWBJMOSar88pmI+rlYrp9NwMO4NliQC4MSD86mvcgNLv4BIX2biwGLPBcdzBuE1T
GB8P8NNPWFRpx3Ae/DP5
=VGyx
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
