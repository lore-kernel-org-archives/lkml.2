Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1JJNmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:42:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1JJNlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:46 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=hwJdTlaRMEIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ZTsbKecoXV8ulAn1bFYA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=F-60tdLsUlesTd8xBt8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134145.187024286@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 17/20] tracing: Add a counter clock for those that do not trust clocks
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0017-tracing-Add-a-counter-clock-for-those-that-do-not-tr.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When debugging tight race conditions, it can be helpful to have a
synchronized tracing method. Although in most cases the global clock
provides this functionality, if timings is not the issue, it is more
comforting to know that the order of events really happened in a precise
order.

Instead of using a clock, add a "counter" that is simply an incrementing
atomic 64bit counter that orders the events as they are perceived to
happen.

The trace_clock_counter() is added from the attempt by Peter Zijlstra
trying to convert the trace_clock_global() to it. I took Peter's counter
code and made trace_clock_counter() instead, and added it to the choice
of clocks. Just echo counter > /debug/tracing/trace_clock to activate
it.

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Requested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_clock.h |    1 +
 kernel/trace/trace.c        |    1 +
 kernel/trace/trace_clock.c  |   12 ++++++++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index 7a81303..4eb4902 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -15,5 +15,6 @@
 extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
 extern u64 notrace trace_clock_global(void);
+extern u64 notrace trace_clock_counter(void);
=20
 #endif /* _LINUX_TRACE_CLOCK_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b419070..4b8df0d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -435,6 +435,7 @@ static struct {
 } trace_clocks[] =3D {
 	{ trace_clock_local,	"local" },
 	{ trace_clock_global,	"global" },
+	{ trace_clock_counter,	"counter" },
 };
=20
 int trace_clock_id;
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 6302747..3947835 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -113,3 +113,15 @@ u64 notrace trace_clock_global(void)
=20
 	return now;
 }
+
+static atomic64_t trace_counter;
+
+/*
+ * trace_clock_counter(): simply an atomic counter.
+ * Use the trace_counter "counter" for cases where you do not care
+ * about timings, but are interested in strict ordering.
+ */
+u64 notrace trace_clock_counter(void)
+{
+	return atomic64_add_return(1, &trace_counter);
+}
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYZAAoJEIy3vGnGbaoAuJMP/1AXU2iUSOyrhpW1sig+ulMd
FAVM/aVEwTn/yAfq6xMPBr3Zji5AvTdJk2dCpSFg769zJonMwII7Fhv+WLkOYWtc
N1vf5VU80iBU4YzBThPoRxJoAfC2Lt42sanA9l9r9eWsA/frW5MTo9KhMv/ERaBt
9D3/qBKH6vw/EG3jNvPQKHfh/4DH15QW8x9NfCvEqlcIROsm2Vyk6dKRp8xHfavu
NH+VCYF6HtV5H5O4uojpoQ71shxpwEW5iu5TDd8PJRo8ElLXUC5Rpelg25s9MKGd
9xr51W5a6nj0O4RDqOI5h+V0x7kwvd8F+3lWWeThgHnshw23EsOrjw3Bj9i3D7bq
cmCbq69O5nUcpbfOHeSL26WJNA4XZ8p3ZDVdYrcPTFQgIGOJO4PputUydrtamhrc
lrwaHN2ect+qJp6yAnO0+KUCpkJk/ZuCvAVz88Rr3TMsgWKe4Fc8XIMijrKXubRS
X92TgEpn54MiVHipFAwG790A8f6DwgOXuhV0f5etNW2XsMVq1JS/rpijNeN58aKB
jq6ctA3zsVjP/5FePZWiUL5xqPe5d2fbrNrDeUAtCD0DXBoIiXKDvc268NQQ4jbw
h2BQZ9b1y6H7P/eiCP9Lfs2HJK1IAZCZZ2xvxRCaEkbUgZzaqsNXBM3IwWdBZ3gy
pyrIyxWAH6Mt/BkPqm/U
=JdAI
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
