Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1JKPeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:34:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62429 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1JKPef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:34:35 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=tUKh1AjsFWwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=rjThEyhAoLXAF--DWNcA:9 a=kfdeS9qfIcqWZ6AEeN4A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=FwtBW7K2YbzgT-87HIkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111011153432.335659820@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 11 Oct 2011 11:20:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2 v2] tracing: Warn on output if the function tracer was found corrupted
References: <20111011152026.701326733@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Warn-on-output-if-the-function-tracer-was-fo.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

As the function tracer is very intrusive, lots of self checks are
performed on the tracer and if something is found to be strange
it will shut itself down keeping it from corrupting the rest of the
kernel. This shutdown may still allow functions to be traced, as the
tracing only stops new modifications from happening. Trying to stop
the function tracer itself can cause more harm as it requires code
modification.

Although a WARN_ON() is executed, a user may not notice it. To help
the user see that something isn't right with the tracing of the system
a big warning is added to the output of the tracer that lets the user
know that their data may be incomplete.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    8 ++++++++
 kernel/trace/trace.c  |   15 +++++++++++++++
 kernel/trace/trace.h  |    2 ++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c3e4575..077d853 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3863,6 +3863,14 @@ void ftrace_kill(void)
 }
=20
 /**
+ * Test if ftrace is dead or not.
+ */
+int ftrace_is_dead(void)
+{
+	return ftrace_disabled;
+}
+
+/**
  * register_ftrace_function - register a function for profiling
  * @ops - ops structure that holds the function for profiling.
  *
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4b8df0d..13f2b84 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2160,6 +2160,14 @@ void trace_default_header(struct seq_file *m)
 	}
 }
=20
+static void test_ftrace_alive(struct seq_file *m)
+{
+	if (!ftrace_is_dead())
+		return;
+	seq_printf(m, "# WARNING: FUNCTION TRACING IS CORRUPTED\n");
+	seq_printf(m, "#          MAY BE MISSING FUNCTION EVENTS\n");
+}
+
 static int s_show(struct seq_file *m, void *v)
 {
 	struct trace_iterator *iter =3D v;
@@ -2169,6 +2177,7 @@ static int s_show(struct seq_file *m, void *v)
 		if (iter->tr) {
 			seq_printf(m, "# tracer: %s\n", iter->trace->name);
 			seq_puts(m, "#\n");
+			test_ftrace_alive(m);
 		}
 		if (iter->trace && iter->trace->print_header)
 			iter->trace->print_header(m);
@@ -4613,6 +4622,12 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump=
_mode oops_dump_mode)
=20
 	tracing_off();
=20
+	/* Did function tracer already get disabled? */
+	if (ftrace_is_dead()) {
+		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
+		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
+	}
+
 	if (disable_tracing)
 		ftrace_kill();
=20
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4c7540a..092e1f8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -579,11 +579,13 @@ static inline int ftrace_trace_task(struct task_struc=
t *task)
=20
 	return test_tsk_trace_trace(task);
 }
+extern int ftrace_is_dead(void);
 #else
 static inline int ftrace_trace_task(struct task_struct *task)
 {
 	return 1;
 }
+static inline int ftrace_is_dead(void) { return 0; }
 #endif
=20
 /*
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOlGIIAAoJEIy3vGnGbaoAA3QP/jEUtqKTrMk0BCsj3G6UJk8n
ptatwtmmhExQiiAqNbMcKFqYZxTQGZdtHeFVfodY+jUfMIdMVUXMihrCeobENaSu
0CUSCsLJks+1H8noXTXJ8Asi4ccT9qzeeLxZP4aqiSOv2j3feWsvLLAmScEG1l2W
uS9YsrvvydEApWwXVuAtoWbjify5VjcOEoEVhs/v3bFbPlQuaS0C0Owh3v7YoB3I
iRnulpZpl2BW0LJ/K2ZXzwMoNqKjHb0Ki+oHBlg4p21o9xJF7ifFdEKZhGkuhnN4
Sd5+LQ7rvjsPtPVi+rr4JOeqvebERuJ1HadNLfsq5GPRW6+rq86uKku3fr1tzETx
Cx0M6J8t1fJIocQ2gGGqvfPMahwjaScfhIKaXmB4qBhS5mWo0C7KbHyQKHn+kjng
jrjoAc6j6CK9bEJKTwFmuTXHzw9QkCPE7L5am2P7/VI+2nm5bYDMCmQdgHr/Khf/
Kdmh59htn/yNegQmNZrGavytNxtEuYyECVryDbwaIO4t93NlZ7dipmngO8NYhMut
Q1OoeRXJH/oL2LlSPbC/k+wsG7I269eivMUKHbeMrtlxCcTS/MTlmNmgH/IZkdB6
CgeHCl2Z+nZjc+hdWS2cFEdfRDjMh15zJhTZmz/uun0m0Dzgzz/uQDevwrQw923P
tcZbW+XKYDobIllyfp3w
=p07O
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
