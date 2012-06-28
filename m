Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2F1XSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:18:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2F1XSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:18:09 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=gPd_vPk-9ZsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=PFdwZuHhyXk_C6xg1CIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=dZBFts610Iad9Od8:21 a=egoK9Nwt7MFIOrmi:21 a=V321SCqgmWnzJbpYo5kA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120628231807.393107634@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 28 Jun 2012 19:16:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>
Subject: [PATCH 3/4] tracing: Remove NR_CPUS array from trace_iterator
References: <20120628231625.869980334@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Remove-NR_CPUS-array-from-trace_iterator.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Replace the NR_CPUS array of buffer_iter from the trace_iterator
with an allocated array. This will just create an array of
possible CPUS instead of the max number specified.

The use of NR_CPUS in that array caused allocation failures for
machines that were tight on memory. This did not cause any failures
to the system itself (no crashes), but caused unnecessary failures
for reading the trace files.

Added a helper function called 'trace_buffer_iter()' that returns
the buffer_iter item or NULL if it is not defined or the array was
not allocated. Some routines do not require the array
(tracing_open_pipe() for one).

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h         |    2 +-
 kernel/trace/trace.c                 |   27 ++++++++++++++++++---------
 kernel/trace/trace.h                 |    8 ++++++++
 kernel/trace/trace_functions_graph.c |    2 +-
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 1aff183..af961d6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -65,7 +65,7 @@ struct trace_iterator {
 	void			*private;
 	int			cpu_file;
 	struct mutex		mutex;
-	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
+	struct ring_buffer_iter	**buffer_iter;
 	unsigned long		iter_flags;
=20
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 748f640..b2af14e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1710,9 +1710,11 @@ EXPORT_SYMBOL_GPL(trace_vprintk);
=20
 static void trace_iterator_increment(struct trace_iterator *iter)
 {
+	struct ring_buffer_iter *buf_iter =3D trace_buffer_iter(iter, iter->cpu);
+
 	iter->idx++;
-	if (iter->buffer_iter[iter->cpu])
-		ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
+	if (buf_iter)
+		ring_buffer_read(buf_iter, NULL);
 }
=20
 static struct trace_entry *
@@ -1720,7 +1722,7 @@ peek_next_entry(struct trace_iterator *iter, int cpu,=
 u64 *ts,
 		unsigned long *lost_events)
 {
 	struct ring_buffer_event *event;
-	struct ring_buffer_iter *buf_iter =3D iter->buffer_iter[cpu];
+	struct ring_buffer_iter *buf_iter =3D trace_buffer_iter(iter, cpu);
=20
 	if (buf_iter)
 		event =3D ring_buffer_iter_peek(buf_iter, ts);
@@ -1858,10 +1860,10 @@ void tracing_iter_reset(struct trace_iterator *iter=
, int cpu)
=20
 	tr->data[cpu]->skipped_entries =3D 0;
=20
-	if (!iter->buffer_iter[cpu])
+	buf_iter =3D trace_buffer_iter(iter, cpu);
+	if (!buf_iter)
 		return;
=20
-	buf_iter =3D iter->buffer_iter[cpu];
 	ring_buffer_iter_reset(buf_iter);
=20
 	/*
@@ -2207,13 +2209,15 @@ static enum print_line_t print_bin_fmt(struct trace=
_iterator *iter)
=20
 int trace_empty(struct trace_iterator *iter)
 {
+	struct ring_buffer_iter *buf_iter;
 	int cpu;
=20
 	/* If we are looking at one CPU buffer, only check that one */
 	if (iter->cpu_file !=3D TRACE_PIPE_ALL_CPU) {
 		cpu =3D iter->cpu_file;
-		if (iter->buffer_iter[cpu]) {
-			if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
+		buf_iter =3D trace_buffer_iter(iter, cpu);
+		if (buf_iter) {
+			if (!ring_buffer_iter_empty(buf_iter))
 				return 0;
 		} else {
 			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
@@ -2223,8 +2227,9 @@ int trace_empty(struct trace_iterator *iter)
 	}
=20
 	for_each_tracing_cpu(cpu) {
-		if (iter->buffer_iter[cpu]) {
-			if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
+		buf_iter =3D trace_buffer_iter(iter, cpu);
+		if (buf_iter) {
+			if (!ring_buffer_iter_empty(buf_iter))
 				return 0;
 		} else {
 			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
@@ -2383,6 +2388,8 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (!iter)
 		return ERR_PTR(-ENOMEM);
=20
+	iter->buffer_iter =3D kzalloc(sizeof(*iter->buffer_iter) * num_possible_c=
pus(),
+				    GFP_KERNEL);
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
 	 * changes on it while we are reading.
@@ -2443,6 +2450,7 @@ __tracing_open(struct inode *inode, struct file *file)
  fail:
 	mutex_unlock(&trace_types_lock);
 	kfree(iter->trace);
+	kfree(iter->buffer_iter);
 	seq_release_private(inode, file);
 	return ERR_PTR(-ENOMEM);
 }
@@ -2483,6 +2491,7 @@ static int tracing_release(struct inode *inode, struc=
t file *file)
 	mutex_destroy(&iter->mutex);
 	free_cpumask_var(iter->started);
 	kfree(iter->trace);
+	kfree(iter->buffer_iter);
 	seq_release_private(inode, file);
 	return 0;
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5aec220..55e1f7f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -317,6 +317,14 @@ struct tracer {
=20
 #define TRACE_PIPE_ALL_CPU	-1
=20
+static inline struct ring_buffer_iter *
+trace_buffer_iter(struct trace_iterator *iter, int cpu)
+{
+	if (iter->buffer_iter && iter->buffer_iter[cpu])
+		return iter->buffer_iter[cpu];
+	return NULL;
+}
+
 int tracer_init(struct tracer *t, struct trace_array *tr);
 int tracing_is_enabled(void);
 void trace_wake_up(void);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_func=
tions_graph.c
index a7d2a4c..ce27c8b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -538,7 +538,7 @@ get_return_for_leaf(struct trace_iterator *iter,
 		next =3D &data->ret;
 	} else {
=20
-		ring_iter =3D iter->buffer_iter[iter->cpu];
+		ring_iter =3D trace_buffer_iter(iter, iter->cpu);
=20
 		/* First peek to compare current entry and the next one */
 		if (ring_iter)
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7OYvAAoJEIy3vGnGbaoAESYQALDGS+T+bV81fg1Ykg5Oqwgr
q69H3eNf6SDi6gbRE1XUPwLWNof0RjND2kTUgYq6P7iT+aTa/zIuSlxJArylNHoy
/OFuX94X5+w/HN6Wka2B4ObpeuJZR1GgN4hYUmhK3obqLDL1+e3n5gTYhjBIee+9
AWNexyYk+qiIP84RzgBJTknpkhdTQqjk+kNj2fZe4PFRe25boyH6UfDqOcfbGgfu
GeC8VvkZTedEH2D6uA7BBlANqbglhPNent/d6ALeOldWIQOtQInaULoxr89UiqUA
NuY4O2FWkuMB46sBQasEr0VpuF/BO0GcnC0EgVyu2Q3ci0dA9/J1ApQhWOJENubv
bHulVmR4ZzYUikT1S+wwxBr8KLBUgBlHavDx47c+WOWRZM5zUz4T73eA64Kxa/U8
2ACqOwOGjck5uG3grZ7nXU3Fkxrb09+vU1kFjH+6vWA+TqhlvRQoeOxiGhMpwobt
lxdkwI7IY3VkUZxv0C50n6426SQjrDGF7KR3FwKuHJosNGAsIx1nK2m5SCqXX45K
8RvZW1AW8kWGXFnKIyJxIRXj9fz+ASKVTIaBEgzqKQmvGPkZCxEqLv3vlXzGuGH+
/NDkGpbtpsvbaIyQCazEWjczmbp1+kYCzBXHkfaUoS5CSAxURUCCLRqS8DBZevDg
EJqkkvmO408+8ebZG7p6
=BujS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
