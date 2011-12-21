Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1LUMiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:38:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1LUMiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:05 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=1I07Q0TatcwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=MlcZDvOLqQyxVWGOKj8A:9 a=870oPlkCIYrN_QdnZ58A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=12gPnmQeNGDigk7SyS0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123802.940692552@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/16] ftrace: Do not function trace inlined functions
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Do-not-function-trace-inlined-functions.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When gcc inlines a function, it does not mark it with the mcount
prologue, which in turn means that inlined functions are not traced
by the function tracer. But if CONFIG_OPTIMIZE_INLINING is set, then
gcc is allowed not to inline a function that is marked inline.

Depending on the options and the compiler, a function may or may
not be traced by the function tracer, depending on whether gcc
decides to inline a function or not. This has caused several
problems in the pass becaues gcc is not always consistent with
what it decides to inline between different gcc versions.

Some places should not be traced (like paravirt native_* functions)
and these are mostly marked as inline. When gcc decides not to
inline the function, and if that function should not be traced, then
the ftrace function tracer will suddenly break when it use to work
fine. This becomes even harder to debug when different versions of
gcc will not inline that function, making the same kernel and config
work for some gcc versions and not work for others.

By making all functions marked inline to not be traced will remove
the ambiguity that gcc adds when it comes to tracing functions marked
inline. All gcc versions will be consistent with what functions are
traced and having volatile working code will be removed.

Note, only the inline macro when CONFIG_OPTIMIZE_INLINING is set needs
to have notrace added, as the attribute __always_inline will force
the function to be inlined and then not traced.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/compiler-gcc.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 59e4028..3fd17c2 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -50,6 +50,11 @@
 # define inline		inline		__attribute__((always_inline))
 # define __inline__	__inline__	__attribute__((always_inline))
 # define __inline	__inline	__attribute__((always_inline))
+#else
+/* A lot of inline functions can cause havoc with function tracing */
+# define inline		inline		notrace
+# define __inline__	__inline__	notrace
+# define __inline	__inline	notrace
 #endif
=20
 #define __deprecated			__attribute__((deprecated))
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMrAAoJEIy3vGnGbaoAQFQP/A8/E852/5Kr44HY0dhl57P1
vwmA24QgP4GuajwxcTY2d12B9D57WqafrxlU8fYjybrD7Q/llwrTj6I9q+U3Kz+K
wMo+U9fJysP/pGKCu8oxEFCoMegd6RcPPJJjhrkH0ocq/lBEZUG1kdASZ35d93lv
KIBiz1WacyP8zb1dj8jAXe7uu0slIospEZw6tGsnhW1wCcpMTME77bWX1IHyB3Na
FcKOnR59MrhnmBYSlKqMyMLyb+jxyv8Sb61yg0rF7bleNd+7nZenhp6P4sTTvFRf
souwcJOYVKn2PiH+JmYWBJnf3UBHlpvIm3T2jamEdSmQgLdILxwQY0HaSvS1y3Wg
Af8t6rjARZmZJt7UAAmmbSElpYMnr7qI/FHHU/cpNhOlggsaSD+S2qMQ4Lj7M+4u
36RrgiqXcI0toiPiQo2Kosal9EjacWmqVuu9Mp6ywNClRqJ65u11g2jBd6TMbS5O
0HWqOViUt+4ZGtI9/gfuk0K/H0meEW08yVNMgJ0LhlxZvEb9mF52eUZPqRikz9wu
UnnuZd/zb6hy3TqAELa280Zy8HqjysoJsCWH27Uq7ggBcymO1cD0ODE4dBVR38bk
usTjScR1ciiRSP8+AQgzpoipdHdBsWnsgTN0oh6ssllB2HBqYSdif5uoEmc5e04g
hE899rCM/aSNe9itvpQK
=lhgP
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
