Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946058Ab2ERNLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:11:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737Ab2ERNK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:56 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=fFU6h83J9SwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=reo06KVvno3Mf215nIEA:9 a=Di4IDHX3orKPkm3snHAA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=5Im4EN9ASZK137pADnAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131051.570714924@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 13/15] ftrace: Make ftrace_modify_all_code() global for archs to use
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0013-ftrace-Make-ftrace_modify_all_code-global-for-archs-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Rename __ftrace_modify_code() to ftrace_modify_all_code() and make
it global for all archs to use. This will remove the duplication
of code, as archs that can modify code without stop_machine()
can use it directly outside of the stop_machine() call.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    2 ++
 kernel/trace/ftrace.c  |   21 +++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 609948e..cd72ace 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -319,6 +319,8 @@ extern void ftrace_caller(void);
 extern void ftrace_call(void);
 extern void mcount_call(void);
=20
+void ftrace_modify_all_code(int command);
+
 #ifndef FTRACE_ADDR
 #define FTRACE_ADDR ((unsigned long)ftrace_caller)
 #endif
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ef08262..3c34582 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1811,22 +1811,27 @@ int __weak ftrace_arch_code_modify_post_process(voi=
d)
 	return 0;
 }
=20
-static int __ftrace_modify_code(void *data)
+void ftrace_modify_all_code(int command)
 {
-	int *command =3D data;
-
-	if (*command & FTRACE_UPDATE_CALLS)
+	if (command & FTRACE_UPDATE_CALLS)
 		ftrace_replace_code(1);
-	else if (*command & FTRACE_DISABLE_CALLS)
+	else if (command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);
=20
-	if (*command & FTRACE_UPDATE_TRACE_FUNC)
+	if (command & FTRACE_UPDATE_TRACE_FUNC)
 		ftrace_update_ftrace_func(ftrace_trace_function);
=20
-	if (*command & FTRACE_START_FUNC_RET)
+	if (command & FTRACE_START_FUNC_RET)
 		ftrace_enable_ftrace_graph_caller();
-	else if (*command & FTRACE_STOP_FUNC_RET)
+	else if (command & FTRACE_STOP_FUNC_RET)
 		ftrace_disable_ftrace_graph_caller();
+}
+
+static int __ftrace_modify_code(void *data)
+{
+	int *command =3D data;
+
+	ftrace_modify_all_code(*command);
=20
 	return 0;
 }
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpbAAoJEIy3vGnGbaoAcR4P/iKFlGdBE39lSDI9tBLwsVEF
Sw9YhnRRs7qER0mDuoisnX5V3MxcUYMXcYgvLJ2c2xJGaXlCBQ3nvDLNqbUYSSEq
u41r/45Hl3RrPHmdHR0zaDvOf6rlCeCK8CMHZJAXIDmljsSZlqHjl+D4z+13IXb3
SnElaO319BkAungi2KufN9R25N0bVLCWj2jXCUF05z5CR/moPKtON8yPiSBrBncZ
ZYtCLkRXSaSHX5zJAmmsOISxv/Yc8yL7Y2wRCiLwFwS3+T1+x1TQ4xcJlbB3cUQg
IsPbF2sGaxRpzRQ/bZC99IODgHsZMP3VEmjAuURny0/waioQ3DDsKgECuMBUBQz2
b1PiPBmyiDhm40bZq64R2RHht1i6t8x49sUoXhsAqyfe16iucG5Ze3muf1amMnpN
Y60DuJRS6YHS3sL47/LlwKfBqgTYUxw4VfItnvcvMvHLgZNSaFeCxRJQZNR0oFxw
qCIHO3DQ10ohVIy66N4oIXZVE5LJPygw+RIEX+4It/X0RGtYXXmot0diD+Cy5aYM
hDYGgtKuBdkFPvMLrsCc3He2kqIEco8F0BW65/XcIjvTrNaCB4vauhc6ek1RKIHg
ArwvaBXTdzOj0i/ngSok3fijlqNs+gqIMkAAtSQ8hDAwHw83JAubI2r8tWTC2XfO
Fb6j/aiG01Su8ChwKOeM
=dS6v
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
