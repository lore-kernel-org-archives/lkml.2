Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2BVOmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:42:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2BVOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:42:11 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=2fCBcuG4pWYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=KeQVmMHEjfmykGWvzRcA:9 a=3ozQg6SRpXZSC3Nx-hwA:7 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=ikPE-4BPvvn8V_pIStIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120222144209.780469516@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 22 Feb 2012 09:40:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/9] ftrace: Add enable/disable ftrace_ops control interface
References: <20120222144036.824378742@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Add-enable-disable-ftrace_ops-control-interfa.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Adding a way to temporarily enable/disable ftrace_ops. The change
follows the same way as 'global' ftrace_ops are done.

Introducing 2 global ftrace_ops - control_ops and ftrace_control_list
which take over all ftrace_ops registered with FTRACE_OPS_FL_CONTROL
flag. In addition new per cpu flag called 'disabled' is also added to
ftrace_ops to provide the control information for each cpu.

When ftrace_ops with FTRACE_OPS_FL_CONTROL is registered, it is
set as disabled for all cpus.

The ftrace_control_list contains all the registered 'control' ftrace_ops.
The control_ops provides function which iterates ftrace_control_list
and does the check for 'disabled' flag on current cpu.

Adding 3 inline functions:
  ftrace_function_local_disable/ftrace_function_local_enable
  - enable/disable the ftrace_ops on current cpu
  ftrace_function_local_disabled
  - get disabled ftrace_ops::disabled value for current cpu

Link: http://lkml.kernel.org/r/1329317514-8131-2-git-send-email-jolsa@redha=
t.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |   66 ++++++++++++++++++++++++++++
 kernel/trace/ftrace.c  |  111 ++++++++++++++++++++++++++++++++++++++++++++=
+---
 kernel/trace/trace.h   |    2 +
 3 files changed, 172 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f33fb3b..64a309d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -31,16 +31,33 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
=20
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
=20
+/*
+ * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
+ * set in the flags member.
+ *
+ * ENABLED - set/unset when ftrace_ops is registered/unregistered
+ * GLOBAL  - set manualy by ftrace_ops user to denote the ftrace_ops
+ *           is part of the global tracers sharing the same filter
+ *           via set_ftrace_* debugfs files.
+ * DYNAMIC - set when ftrace_ops is registered to denote dynamically
+ *           allocated ftrace_ops which need special care
+ * CONTROL - set manualy by ftrace_ops user to denote the ftrace_ops
+ *           could be controled by following calls:
+ *             ftrace_function_local_enable
+ *             ftrace_function_local_disable
+ */
 enum {
 	FTRACE_OPS_FL_ENABLED		=3D 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		=3D 1 << 1,
 	FTRACE_OPS_FL_DYNAMIC		=3D 1 << 2,
+	FTRACE_OPS_FL_CONTROL		=3D 1 << 3,
 };
=20
 struct ftrace_ops {
 	ftrace_func_t			func;
 	struct ftrace_ops		*next;
 	unsigned long			flags;
+	int __percpu			*disabled;
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
@@ -97,6 +114,55 @@ int register_ftrace_function(struct ftrace_ops *ops);
 int unregister_ftrace_function(struct ftrace_ops *ops);
 void clear_ftrace_function(void);
=20
+/**
+ * ftrace_function_local_enable - enable controlled ftrace_ops on current =
cpu
+ *
+ * This function enables tracing on current cpu by decreasing
+ * the per cpu control variable.
+ * It must be called with preemption disabled and only on ftrace_ops
+ * registered with FTRACE_OPS_FL_CONTROL. If called without preemption
+ * disabled, this_cpu_ptr will complain when CONFIG_DEBUG_PREEMPT is enabl=
ed.
+ */
+static inline void ftrace_function_local_enable(struct ftrace_ops *ops)
+{
+	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL)))
+		return;
+
+	(*this_cpu_ptr(ops->disabled))--;
+}
+
+/**
+ * ftrace_function_local_disable - enable controlled ftrace_ops on current=
 cpu
+ *
+ * This function enables tracing on current cpu by decreasing
+ * the per cpu control variable.
+ * It must be called with preemption disabled and only on ftrace_ops
+ * registered with FTRACE_OPS_FL_CONTROL. If called without preemption
+ * disabled, this_cpu_ptr will complain when CONFIG_DEBUG_PREEMPT is enabl=
ed.
+ */
+static inline void ftrace_function_local_disable(struct ftrace_ops *ops)
+{
+	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL)))
+		return;
+
+	(*this_cpu_ptr(ops->disabled))++;
+}
+
+/**
+ * ftrace_function_local_disabled - returns ftrace_ops disabled value
+ *                                  on current cpu
+ *
+ * This function returns value of ftrace_ops::disabled on current cpu.
+ * It must be called with preemption disabled and only on ftrace_ops
+ * registered with FTRACE_OPS_FL_CONTROL. If called without preemption
+ * disabled, this_cpu_ptr will complain when CONFIG_DEBUG_PREEMPT is enabl=
ed.
+ */
+static inline int ftrace_function_local_disabled(struct ftrace_ops *ops)
+{
+	WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL));
+	return *this_cpu_ptr(ops->disabled);
+}
+
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
=20
 #else /* !CONFIG_FUNCTION_TRACER */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d1499e9..f615f97 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -62,6 +62,8 @@
 #define FTRACE_HASH_DEFAULT_BITS 10
 #define FTRACE_HASH_MAX_BITS 12
