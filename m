Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934850Ab2KBSRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:17:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203Ab2KBSOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:33 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hJFlb0YJowUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ModjrBHf92sA:10 a=20KFwNOVAAAA:8 a=e83X5d5WYuDQz-TBYIUA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=VRlXsIl9l5rApKKqbcIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181431.223651901@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 08/19] tracing: Cache comms only after an event occurred
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Cache-comms-only-after-an-event-occurred.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Whenever an event is registered, the comm of tasks are saved at
every task switch instead of saving them at every event. But if
an event isn't executed much, the comm cache will be filled up
by tasks that did not record the event and you lose out on the comms
that did.

Here's an example, if you enable the following events:

echo 1 > /debug/tracing/events/kvm/kvm_cr/enable
echo 1 > /debug/tracing/events/net/net_dev_xmit/enable

Note, there's no kvm running on this machine so the first event will
never be triggered, but because it is enabled, the storing of comms
will continue. If we now disable the network event:

echo 0 > /debug/tracing/events/net/net_dev_xmit/enable

and look at the trace:

cat /debug/tracing/trace
            sshd-2672  [001] ..s2   375.731616: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6de0 len=3D242 rc=3D0
            sshd-2672  [001] ..s1   375.731617: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6de0 len=3D242 rc=3D0
            sshd-2672  [001] ..s2   375.859356: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6de0 len=3D242 rc=3D0
            sshd-2672  [001] ..s1   375.859357: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6de0 len=3D242 rc=3D0
            sshd-2672  [001] ..s2   375.947351: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6de0 len=3D242 rc=3D0
            sshd-2672  [001] ..s1   375.947352: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6de0 len=3D242 rc=3D0
            sshd-2672  [001] ..s2   376.035383: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6de0 len=3D242 rc=3D0
            sshd-2672  [001] ..s1   376.035383: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6de0 len=3D242 rc=3D0
            sshd-2672  [001] ..s2   377.563806: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6de0 len=3D226 rc=3D0
            sshd-2672  [001] ..s1   377.563807: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6de0 len=3D226 rc=3D0
            sshd-2672  [001] ..s2   377.563834: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6be0 len=3D114 rc=3D0
            sshd-2672  [001] ..s1   377.563842: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6be0 len=3D114 rc=3D0

We see that process 2672 which triggered the events has the comm "sshd".
But if we run hackbench for a bit and look again:

cat /debug/tracing/trace
           <...>-2672  [001] ..s2   375.731616: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6de0 len=3D242 rc=3D0
           <...>-2672  [001] ..s1   375.731617: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6de0 len=3D242 rc=3D0
           <...>-2672  [001] ..s2   375.859356: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6de0 len=3D242 rc=3D0
           <...>-2672  [001] ..s1   375.859357: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6de0 len=3D242 rc=3D0
           <...>-2672  [001] ..s2   375.947351: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6de0 len=3D242 rc=3D0
           <...>-2672  [001] ..s1   375.947352: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6de0 len=3D242 rc=3D0
           <...>-2672  [001] ..s2   376.035383: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6de0 len=3D242 rc=3D0
           <...>-2672  [001] ..s1   376.035383: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6de0 len=3D242 rc=3D0
           <...>-2672  [001] ..s2   377.563806: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6de0 len=3D226 rc=3D0
           <...>-2672  [001] ..s1   377.563807: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6de0 len=3D226 rc=3D0
           <...>-2672  [001] ..s2   377.563834: net_dev_xmit: dev=3Deth0 sk=
baddr=3Dffff88005cbb6be0 len=3D114 rc=3D0
           <...>-2672  [001] ..s1   377.563842: net_dev_xmit: dev=3Dbr0 skb=
addr=3Dffff88005cbb6be0 len=3D114 rc=3D0

The stored "sshd" comm has been flushed out and we get a useless "<...>".

But by only storing comms after a trace event occurred, we can run
hackbench all day and still get the same output.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c                 |   35 ++++++++++++++++++++++++++----=
----
 kernel/trace/trace.h                 |    3 +++
 kernel/trace/trace_branch.c          |    2 +-
 kernel/trace/trace_functions_graph.c |    4 ++--
 4 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b90a827..88111b0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -78,6 +78,13 @@ static int dummy_set_flag(u32 old_flags, u32 bit, int se=
t)
 }
