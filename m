Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab2BNDmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:42:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34864 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046Ab2BNDkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:40:09 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=ZFwbs3lezaIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=VnNF1IyMAAAA:8 a=UPm3pfgAAAAA:8 a=meVymXHHAAAA:8 a=wv91tmdJEZCA7l7znooA:9 a=4QEkGuhcRcO4Eu0zGw0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=mOio7EKfaG4A:10 a=jeBq3FmKZ4MA:10 a=qRwDAILiZSZ_nH0S0w8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120214034006.458739095@goodmis.org>
User-Agent: quilt/0.50-1
Date: Mon, 13 Feb 2012 22:39:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 3/9] tracing/rcu: Add trace_##name##__rcuidle() static tracepoint for
 inside rcu_idle_exit() sections
References: <20120214033909.904564921@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-rcu-Add-trace_-name-__rcuidle-static-tracepo.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Added is a new static inline function that lets *any* tracepoint be used
inside a rcu_idle_exit() section. And this also solves the problem where
the same tracepoint may be used inside a rcu_idle_exit() section as well
as outside of one.

I added a new tracepoint function with a "_rcuidle" extension. All
tracepoints can be used with either the normal "trace_foobar()"
function, or the "trace_foobar_rcuidle()" function when inside a
rcu_idle_exit() section.

All tracepoints defined by TRACE_EVENT() or any of the derivatives
will have a "_rcuidle()" function also defined. When a tracepoint is
used within an rcu_idle_exit() section, the "_rcuidle()" version must
be used. This denotes that the tracepoint is within rcu_idle_exit()
and it allows the rcu read locks within the tracepoint to still
be valid, as this version takes us out of rcu_idle_exit().

Another nice aspect about this patch is that "static inline"s are not
compiled into text when not used. So only the tracepoints that actually
use the _rcuidle() version will have them defined in the actual text
that is booted.

Link: http://lkml.kernel.org/r/1328563113.2200.39.camel@gandalf.stny.rr.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index df0a779..fc36da9 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -114,7 +114,7 @@ static inline void tracepoint_synchronize_unregister(vo=
id)
  * as "(void *, void)". The DECLARE_TRACE_NOARGS() will pass in just
  * "void *data", where as the DECLARE_TRACE() will pass in "void *data, pr=
oto".
  */
-#define __DO_TRACE(tp, proto, args, cond)				\
+#define __DO_TRACE(tp, proto, args, cond, prercu, postrcu)		\
 	do {								\
 		struct tracepoint_func *it_func_ptr;			\
 		void *it_func;						\
@@ -122,6 +122,7 @@ static inline void tracepoint_synchronize_unregister(vo=
id)
 									\
 		if (!(cond))						\
 			return;						\
+		prercu;							\
 		rcu_read_lock_sched_notrace();				\
 		it_func_ptr =3D rcu_dereference_sched((tp)->funcs);	\
 		if (it_func_ptr) {					\
@@ -132,6 +133,7 @@ static inline void tracepoint_synchronize_unregister(vo=
id)
 			} while ((++it_func_ptr)->func);		\
 		}							\
 		rcu_read_unlock_sched_notrace();			\
+		postrcu;						\
 	} while (0)
=20
 /*
@@ -139,7 +141,7 @@ static inline void tracepoint_synchronize_unregister(vo=
id)
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
@@ -147,7 +149,17 @@ static inline void tracepoint_synchronize_unregister(v=
oid)
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
-				TP_CONDITION(cond));			\
+				TP_CONDITION(cond),,);			\
+	}								\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{								\
+		if (static_branch(&__tracepoint_##name.key))		\
+			__DO_TRACE(&__tracepoint_##name,		\
+				TP_PROTO(data_proto),			\
+				TP_ARGS(data_args),			\
+				TP_CONDITION(cond),			\
+				rcu_idle_exit(),			\
+				rcu_idle_enter());			\
 	}								\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto), void *data)	\
@@ -190,9 +202,11 @@ static inline void tracepoint_synchronize_unregister(v=
oid)
 	EXPORT_SYMBOL(__tracepoint_##name)
=20
 #else /* !CONFIG_TRACEPOINTS */
-#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
 	static inline void trace_##name(proto)				\
 	{ }								\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{ }								\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto),		\
 			      void *data)				\
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPOdeWAAoJEIy3vGnGbaoAJuQQAOkbjc5Rg1VvzfZ4DhhyG3Ki
YeKwd8KC61hOZFKwLk/QDYfow5ppovMGdwHowWmi4vfy3TfDIEW6NRpO8rdRpbsC
sDJyhBP3iPpTIC+3JaQSFjN4uYZWcHvimlNIvxQFY67ACuYK/mHlUfEmDq98A7+I
xD8f1H2LLTaT+jcvdXJ/P5L5JTBMK5UFW32Ag94P4H2gxi/0LiWJHzlEvxukkffs
GzoESQWZoR5JlC71nR/HoFD4xLgtN3oQJ7UI4aQUMZ04oLATE6ehxiHZEOtGi9a/
GBecXr7CmcNs3AsYRGxihljCPMzaySjvqmxqCO6T6AAwZH1wifDf9oFmSIw4/bJP
HHH4pZ/cj7LqAcBmcs9bUnnostZt+Ud33+Sk9zOoWV1HPVhGsR8MgaCfwfI7sNaX
WOF6JwT41C84eDp0Qpo1Tzl5LvS5t8qdDR5lO4TWybTZgJhpmZahsBC5Cd53Oxyr
8VTPbYulLPVViejfgPt0A+NPV3WKjx/eBef9frJZwyrZnveHz69awbfsLOqoi4jJ
UZURZ2YhpQ3qiMPRwqy5PIMaUNLzrc2KDTgV8fBGH1znONMqzNDsZTPTeP1gpZxY
jzRfMaRpZMzfL+FU+DbAiX5UfEmEFTyeci1UG/hXacyYrXZYjdWMnszUQhQAaM52
aTE62GdqbymZlldA+DZl
=OaKt
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
