Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1LFRqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:46:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62713 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1LFRqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:46:09 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=Aan5S49zAfcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=WUBaXGvqeXaJHHRtF2UA:9 a=BgXn1gSJnmzR_GRWolsA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=l0SsYvLoWY-H3onV:21 a=HfYPcuWHWBE0ZILs:21 a=BlEtjoWpET0-QbcgKXQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111206174608.055787103@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 06 Dec 2011 12:45:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] tracing: Add entries in buffer and total entries to default output header
References: <20111206174537.048874021@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Add-entries-in-buffer-and-total-entries-to-d.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Knowing the number of event entries in the ring buffer compared
to the total number that were written is useful information. The
latency format gives this information and there's no reason that the
default format does not.

This information is now added to the default header, along with the
number of online CPUs:

 # tracer: nop
 #
 # entries-in-buffer/entries-written: 159836/64690869   #P:4
 #
 #                              _-----=3D> irqs-off
 #                             / _----=3D> need-resched
 #                            | / _---=3D> hardirq/softirq
 #                            || / _--=3D> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
           <idle>-0     [000] ...2    49.442971: local_touch_nmi <-cpu_idle
           <idle>-0     [000] d..2    49.442973: enter_idle <-cpu_idle
           <idle>-0     [000] d..2    49.442974: atomic_notifier_call_chain=
 <-enter_idle
           <idle>-0     [000] d..2    49.442976: __atomic_notifier_call_cha=
in <-atomic_notifier

The above shows that the trace contains 159836 entries, but
64690869 were written. One could figure out that there were
64531033 entries that were dropped.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   72 ++++++++++++++++++++++++++++++++--------------=
---
 1 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fa5cee6..7392070 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1845,6 +1845,33 @@ static void s_stop(struct seq_file *m, void *p)
 	trace_event_read_unlock();
 }
=20
+static void
+get_total_entries(struct trace_array *tr, unsigned long *total, unsigned l=
ong *entries)
+{
+	unsigned long count;
+	int cpu;
+
+	*total =3D 0;
+	*entries =3D 0;
+
+	for_each_tracing_cpu(cpu) {
+		count =3D ring_buffer_entries_cpu(tr->buffer, cpu);
+		/*
+		 * If this buffer has skipped entries, then we hold all
+		 * entries for the trace and we need to ignore the
+		 * ones before the time stamp.
+		 */
+		if (tr->data[cpu]->skipped_entries) {
+			count -=3D tr->data[cpu]->skipped_entries;
+			/* total is the same as the entries */
+			*total +=3D count;
+		} else
+			*total +=3D count +
+				ring_buffer_overrun_cpu(tr->buffer, cpu);
+		*entries +=3D count;
+	}
+}
+
 static void print_lat_help_header(struct seq_file *m)
 {
 	seq_puts(m, "#                  _------=3D> CPU#            \n");
@@ -1857,14 +1884,27 @@ static void print_lat_help_header(struct seq_file *=
m)
 	seq_puts(m, "#     \\   /      |||||  \\    |   /           \n");
 }
=20
-static void print_func_help_header(struct seq_file *m)
+static void print_event_info(struct trace_array *tr, struct seq_file *m)
 {
+	unsigned long total;
+	unsigned long entries;
+
+	get_total_entries(tr, &total, &entries);
+	seq_printf(m, "# entries-in-buffer/entries-written: %lu/%lu   #P:%d\n",
+		   entries, total, num_online_cpus());
+	seq_puts(m, "#\n");
+}
+
+static void print_func_help_header(struct trace_array *tr, struct seq_file=
 *m)
+{
+	print_event_info(tr, m);
 	seq_puts(m, "#           TASK-PID   CPU#      TIMESTAMP  FUNCTION\n");
 	seq_puts(m, "#              | |       |          |         |\n");
 }
