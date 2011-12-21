Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1LUMln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:41:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1LUMiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:06 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=-MOWFb3CJkgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=XcodJx0mWIcY_zNYTPoA:9 a=M_bK0gPTVzZQ_13NMI0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=_WyT79Eiu8tf0jUy:21 a=02BwAljHrFdGuyua:21 a=Fk0h02fQxCbcKVUlfUwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123803.641322820@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/16] ftrace: Allow archs to modify code without stop machine
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Allow-archs-to-modify-code-without-stop-machi.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The stop machine method to modify all functions in the kernel
(some 20,000 of them) is the safest way to do so across all archs.
But some archs may not need this big hammer approach to modify code
on SMP machines, and can simply just update the code it needs.

Adding a weak function arch_ftrace_update_code() that now does the
stop machine, will also let any arch override this method.

If the arch needs to check the system and then decide if it can
avoid stop machine, it can still call ftrace_run_stop_machine() to
use the old method.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |   31 ++++++
 kernel/trace/ftrace.c  |  253 ++++++++++++++++++++++++++++++++++++++++----=
---
 2 files changed, 246 insertions(+), 38 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 26eafce..4f0b6fe 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -133,6 +133,8 @@ struct ftrace_func_command {
 int ftrace_arch_code_modify_prepare(void);
 int ftrace_arch_code_modify_post_process(void);
=20
+void ftrace_bug(int err, unsigned long ip);
+
 struct seq_file;
=20
 struct ftrace_probe_ops {
@@ -190,6 +192,35 @@ void ftrace_set_global_notrace(unsigned char *buf, int=
 len, int reset);
 int register_ftrace_command(struct ftrace_func_command *cmd);
 int unregister_ftrace_command(struct ftrace_func_command *cmd);
=20
+enum {
+	FTRACE_UPDATE_CALLS		=3D (1 << 0),
+	FTRACE_DISABLE_CALLS		=3D (1 << 1),
+	FTRACE_UPDATE_TRACE_FUNC	=3D (1 << 2),
+	FTRACE_START_FUNC_RET		=3D (1 << 3),
+	FTRACE_STOP_FUNC_RET		=3D (1 << 4),
+};
+
+enum {
+	FTRACE_UPDATE_IGNORE,
+	FTRACE_UPDATE_MAKE_CALL,
+	FTRACE_UPDATE_MAKE_NOP,
+};
+
+void arch_ftrace_update_code(int command);
+
+struct ftrace_rec_iter;
+
+struct ftrace_rec_iter *ftrace_rec_iter_start(void);
+struct ftrace_rec_iter *ftrace_rec_iter_next(struct ftrace_rec_iter *iter);
+struct dyn_ftrace *ftrace_rec_iter_record(struct ftrace_rec_iter *iter);
+
+int ftrace_update_record(struct dyn_ftrace *rec, int enable);
+int ftrace_test_record(struct dyn_ftrace *rec, int enable);
+void ftrace_run_stop_machine(int command);
+int ftrace_location(unsigned long ip);
+
+extern ftrace_func_t ftrace_trace_function;
+
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
 extern int ftrace_dyn_arch_init(void *data);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 25b4f4d..655b432 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -947,13 +947,6 @@ struct ftrace_func_probe {
 	struct rcu_head		rcu;
 };
=20
-enum {
-	FTRACE_UPDATE_CALLS		=3D (1 << 0),
-	FTRACE_DISABLE_CALLS		=3D (1 << 1),
-	FTRACE_UPDATE_TRACE_FUNC	=3D (1 << 2),
-	FTRACE_START_FUNC_RET		=3D (1 << 3),
-	FTRACE_STOP_FUNC_RET		=3D (1 << 4),
-};
 struct ftrace_func_entry {
 	struct hlist_node hlist;
 	unsigned long ip;
@@ -1307,6 +1300,28 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned lon=
g ip)
 		}				\
 	}
