Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2ILSrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:47:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26279 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2ILSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:47:05 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=58kWvx2hfm4A:10 a=5SG0PmZfjMsA:10 a=meVymXHHAAAA:8 a=FESrO29vrNYA:10 a=VwQbUJbxAAAA:8 a=UPm3pfgAAAAA:8 a=7d_E57ReAAAA:8 a=VnNF1IyMAAAA:8 a=W_bB3CCIMeGES-C5mZYA:9 a=PUjeQqilurYA:10 a=mOio7EKfaG4A:10 a=jeBq3FmKZ4MA:10 a=D6-X0JM3zdQA:10 a=AKkd25gFMYLUd2OKSyYA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347475616.10751.74.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL][v3.7] trace: Don't declare trace_*_rcuidle
 functions in modules
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 12 Sep 2012 14:46:56 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-SI7TaOChoNwsIx1DTUfu"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SI7TaOChoNwsIx1DTUfu
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Ingo,

Josh made a change to the tracing code that affects both the work
Paul McKenney and I are currently doing. At the last Kernel Summit back
in August, Linus said when such a case exists, it is best to make a
separate branch based off of his tree and place the change there. This
way, the repositories that need to share the change can both pull them
in and the SHA1 will match for both. Whichever branch is pulled in first
by Linus will also pull in the necessary change for the other branch as
well.

I made a separate branch from Linus's v3.6-rc5 (called tip/perf/rcu) and
applied Josh's change to it. Could you please pull this into perf/core
and whatever branch that Paul needs it in. Or just have Paul pull this
change as well.

Feel free to add the above text when merging the changes.

Thanks,

-- Steve


Please pull the latest tip/perf/rcu tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/rcu

Head SHA1: 7ece55a4a3a04abe37118b1d4fb0b702eeb1de4c


Josh Triplett (1):
      trace: Don't declare trace_*_rcuidle functions in modules

----
 include/linux/tracepoint.h |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)
---------------------------
commit 7ece55a4a3a04abe37118b1d4fb0b702eeb1de4c
Author: Josh Triplett <josh@joshtriplett.org>
Date:   Tue Sep 4 23:23:06 2012 -0700

    trace: Don't declare trace_*_rcuidle functions in modules
   =20
    Tracepoints declare a static inline trace_*_rcuidle variant of the trac=
e
    function, to support safely generating trace events from the idle loop.
    Module code never actually uses that variant of trace functions, becaus=
e
    modules don't run code that needs tracing with RCU idled.  However, the
    declaration of those otherwise unused functions causes the module to
    reference rcu_idle_exit and rcu_idle_enter, which RCU does not export t=
o
    modules.
   =20
    To avoid this, don't generate trace_*_rcuidle functions for tracepoints
    declared in module code.
   =20
    Link: http://lkml.kernel.org/r/20120905062306.GA14756@leaf
   =20
    Reported-by: Steven Rostedt <rostedt@goodmis.org>
    Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Signed-off-by: Josh Triplett <josh@joshtriplett.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 802de56..2f322c3 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -136,6 +136,22 @@ static inline void tracepoint_synchronize_unregister(v=
oid)
 		postrcu;						\
 	} while (0)
=20
+#ifndef MODULE
+#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args=
)	\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{								\
+		if (static_key_false(&__tracepoint_##name.key))		\
+			__DO_TRACE(&__tracepoint_##name,		\
+				TP_PROTO(data_proto),			\
+				TP_ARGS(data_args),			\
+				TP_CONDITION(cond),			\
+				rcu_idle_exit(),			\
+				rcu_idle_enter());			\
+	}
+#else
+#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args=
)
+#endif
+
 /*
  * Make sure the alignment of the structure in the __tracepoints section w=
ill
  * not add unwanted padding between the beginning of the section and the
@@ -151,16 +167,8 @@ static inline void tracepoint_synchronize_unregister(v=
oid)
 				TP_ARGS(data_args),			\
 				TP_CONDITION(cond),,);			\
 	}								\
-	static inline void trace_##name##_rcuidle(proto)		\
-	{								\
-		if (static_key_false(&__tracepoint_##name.key))		\
-			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(data_proto),			\
-				TP_ARGS(data_args),			\
-				TP_CONDITION(cond),			\
-				rcu_idle_exit(),			\
-				rcu_idle_enter());			\
-	}								\
+	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),		\
+		PARAMS(cond), PARAMS(data_proto), PARAMS(data_args))	\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto), void *data)	\
 	{								\


--=-SI7TaOChoNwsIx1DTUfu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQUNigAAoJEOdOSU1xswtM1xIIALK3t+iy7nCFw1KbZKtiGHlZ
3cDoB6QBfWtgwIEG2+l//JdviC4P4dnvhY+ME6QRWNgKbBXIhW63wS9/aRQ/a3/p
RXZmqP/3e4hV962lZP4bdzyaCSfEwAWH7t2ea6npdFfYj68lCtgiLT3+JDrBJxvI
GuQ2CS+sUKBmsU5PVewGElt7mYViEUvjxXMW5k1w+8HEoncL1J20ZqljJoA0962P
xPBJ/tcxzOa94pln4vqvgpoR/DtGRH1za40fjEH+H7oOuYfH0NHtx5oTgcCqbczk
UBLDHWkTs77AeqedmQUuFmj+mZcUXMRFEIeyqzLkhwbZP40+4XOfV41SvyCpmfU=
=3Pf6
-----END PGP SIGNATURE-----

--=-SI7TaOChoNwsIx1DTUfu--

