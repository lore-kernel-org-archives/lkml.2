Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1LUMiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:38:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34360 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab1LUMiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:06 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=ZHxOl6q1S3YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=TyPDiFI9Ut_iP82c7iIA:9 a=3R9n-rATtjZmO4TJBm0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Vt5-kZCQfFtjhqDTQi4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123804.314842461@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/16] ftrace: Remove usage of "freed" records
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Remove-usage-of-freed-records.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Records that are added to the function trace table are
permanently there, except for modules. By separating out the
modules to their own pages that can be freed in one shot
we can remove the "freed" flag and simplify some of the record
management.

Another benefit of doing this is that we can also move the
records around; sort them.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    1 -
 kernel/trace/ftrace.c  |  100 +++++++++++++++++++++++---------------------=
---
 2 files changed, 49 insertions(+), 52 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 4f0b6fe..3f79bc4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -163,7 +163,6 @@ extern int ftrace_text_reserved(void *start, void *end);
=20
 enum {
 	FTRACE_FL_ENABLED	=3D (1 << 30),
-	FTRACE_FL_FREE		=3D (1 << 31),
 };
=20
 #define FTRACE_FL_MASK		(0x3UL << 30)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 655b432..be6888f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -996,8 +996,6 @@ struct ftrace_page {
 static struct ftrace_page	*ftrace_pages_start;
 static struct ftrace_page	*ftrace_pages;