=20
+/**
+ * ftrace_location - return true if the ip giving is a traced location
+ * @ip: the instruction pointer to check
+ *
+ * Returns 1 if @ip given is a pointer to a ftrace location.
+ * That is, the instruction that is either a NOP or call to
+ * the function tracer. It checks the ftrace internal tables to
+ * determine if the address belongs or not.
+ */
+int ftrace_location(unsigned long ip)
+{
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
+
+	do_for_each_ftrace_rec(pg, rec) {
+		if (rec->ip =3D=3D ip)
+			return 1;
+	} while_for_each_ftrace_rec();
+
+	return 0;
+}
+
 static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				     int filter_hash,
 				     bool inc)
@@ -1475,7 +1490,19 @@ static void print_ip_ins(const char *fmt, unsigned c=
har *p)
 		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
 }
=20
-static void ftrace_bug(int failed, unsigned long ip)
+/**
+ * ftrace_bug - report and shutdown function tracer
+ * @failed: The failed type (EFAULT, EINVAL, EPERM)
+ * @ip: The address that failed
+ *
+ * The arch code that enables or disables the function tracing
+ * can call ftrace_bug() when it has detected a problem in
+ * modifying the code. @failed should be one of either:
+ * EFAULT - if the problem happens on reading the @ip address
+ * EINVAL - if what is read at @ip is not what was expected
+ * EPERM - if the problem happens on writting to the @ip address
+ */
+void ftrace_bug(int failed, unsigned long ip)
 {
 	switch (failed) {
 	case -EFAULT:
@@ -1517,15 +1544,10 @@ int ftrace_text_reserved(void *start, void *end)
 	return 0;
 }
=20
-
-static int
-__ftrace_replace_code(struct dyn_ftrace *rec, int update)
+static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int upd=
ate)
 {
-	unsigned long ftrace_addr;
 	unsigned long flag =3D 0UL;
=20
-	ftrace_addr =3D (unsigned long)FTRACE_ADDR;
-
 	/*
 	 * If we are updating calls:
 	 *
@@ -1537,20 +1559,74 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int u=
pdate)
 	 * If we are disabling calls, then disable all records that
 	 * are enabled.
 	 */
-	if (update && (rec->flags & ~FTRACE_FL_MASK))
+	if (enable && (rec->flags & ~FTRACE_FL_MASK))
 		flag =3D FTRACE_FL_ENABLED;
=20
 	/* If the state of this record hasn't changed, then do nothing */
 	if ((rec->flags & FTRACE_FL_ENABLED) =3D=3D flag)
-		return 0;
+		return FTRACE_UPDATE_IGNORE;
=20
 	if (flag) {
-		rec->flags |=3D FTRACE_FL_ENABLED;
+		if (update)
+			rec->flags |=3D FTRACE_FL_ENABLED;
+		return FTRACE_UPDATE_MAKE_CALL;
+	}
+
+	if (update)
+		rec->flags &=3D ~FTRACE_FL_ENABLED;
+
+	return FTRACE_UPDATE_MAKE_NOP;
+}
+
+/**
+ * ftrace_update_record, set a record that now is tracing or not
+ * @rec: the record to update
+ * @enable: set to 1 if the record is tracing, zero to force disable
+ *
+ * The records that represent all functions that can be traced need
+ * to be updated when tracing has been enabled.
+ */
+int ftrace_update_record(struct dyn_ftrace *rec, int enable)
+{
+	return ftrace_check_record(rec, enable, 1);
+}
+
+/**
+ * ftrace_test_record, check if the record has been enabled or not
+ * @rec: the record to test
+ * @enable: set to 1 to check if enabled, 0 if it is disabled
+ *
+ * The arch code may need to test if a record is already set to
+ * tracing to determine how to modify the function code that it
+ * represents.
+ */
+int ftrace_test_record(struct dyn_ftrace *rec, int enable)
+{
+	return ftrace_check_record(rec, enable, 0);
+}
+
+static int
+__ftrace_replace_code(struct dyn_ftrace *rec, int enable)
+{
+	unsigned long ftrace_addr;
+	int ret;
+
+	ftrace_addr =3D (unsigned long)FTRACE_ADDR;
+
+	ret =3D ftrace_update_record(rec, enable);
+
+	switch (ret) {
+	case FTRACE_UPDATE_IGNORE:
+		return 0;
+
+	case FTRACE_UPDATE_MAKE_CALL:
 		return ftrace_make_call(rec, ftrace_addr);
+
+	case FTRACE_UPDATE_MAKE_NOP:
+		return ftrace_make_nop(NULL, rec, ftrace_addr);
 	}
=20
-	rec->flags &=3D ~FTRACE_FL_ENABLED;
-	return ftrace_make_nop(NULL, rec, ftrace_addr);
+	return -1; /* unknow ftrace bug */
 }
