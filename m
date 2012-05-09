Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405Ab2EIQ6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:58:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32933 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760329Ab2EIQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:58:40 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=i1G6-F1wIVMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=zg1-9blflCZSlBrzKgAA:9 a=R5qWZ_JjyO0NTLiSobAA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=CnnZq_0nuYF3g-EsbngA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120509165838.970669723@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 12:57:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] tracing: Remove ftrace_disable/enable_cpu()
References: <20120509165751.114716410@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Remove-ftrace_disable-enable_cpu.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The ftrace_disable_cpu() and ftrace_enable_cpu() functions were
needed back before the ring buffer was lockless. Now that the
ring buffer is lockless (and has been for some time), these functions
serve no purpose, and unnecessarily slow down operations of the tracer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   44 ++------------------------------------------
 1 file changed, 2 insertions(+), 42 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4fb10ef..48ef496 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -87,18 +87,6 @@ static int tracing_disabled =3D 1;
=20
 DEFINE_PER_CPU(int, ftrace_cpu_disabled);
=20
-static inline void ftrace_disable_cpu(void)
-{
-	preempt_disable();
-	__this_cpu_inc(ftrace_cpu_disabled);
-}
-
-static inline void ftrace_enable_cpu(void)
-{
-	__this_cpu_dec(ftrace_cpu_disabled);
-	preempt_enable();
-}
-
 cpumask_var_t __read_mostly	tracing_buffer_mask;
=20
 /*
@@ -748,8 +736,6 @@ update_max_tr_single(struct trace_array *tr, struct tas=
k_struct *tsk, int cpu)
=20
 	arch_spin_lock(&ftrace_max_lock);
=20
-	ftrace_disable_cpu();
-
 	ret =3D ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
=20
 	if (ret =3D=3D -EBUSY) {
@@ -763,8 +749,6 @@ update_max_tr_single(struct trace_array *tr, struct tas=
k_struct *tsk, int cpu)
 			"Failed to swap buffers due to commit in progress\n");
 	}
=20
-	ftrace_enable_cpu();
-
 	WARN_ON_ONCE(ret && ret !=3D -EAGAIN && ret !=3D -EBUSY);
=20
 	__update_max_tr(tr, tsk, cpu);
@@ -916,13 +900,6 @@ out:
 	mutex_unlock(&trace_types_lock);
 }
=20
-static void __tracing_reset(struct ring_buffer *buffer, int cpu)
-{
-	ftrace_disable_cpu();
-	ring_buffer_reset_cpu(buffer, cpu);
-	ftrace_enable_cpu();
-}
-
 void tracing_reset(struct trace_array *tr, int cpu)
 {
 	struct ring_buffer *buffer =3D tr->buffer;
@@ -931,7 +908,7 @@ void tracing_reset(struct trace_array *tr, int cpu)
=20
 	/* Make sure all commits have finished */
 	synchronize_sched();
-	__tracing_reset(buffer, cpu);
+	ring_buffer_reset_cpu(buffer, cpu);
=20
 	ring_buffer_record_enable(buffer);
 }
@@ -949,7 +926,7 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 	tr->time_start =3D ftrace_now(tr->cpu);
=20
 	for_each_online_cpu(cpu)
-		__tracing_reset(buffer, cpu);
+		ring_buffer_reset_cpu(buffer, cpu);
=20
 	ring_buffer_record_enable(buffer);
 }
@@ -1733,14 +1710,9 @@ EXPORT_SYMBOL_GPL(trace_vprintk);
=20
 static void trace_iterator_increment(struct trace_iterator *iter)
 {
-	/* Don't allow ftrace to trace into the ring buffers */
-	ftrace_disable_cpu();
-
 	iter->idx++;
 	if (iter->buffer_iter[iter->cpu])
 		ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
-
-	ftrace_enable_cpu();
 }
=20
 static struct trace_entry *
@@ -1750,17 +1722,12 @@ peek_next_entry(struct trace_iterator *iter, int cp=
u, u64 *ts,
 	struct ring_buffer_event *event;
 	struct ring_buffer_iter *buf_iter =3D iter->buffer_iter[cpu];
=20
-	/* Don't allow ftrace to trace into the ring buffers */
-	ftrace_disable_cpu();
-
 	if (buf_iter)
 		event =3D ring_buffer_iter_peek(buf_iter, ts);
 	else
 		event =3D ring_buffer_peek(iter->tr->buffer, cpu, ts,
 					 lost_events);
=20
-	ftrace_enable_cpu();
-
 	if (event) {
 		iter->ent_size =3D ring_buffer_event_length(event);
 		return ring_buffer_event_data(event);
@@ -1850,11 +1817,8 @@ void *trace_find_next_entry_inc(struct trace_iterato=
r *iter)
=20
 static void trace_consume(struct trace_iterator *iter)
 {
-	/* Don't allow ftrace to trace into the ring buffers */
-	ftrace_disable_cpu();
 	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts,
 			    &iter->lost_events);
-	ftrace_enable_cpu();
 }
=20
 static void *s_next(struct seq_file *m, void *v, loff_t *pos)
@@ -1943,16 +1907,12 @@ static void *s_start(struct seq_file *m, loff_t *po=
s)
 		iter->cpu =3D 0;
 		iter->idx =3D -1;
=20
-		ftrace_disable_cpu();
-
 		if (cpu_file =3D=3D TRACE_PIPE_ALL_CPU) {
 			for_each_tracing_cpu(cpu)
 				tracing_iter_reset(iter, cpu);
 		} else
 			tracing_iter_reset(iter, cpu_file);
=20
-		ftrace_enable_cpu();
-
 		iter->leftover =3D 0;
 		for (p =3D iter; p && l < *pos; p =3D s_next(m, p, &l))
 			;
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPqqI/AAoJEIy3vGnGbaoAuzkQAMI8ncunbHp+ir8yWSQ6kZXt
TJgBBiHuKlIYY/xpG+3eqznd5/0tPfnorJWvPUpUbsHp4osiHV2spJrCFh8v6/Wn
QcUxD/tHJVCGiC+3RNtHQIWZpAOXYav1SiSMuMmPx0ZZrC0LVWi2cDlBPYu6W0ko
eqDQwrQI0ngK1wlLsNvZrMNqaSdrtW49VBfx+Xl9dUDJfli39XP9aHNMqjNQcTQO
Gz+D7KSh2uJ/x7tSpBFYFovVw10GXW/8bO9prdo3pWoRy1Us/q7VPUqC2NovK8Sd
C6KoOuBu3uXYUgpqw8+1qhzwJZ8QkE+PVZH1RuOCHRgSxQkulspr6Imjz4L9GTBm
WOZN+BRNnRe980Qw7Z+qYuKgBMsI12jy/9f1C6mz+DlwfsfXxarDhpig2QEmiM0J
V/Yf2UWmreZYL6qwOexX6EBSFIFFcRWGh+R5HLUUgYOH1kDkE+v+t9VUwrgKONkw
emL75xBzILIxeRLVfukOHAUuIoO20dmXkUbOC3LlMzfA6JGNU9vYOi7GvRDyCr1g
ICHiLE5+1Gikw9aPBuRDKDHFJknaNAl7YnRqyysKqOBAdVy/s9lsjdQZquqI7h3/
fsNX3slRWbW471K8Ltf6azm8/k6mXG1V+fUtzYqzYXo1nkDSIaH5mdpcY4tqmeIm
tjIGmlyzRtuExp+kOj7b
=vUNz
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