=20
-static struct dyn_ftrace *ftrace_free_records;
-
 static struct ftrace_func_entry *
 ftrace_lookup_ip(struct ftrace_hash *hash, unsigned long ip)
 {
@@ -1421,32 +1419,8 @@ static void ftrace_hash_rec_enable(struct ftrace_ops=
 *ops,
 	__ftrace_hash_rec_update(ops, filter_hash, 1);
 }
=20
-static void ftrace_free_rec(struct dyn_ftrace *rec)
-{
-	rec->freelist =3D ftrace_free_records;
-	ftrace_free_records =3D rec;
-	rec->flags |=3D FTRACE_FL_FREE;
-}
-
 static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
 {
-	struct dyn_ftrace *rec;
-
-	/* First check for freed records */
-	if (ftrace_free_records) {
-		rec =3D ftrace_free_records;
-
-		if (unlikely(!(rec->flags & FTRACE_FL_FREE))) {
-			FTRACE_WARN_ON_ONCE(1);
-			ftrace_free_records =3D NULL;
-			return NULL;
-		}
-
-		ftrace_free_records =3D rec->freelist;
-		memset(rec, 0, sizeof(*rec));
-		return rec;
-	}
-
 	if (ftrace_pages->index =3D=3D ENTRIES_PER_PAGE) {
 		if (!ftrace_pages->next) {
 			/* allocate another page */
@@ -1639,10 +1613,6 @@ static void ftrace_replace_code(int update)
 		return;
=20
 	do_for_each_ftrace_rec(pg, rec) {
-		/* Skip over free records */
-		if (rec->flags & FTRACE_FL_FREE)
-			continue;
-
 		failed =3D __ftrace_replace_code(rec, update);
 		if (failed) {
 			ftrace_bug(failed, rec->ip);
@@ -2007,11 +1977,8 @@ static int ftrace_update_code(struct module *mod)
 		 * Do the initial record conversion from mcount jump
 		 * to the NOP instructions.
 		 */
-		if (!ftrace_code_disable(mod, p)) {
-			ftrace_free_rec(p);
-			/* Game over */
+		if (!ftrace_code_disable(mod, p))
 			break;
-		}
=20
 		ftrace_update_cnt++;
=20
@@ -2026,10 +1993,8 @@ static int ftrace_update_code(struct module *mod)
 		 */
 		if (ftrace_start_up && ref) {
 			int failed =3D __ftrace_replace_code(p, 1);
-			if (failed) {
+			if (failed)
 				ftrace_bug(failed, p->ip);
-				ftrace_free_rec(p);
-			}
 		}
 	}
=20
@@ -2223,9 +2188,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		}
 	} else {
 		rec =3D &iter->pg->records[iter->idx++];
-		if ((rec->flags & FTRACE_FL_FREE) ||
-
-		    ((iter->flags & FTRACE_ITER_FILTER) &&
+		if (((iter->flags & FTRACE_ITER_FILTER) &&
 		     !(ftrace_lookup_ip(ops->filter_hash, rec->ip))) ||
=20
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
@@ -2602,7 +2565,6 @@ match_records(struct ftrace_hash *hash, char *buff,
 		goto out_unlock;
=20
 	do_for_each_ftrace_rec(pg, rec) {
-
 		if (ftrace_match_record(rec, mod, search, search_len, type)) {
 			ret =3D enter_record(hash, rec, not);
 			if (ret < 0) {
@@ -3446,9 +3408,6 @@ ftrace_set_func(unsigned long *array, int *idx, char =
*buffer)
=20
 	do_for_each_ftrace_rec(pg, rec) {
=20
-		if (rec->flags & FTRACE_FL_FREE)
-			continue;
-
 		if (ftrace_match_record(rec, NULL, search, search_len, type)) {
 			/* if it is in the array */
 			exists =3D false;
@@ -3566,6 +3525,27 @@ static int ftrace_process_locs(struct module *mod,
 	unsigned long flags =3D 0; /* Shut up gcc */
=20
 	mutex_lock(&ftrace_lock);
+	/*
+	 * Core and each module needs their own pages, as
+	 * modules will free them when they are removed.
+	 * Force a new page to be allocated for modules.
+	 */
+	if (mod) {
+		if (!ftrace_pages)
+			return -ENOMEM;
+
+		/*
+		 * If the last page was full, it will be
+		 * allocated anyway.
+		 */
+		if (ftrace_pages->index !=3D ENTRIES_PER_PAGE) {
+			ftrace_pages->next =3D (void *)get_zeroed_page(GFP_KERNEL);
+			if (!ftrace_pages->next)
+				return -ENOMEM;
+			ftrace_pages =3D ftrace_pages->next;
+		}
+	}
+
 	p =3D start;
 	while (p < end) {
 		addr =3D ftrace_call_adjust(*p++);
@@ -3599,9 +3579,13 @@ static int ftrace_process_locs(struct module *mod,
 }
=20
 #ifdef CONFIG_MODULES
+
+#define next_to_ftrace_page(p) container_of(p, struct ftrace_page, next)
+
 void ftrace_release_mod(struct module *mod)
 {
 	struct dyn_ftrace *rec;
+	struct ftrace_page **last_pg;
 	struct ftrace_page *pg;
=20
 	mutex_lock(&ftrace_lock);
@@ -3609,16 +3593,30 @@ void ftrace_release_mod(struct module *mod)
 	if (ftrace_disabled)
 		goto out_unlock;
=20
-	do_for_each_ftrace_rec(pg, rec) {
+	/*
+	 * Each module has its own ftrace_pages, remove
+	 * them from the list.
+	 */
+	last_pg =3D &ftrace_pages_start;
+	for (pg =3D ftrace_pages_start; pg; pg =3D *last_pg) {
+		rec =3D &pg->records[0];
 		if (within_module_core(rec->ip, mod)) {
 			/*
-			 * rec->ip is changed in ftrace_free_rec()
-			 * It should not between s and e if record was freed.
+			 * As core pages are first, the first
+			 * page should never be a module page.
 			 */
-			FTRACE_WARN_ON(rec->flags & FTRACE_FL_FREE);
-			ftrace_free_rec(rec);
-		}
-	} while_for_each_ftrace_rec();
+			if (WARN_ON(pg =3D=3D ftrace_pages_start))
+				goto out_unlock;
+
+			/* Check if we are deleting the last page */
+			if (pg =3D=3D ftrace_pages)
+				ftrace_pages =3D next_to_ftrace_page(last_pg);
+
+			*last_pg =3D pg->next;
+			free_page((unsigned long)pg);
+		} else
+			last_pg =3D &pg->next;
+	}
  out_unlock:
 	mutex_unlock(&ftrace_lock);
 }
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMsAAoJEIy3vGnGbaoAwYEQAM/xLf1lDVor+IL4UmXVBTGM
wT2kagSHb+CKI67F+kAtD/eRtbseudmC8WjxSzQXSEhQcvq8S1a1KTCtpive3b0e
OGP3jFR7Lj6uFHbVYsAwFMWGqXn0Jzijd4K0OlqhpllyFKPUzf04So0o+XMvn1ui
seyaMYEpFg1U7Yt5ZlAV7mmS45hPAAXZsSXzvaHz3xiWGcv0m5a5FOD8A9HS8NNu
ekvHJSqNHv9f93GIb8L6bV5PEjSnL8x8GdDsCVNhzVZ5e3QKmeyqUpNDbLR1yXtH
kvyzLl9LYpFO+YPPy24/oZnQpp7ZhFZW/U56OXEsImOvMzzojW6udtkxShH7ivmN
tJ8hmKksjXtGDV5pzZSV/vanN24FP4IhXYJIRH/faQ7NzAAgafMxAX53Ndeny6EQ
trdjGWc3ozx8mrbG1u9ISVcAI6qAyD3trAKNaJohS0SRX7IsPj+wjPIXtVZaKdGH
yAN3Mw1IyjUcjFyfweJAMYw3Qh3FE1LcSl4Rswexs4tIxxtylw4NAj1A4mAQVxi4
hs8wOY6apKy0k7L/4WlJlEHRJqnalLe3fUUQas5j2NDICEPEIqZvB/DOrnuiOWuZ
0igPzu8E1PyB4dx99cn/PZqySj5AYE27yaPf58f8tcnfs+JnHO+k7tHfZ18KUmoP
tG6Dun/i6ZMRg7nRiDEZ
=zT3R
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
