Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2EaRd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:33:26 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44161 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab2EaRdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:33:25 -0400
Date: Thu, 31 May 2012 19:33:51 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
Message-ID: <20120531173351.GP14515@aftab.osrc.amd.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-2-git-send-email-bp@amd64.org>
 <1337336040.573.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337336040.573.12.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 12:14:00PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-03-21 at 15:34 +0100, Borislav Petkov wrote:
> > +int perf_add_persistent_on_cpu(int cpu, struct pers_event_desc *desc,
> > +                              struct dentry *dir, unsigned nr_pages) 
> 
> OK, so this creates an even and registers it somewhere in debugfs.
> 
>  - you allow an arbitrary place in debugfs; this might make finding them
> 'interesting'. Should we put them all in the same place?
> 
>  - persistent events created from userspace don't seem to get a debugfs
> entry and will be lost forever?
> 
> In general I think a little more exploring of the semantics and
> ramifications might be in order.

Ok, how about the following. This is rough and not in any way ready - it
is supposed to feel out how you guys feel about it. Basically, it adds
another file in (debugfs)/tracing/events/<subsys>/<event_name>/ which
can be used for whatever.

In the persistent event case, I get this:

/mnt/dbg/tracing/events/mce/mce_record/
|-- enable
|-- filter
|-- format
|-- id
`-- pers

and 'pers' contains the file descriptor of the perf per-cpu buffer which
I can mmap in userspace. I can read that out later.

Other events can put other files in there containing other relevant
stuff for them.

The interface trace_add_file() is pretty generic (it can be done
even more so). It is not design-finished - it is only meant to show
the intent. Oh, and don't look at bob_add_trace_file() - it is a
quick'n'dirty hack for testing :-).

So, what do you guys think, Peter, Steven?

Thanks.

--
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 176a939d1547..1c13fb5e9a50 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -222,6 +222,8 @@ struct ftrace_event_call {
 #ifdef CONFIG_PERF_EVENTS
 	int				perf_refcount;
 	struct hlist_head __percpu	*perf_events;
+	/* persistent event filedes */
+	int				pers_fd;
 #endif
 };
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29111da1d100..57ad0fbe0aef 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -980,6 +980,29 @@ show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 	return r;
 }
 
+static ssize_t
+event_pers_fd_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct ftrace_event_call *call = filp->private_data;
+	struct trace_seq *s;
+	int r;
+
+	if (*ppos)
+		return 0;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+	trace_seq_printf(s, "%d\n", call->pers_fd);
+
+	r = simple_read_from_buffer(ubuf, cnt, ppos,
+				    s->buffer, s->len);
+	kfree(s);
+	return r;
+}
+
 static const struct seq_operations show_event_seq_ops = {
 	.start = t_start,
 	.next = t_next,
@@ -1058,6 +1081,12 @@ static const struct file_operations ftrace_show_header_fops = {
 	.llseek = default_llseek,
 };
 
+static const struct file_operations ftrace_persistent_fops = {
+	.open = tracing_open_generic,
+	.read = event_pers_fd_read,
+	.llseek = default_llseek,
+};
+
 static struct dentry *event_trace_events_dir(void)
 {
 	static struct dentry *d_tracer;
@@ -1199,6 +1228,56 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	return 0;
 }
 
+static int __trace_add_file(struct ftrace_event_call *call, const char *fname,
+			    umode_t mode, const struct file_operations *fops)
+{
+	int ret = 0;
+	mutex_lock(&event_mutex);
+
+	if (!trace_create_file(fname, mode, call->dir, call, fops))
+		ret = -EINVAL;
+
+	mutex_unlock(&event_mutex);
+	return ret;
+}
+
+extern struct ftrace_event_call *__start_ftrace_events[];
+extern struct ftrace_event_call *__stop_ftrace_events[];
+
+#define for_each_event(event, start, end)			\
+	for (event = start;					\
+	     (unsigned long)event < (unsigned long)end;		\
+	     event++)
+
+/*
+ * Assumptions:
+ * - event debugfs dir is already initialized
+ * - trace event is not declared in a module
+ */
+int trace_add_file(const char *dir_name, const char *fname, umode_t mode,
+		   const struct file_operations *fops)
+{
+	struct ftrace_event_call *call;
+
+	if (!strlen(fname))
+		return -EINVAL;
+
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (!strncmp(call->name, dir_name, strlen(dir_name)))
+			return __trace_add_file(call, fname, mode, fops);
+	}
+	return -EINVAL;
+}
+
+static __init int bob_add_trace_file(void)
+{
+	int ret = 0;
+
+	ret = trace_add_file("mce_record", "pers", 0444, &ftrace_persistent_fops);
+
+	return ret;
+}
+
 static int
 __trace_add_event_call(struct ftrace_event_call *call, struct module *mod,
 		       const struct file_operations *id,
@@ -1292,11 +1371,6 @@ void trace_remove_event_call(struct ftrace_event_call *call)
 	mutex_unlock(&event_mutex);
 }
 
-#define for_each_event(event, start, end)			\
-	for (event = start;					\
-	     (unsigned long)event < (unsigned long)end;		\
-	     event++)
-
 #ifdef CONFIG_MODULES
 
 static LIST_HEAD(ftrace_module_file_list);
@@ -1435,9 +1509,6 @@ static struct notifier_block trace_module_nb = {
 	.priority = 0,
 };
 
-extern struct ftrace_event_call *__start_ftrace_events[];
-extern struct ftrace_event_call *__stop_ftrace_events[];
-
 static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
 
 static __init int setup_trace_event(char *str)
@@ -1753,3 +1824,4 @@ static __init int event_trace_self_tests_init(void)
 late_initcall(event_trace_self_tests_init);
 
 #endif
+late_initcall(bob_add_trace_file);


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