=20
+#define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_CONTR=
OL)
+
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
@@ -89,12 +91,14 @@ static struct ftrace_ops ftrace_list_end __read_mostly =
=3D {
 };
=20
 static struct ftrace_ops *ftrace_global_list __read_mostly =3D &ftrace_lis=
t_end;
+static struct ftrace_ops *ftrace_control_list __read_mostly =3D &ftrace_li=
st_end;
 static struct ftrace_ops *ftrace_ops_list __read_mostly =3D &ftrace_list_e=
nd;
 ftrace_func_t ftrace_trace_function __read_mostly =3D ftrace_stub;
 static ftrace_func_t __ftrace_trace_function_delay __read_mostly =3D ftrac=
e_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly =3D ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly =3D ftrace_stub;
 static struct ftrace_ops global_ops;
+static struct ftrace_ops control_ops;
=20
 static void
 ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
@@ -168,6 +172,32 @@ static void ftrace_test_stop_func(unsigned long ip, un=
signed long parent_ip)
 }
 #endif
=20
+static void control_ops_disable_all(struct ftrace_ops *ops)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr(ops->disabled, cpu) =3D 1;
+}
+
+static int control_ops_alloc(struct ftrace_ops *ops)
+{
+	int __percpu *disabled;
+
+	disabled =3D alloc_percpu(int);
+	if (!disabled)
+		return -ENOMEM;
+
+	ops->disabled =3D disabled;
+	control_ops_disable_all(ops);
+	return 0;
+}
+
+static void control_ops_free(struct ftrace_ops *ops)
+{
+	free_percpu(ops->disabled);
+}
+
 static void update_global_ops(void)
 {
 	ftrace_func_t func;
@@ -259,6 +289,26 @@ static int remove_ftrace_ops(struct ftrace_ops **list,=
 struct ftrace_ops *ops)
 	return 0;
 }
=20
+static void add_ftrace_list_ops(struct ftrace_ops **list,
+				struct ftrace_ops *main_ops,
+				struct ftrace_ops *ops)
+{
+	int first =3D *list =3D=3D &ftrace_list_end;
+	add_ftrace_ops(list, ops);
+	if (first)
+		add_ftrace_ops(&ftrace_ops_list, main_ops);
+}
+
+static int remove_ftrace_list_ops(struct ftrace_ops **list,
+				  struct ftrace_ops *main_ops,
+				  struct ftrace_ops *ops)
+{
+	int ret =3D remove_ftrace_ops(list, ops);
+	if (!ret && *list =3D=3D &ftrace_list_end)
+		ret =3D remove_ftrace_ops(&ftrace_ops_list, main_ops);
+	return ret;
+}
+
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
 	if (ftrace_disabled)
