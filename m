Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228Ab2BNDkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:40:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34864 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2BNDkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:40:08 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=S5vDBso3x9EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=cGU8ElX3DAHLmvqY75wA:9 a=-KroAmiC8UV5hKibA-AA:7 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=2uqyl7nPndGxnG6HsHsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120214034005.679102672@goodmis.org>
User-Agent: quilt/0.50-1
Date: Mon, 13 Feb 2012 22:39:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/9] ftrace: Change filter/notrace set functions to return exit code
References: <20120214033909.904564921@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Change-filter-notrace-set-functions-to-return.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Currently the ftrace_set_filter and ftrace_set_notrace functions
do not return any return code. So there's no way for ftrace_ops
user to tell wether the filter was correctly applied.

The set_ftrace_filter interface returns error in case the filter
did not match:

  # echo krava > set_ftrace_filter
  bash: echo: write error: Invalid argument

Changing both ftrace_set_filter and ftrace_set_notrace functions
to return zero if the filter was applied correctly or -E* values
in case of error.

Link: http://lkml.kernel.org/r/1325495060-6402-2-git-send-email-jolsa@redha=
t.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    4 ++--
 kernel/trace/ftrace.c  |   15 +++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 028e26f..f33fb3b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -178,9 +178,9 @@ struct dyn_ftrace {
 };
=20
 int ftrace_force_update(void);
-void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset);
-void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset);
 void ftrace_set_global_filter(unsigned char *buf, int len, int reset);
 void ftrace_set_global_notrace(unsigned char *buf, int len, int reset);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 683d559..e2e0597 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3146,8 +3146,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned ch=
ar *buf, int len,
 	mutex_lock(&ftrace_regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
-	if (buf)
-		ftrace_match_records(hash, buf, len);
+	if (buf && !ftrace_match_records(hash, buf, len)) {
+		ret =3D -EINVAL;
+		goto out_regex_unlock;
+	}
=20
 	mutex_lock(&ftrace_lock);
 	ret =3D ftrace_hash_move(ops, enable, orig_hash, hash);
@@ -3157,6 +3159,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned cha=
r *buf, int len,
=20
 	mutex_unlock(&ftrace_lock);
=20
+ out_regex_unlock:
 	mutex_unlock(&ftrace_regex_lock);
=20
 	free_ftrace_hash(hash);
@@ -3173,10 +3176,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned c=
har *buf, int len,
  * Filters denote which functions should be enabled when tracing is enable=
d.
  * If @buf is NULL and reset is set, all functions will be enabled for tra=
cing.
  */
-void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset)
 {
-	ftrace_set_regex(ops, buf, len, reset, 1);
+	return ftrace_set_regex(ops, buf, len, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter);
=20
@@ -3191,10 +3194,10 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter);
  * is enabled. If @buf is NULL and reset is set, all functions will be ena=
bled
  * for tracing.
  */
-void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset)
 {
-	ftrace_set_regex(ops, buf, len, reset, 0);
+	return ftrace_set_regex(ops, buf, len, reset, 0);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_notrace);
 /**
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPOdeVAAoJEIy3vGnGbaoAR80QAJp5VjrDvK6gO6R/R9T2LRao
mzHJWqwrqqtIvBcX/djL2O/fxBv5O7L/1rwe3QiET9Vr0Gyhjtge5nDlGYoR1Hjh
gWhiZsuEzG2AbZ5kKp4vn7KLxya6gg96ryQ4GbnS9SlX62k3zGoySL06oZl0HQdb
m5+F9QXnd9SRVxHg9ifFika1pDZDmty3bBE5e9YKfd1UVwhF6cGpp6zayxNini2T
jODACMqx+jUKFd67mCX5VqYWsDKlEUE2iw3fWx1m9c1qbOsbD+zNPCfjY4eqZ4lD
SZfYWqblW+Owq4SqgLKgzPdzteMZPZac7LcP7KKJC7lF2LtaAbgLR6bsl0NHDOh7
7dzq7lxAY3J/oqjQSbl38SvrS8CVJvsb3UHVvzuDCifNTXfUeVxkgS9AUPiwDEuK
bs2IrcNF8u0Eb/B9jnvN9JdD8snNbo4y8Q04jXdLRZM4MYzDIC3d9mb9CqSODEmA
FAjlyCKY+6aN4QNRAH3x2OVwW1Yt2OmQ6+qVT6/bu1ABEyv7o9q0AQz4xR8COdxC
4aFvQfRQC1IFOvMFBRLaJpWXW8+RwyqqsiaVFmo5BkI6reH8MQvsUTmRdRSjKYKA
NdWoR+tUgHhabGykmABYOHNciFc8d/ZwEfXZ8/gVmiGJuA73gcqCAVvNkMSB/DGZ
fmPXfmGhug8rh+CLAe1J
=d830
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
