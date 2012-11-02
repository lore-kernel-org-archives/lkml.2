Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728Ab2KBSSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:18:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18827 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130Ab2KBSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:32 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=IK9KjLBd890A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=UuwjzpaS_z8A:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=Ve_rBlQliS94wRw8MkYA:9 a=QEXdDO2ut3YA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=F7Ktqph0HaZtkVwZ:21 a=_pEONxIXbNfAPjHg:21 a=c_oVvCBZ_v6RS1arTF8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181430.519736413@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Slava Pestov <slavapestov@google.com>
Subject: [PATCH 04/19] ring-buffer: Add a dropped events counter
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0004-ring-buffer-Add-a-dropped-events-counter.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Slava Pestov <slavapestov@google.com>

The existing 'overrun' counter is incremented when the ring
buffer wraps around, with overflow on (the default). We wanted
a way to count requests lost from the buffer filling up with
overflow off, too. I decided to add a new counter instead
of retro-fitting the existing one because it seems like a
different statistic to count conceptually, and also because
of how the code was structured.

Link: http://lkml.kernel.org/r/1310765038-26399-1-git-send-email-slavapesto=
v@google.com

Signed-off-by: Slava Pestov <slavapestov@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    1 +
 kernel/trace/ring_buffer.c  |   41 +++++++++++++++++++++++++++++++++++----=
--
 kernel/trace/trace.c        |    3 +++
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 6c8835f..2007375 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -166,6 +166,7 @@ unsigned long ring_buffer_overruns(struct ring_buffer *=
buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, i=
nt cpu);
+unsigned long ring_buffer_dropped_events_cpu(struct ring_buffer *buffer, i=
nt cpu);
=20
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
 void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b979426..0ebeb1d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -460,9 +460,10 @@ struct ring_buffer_per_cpu {
 	unsigned long			lost_events;
 	unsigned long			last_overrun;
 	local_t				entries_bytes;
-	local_t				commit_overrun;
-	local_t				overrun;
 	local_t				entries;
+	local_t				overrun;
+	local_t				commit_overrun;
+	local_t				dropped_events;
 	local_t				committing;
 	local_t				commits;
 	unsigned long			read;
@@ -2155,8 +2156,10 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 			 * If we are not in overwrite mode,
 			 * this is easy, just stop here.
 			 */
-			if (!(buffer->flags & RB_FL_OVERWRITE))
+			if (!(buffer->flags & RB_FL_OVERWRITE)) {
+				local_inc(&cpu_buffer->dropped_events);
 				goto out_reset;
+			}
=20
 			ret =3D rb_handle_head_page(cpu_buffer,
 						  tail_page,
@@ -2995,7 +2998,8 @@ unsigned long ring_buffer_entries_cpu(struct ring_buf=
fer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_entries_cpu);
=20
 /**
- * ring_buffer_overrun_cpu - get the number of overruns in a cpu_buffer
+ * ring_buffer_overrun_cpu - get the number of overruns caused by the ring
+ * buffer wrapping around (only if RB_FL_OVERWRITE is on).
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
  */
@@ -3015,7 +3019,9 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buf=
fer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
=20
 /**
- * ring_buffer_commit_overrun_cpu - get the number of overruns caused by c=
ommits
+ * ring_buffer_commit_overrun_cpu - get the number of overruns caused by
+ * commits failing due to the buffer wrapping around while there are uncom=
mitted
+ * events, such as during an interrupt storm.
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
  */
@@ -3036,6 +3042,28 @@ ring_buffer_commit_overrun_cpu(struct ring_buffer *b=
uffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_commit_overrun_cpu);
=20
 /**
+ * ring_buffer_dropped_events_cpu - get the number of dropped events cause=
d by
+ * the ring buffer filling up (only if RB_FL_OVERWRITE is off).
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long
+ring_buffer_dropped_events_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer =3D buffer->buffers[cpu];
+	ret =3D local_read(&cpu_buffer->dropped_events);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_dropped_events_cpu);
+
+/**
  * ring_buffer_entries - get the number of entries in a buffer
  * @buffer: The ring buffer
  *
@@ -3864,9 +3892,10 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read =3D 0;
=20
-	local_set(&cpu_buffer->commit_overrun, 0);
 	local_set(&cpu_buffer->entries_bytes, 0);
 	local_set(&cpu_buffer->overrun, 0);
+	local_set(&cpu_buffer->commit_overrun, 0);
+	local_set(&cpu_buffer->dropped_events, 0);
 	local_set(&cpu_buffer->entries, 0);
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f6928ed..36c213f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4385,6 +4385,9 @@ tracing_stats_read(struct file *filp, char __user *ub=
uf,
 	usec_rem =3D do_div(t, USEC_PER_SEC);
 	trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
=20
+	cnt =3D ring_buffer_dropped_events_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "dropped events: %ld\n", cnt);
+
 	count =3D simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
=20
 	kfree(s);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2GAAoJEOdOSU1xswtMXbAIAM6PyNA5X8sZ4YjknUtOTwK/
EpEP88y+gwcUsQ/P1TWyk3gz1anOqIBmIiBWrUQbeqFPJ78irOwlTkT1cJU5ScEv
bzOOtpzusS12yXxcqgEg0GJWiCrmsYCB9/fK/PCPmCOhIeIkLCmZkEMWUl35+sjg
U//CMWOUJRdbrNUFdHoUN8F9YBOHcAYm1mN8ggf8SjH8JrUZiPVrPnueZeYr6NfT
3V8j6tupq/ly8DKx0etQcX1wYjx8Y3s+RqIg8TUEdoDEr19lfR70TjeysD3I8Zxf
KgC4B5+wGOvqnO2Blf8TI3AudB4RwtjcbvbEfmScd6VOu/BHVqqDRKXs9/bH9LM=
=GiRm
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
