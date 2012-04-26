Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2DZCiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:38:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10821 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2DZChL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:37:11 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=m6zUCcfVnScA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=8XEjfe34XjmxG5zXbsgA:9 a=56Q5d-d8OoC3fkeB5q0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=upARtvWGIfCobXerBRAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426023708.168717736@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 22:29:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/6][RFC] ftrace: Return record ip addr for ftrace_location()
References: <20120426022922.683707508@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-Return-record-ip-addr-for-ftrace_location.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

ftrace_location() is passed an addr, and returns 1 if the addr is
on a ftrace nop (or caller to ftrace_caller), and 0 otherwise.

To let kprobes know if it should move a breakpoint or not, it
must return the actual addr that is the start of the ftrace nop.
This way a kprobe placed on the location of a ftrace nop, can
instead be placed on the instruction after the nop. Even if the
probe addr is on the second or later byte of the nop, it can
simply be moved forward.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    2 +-
 kernel/trace/ftrace.c  |   16 ++++++++++------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0b55903..9310993 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -295,7 +295,7 @@ struct dyn_ftrace *ftrace_rec_iter_record(struct ftrace=
_rec_iter *iter);
 int ftrace_update_record(struct dyn_ftrace *rec, int enable);
 int ftrace_test_record(struct dyn_ftrace *rec, int enable);
 void ftrace_run_stop_machine(int command);
-int ftrace_location(unsigned long ip);
+unsigned long ftrace_location(unsigned long ip);
=20
 extern ftrace_func_t ftrace_trace_function;
=20
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 51e07f7..7e3c398 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1393,7 +1393,7 @@ static int ftrace_cmp_recs(const void *a, const void =
*b)
 	return 0;
 }
=20
-static int ftrace_location_range(unsigned long start, unsigned long end)
+static unsigned long ftrace_location_range(unsigned long start, unsigned l=
ong end)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
@@ -1410,7 +1410,7 @@ static int ftrace_location_range(unsigned long start,=
 unsigned long end)
 			      sizeof(struct dyn_ftrace),
 			      ftrace_cmp_recs);
 		if (rec)
-			return 1;
+			return rec->ip;
 	}
=20
 	return 0;
@@ -1420,12 +1420,12 @@ static int ftrace_location_range(unsigned long star=
t, unsigned long end)
  * ftrace_location - return true if the ip giving is a traced location
  * @ip: the instruction pointer to check
  *
- * Returns 1 if @ip given is a pointer to a ftrace location.
+ * Returns rec->ip if @ip given is a pointer to a ftrace location.
  * That is, the instruction that is either a NOP or call to
  * the function tracer. It checks the ftrace internal tables to
  * determine if the address belongs or not.
  */
-int ftrace_location(unsigned long ip)
+unsigned long ftrace_location(unsigned long ip)
 {
 	return ftrace_location_range(ip, ip);
 }
@@ -1442,8 +1442,12 @@ int ftrace_location(unsigned long ip)
  */
 int ftrace_text_reserved(void *start, void *end)
 {
-	return ftrace_location_range((unsigned long)start,
-				     (unsigned long)end);
+	unsigned long ret;
+
+	ret =3D ftrace_location_range((unsigned long)start,
+				    (unsigned long)end);
+
+	return (int)!!ret;
 }
=20
 static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
--=20
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmLTUAAoJEIy3vGnGbaoALhIQAK8skJwNa8jbPxcvsZPiwf4C
5ARSxzTNCDE4M3Q2i3J6T0N0t8rAgAg13qQDeiydj7+1oGToX0J4jBNHgnU0RTbh
MWgOsr8gNVRdnp0n9ko7EerLnB/CRvlCLcx78hNx7pxp63/+7pmticqCtPVLMlGV
AvSSfbdbltDYlcv7AnQhMA1Psfzi8gARwma+l/UmV/ODSnda00oWGW9bH2Yf/WPk
5aP2vqQnLjF+eppnqP1ZNxkN6dH8gbmCwKFE/ismkK+pp/ZLSW9olVWGE+iEl0Ss
FsZFSY6EDZKSrC8H6fceaoVlDeQT3BkpvIZ58kdxuoJ7ar+s1B8ZKkxlRtqK4AZN
zwKyp59L1ALjNVetZpS3JD9mfzVNLwOAq1PdHjdUYSGidrN/0d1Vsm7op0EaHAN5
d+Ea7YfexNqUyLCJ/nTxHyLoE3KhrsiMCF+t0z1bLEvsNKXaqOvSg7hzbhqGLBE6
SxqA+G9gwSnjraqY/ydqbdU/TV6MIhBnYxdqAEEliAZBZvpGXY4g1Dcp1fxc515Q
VR/zWwobQltWxyvf9EMf/jAgFZzlvd4lhkbHtPheRfeO0QQX7gb6TGwYFXHgWTvX
hMPPgIuj25plGivIAdM+oGANcSsxeoSIcnM5COJlP54Mo6rPF4ng2K1CHRu8Xzrl
j+bDxBnGKbfJjvHe2CVR
=pWYR
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
