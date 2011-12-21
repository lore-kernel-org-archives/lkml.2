Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1LUMlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:41:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab1LUMiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:06 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=P-MctEiuskcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=6WOmNk-UtHAHClD5LlIA:9 a=uRCH1OAuNXXzK-pAPcsA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=XAcaTGMwx7r_w-Ew7dkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123802.290698996@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, stable@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/16] ftrace: Fix unregister ftrace_ops accounting
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Fix-unregister-ftrace_ops-accounting.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Multiple users of the function tracer can register their functions
with the ftrace_ops structure. The accounting within ftrace will
update the counter on each function record that is being traced.
When the ftrace_ops filtering adds or removes functions, the
function records will be updated accordingly if the ftrace_ops is
still registered.

When a ftrace_ops is removed, the counter of the function records,
that the ftrace_ops traces, are decremented. When they reach zero
the functions that they represent are modified to stop calling the
mcount code.

When changes are made, the code is updated via stop_machine() with
a command passed to the function to tell it what to do. There is an
ENABLE and DISABLE command that tells the called function to enable
or disable the functions. But the ENABLE is really a misnomer as it
should just update the records, as records that have been enabled
and now have a count of zero should be disabled.

The DISABLE command is used to disable all functions regardless of
their counter values. This is the big off switch and is not the
complement of the ENABLE command.

To make matters worse, when a ftrace_ops is unregistered and there
is another ftrace_ops registered, neither the DISABLE nor the
ENABLE command are set when calling into the stop_machine() function
and the records will not be updated to match their counter. A command
is passed to that function that will update the mcount code to call
the registered callback directly if it is the only one left. This
means that the ftrace_ops that is still registered will have its callback
called by all functions that have been set for it as well as the ftrace_ops
that was just unregistered.

Here's a way to trigger this bug. Compile the kernel with
CONFIG_FUNCTION_PROFILER set and with CONFIG_FUNCTION_GRAPH not set:

 CONFIG_FUNCTION_PROFILER=3Dy
 # CONFIG_FUNCTION_GRAPH is not set

This will force the function profiler to use the function tracer instead
of the function graph tracer.

  # cd /sys/kernel/debug/tracing
  # echo schedule > set_ftrace_filter
  # echo function > current_tracer
  # cat set_ftrace_filter
 schedule
  # cat trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 692/68108025   #P:4
 #
 #                              _-----=3D> irqs-off
 #                             / _----=3D> need-resched
 #                            | / _---=3D> hardirq/softirq
 #                            || / _--=3D> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
      kworker/0:2-909   [000] ....   531.235574: schedule <-worker_thread
           <idle>-0     [001] .N..   531.235575: schedule <-cpu_idle
      kworker/0:2-909   [000] ....   531.235597: schedule <-worker_thread
             sshd-2563  [001] ....   531.235647: schedule <-schedule_hrtime=
out_range_clock

  # echo 1 > function_profile_enabled
  # echo 0 > function_porfile_enabled
  # cat set_ftrace_filter
 schedule
  # cat trace
 # tracer: function
 #
 # entries-in-buffer/entries-written: 159701/118821262   #P:4
 #
 #                              _-----=3D> irqs-off
 #                             / _----=3D> need-resched
 #                            | / _---=3D> hardirq/softirq
 #                            || / _--=3D> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
           <idle>-0     [002] ...1   604.870655: local_touch_nmi <-cpu_idle
           <idle>-0     [002] d..1   604.870655: enter_idle <-cpu_idle
           <idle>-0     [002] d..1   604.870656: atomic_notifier_call_chain=
 <-enter_idle
           <idle>-0     [002] d..1   604.870656: __atomic_notifier_call_cha=
in <-atomic_notifier_call_chain

The same problem could have happened with the trace_probe_ops,
but they are modified with the set_frace_filter file which does the
update at closure of the file.

The simple solution is to change ENABLE to UPDATE and call it every
time an ftrace_ops is unregistered.

Link: http://lkml.kernel.org/r/1323105776-26961-3-git-send-email-jolsa@redh=
at.com

Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b1e8943..25b4f4d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -948,7 +948,7 @@ struct ftrace_func_probe {
 };
=20
 enum {
-	FTRACE_ENABLE_CALLS		=3D (1 << 0),
+	FTRACE_UPDATE_CALLS		=3D (1 << 0),
 	FTRACE_DISABLE_CALLS		=3D (1 << 1),
 	FTRACE_UPDATE_TRACE_FUNC	=3D (1 << 2),
 	FTRACE_START_FUNC_RET		=3D (1 << 3),
@@ -1519,7 +1519,7 @@ int ftrace_text_reserved(void *start, void *end)
=20
=20
 static int
-__ftrace_replace_code(struct dyn_ftrace *rec, int enable)
+__ftrace_replace_code(struct dyn_ftrace *rec, int update)
 {
 	unsigned long ftrace_addr;
 	unsigned long flag =3D 0UL;
@@ -1527,17 +1527,17 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int e=
nable)
 	ftrace_addr =3D (unsigned long)FTRACE_ADDR;
=20
 	/*
-	 * If we are enabling tracing:
+	 * If we are updating calls:
 	 *
 	 *   If the record has a ref count, then we need to enable it
 	 *   because someone is using it.
 	 *
 	 *   Otherwise we make sure its disabled.
 	 *
-	 * If we are disabling tracing, then disable all records that
+	 * If we are disabling calls, then disable all records that
 	 * are enabled.
 	 */
-	if (enable && (rec->flags & ~FTRACE_FL_MASK))
+	if (update && (rec->flags & ~FTRACE_FL_MASK))
 		flag =3D FTRACE_FL_ENABLED;
=20
 	/* If the state of this record hasn't changed, then do nothing */
@@ -1553,7 +1553,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int ena=
ble)
 	return ftrace_make_nop(NULL, rec, ftrace_addr);
 }