@@ -270,15 +320,20 @@ static int __register_ftrace_function(struct ftrace_o=
ps *ops)
 	if (WARN_ON(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return -EBUSY;
=20
+	/* We don't support both control and global flags set. */
+	if ((ops->flags & FL_GLOBAL_CONTROL_MASK) =3D=3D FL_GLOBAL_CONTROL_MASK)
+		return -EINVAL;
+
 	if (!core_kernel_data((unsigned long)ops))
 		ops->flags |=3D FTRACE_OPS_FL_DYNAMIC;
=20
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		int first =3D ftrace_global_list =3D=3D &ftrace_list_end;
-		add_ftrace_ops(&ftrace_global_list, ops);
+		add_ftrace_list_ops(&ftrace_global_list, &global_ops, ops);
 		ops->flags |=3D FTRACE_OPS_FL_ENABLED;
-		if (first)
-			add_ftrace_ops(&ftrace_ops_list, &global_ops);
+	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
+		if (control_ops_alloc(ops))
+			return -ENOMEM;
+		add_ftrace_list_ops(&ftrace_control_list, &control_ops, ops);
 	} else
 		add_ftrace_ops(&ftrace_ops_list, ops);
=20
@@ -302,11 +357,23 @@ static int __unregister_ftrace_function(struct ftrace=
_ops *ops)
 		return -EINVAL;
=20
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		ret =3D remove_ftrace_ops(&ftrace_global_list, ops);
-		if (!ret && ftrace_global_list =3D=3D &ftrace_list_end)
-			ret =3D remove_ftrace_ops(&ftrace_ops_list, &global_ops);
+		ret =3D remove_ftrace_list_ops(&ftrace_global_list,
+					     &global_ops, ops);
 		if (!ret)
 			ops->flags &=3D ~FTRACE_OPS_FL_ENABLED;
+	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
+		ret =3D remove_ftrace_list_ops(&ftrace_control_list,
+					     &control_ops, ops);
+		if (!ret) {
+			/*
+			 * The ftrace_ops is now removed from the list,
+			 * so there'll be no new users. We must ensure
+			 * all current users are done before we free
+			 * the control data.
+			 */
+			synchronize_sched();
+			control_ops_free(ops);
+		}
 	} else
 		ret =3D remove_ftrace_ops(&ftrace_ops_list, ops);
=20
@@ -3874,6 +3941,36 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned lon=
g ip)
 #endif /* CONFIG_DYNAMIC_FTRACE */
=20
 static void
+ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_ops *op;
+
+	if (unlikely(trace_recursion_test(TRACE_CONTROL_BIT)))
+		return;
+
+	/*
+	 * Some of the ops may be dynamically allocated,
+	 * they must be freed after a synchronize_sched().
+	 */
+	preempt_disable_notrace();
+	trace_recursion_set(TRACE_CONTROL_BIT);
+	op =3D rcu_dereference_raw(ftrace_control_list);
+	while (op !=3D &ftrace_list_end) {
+		if (!ftrace_function_local_disabled(op) &&
+		    ftrace_ops_test(op, ip))
+			op->func(ip, parent_ip);
+
+		op =3D rcu_dereference_raw(op->next);
+	};
+	trace_recursion_clear(TRACE_CONTROL_BIT);
+	preempt_enable_notrace();
+}
+
+static struct ftrace_ops control_ops =3D {
+	.func =3D ftrace_ops_control_func,
+};
+
+static void
 ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index b93ecba..55c6ea0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -288,6 +288,8 @@ struct tracer {
 /* for function tracing recursion */
 #define TRACE_INTERNAL_BIT		(1<<11)
 #define TRACE_GLOBAL_BIT		(1<<12)
+#define TRACE_CONTROL_BIT		(1<<13)
+
 /*
  * Abuse of the trace_recursion.
  * As we need a way to maintain state if we are tracing the function
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPRP7BAAoJEIy3vGnGbaoAXdcP/0Ychr9CnFcscPd+coKTkUx1
1AmDnP2uj9QHT6DhPseRbcqmHH3SartLzwyeJ5ow8+0thK4X79Ly0PeXLdefxLnl
zktug6GrTgjd0LzROuOpO0CAGsB7g/h/td6FPlNOjY7wmFkgvHT5nQWNWU8jg4xk
5ZPOZuFoGVDC1zxFJ38CjPkd3hj9ZygDqfk5Qz30g0Xx/U9FPR5YtNTv4IiRQ+dw
edLIbiEOkyUl/4thgJKQcLyTfcTlcuDXHqaStjWi+gCSv1n+tYkTzxhDF0YTpNKV
X1U+6chnU2pAWWfZWBjlQ4xlo9XnF2D4zkvZIcyUzuDrLmEGhhMw6IY7WFJtIBNm
8klZ56AShqf0IwYR0H7008R4bP02+zPji9X3+m3Ob71G2iXlLeeVI9/1HbEqlAyy
D0S815HOL0UCBaq9pWsCZJjwaQzMOaPFTXSOgTcM+rAun43AykKngQraStc7dvmn
5//E8dyqHCJIG9qns5bU5lWPPiOJZgm7zOROBfZH9thssguHvXlvL1K9VYIsnGQ2
m0Sb1hrssy9aPvJtvZEf6xlZ+yevIcS92kwM83L6ZBkpEtB4Sowlx1z8Fdt3jYaG
z4xvzmUM2AtaP+y7rc865aLhxvrO4k81IEPdNRb8bD5r+X1bx0A6lLu5D1uj9u+U
Mz4c4gGkj09POmodNPq6
=ZpaU
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
