Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab2BNDkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:40:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab2BNDkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:40:12 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=4YTyipVRR88A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=stkexhm8AAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=B3p0L5jOXJwcO024zckA:9 a=dkwQb9cDP1Ew9sMgWFoA:7 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=hGVi4cUYLJSzEAsVQGcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120214034008.763470231@goodmis.org>
User-Agent: quilt/0.50-1
Date: Mon, 13 Feb 2012 22:39:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/9] printk/tracing: Add console output tracing
References: <20120214033909.904564921@goodmis.org>
Content-Disposition: inline; filename=0008-printk-tracing-Add-console-output-tracing.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Johannes Berg <johannes.berg@intel.com>

Add a printk.console trace point to record any printk
messages into the trace, regardless of the current
console loglevel. This can help correlate (existing)
printk debugging with other tracing.

Link: http://lkml.kernel.org/r/1322161388.5366.54.camel@jlt3.sipsolutions.n=
et

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/printk.h |   41 +++++++++++++++++++++++++++++++++++++=
++++
 kernel/printk.c               |    5 +++++
 2 files changed, 46 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/printk.h

diff --git a/include/trace/events/printk.h b/include/trace/events/printk.h
new file mode 100644
index 0000000..94ec79c
--- /dev/null
+++ b/include/trace/events/printk.h
@@ -0,0 +1,41 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM printk
+
+#if !defined(_TRACE_PRINTK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PRINTK_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT_CONDITION(console,
+	TP_PROTO(const char *log_buf, unsigned start, unsigned end,
+		 unsigned log_buf_len),
+
+	TP_ARGS(log_buf, start, end, log_buf_len),
+
+	TP_CONDITION(start !=3D end),
+
+	TP_STRUCT__entry(
+		__dynamic_array(char, msg, end - start + 1)
+	),
+
+	TP_fast_assign(
+		if ((start & (log_buf_len - 1)) > (end & (log_buf_len - 1))) {
+			memcpy(__get_dynamic_array(msg),
+			       log_buf + (start & (log_buf_len - 1)),
+			       log_buf_len - (start & (log_buf_len - 1)));
+			memcpy((char *)__get_dynamic_array(msg) +
+			       log_buf_len - (start & (log_buf_len - 1)),
+			       log_buf, end & (log_buf_len - 1));
+		} else
+			memcpy(__get_dynamic_array(msg),
+			       log_buf + (start & (log_buf_len - 1)),
+			       end - start);
+		((char *)__get_dynamic_array(msg))[end - start] =3D 0;
+	),
+
+	TP_printk("%s", __get_str(msg))
+);
+#endif /* _TRACE_PRINTK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/printk.c b/kernel/printk.c
index 13c0a11..cb8a6bd 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -44,6 +44,9 @@
=20
 #include <asm/uaccess.h>
=20
+#define CREATE_TRACE_POINTS
+#include <trace/events/printk.h>
+
 /*
  * Architectures can override it:
  */
@@ -542,6 +545,8 @@ MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel sett=
ing, to"
 static void _call_console_drivers(unsigned start,
 				unsigned end, int msg_log_level)
 {
+	trace_console(&LOG_BUF(0), start, end, log_buf_len);
+
 	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
 			console_drivers && start !=3D end) {
 		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPOdeYAAoJEIy3vGnGbaoAAxMP/jANtFCOC5/8Cz8AqD91T850
1eLsb8fVsmJxEj/EOOrPEX/SM7Wc3AsHRkgrkqICjX3dXRY7qxqPZ4wvWvKL4aAs
nFaJqb7vjAtKOqDzcqIrzaYpU4bjDcbDf7SnnYgC5ABQxTMB87e8Hxa0VE/ZOHOV
/XiX8J+5Hmv7kiReYZmDFtA/l/tiJciScLY2eX+3h+/rRN8GTBzQhMWjIvKXVtAq
dPgos/sqZJ3W3M1twibtAzM0RMvKoMhRKJc3NO1o5RSJszALCtUI6uNlvTlBnldh
LjQfAoGue1ccyqc3uqLNsa3poU2/bFjNqaF8fq2vZ57Mb5TKM+fvm6XdQZ676iM5
D3XhKyMzYUtEoTn7fAK7XOsN2xzNA5FWFDG07wKSV5CqrcJar0SNvJsMt+OvrhqX
d3JH9tYDHdcjEZGH3O8BlEqJXK1n7whzEYsv6XT4OaSpn560n67RGsNSGzglGLTR
R2lUI44tSk0NAPaTWlcZ2Py3W9DTnjyZCwBG1ssRdhgW1ekACYttVXPtms2qS8dp
Upl5qvFj8vVxD/0Q36ruo8gCZl+xfL9wp2SP8Tb4r3y8UexTP6Hp7vct0FUtYMIU
Erz/TB6BZpc8GNGMiVZt18DAQdNJHHC7Z/IIPjvSAX+J4aTqB5O5IvF9PnUa3usn
0uFvdbkl95uCZRu0newQ
=hySG
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