=20
-static void ftrace_replace_code(int enable)
+static void ftrace_replace_code(int update)
 {
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
@@ -1567,7 +1567,7 @@ static void ftrace_replace_code(int enable)
 		if (rec->flags & FTRACE_FL_FREE)
 			continue;
=20
-		failed =3D __ftrace_replace_code(rec, enable);
+		failed =3D __ftrace_replace_code(rec, update);
 		if (failed) {
 			ftrace_bug(failed, rec->ip);
 			/* Stop processing */
@@ -1623,7 +1623,7 @@ static int __ftrace_modify_code(void *data)
 	 */
 	function_trace_stop++;
=20
-	if (*command & FTRACE_ENABLE_CALLS)
+	if (*command & FTRACE_UPDATE_CALLS)
 		ftrace_replace_code(1);
 	else if (*command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);
@@ -1691,7 +1691,7 @@ static int ftrace_startup(struct ftrace_ops *ops, int=
 command)
 		return -ENODEV;
=20
 	ftrace_start_up++;
-	command |=3D FTRACE_ENABLE_CALLS;
+	command |=3D FTRACE_UPDATE_CALLS;
=20
 	/* ops marked global share the filter hashes */
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
@@ -1743,8 +1743,7 @@ static void ftrace_shutdown(struct ftrace_ops *ops, i=
nt command)
 	if (ops !=3D &global_ops || !global_start_up)
 		ops->flags &=3D ~FTRACE_OPS_FL_ENABLED;
=20
-	if (!ftrace_start_up)
-		command |=3D FTRACE_DISABLE_CALLS;
+	command |=3D FTRACE_UPDATE_CALLS;
=20
 	if (saved_ftrace_func !=3D ftrace_trace_function) {
 		saved_ftrace_func =3D ftrace_trace_function;
@@ -1766,7 +1765,7 @@ static void ftrace_startup_sysctl(void)
 	saved_ftrace_func =3D NULL;
 	/* ftrace_start_up is true if we want ftrace running */
 	if (ftrace_start_up)
-		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+		ftrace_run_update_code(FTRACE_UPDATE_CALLS);
 }
=20
 static void ftrace_shutdown_sysctl(void)
@@ -2919,7 +2918,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned cha=
r *buf, int len,
 	ret =3D ftrace_hash_move(ops, enable, orig_hash, hash);
 	if (!ret && ops->flags & FTRACE_OPS_FL_ENABLED
 	    && ftrace_enabled)
-		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+		ftrace_run_update_code(FTRACE_UPDATE_CALLS);
=20
 	mutex_unlock(&ftrace_lock);
=20
@@ -3107,7 +3106,7 @@ ftrace_regex_release(struct inode *inode, struct file=
 *file)
 				       orig_hash, iter->hash);
 		if (!ret && (iter->ops->flags & FTRACE_OPS_FL_ENABLED)
 		    && ftrace_enabled)
-			ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+			ftrace_run_update_code(FTRACE_UPDATE_CALLS);
=20
 		mutex_unlock(&ftrace_lock);
 	}
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMqAAoJEIy3vGnGbaoAdR4QAKRSSoIJjcr+vdFQFf56zFY3
KuX1y8X2773Xv38UGHzDeKtRZCBPWyf6uVqO7C5MXvjIiYgoButIGivttPGLU+PA
4oXeW7Di2RhVjnn43OhjqLDK9fJSJDZE36kZON6Ymsn9qKhQDD1F4EC5CCC1TwCV
yV/Xo/CGqLZ81iC3WzwSjq9Ygg/ops+tM8ZcKu1E2Vk8rpgixCNwVKg4o3d6bxk4
OaTHm2Flb/qijAEVFko6UdAb6KSsEMqqPPRrqI78i/807s466CYKue6KDfIHD2AM
gBHLU/hYSgfSDaRdNefKVJNXmQsyM+i7OCPjiqBdjWA7deZaVaqO5ViG6eq8rRRS
kQcFroZ88LeV6Zk0UMkLxgyO9r4B73mDrDTXu6+TniwI/Kspvsiov+bXoE/HQ/Xl
gQRahT/lk0tIY0GfwRScO07+O7K3V2lEbZSGXFTiQOhoT2FBFuXQoYZRHm3QR4Go
e0W6+1aZucJqgnRQP4GjBoyT/ksTglkEG8dXetfkm9enDH2HXeUIpy4k8QO0H7Od
QacljggAcaKxsUYoGNQMrjTWAFyB6Zo/sdFwi5IyxTHY+S04I2/jRfDrzCuq2xGf
3OV1Ok9gs26o9NV7vnD6yuieAxPmjIK70tVqrPURikMdCo5dn4CttBxzMdRj6WAb
E4SAV4JQK97E7u+AfG3R
=7Oeu
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