=20
 /*
+ * To prevent the comm cache from being overwritten when no
+ * tracing is active, only save the comm when a trace event
+ * occurred.
+ */
+static DEFINE_PER_CPU(bool, trace_cmdline_save);
+
+/*
  * Kill all tracing for good (never come back).
  * It is initialized to 1 but will turn to zero if the initialization
  * of the tracer is successful. But that is the only place that sets
@@ -1135,6 +1142,11 @@ void tracing_record_cmdline(struct task_struct *tsk)
 	    !tracing_is_on())
 		return;
=20
+	if (!__this_cpu_read(trace_cmdline_save))
+		return;
+
+	__this_cpu_write(trace_cmdline_save, false);
+
 	trace_save_cmdline(tsk);
 }
=20
@@ -1178,13 +1190,20 @@ trace_buffer_lock_reserve(struct ring_buffer *buffe=
r,
 	return event;
 }
=20
+void
+__buffer_unlock_commit(struct ring_buffer *buffer, struct ring_buffer_even=
t *event)
+{
+	__this_cpu_write(trace_cmdline_save, true);
+	ring_buffer_unlock_commit(buffer, event);
+}
+
 static inline void
 __trace_buffer_unlock_commit(struct ring_buffer *buffer,
 			     struct ring_buffer_event *event,
 			     unsigned long flags, int pc,
 			     int wake)
 {
-	ring_buffer_unlock_commit(buffer, event);
+	__buffer_unlock_commit(buffer, event);
=20
 	ftrace_trace_stack(buffer, flags, 6, pc);
 	ftrace_trace_userstack(buffer, flags, pc);
@@ -1232,7 +1251,7 @@ void trace_nowake_buffer_unlock_commit_regs(struct ri=
ng_buffer *buffer,
 					    unsigned long flags, int pc,
 					    struct pt_regs *regs)
 {
-	ring_buffer_unlock_commit(buffer, event);
+	__buffer_unlock_commit(buffer, event);
=20
 	ftrace_trace_stack_regs(buffer, flags, 0, pc, regs);
 	ftrace_trace_userstack(buffer, flags, pc);
@@ -1269,7 +1288,7 @@ trace_function(struct trace_array *tr,
 	entry->parent_ip		=3D parent_ip;
=20
 	if (!filter_check_discard(call, entry, buffer, event))
-		ring_buffer_unlock_commit(buffer, event);
+		__buffer_unlock_commit(buffer, event);
 }
=20
 void
@@ -1362,7 +1381,7 @@ static void __ftrace_trace_stack(struct ring_buffer *=
buffer,
 	entry->size =3D trace.nr_entries;
=20
 	if (!filter_check_discard(call, entry, buffer, event))
-		ring_buffer_unlock_commit(buffer, event);
+		__buffer_unlock_commit(buffer, event);
=20
  out:
 	/* Again, don't let gcc optimize things here */
@@ -1458,7 +1477,7 @@ ftrace_trace_userstack(struct ring_buffer *buffer, un=
signed long flags, int pc)
=20
 	save_stack_trace_user(&trace);
 	if (!filter_check_discard(call, entry, buffer, event))
-		ring_buffer_unlock_commit(buffer, event);
+		__buffer_unlock_commit(buffer, event);
=20
  out_drop_count:
 	__this_cpu_dec(user_stack_count);
@@ -1653,7 +1672,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt,=
 va_list args)
=20
 	memcpy(entry->buf, tbuffer, sizeof(u32) * len);
 	if (!filter_check_discard(call, entry, buffer, event)) {
-		ring_buffer_unlock_commit(buffer, event);
+		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
=20
@@ -1724,7 +1743,7 @@ int trace_array_vprintk(struct trace_array *tr,
 	memcpy(&entry->buf, tbuffer, len);
 	entry->buf[len] =3D '\0';
 	if (!filter_check_discard(call, entry, buffer, event)) {
-		ring_buffer_unlock_commit(buffer, event);
+		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
  out:
@@ -3993,7 +4012,7 @@ tracing_mark_write(struct file *filp, const char __us=
er *ubuf,
 	} else
 		entry->buf[cnt] =3D '\0';
=20
-	ring_buffer_unlock_commit(buffer, event);
+	__buffer_unlock_commit(buffer, event);
=20
 	written =3D cnt;
=20
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7824a55..839ae00 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -359,6 +359,9 @@ struct trace_entry *tracing_get_trace_entry(struct trac=
e_array *tr,
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 					  int *ent_cpu, u64 *ent_ts);
=20
+void __buffer_unlock_commit(struct ring_buffer *buffer,
+			    struct ring_buffer_event *event);
+
 int trace_empty(struct trace_iterator *iter);
=20
 void *trace_find_next_entry_inc(struct trace_iterator *iter);
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index bd3e0ee..95e9684 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -77,7 +77,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int =
val, int expect)
 	entry->correct =3D val =3D=3D expect;
=20
 	if (!filter_check_discard(call, entry, buffer, event))
-		ring_buffer_unlock_commit(buffer, event);
+		__buffer_unlock_commit(buffer, event);
=20
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_func=
tions_graph.c
index a84b558..4edb4b7 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -223,7 +223,7 @@ int __trace_graph_entry(struct trace_array *tr,
 	entry	=3D ring_buffer_event_data(event);
 	entry->graph_ent			=3D *trace;
 	if (!filter_current_check_discard(buffer, call, entry, event))
-		ring_buffer_unlock_commit(buffer, event);
+		__buffer_unlock_commit(buffer, event);
=20
 	return 1;
 }
@@ -327,7 +327,7 @@ void __trace_graph_return(struct trace_array *tr,
 	entry	=3D ring_buffer_event_data(event);
 	entry->ret				=3D *trace;
 	if (!filter_current_check_discard(buffer, call, entry, event))
-		ring_buffer_unlock_commit(buffer, event);
+		__buffer_unlock_commit(buffer, event);
 }
=20
 void trace_graph_return(struct ftrace_graph_ret *trace)
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2HAAoJEOdOSU1xswtMI4oH/0RjoZdWRHfw40C2hG3S7ruX
QM5u/9vhKa4SYJkxiwMdPXVMkr6Z602jsfabaA9UsGQK/CyLihArKEvYv9SS1ADm
blp3VHEi/xjLhdnlhbw7wbBw+qPfrUp5+F7cfBrpuhUtmQs5CpSzGlCvJbO/NY2o
iiys94QwecqzZO9uA+fmkv4SKNRbjsZYxqIcRMC2flC3KOe34HiDpsEmm5vAQgWu
urar19ZbhPoSFDcYd4c+o3y1J5ul3YYuOQP1E5qJrw8a+ubAB/nG0P7aUKSX7kk9
sqLlgqw7yb7SopwIC9M49dhiaSn+6+vwfIHRGlUgH3JTuitwO+w8qAfkEyfETo4=
=rgmn
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