=20
-static void print_func_help_header_irq(struct seq_file *m)
+static void print_func_help_header_irq(struct trace_array *tr, struct seq_=
file *m)
 {
+	print_event_info(tr, m);
 	seq_puts(m, "#                              _-----=3D> irqs-off\n");
 	seq_puts(m, "#                             / _----=3D> need-resched\n");
 	seq_puts(m, "#                            | / _---=3D> hardirq/softirq\n"=
);
@@ -1881,32 +1921,14 @@ print_trace_header(struct seq_file *m, struct trace=
_iterator *iter)
 	struct trace_array *tr =3D iter->tr;
 	struct trace_array_cpu *data =3D tr->data[tr->cpu];
 	struct tracer *type =3D current_trace;
-	unsigned long entries =3D 0;
-	unsigned long total =3D 0;
-	unsigned long count;
+	unsigned long entries;
+	unsigned long total;
 	const char *name =3D "preemption";
-	int cpu;
=20
 	if (type)
 		name =3D type->name;
=20
-
-	for_each_tracing_cpu(cpu) {
-		count =3D ring_buffer_entries_cpu(tr->buffer, cpu);
-		/*
-		 * If this buffer has skipped entries, then we hold all
-		 * entries for the trace and we need to ignore the
-		 * ones before the time stamp.
-		 */
-		if (tr->data[cpu]->skipped_entries) {
-			count -=3D tr->data[cpu]->skipped_entries;
-			/* total is the same as the entries */
-			total +=3D count;
-		} else
-			total +=3D count +
-				ring_buffer_overrun_cpu(tr->buffer, cpu);
-		entries +=3D count;
-	}
+	get_total_entries(tr, &total, &entries);
=20
 	seq_printf(m, "# %s latency trace v1.1.5 on %s\n",
 		   name, UTS_RELEASE);
@@ -2184,9 +2206,9 @@ void trace_default_header(struct seq_file *m)
 	} else {
 		if (!(trace_flags & TRACE_ITER_VERBOSE)) {
 			if (trace_flags & TRACE_ITER_IRQ_INFO)
-				print_func_help_header_irq(m);
+				print_func_help_header_irq(iter->tr, m);
 			else
-				print_func_help_header(m);
+				print_func_help_header(iter->tr, m);
 		}
 	}
 }
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3lTgAAoJEIy3vGnGbaoA1XsP/jwqpBwubDTYDHydtnYYtVXU
mQn94JxMBReb6KlQVqRWehvCIPe/Sfs63cAlnCugbMkNym4mgPVzC1g+ynsf+tY6
f4+pjSI9v1CxH5qjpypmNZT6M5B4z00ptf0P2iBJy7z0pHnHOEkVKYaJpa0T5itW
ZInDE+4ugCa17If33Wp9tpVIyd6jtxVvEejVjJVVPLslC5zJ9swvnkBgqCPu4Bzd
8XDkAyB0LweZTJLMVXWe2dHAlblDPSfsexAX3AKgsq0ra1pnJ+PI56M/eUkfjTih
vnuY2Y3VP6tH9LuCXbRJstS0v2XOfItKE445G3JJYU5YZ+0pSSNfo0w50SDOL3oK
AuDSk8KRSwb788ClfxbAm2Gxg1HDukMIXYdhBgy+I4b83+b4A800yJlpCMyvxlfh
IjdW/+aSMbg3cQLTJchGW9MiGwPC9J+HcAGKXVTf4j59IP6GHjtKT4II9SNx9F7W
b4mBBKzYa+hMAHYkaGhod0/KSHTBypnG6Fl1k6JmdFzWI1129Mlo1ROYmcX1fSqq
r6Cc4pMU48SNdSFTXSRLQmZRSVgn5kA6benPrY5BhnKTEFSrODI1I76Kr9l4YNaE
JCjrl7hz+kMBnoV0vOdEyOSDi1GNOWpPhSF6bYg1oNmVtXa7i7pEmKPDpte2sAGU
1b1it42QELWi+cb4pR14
=oMEh
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
