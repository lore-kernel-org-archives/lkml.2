Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1LUMj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:39:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab1LUMiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:13 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=lZ6pygRrkf4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=z9H4p5xy35ATwI9cdJwA:9 a=dNNZwsspBHPju-ClEOUA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=TM6FzR30IeO6I8DjnMwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123809.618715034@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 12/16] ftrace: Decouple hash items from showing filtered functions
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0012-ftrace-Decouple-hash-items-from-showing-filtered-fun.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The set_ftrace_filter shows "hashed" functions, which are functions
that are added with operations to them (like traceon and traceoff).

As other subsystems may be able to show what functions they are
using for function tracing, the hash items should no longer
be shown just because the FILTER flag is set. As they have nothing
to do with other subsystems filters.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    5 +++--
 kernel/trace/ftrace.c  |   16 ++++++++--------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index aa7559f..d1ff0de 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -206,8 +206,9 @@ enum {
 	FTRACE_ITER_FILTER	=3D (1 << 0),
 	FTRACE_ITER_NOTRACE	=3D (1 << 1),
 	FTRACE_ITER_PRINTALL	=3D (1 << 2),
-	FTRACE_ITER_HASH	=3D (1 << 3),
-	FTRACE_ITER_ENABLED	=3D (1 << 4),
+	FTRACE_ITER_DO_HASH	=3D (1 << 3),
+	FTRACE_ITER_HASH	=3D (1 << 4),
+	FTRACE_ITER_ENABLED	=3D (1 << 5),
 };
=20
 void arch_ftrace_update_code(int command);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b105c5..5728d9a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2198,6 +2198,9 @@ static void *t_hash_start(struct seq_file *m, loff_t =
*pos)
 	void *p =3D NULL;
 	loff_t l;
=20
+	if (!(iter->flags & FTRACE_ITER_DO_HASH))
+		return NULL;
+
 	if (iter->func_pos > *pos)
 		return NULL;
=20
@@ -2343,12 +2346,8 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 			break;
 	}
=20
-	if (!p) {
-		if (iter->flags & FTRACE_ITER_FILTER)
-			return t_hash_start(m, pos);
-
-		return NULL;
-	}
+	if (!p)
+		return t_hash_start(m, pos);
=20
 	return iter;
 }
@@ -2541,8 +2540,9 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 static int
 ftrace_filter_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(&global_ops, FTRACE_ITER_FILTER,
-				 inode, file);
+	return ftrace_regex_open(&global_ops,
+			FTRACE_ITER_FILTER | FTRACE_ITER_DO_HASH,
+			inode, file);
 }
=20
 static int
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMxAAoJEIy3vGnGbaoAQfAP/0HdbmPtg4rczSsYG7tlEs/z
SecbSMlb/3iGVeo3oy6JtoBf3wszflON1nbMoj5YXzcBM2cSv1Efgi2qqLRc/7UI
y0f3Y7ijx78QYRbbUo2AypsblWPPjgDpQbZuCjcY8yds56OoKBfk/7sgrGVVSt2E
QUXEhVQzlTIOJFz6j/pI/fsbcpydScBtYUvX+2dgjeNcpVTSpdwIc46qm6JOuljs
hhjL/qBsMqXSZxL+xPG7H3m9e4RzpBvnqZ4SGKbJ1d8TB0zISV2FEhYShLMXfx8K
0Dgb+l1RL1DSpRNcAwpNpwT3m5+VHgCrMu0gDVAOR3JnuDOvoFDgXaKUk8KYIJRX
XiPBKejlx5ljjITuPzjeJGtDMp5RUN39NLj6O2MM6B7bchSROuojRmnXK8LlEYBN
8+TW9wEp/YlUDHJhvQY6lyQVSWZkN57j/7ZJhuiidoPXVuxrhGhg7oYPxdU4oX1o
KnVSbq4QBe5I7EWJYuhUg8HwaeYWj2nbNGxKEu3eG7PuaVdXpWuh/lYzhNPLzQ+l
QCHbbVYyATa+zDF/9lsFUOEroXM68x2htnLZmK8ZuJ5FFcE1wc06NNLMf+ZhW0wP
rudSzpXgh5PzQRh9KlHiCakx2fBBPfIRRPhsMu+vkeiGO9NQ6L6BD4lkTINtBoSz
5/N4ucRKje9+epJfCXeE
=v1Fp
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
