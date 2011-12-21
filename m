Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab1LUMiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:38:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1LUMiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:07 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=MnYK5gt4TwkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5WSkYo6Eoo2OwDka7ncA:9 a=6n7fa0yeXSLr2W_RtMwA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=sQIOF5EQxsKyQ06s2OMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123805.619027837@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/16] ftrace: Replace record newlist with record page list
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Replace-record-newlist-with-record-page-list.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

As new functions come in to be initalized from mcount to nop,
they are done by groups of pages. Whether it is the core kernel
or a module. There's no need to keep track of these on a per record
basis.

At startup, and as any module is loaded, the functions to be
traced are stored in a group of pages and added to the function
list at the end. We just need to keep a pointer to the first
page of the list that was added, and use that to know where to
start on the list for initializing functions.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    5 +---
 kernel/trace/ftrace.c  |   68 ++++++++++++++++++++++++++------------------=
----
 2 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 3f79bc4..31b9fd7 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -173,10 +173,7 @@ struct dyn_ftrace {
 		unsigned long		ip; /* address of mcount call-site */
 		struct dyn_ftrace	*freelist;
 	};
-	union {
-		unsigned long		flags;
-		struct dyn_ftrace	*newlist;
-	};
+	unsigned long		flags;
 	struct dyn_arch_ftrace		arch;
 };
=20
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2e72188..366d788 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -977,8 +977,6 @@ static struct ftrace_ops global_ops =3D {
 	.filter_hash		=3D EMPTY_HASH,
 };
=20
-static struct dyn_ftrace *ftrace_new_addrs;
-
 static DEFINE_MUTEX(ftrace_regex_lock);
=20
 struct ftrace_page {
@@ -988,6 +986,8 @@ struct ftrace_page {
 	int			size;
 };
=20
+static struct ftrace_page *ftrace_new_pgs;
+
 #define ENTRY_SIZE sizeof(struct dyn_ftrace)
 #define ENTRIES_PER_PAGE (PAGE_SIZE / ENTRY_SIZE)
=20
@@ -1445,8 +1445,6 @@ ftrace_record_ip(unsigned long ip)
 		return NULL;
=20
 	rec->ip =3D ip;
-	rec->newlist =3D ftrace_new_addrs;
-	ftrace_new_addrs =3D rec;
=20
 	return rec;
 }
@@ -1936,9 +1934,11 @@ static int ops_traces_mod(struct ftrace_ops *ops)
=20
 static int ftrace_update_code(struct module *mod)
 {
+	struct ftrace_page *pg;
 	struct dyn_ftrace *p;
 	cycle_t start, stop;
 	unsigned long ref =3D 0;
+	int i;
=20
 	/*
 	 * When adding a module, we need to check if tracers are
@@ -1960,41 +1960,44 @@ static int ftrace_update_code(struct module *mod)
 	start =3D ftrace_now(raw_smp_processor_id());
 	ftrace_update_cnt =3D 0;
=20
-	while (ftrace_new_addrs) {
+	for (pg =3D ftrace_new_pgs; pg; pg =3D pg->next) {
=20
-		/* If something went wrong, bail without enabling anything */
-		if (unlikely(ftrace_disabled))
-			return -1;
+		for (i =3D 0; i < pg->index; i++) {
+			/* If something went wrong, bail without enabling anything */
+			if (unlikely(ftrace_disabled))
+				return -1;
=20
-		p =3D ftrace_new_addrs;
-		ftrace_new_addrs =3D p->newlist;
-		p->flags =3D ref;
+			p =3D &pg->records[i];
+			p->flags =3D ref;
=20
-		/*
-		 * Do the initial record conversion from mcount jump
-		 * to the NOP instructions.
-		 */
-		if (!ftrace_code_disable(mod, p))
-			break;
+			/*
+			 * Do the initial record conversion from mcount jump
+			 * to the NOP instructions.
+			 */
+			if (!ftrace_code_disable(mod, p))
+				break;
=20
-		ftrace_update_cnt++;
+			ftrace_update_cnt++;
=20
-		/*
-		 * If the tracing is enabled, go ahead and enable the record.
-		 *
-		 * The reason not to enable the record immediatelly is the
-		 * inherent check of ftrace_make_nop/ftrace_make_call for
-		 * correct previous instructions.  Making first the NOP
-		 * conversion puts the module to the correct state, thus
-		 * passing the ftrace_make_call check.
-		 */
-		if (ftrace_start_up && ref) {
-			int failed =3D __ftrace_replace_code(p, 1);
-			if (failed)
-				ftrace_bug(failed, p->ip);
+			/*
+			 * If the tracing is enabled, go ahead and enable the record.
+			 *
+			 * The reason not to enable the record immediatelly is the
+			 * inherent check of ftrace_make_nop/ftrace_make_call for
+			 * correct previous instructions.  Making first the NOP
+			 * conversion puts the module to the correct state, thus
+			 * passing the ftrace_make_call check.
+			 */
+			if (ftrace_start_up && ref) {
+				int failed =3D __ftrace_replace_code(p, 1);
+				if (failed)
+					ftrace_bug(failed, p->ip);
+			}
 		}
 	}
=20
+	ftrace_new_pgs =3D NULL;
+
 	stop =3D ftrace_now(raw_smp_processor_id());
 	ftrace_update_time =3D stop - start;
 	ftrace_update_tot_cnt +=3D ftrace_update_cnt;
@@ -3632,6 +3635,9 @@ static int ftrace_process_locs(struct module *mod,
 			break;
 	}
=20
+	/* These new locations need to be initialized */
+	ftrace_new_pgs =3D pg;
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

iQIcBAABAgAGBQJO8dMtAAoJEIy3vGnGbaoASyAQALE5O3S5BNXIFmKuh4VFUyyN
x7cbZ0iXAH5EoqvszbXnfJsWD4c8bm2o+8YTTMBwtkQ4zJOxUWsjd1VPf/vK1SAG
e+RULizigribWgACcUzZgKW4iF2DSpINPuHkUxj1+K4TGsVjSy9VkElFrJKC3Y94
TWoQolCWUajr3jtqL6Rl3SwH4hhudvnioETBI9Ij1m8hwvl34HQJSr+sQoA4Mhda
47gaoFA9OQbpsPBc+dJUHxLHfw7wOUrs1GekVINYlsKGPMMS9HvyD/9FkC90gj6l
iG5rwxThl/Mb8RyENATFrxYhdK3YqoqvB53BaCfqJDLocnWPQbbMMCPMksP41EF9
4JConFgPVsp4xbEhrAJnCBPSI8NIZZnozr/X3toWGNKcHlyJv5+cXuyPSC+pXtsn
1TfS87cT4MExT32/opF+Ktx6WauZk5E6fCGeJcRi9u9vJbrvX6znLizrW0ntBkPR
Jl9w0qkoJUWDToo5v9a28CxilGpkPB5yDJuVcl3E/DNKkQr8SlrDM7hNy5uBH2QC
oFHzfqQWuNUgy366SlWsMGlBUnz1taRmp3sF0kUFxwIlp7jNBjWp5A4Nsn1MpVG/
RBTE67qTBsQRmPKK0kurh1eoc4GnM+2pJbu2X7ua5yrCVGriFNNVp4e6ASG2EjSV
OwAm2jjZe0Z9yCtqX/HR
=ueHh
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