=20
 static void ftrace_replace_code(int update)
@@ -1576,6 +1652,78 @@ static void ftrace_replace_code(int update)
 	} while_for_each_ftrace_rec();
 }
=20
+struct ftrace_rec_iter {
+	struct ftrace_page	*pg;
+	int			index;
+};
+
+/**
+ * ftrace_rec_iter_start, start up iterating over traced functions
+ *
+ * Returns an iterator handle that is used to iterate over all
+ * the records that represent address locations where functions
+ * are traced.
+ *
+ * May return NULL if no records are available.
+ */
+struct ftrace_rec_iter *ftrace_rec_iter_start(void)
+{
+	/*
+	 * We only use a single iterator.
+	 * Protected by the ftrace_lock mutex.
+	 */
+	static struct ftrace_rec_iter ftrace_rec_iter;
+	struct ftrace_rec_iter *iter =3D &ftrace_rec_iter;
+
+	iter->pg =3D ftrace_pages_start;
+	iter->index =3D 0;
+
+	/* Could have empty pages */
+	while (iter->pg && !iter->pg->index)
+		iter->pg =3D iter->pg->next;
+
+	if (!iter->pg)
+		return NULL;
+
+	return iter;
+}
+
+/**
+ * ftrace_rec_iter_next, get the next record to process.
+ * @iter: The handle to the iterator.
+ *
+ * Returns the next iterator after the given iterator @iter.
+ */
+struct ftrace_rec_iter *ftrace_rec_iter_next(struct ftrace_rec_iter *iter)
+{
+	iter->index++;
+
+	if (iter->index >=3D iter->pg->index) {
+		iter->pg =3D iter->pg->next;
+		iter->index =3D 0;
+
+		/* Could have empty pages */
+		while (iter->pg && !iter->pg->index)
+			iter->pg =3D iter->pg->next;
+	}
+
+	if (!iter->pg)
+		return NULL;
+
+	return iter;
+}
+
+/**
+ * ftrace_rec_iter_record, get the record at the iterator location
+ * @iter: The current iterator location
+ *
+ * Returns the record that the current @iter is at.
+ */
+struct dyn_ftrace *ftrace_rec_iter_record(struct ftrace_rec_iter *iter)
+{
+	return &iter->pg->records[iter->index];
+}
+
 static int
 ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
 {
@@ -1617,12 +1765,6 @@ static int __ftrace_modify_code(void *data)
 {
 	int *command =3D data;
=20
-	/*
-	 * Do not call function tracer while we update the code.
-	 * We are in stop machine, no worrying about races.
-	 */
-	function_trace_stop++;
-
 	if (*command & FTRACE_UPDATE_CALLS)
 		ftrace_replace_code(1);
 	else if (*command & FTRACE_DISABLE_CALLS)
@@ -1636,21 +1778,33 @@ static int __ftrace_modify_code(void *data)
 	else if (*command & FTRACE_STOP_FUNC_RET)
 		ftrace_disable_ftrace_graph_caller();
=20
-#ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	/*
-	 * For archs that call ftrace_test_stop_func(), we must
-	 * wait till after we update all the function callers
-	 * before we update the callback. This keeps different
-	 * ops that record different functions from corrupting
-	 * each other.
-	 */
-	__ftrace_trace_function =3D __ftrace_trace_function_delay;
-#endif
-	function_trace_stop--;
-
 	return 0;
 }
=20
+/**
+ * ftrace_run_stop_machine, go back to the stop machine method
+ * @command: The command to tell ftrace what to do
+ *
+ * If an arch needs to fall back to the stop machine method, the
+ * it can call this function.
+ */
+void ftrace_run_stop_machine(int command)
+{
+	stop_machine(__ftrace_modify_code, &command, NULL);
+}
+
+/**
+ * arch_ftrace_update_code, modify the code to trace or not trace
+ * @command: The command that needs to be done
+ *
+ * Archs can override this function if it does not need to
+ * run stop_machine() to modify code.
+ */
+void __weak arch_ftrace_update_code(int command)
+{
+	ftrace_run_stop_machine(command);
+}
+
 static void ftrace_run_update_code(int command)
 {
 	int ret;
@@ -1659,8 +1813,31 @@ static void ftrace_run_update_code(int command)
 	FTRACE_WARN_ON(ret);
 	if (ret)
 		return;
+	/*
+	 * Do not call function tracer while we update the code.
+	 * We are in stop machine.
+	 */
+	function_trace_stop++;
=20
-	stop_machine(__ftrace_modify_code, &command, NULL);
+	/*
+	 * By default we use stop_machine() to modify the code.
+	 * But archs can do what ever they want as long as it
+	 * is safe. The stop_machine() is the safest, but also
+	 * produces the most overhead.
+	 */
+	arch_ftrace_update_code(command);
+
+#ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	/*
+	 * For archs that call ftrace_test_stop_func(), we must
+	 * wait till after we update all the function callers
+	 * before we update the callback. This keeps different
+	 * ops that record different functions from corrupting
+	 * each other.
+	 */
+	__ftrace_trace_function =3D __ftrace_trace_function_delay;
+#endif
+	function_trace_stop--;
=20
 	ret =3D ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMrAAoJEIy3vGnGbaoAfpgP/1mwd1jlfUmJDiPLwnIebQR+
xPYyz3OyNPHpHcpMDQypyk76m+oTtf6Zvfv1NNup/dclD58m4DOxEvYQRx2fT9VL
pjbFg/O63s4BQ3+XD3l+TekpR0YXq7IlytSHOkdySXhU3kj+PjgPHwYLUrdE7jqq
80SJn2SS+ldCUKJvcDDFiXvbKkUT8TLZaRxicyx4AtPWjk5i8F0wi1SX5MIkOere
GzdqioYTuu9ZzgRodi9HxS6zH5M3fkTKyTigGiXJVuF3Zg1bepCmvFmLqQ2FcFrA
dKQIRvlpvvrqppUpJeBH5gbfvSpiyzGGE9TqkF94QhjjRQsS/cZaA77vsTViD2aS
VJe9qPbc1hn16UEXNK3P89IpJAg6LxKo4mK8H18UJUS3mpG1X7Ndr6p6LsCLygQS
jmPmkRunfofNOVv2Ibi609YJ2Zs6A6ZtqxVd6j/p0n9jXHOAM6Iz6DKIDUfzBcdd
04jRhO0ibRKk0T0gHHgOFYt8E3Z73ABsy8PlRCL7Gt3ddNZUPCoTaGNDlJp5hKHv
omD+JxdCRJoKvtXzQiHACbBuQMuRBHd+z5VuGWDaP4oZJhiphCrGaAngKyux7Be1
FHIqk+A2/wh2mRC74B3Dv4kZTMJk+UPUtorAdkL5L4eEswJ++YJmEn+zDeUau+0o
76oObTQFm/ZryEWbLKzQ
=28sd
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
