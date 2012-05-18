Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741Ab2ERNN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:13:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2ERNKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:52 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=BjZeK3_sesgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=8XEjfe34XjmxG5zXbsgA:9 a=56Q5d-d8OoC3fkeB5q0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=FvoYW7iHMZULq8KeIAcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131051.251652937@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 12/15] ftrace: Return record ip addr for ftrace_location()
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0012-ftrace-Return-record-ip-addr-for-ftrace_location.patch
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
index d32cc5e..609948e 100644
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
index dd091c8..ef08262 100644
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
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpbAAoJEIy3vGnGbaoAobcP/R4uTnYmomAtWDlfvK4MZfGv
dbBGmBAeGGbi86rJXpS8GFdoO2FT34iZfK1tMob5YZJc6JzH0K+J3s0k3LiiHXdV
PTnVWiNvQYJLVlEjarmG7ILIJIGbTC6qc/GUjHeavXgVYlsANUuyCGp3NpKODLNl
WZcqY5cT/blQsAyfq4i0W/hvjch1OLelVpuxgY0HgIKZMeHPDx+ho8qK6fuMYJsx
wvbbjTjYHIQzhMr9oHJiJ0b5DP8KVVZGSL75SLb4WBKcHUAk9xGmnCk9ZRjluVTB
qfGBEaXMNZqcOfmfPK6xdWNFTP1SeDKp8vdp6YWwLY+v/aMtZbfyXROwJyP5Od+i
L+nbh/lKoOYzyJ/Ge/T926DXaT3ZSFcsbipcUWENbScaHqKsNMQqkBZTvqI8gVBK
CJCulciY2a7OsePL2erUB+toIaXn1t7Z613gpeWD24bH4/5+V80K4FSwZRNuerb0
xKfs1KU2gJIlQGjXDfuqfMpL9ao7rf+BXrt/WzhXibraVkc8L+fUNmAtjrVSP2Fx
7zEAuaP+x2aB0VCTewrswoseByvN14KAzKxLvFi+6/c4j9CyFuBSfLb14R3OWfiU
C+OSrN/3mP1vHBe/90+f5CH2RXNoPBE+r1Vnw/yWjviJK5Eo0voSNIsHnG6HAn9t
o1d8ze/GOpvMmtNjhxoJ
=2ruf
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
