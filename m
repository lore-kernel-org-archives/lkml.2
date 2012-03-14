Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760365Ab2CNQ1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:27:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2CNQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:27:10 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=mqpRjINo6MAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=rPsebEkEFBZb221JanAA:9 a=CHW4ehtY5R_ZYQNRnCQA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=HbLgpbLnAEnp-dPqeKEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314162707.905821590@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 14 Mar 2012 12:26:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/6] tracing/ring-buffer: Only have tracing_on disable tracing buffers
References: <20120314162629.118638243@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-ring-buffer-Only-have-tracing_on-disable-tra.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

As the ring-buffer code is being used by other facilities in the
kernel, having tracing_on file disable *all* buffers is not a desired
affect. It should only disable the ftrace buffers that are being used.

Move the code into the trace.c file and use the buffer disabling
for tracing_on() and tracing_off(). This way only the ftrace buffers
will be affected by them and other kernel utilities will not be
confused to why their output suddenly stopped.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    3 +
 kernel/trace/ring_buffer.c  |  157 ++++++++++++++++-----------------------=
---
 kernel/trace/trace.c        |  107 +++++++++++++++++++++++++++++
 kernel/trace/trace.h        |    1 +
 4 files changed, 171 insertions(+), 97 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 67be037..7be2e88 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -151,6 +151,9 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, i=
nt cpu);
=20
 void ring_buffer_record_disable(struct ring_buffer *buffer);
 void ring_buffer_record_enable(struct ring_buffer *buffer);
+void ring_buffer_record_off(struct ring_buffer *buffer);
+void ring_buffer_record_on(struct ring_buffer *buffer);
+int ring_buffer_record_is_on(struct ring_buffer *buffer);
 void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu);
 void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
