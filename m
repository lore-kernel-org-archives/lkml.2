Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1LUMiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:38:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1LUMiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:15 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=1Uloil5VDxoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=fSKjzi4JXkHAgi3j2_0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=_W1ly9K-Lw48Be9KigsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123811.457975427@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 15/16] tracing: Have stack tracing set filtered functions at boot
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0015-tracing-Have-stack-tracing-set-filtered-functions-at.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add stacktrace_filter=3D to the kernel command line that lets
the user pick specific functions to check the stack on.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/kernel-parameters.txt |    8 ++++++++
 kernel/trace/trace_stack.c          |   11 +++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-par=
ameters.txt
index fd5c913..fde2ae0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2435,6 +2435,14 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
 	stacktrace	[FTRACE]
 			Enabled the stack tracer on boot up.
=20
+	stacktrace_filter=3D[function-list]
+			[FTRACE] Limit the functions that the stack tracer
+			will trace at boot up. function-list is a comma separated
+			list of functions. This list can be changed at run
+			time by the stack_trace_filter file in the debugfs
+			tracing directory. Note, this enables stack tracing
+			and the stacktrace above is not needed.
+
 	sti=3D		[PARISC,HW]
 			Format: <num>
 			Set the STI (builtin display/keyboard on the HP-PARISC
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 0398b7c..d4545f4 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -13,6 +13,9 @@
 #include <linux/sysctl.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+
+#include <asm/setup.h>
+
 #include "trace.h"
=20
 #define STACK_TRACE_ENTRIES 500
@@ -352,8 +355,13 @@ stack_trace_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
=20
+static char stack_trace_filter_buf[COMMAND_LINE_SIZE+1] __initdata;
+
 static __init int enable_stacktrace(char *str)
 {
+	if (strncmp(str, "_filter=3D", 8) =3D=3D 0)
+		strncpy(stack_trace_filter_buf, str+8, COMMAND_LINE_SIZE);
+
 	stack_tracer_enabled =3D 1;
 	last_stack_tracer_enabled =3D 1;
 	return 1;
@@ -375,6 +383,9 @@ static __init int stack_trace_init(void)
 	trace_create_file("stack_trace_filter", 0444, d_tracer,
 			NULL, &stack_trace_filter_fops);
=20
+	if (stack_trace_filter_buf[0])
+		ftrace_set_early_filter(&trace_ops, stack_trace_filter_buf, 1);
+
 	if (stack_tracer_enabled)
 		register_ftrace_function(&trace_ops);
=20
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMzAAoJEIy3vGnGbaoAYGwQAMJ0PR4xsUOBLGVUXacQJDvq
/nSqaXP9RrV3jpv6A5eBT8AIuw0jY13dt3EBJsBtX8BUBasPgNXbasZyBlP8i0nM
+zVvUm9Vl8nvl/pgL66EibYyPzASPgNjYclSwL3IUdXSMgluH6tZbYC2NKuNI1mH
iJRUIgar+Gwk01+RnCXIU6VhFh2RQgfCSIHgKKeOKPHawfi2e5tLuHlfFWYlK7Vr
/KjsRlKdrCNTm6qSHQu62BbRIfZhezGFnEIhFcTQA1Np9pRczXwuURDLm8Ut0gIL
owbNfD6IFcNk7hsTIYPleNv6sBI2Qbxn19zoxmpRaHoEiTIpcEV4v/aHrPELqx5X
dKij/E1UWZBHdeA5fqg8he0ydQtSlty3s66vWoRPAC5R/rTWA1aGmUXmkwcIxuGN
cItz1jq1ys7vfscjxySL9SQ/kkfs6BXOoFKH8x7Oj/yZmImZ4+65RnBb0InCLFRM
/UIWObJ79BraLz+KwXlXCbyxa4ZKqD3FbkQBv2/mPdQH1wVfNQpuDonA42us2URv
HlbKX54x29jaBTifO/fAcyOyU5HPdh38ap9AcMylCfPT7IGWOSMnAJ2QvIr50tDq
GSL+3Kuho1bydnzuhYb8MUFAsp4BjpG1WXv4+a7EXtM8nAcfK/J8o/4u3uhatdkw
enc1MDR9FwtwCEWaXnKb
=7YTD
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
