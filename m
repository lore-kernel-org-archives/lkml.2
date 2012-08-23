Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab2HWSSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:18:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2HWSRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:17:01 -0400
X-Authority-Analysis: v=2.0 cv=A87uztqG c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=UCMUalGl3i8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=wMe5GXdBbtQA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=WfulkdPnAAAA:8 a=PbXrVSnWgJJwXRCFfZkA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=l29vjEC0CZ8A:10 a=CfryDDMzqY5Dg-3vOOsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120823181659.369170242@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 23 Aug 2012 14:15:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/4] ftrace: Add -mfentry to Makefile on function tracer
References: <20120823181537.510961094@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Add-mfentry-to-Makefile-on-function-tracer.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks to Andi Kleen, gcc 4.6.0 now supports -mfentry for x86
(and hopefully soon for other archs). What this does is to have
the function profiler start at the beginning of the function
instead of after the stack is set up. As plain -pg (mcount) is
called after the stack is set up, and in some cases can have issues
with the function graph tracer. It also requires frame pointers to
be enabled.

The -mfentry now calls __fentry__ at the beginning of the function.
This allows for compiling without frame pointers and even has the
ability to access parameters if needed.

If the architecture and the compiler both support -mfentry then
use that instead.

Link: http://lkml.kernel.org/r/20120807194059.392617243@goodmis.org

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Makefile             |    6 +++++-
 kernel/trace/Kconfig |    5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index ddf5be9..e7ca93f 100644
--- a/Makefile
+++ b/Makefile
@@ -609,7 +609,11 @@ KBUILD_CFLAGS 	+=3D $(call cc-option, -femit-struct-de=
bug-baseonly)
 endif
=20
 ifdef CONFIG_FUNCTION_TRACER
-KBUILD_CFLAGS	+=3D -pg
+ifdef CONFIG_HAVE_FENTRY
+CC_USING_FENTRY	:=3D $(call cc-option, -mfentry -DCC_USING_FENTRY)
+endif
+KBUILD_CFLAGS	+=3D -pg $(CC_USING_FENTRY)
+KBUILD_AFLAGS	+=3D $(CC_USING_FENTRY)
 ifdef CONFIG_DYNAMIC_FTRACE
 	ifdef CONFIG_HAVE_C_RECORDMCOUNT
 		BUILD_C_RECORDMCOUNT :=3D y
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8c4c070..9301a0e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -49,6 +49,11 @@ config HAVE_SYSCALL_TRACEPOINTS
 	help
 	  See Documentation/trace/ftrace-design.txt
=20
+config HAVE_FENTRY
+	bool
+	help
+	  Arch supports the gcc options -pg with -mfentry
+
 config HAVE_C_RECORDMCOUNT
 	bool
 	help
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQNnObAAoJEIy3vGnGbaoA3/8P/2D6c3zsxxNUSvEl4jCLR1Ex
EgUFQbK4rcVzbJDPQItXrAvw4eIAkr0gyKegQKRG5RMpUVGkLq3SJVuRwrL8MXnO
ZnEDyylV/WEox99IjIbpsOZrE9LJF/nqA5sOKYyYtB+bfvUNUvuibVDEHfxku0uJ
3Ww8oFXSwt9FrtkxY67foOYgRb1tg0Z1IcSu67q8kFXDlAEzt2QyCSUcRNKYTCS8
eBNN6Kfo4uen0pRp/uZmi/5b/8FQxI61JIYYFf4xa5H1WrCdxaFrfIlFMxODu3YT
6DR+rY74eaGwy8vEZGZFiLRAsxTSoNB3yFReChlm/yecCV+RefOK+Df4SCwVrJTl
VJEUwJ++jPFTNhdvcL236Ssv9g6POCOr9sXMQIf7fn39KaxHEDK21HAiaDhLS6+q
9FYjFFpefOWrCfFD8xbYKVPLQ/gVD2YWI64s3IkkTO9O2yTzHjKR6yzT1m6cPHB8
jq05a1I1857E5TRSLL2e+uRnQ4MXFTfXabCnaQEqa5KAAH+mFraX7NY12CevsmWk
ShQFl8Ao1f8WYRGWFDNxCY19swcVZZMiX/bCK6GXdDLxDQj/9H4/yU5qsaQ+RRFs
Z8vAK7QCKY/otfIzx6+Hc18VWGzR5TdGQHYOJwSQtZ9Kn2K+oG1CgfuAqTrjcMmY
SvR1UtIuvMIyxSsEcffC
=2uOA
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