=20
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f5b7b5c..cf8d11e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -154,33 +154,10 @@ enum {
=20
 static unsigned long ring_buffer_flags __read_mostly =3D RB_BUFFERS_ON;
=20
-#define BUF_PAGE_HDR_SIZE offsetof(struct buffer_data_page, data)
-
-/**
- * tracing_on - enable all tracing buffers
- *
- * This function enables all tracing buffers that may have been
- * disabled with tracing_off.
- */
-void tracing_on(void)
-{
-	set_bit(RB_BUFFERS_ON_BIT, &ring_buffer_flags);
-}
-EXPORT_SYMBOL_GPL(tracing_on);
+/* Used for individual buffers (after the counter) */
+#define RB_BUFFER_OFF		(1 << 20)
=20
-/**
- * tracing_off - turn off all tracing buffers
- *
- * This function stops all tracing buffers from recording data.
- * It does not disable any overhead the tracers themselves may
- * be causing. This function simply causes all recording to
- * the ring buffers to fail.
- */
-void tracing_off(void)
-{
-	clear_bit(RB_BUFFERS_ON_BIT, &ring_buffer_flags);
-}
-EXPORT_SYMBOL_GPL(tracing_off);
+#define BUF_PAGE_HDR_SIZE offsetof(struct buffer_data_page, data)
=20
 /**
  * tracing_off_permanent - permanently disable ring buffers
@@ -193,15 +170,6 @@ void tracing_off_permanent(void)
 	set_bit(RB_BUFFERS_DISABLED_BIT, &ring_buffer_flags);
 }
=20
-/**
- * tracing_is_on - show state of ring buffers enabled
- */
-int tracing_is_on(void)
-{
-	return ring_buffer_flags =3D=3D RB_BUFFERS_ON;
-}
-EXPORT_SYMBOL_GPL(tracing_is_on);
-
 #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
 #define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
@@ -2619,6 +2587,63 @@ void ring_buffer_record_enable(struct ring_buffer *b=
uffer)
 EXPORT_SYMBOL_GPL(ring_buffer_record_enable);
=20
 /**
+ * ring_buffer_record_off - stop all writes into the buffer
+ * @buffer: The ring buffer to stop writes to.
+ *
+ * This prevents all writes to the buffer. Any attempt to write
+ * to the buffer after this will fail and return NULL.
+ *
+ * This is different than ring_buffer_record_disable() as
+ * it works like an on/off switch, where as the disable() verison
+ * must be paired with a enable().
+ */
+void ring_buffer_record_off(struct ring_buffer *buffer)
+{
+	unsigned int rd;
+	unsigned int new_rd;
+
+	do {
+		rd =3D atomic_read(&buffer->record_disabled);
+		new_rd =3D rd | RB_BUFFER_OFF;
+	} while (atomic_cmpxchg(&buffer->record_disabled, rd, new_rd) !=3D rd);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_record_off);
+
+/**
+ * ring_buffer_record_on - restart writes into the buffer
+ * @buffer: The ring buffer to start writes to.
+ *
+ * This enables all writes to the buffer that was disabled by
+ * ring_buffer_record_off().
+ *
+ * This is different than ring_buffer_record_enable() as
+ * it works like an on/off switch, where as the enable() verison
+ * must be paired with a disable().
+ */
+void ring_buffer_record_on(struct ring_buffer *buffer)
+{
+	unsigned int rd;
+	unsigned int new_rd;
+
+	do {
+		rd =3D atomic_read(&buffer->record_disabled);
+		new_rd =3D rd & ~RB_BUFFER_OFF;
+	} while (atomic_cmpxchg(&buffer->record_disabled, rd, new_rd) !=3D rd);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_record_on);
+
+/**
+ * ring_buffer_record_is_on - return true if the ring buffer can write
+ * @buffer: The ring buffer to see if write is enabled
+ *
+ * Returns true if the ring buffer is in a state that it accepts writes.
+ */
+int ring_buffer_record_is_on(struct ring_buffer *buffer)
+{
+	return !atomic_read(&buffer->record_disabled);
+}
+
+/**
  * ring_buffer_record_disable_cpu - stop all writes into the cpu_buffer
  * @buffer: The ring buffer to stop writes to.
  * @cpu: The CPU buffer to stop
@@ -4039,68 +4064,6 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_page);
=20
-#ifdef CONFIG_TRACING
-static ssize_t
-rb_simple_read(struct file *filp, char __user *ubuf,
-	       size_t cnt, loff_t *ppos)
-{
-	unsigned long *p =3D filp->private_data;
-	char buf[64];
-	int r;
-
-	if (test_bit(RB_BUFFERS_DISABLED_BIT, p))
-		r =3D sprintf(buf, "permanently disabled\n");
-	else
-		r =3D sprintf(buf, "%d\n", test_bit(RB_BUFFERS_ON_BIT, p));
-
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
-
-static ssize_t
-rb_simple_write(struct file *filp, const char __user *ubuf,
-		size_t cnt, loff_t *ppos)
-{
-	unsigned long *p =3D filp->private_data;
-	unsigned long val;
-	int ret;
-
-	ret =3D kstrtoul_from_user(ubuf, cnt, 10, &val);
-	if (ret)
-		return ret;
-
-	if (val)
-		set_bit(RB_BUFFERS_ON_BIT, p);
-	else
-		clear_bit(RB_BUFFERS_ON_BIT, p);
-
-	(*ppos)++;
-
-	return cnt;
-}
-
-static const struct file_operations rb_simple_fops =3D {
-	.open		=3D tracing_open_generic,
-	.read		=3D rb_simple_read,
-	.write		=3D rb_simple_write,
-	.llseek		=3D default_llseek,
-};
-
-
-static __init int rb_init_debugfs(void)
-{
-	struct dentry *d_tracer;
-
-	d_tracer =3D tracing_init_dentry();
-
-	trace_create_file("tracing_on", 0644, d_tracer,
-			    &ring_buffer_flags, &rb_simple_fops);
-
-	return 0;
-}
-
-fs_initcall(rb_init_debugfs);
-#endif
-
 #ifdef CONFIG_HOTPLUG_CPU
 static int rb_cpu_notify(struct notifier_block *self,
 			 unsigned long action, void *hcpu)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 10d5503..f3c13d6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -352,6 +352,59 @@ static void wakeup_work_handler(struct work_struct *wo=
rk)
 static DECLARE_DELAYED_WORK(wakeup_work, wakeup_work_handler);
=20
 /**
+ * tracing_on - enable tracing buffers
+ *
+ * This function enables tracing buffers that may have been
+ * disabled with tracing_off.
+ */
+void tracing_on(void)
+{
+	if (global_trace.buffer)
+		ring_buffer_record_on(global_trace.buffer);
+	/*
+	 * This flag is only looked at when buffers haven't been
+	 * allocated yet. We don't really care about the race
+	 * between setting this flag and actually turning
+	 * on the buffer.
+	 */
+	global_trace.buffer_disabled =3D 0;
+}
+EXPORT_SYMBOL_GPL(tracing_on);
+
+/**
+ * tracing_off - turn off tracing buffers
+ *
+ * This function stops the tracing buffers from recording data.
+ * It does not disable any overhead the tracers themselves may
+ * be causing. This function simply causes all recording to
+ * the ring buffers to fail.
+ */
+void tracing_off(void)
+{
+	if (global_trace.buffer)
+		ring_buffer_record_on(global_trace.buffer);
+	/*
+	 * This flag is only looked at when buffers haven't been
+	 * allocated yet. We don't really care about the race
+	 * between setting this flag and actually turning
+	 * on the buffer.
+	 */
+	global_trace.buffer_disabled =3D 1;
+}
+EXPORT_SYMBOL_GPL(tracing_off);
+
+/**
+ * tracing_is_on - show state of ring buffers enabled
+ */
+int tracing_is_on(void)
+{
+	if (global_trace.buffer)
+		return ring_buffer_record_is_on(global_trace.buffer);
+	return !global_trace.buffer_disabled;
+}
+EXPORT_SYMBOL_GPL(tracing_is_on);
+
+/**
  * trace_wake_up - wake up tasks waiting for trace input
  *
  * Schedules a delayed work to wake up any task that is blocked on the
@@ -4567,6 +4620,55 @@ static __init void create_trace_options_dir(void)
 		create_trace_option_core_file(trace_options[i], i);
 }
=20
+static ssize_t
+rb_simple_read(struct file *filp, char __user *ubuf,
+	       size_t cnt, loff_t *ppos)
+{
+	struct ring_buffer *buffer =3D filp->private_data;
+	char buf[64];
+	int r;
+
+	if (buffer)
+		r =3D ring_buffer_record_is_on(buffer);
+	else
+		r =3D 0;
+
+	r =3D sprintf(buf, "%d\n", r);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+rb_simple_write(struct file *filp, const char __user *ubuf,
+		size_t cnt, loff_t *ppos)
+{
+	struct ring_buffer *buffer =3D filp->private_data;
+	unsigned long val;
+	int ret;
+
+	ret =3D kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	if (buffer) {
+		if (val)
+			ring_buffer_record_on(buffer);
+		else
+			ring_buffer_record_off(buffer);
+	}
+
+	(*ppos)++;
+
+	return cnt;
+}
+
+static const struct file_operations rb_simple_fops =3D {
+	.open		=3D tracing_open_generic,
+	.read		=3D rb_simple_read,
+	.write		=3D rb_simple_write,
+	.llseek		=3D default_llseek,
+};
+
 static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
@@ -4626,6 +4728,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("trace_clock", 0644, d_tracer, NULL,
 			  &trace_clock_fops);
=20
+	trace_create_file("tracing_on", 0644, d_tracer,
+			    global_trace.buffer, &rb_simple_fops);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
@@ -4863,6 +4968,8 @@ __init static int tracer_alloc_buffers(void)
 		goto out_free_cpumask;
 	}
 	global_trace.entries =3D ring_buffer_size(global_trace.buffer);
+	if (global_trace.buffer_disabled)
+		tracing_off();
=20
=20
 #ifdef CONFIG_TRACER_MAX_TRACE
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 54faec7..ce887c0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -154,6 +154,7 @@ struct trace_array {
 	struct ring_buffer	*buffer;
 	unsigned long		entries;
 	int			cpu;
+	int			buffer_disabled;
 	cycle_t			time_start;
 	struct task_struct	*waiter;
 	struct trace_array_cpu	*data[NR_CPUS];
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPYMbbAAoJEIy3vGnGbaoA5UwP/30R8khnO/6b4Pl/nXPCLr2x
5TJw7HWiGvUDd+3b3sTtnLmVZ8QkaHfrNBHu8PbICx8JSR8iC+C5nrXjXoaPamkQ
A52YfEwPz6GxF76nXn0dHSkLmAf2IQejOTAzrKAPv4BGMUeRMEdS9OucJFt25oFO
l0Ro5gatdzRqvtZIHDPDfsjbbSUpo30TyUnRv0uEqKiKJYKWhYqt2ljzqUzxhvBT
MbjVnvbLiCaSUTVb135UMgPwaeWctnW5HnJ6ia9TtRtvcIy1FGAhDCIxKX8mxRm+
ZAsWwNn+2JB/d2KDL/ejG8RDP9eW5g5oJMlojbin0Nm0DXKBhSW+HbSIjXBVP1QQ
ga87GhDadbQp7BJzzXUgf4NkJ3QRmZE4XA23sGCQpkYNopF4P590NZRvwLUEIoIf
jZGX7t0AUiB+CNTt5FT2zkcc4XKgGJc+5F/g4AAwu5fE/ougixXSk7u7nRWod0oH
ZP4RRoVTiBSGkB3TcaRuvnVDayPkswf9lFfmlVShBJy/WjSIbO5/mFhNQR7l7b3i
U6M7ZqATBbUEvBzUabJMZjXv8IvH4YAvqu9rtZsfdDy2A/wqMF1o29a6nnoiDWFF
l+CZ+yOZC7kLI0fnGS5B+ryQpnt85OPg/M8hmWY1uD1T2WeQClZXzcMVCG84zS8u
8HG5VrQL6SbXckIOMupe
=d7vo
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
