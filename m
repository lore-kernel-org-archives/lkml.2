Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab0EDDnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 23:43:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab0EDDmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 23:42:07 -0400
X-Authority-Analysis: v=1.1 cv=tamp8Om8S85MB4Qj1n2yU9kNzNdU9gdJUe8fX0YwrYg= c=1 sm=0 a=xaD9flcbkB4A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=dPK6LATMqSyBc66yiScA:9 a=C8CKXqJpEdZu0VzINGgA:7 a=eIe2iWGC6dTDhW-yyNaEDwRh5BgA:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=wzJtgksNoNszNYsY:21 a=YZISQYTyRpHGscHD:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100504034201.896240097@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 03 May 2010 23:40:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 2/9 - v2][RFC] tracing: Let tracepoints have data passed to tracepoint callbacks
References: <20100504034045.085822814@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Let-tracepoints-have-data-passed-to-tracepoi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch allows data to be passed to the tracepoint callbacks
if the tracepoint was created to do so.

The DECLARE_TRACE() now adds two new functions:

	register_trace_mytracepoint_data()
	unregister_trace_mytracepoint_data()

These two are the same as the original

	register_trace_mytracepoint()
	unregister_trace_mytracepoint()

But now allow you to pass a private data pointer that will
be passed to the callback handle. For example:

DECLARE_TRACE(mytracepoint, int value, value);

will create a function called trace_mytracepoint()

	void trace_mytracepoint(int value);

If the user wants to pass data to register a function to this tracepoint
and have data also passed to this callback, they can use:

	int mycallback(int value, void *data);

	register_trace_mytracepoint_data(mycallback, mydata);

Then the mycallback() will receive the "mydata" as the parameter after
the args.

A more detailed example:

  DECLARE_TRACE(mytracepoint, TP_PROTO(int status), TP_ARGS(status));

  /* In the C file */

  DEFINE_TRACE(mytracepoint, TP_PROTO(int status), TP_ARGS(status));

  [...]

       trace_mytacepoint(status);

  /* In a file registering this tracepoint */

  int my_callback(int status, void *data)
  {
	struct my_struct my_data = data;
	[...]
  }

  [...]
	my_data = kmalloc(sizeof(*my_data), GFP_KERNEL);
	init_my_data(my_data);
	register_trace_mytracepoint_data(my_callback, my_data);

The same callback can also be registered to the same tracepoint as long
as the data registered is the different. Note, the data must also be used
to unregister the callback:

	unregister_trace_mytracepoint_data(my_callback, my_data);

Because of the data parameter, tracepoints declared this way can not have
no args. That is:

  DECLARE_TRACE(mytracepoint, TP_PROTO(void), TP_ARGS());

will cause an error.

If no arguments are needed, a new macro can be used instead:

  DECLARE_TRACE_NOARGS(mytracepoint);

Since there are no arguments, the proto and args fields are left out.

This is part of a series to make the tracepoint footprint smaller:

   text	   data	    bss	    dec	    hex	filename
5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
5792282	1333796	9351592	16477670	 fb6de6	vmlinux.class
5793448	1333780	9351592	16478820	 fb7264	vmlinux.tracepoint

Again, this patch also increases the size of the kernel, but
lays the ground work for decreasing it.

 v2: Made the DECLARE_TRACE() have the ability to pass arguments
     and added a new DECLARE_TRACE_NOARGS() for tracepoints that
     do not need any arguments.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h             |   94 +++++++++++++++++++++++++-------
 kernel/tracepoint.c                    |   91 +++++++++++++++++--------------
 samples/tracepoints/tp-samples-trace.h |    4 +-
 3 files changed, 126 insertions(+), 63 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 78b4bd3..ee8059a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -20,12 +20,17 @@
 struct module;
 struct tracepoint;
 
+struct tracepoint_func {
+	void *func;
+	void *data;
+};
+
 struct tracepoint {
 	const char *name;		/* Tracepoint name */
 	int state;			/* State. */
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
-	void **funcs;
+	struct tracepoint_func *funcs;
 } __attribute__((aligned(32)));		/*
 					 * Aligned on 32 bytes because it is
 					 * globally visible and gcc happily
@@ -46,14 +51,18 @@ struct tracepoint {
  */
 #define __DO_TRACE(tp, proto, args)					\
 	do {								\
-		void **it_func;						\
+		struct tracepoint_func *it_func_ptr;			\
+		void *it_func;						\
+		void *__data;						\
 									\
 		rcu_read_lock_sched_notrace();				\
-		it_func = rcu_dereference_sched((tp)->funcs);		\
-		if (it_func) {						\
+		it_func_ptr = rcu_dereference_sched((tp)->funcs);	\
+		if (it_func_ptr) {					\
 			do {						\
-				((void(*)(proto))(*it_func))(args);	\
-			} while (*(++it_func));				\
+				it_func = (it_func_ptr)->func;		\
+				__data = (it_func_ptr)->data;		\
+				((void(*)(proto))(it_func))(args);	\
+			} while ((++it_func_ptr)->func);		\
 		}							\
 		rcu_read_unlock_sched_notrace();			\
 	} while (0)
@@ -63,23 +72,47 @@ struct tracepoint {
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define DECLARE_TRACE(name, proto, args)				\
+#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
 		if (unlikely(__tracepoint_##name.state))		\
 			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(proto), TP_ARGS(args));	\
+				TP_PROTO(data_proto),			\
+				TP_ARGS(data_args));			\
 	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
-		return tracepoint_probe_register(#name, (void *)probe);	\
+		return tracepoint_probe_register(#name, (void *)probe,	\
+						 NULL);			\
+	}								\
+	static inline int unregister_trace_##name(void (*probe)(proto)) \
+	{								\
+		return tracepoint_probe_unregister(#name, (void *)probe,\
+						   NULL);		\
 	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
+	static inline int						\
+	register_trace_##name##_data(void (*probe)(data_proto),		\
+				     void *data)			\
 	{								\
-		return tracepoint_probe_unregister(#name, (void *)probe);\
+		return tracepoint_probe_register(#name, (void *)probe,	\
+						 data);			\
+	}								\
+	static inline int						\
+	unregister_trace_##name##_data(void (*probe)(data_proto),	\
+				       void *data)			\
+	{								\
+		return tracepoint_probe_unregister(#name, (void *)probe,\
+						   data);		\
 	}
 
+#define DECLARE_TRACE_NOARGS(name)					\
+		__DECLARE_TRACE(name, void, , void *__data, __data)
+
+#define DECLARE_TRACE(name, proto, args)				\
+		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
+				PARAMS(proto, void *__data),		\
+				PARAMS(args, __data))
 
 #define DEFINE_TRACE_FN(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
@@ -100,19 +133,37 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end);
 
 #else /* !CONFIG_TRACEPOINTS */
-#define DECLARE_TRACE(name, proto, args)				\
-	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
-	{ }								\
+#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
 	static inline void trace_##name(proto)				\
-	{ }								\
+	{								\
+	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
 		return -ENOSYS;						\
 	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
+	static inline int unregister_trace_##name(void (*probe)(proto)) \
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline int						\
+	register_trace_##name##_data(void (*probe)(data_proto),		\
+				     void *data)			\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline int						\
+	unregister_trace_##name##_data(void (*probe)(data_proto),	\
+				       void *data)			\
 	{								\
 		return -ENOSYS;						\
 	}
+#define DECLARE_TRACE_NOARGS(name)					\
+		__DECLARE_TRACE(name, void, , void *__data, __data)
+
+#define DECLARE_TRACE(name, proto, args)				\
+		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
+				PARAMS(proto, void *__data),		\
+				PARAMS(args, __data))
 
 #define DEFINE_TRACE_FN(name, reg, unreg)
 #define DEFINE_TRACE(name)
@@ -129,16 +180,19 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
  * Connect a probe to a tracepoint.
  * Internal API, should not be used directly.
  */
-extern int tracepoint_probe_register(const char *name, void *probe);
+extern int tracepoint_probe_register(const char *name, void *probe, void *data);
 
 /*
  * Disconnect a probe from a tracepoint.
  * Internal API, should not be used directly.
  */
-extern int tracepoint_probe_unregister(const char *name, void *probe);
+extern int
+tracepoint_probe_unregister(const char *name, void *probe, void *data);
 
-extern int tracepoint_probe_register_noupdate(const char *name, void *probe);
-extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe);
+extern int tracepoint_probe_register_noupdate(const char *name, void *probe,
+					      void *data);
+extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe,
+						void *data);
 extern void tracepoint_probe_update_all(void);
 
 struct tracepoint_iter {
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index cc89be5..c77f3ec 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -54,7 +54,7 @@ static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
  */
 struct tracepoint_entry {
 	struct hlist_node hlist;
-	void **funcs;
+	struct tracepoint_func *funcs;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
 	char name[0];
 };
@@ -64,12 +64,12 @@ struct tp_probes {
 		struct rcu_head rcu;
 		struct list_head list;
 	} u;
-	void *probes[0];
+	struct tracepoint_func probes[0];
 };
 
 static inline void *allocate_probes(int count)
 {
-	struct tp_probes *p  = kmalloc(count * sizeof(void *)
+	struct tp_probes *p  = kmalloc(count * sizeof(struct tracepoint_func)
 			+ sizeof(struct tp_probes), GFP_KERNEL);
 	return p == NULL ? NULL : p->probes;
 }
@@ -79,7 +79,7 @@ static void rcu_free_old_probes(struct rcu_head *head)
 	kfree(container_of(head, struct tp_probes, u.rcu));
 }
 
-static inline void release_probes(void *old)
+static inline void release_probes(struct tracepoint_func *old)
 {
 	if (old) {
 		struct tp_probes *tp_probes = container_of(old,
@@ -95,15 +95,16 @@ static void debug_print_probes(struct tracepoint_entry *entry)
 	if (!tracepoint_debug || !entry->funcs)
 		return;
 
-	for (i = 0; entry->funcs[i]; i++)
-		printk(KERN_DEBUG "Probe %d : %p\n", i, entry->funcs[i]);
+	for (i = 0; entry->funcs[i].func; i++)
+		printk(KERN_DEBUG "Probe %d : %p\n", i, entry->funcs[i].func);
 }
 
-static void *
-tracepoint_entry_add_probe(struct tracepoint_entry *entry, void *probe)
+static struct tracepoint_func *
+tracepoint_entry_add_probe(struct tracepoint_entry *entry,
+			   void *probe, void *data)
 {
 	int nr_probes = 0;
-	void **old, **new;
+	struct tracepoint_func *old, *new;
 
 	WARN_ON(!probe);
 
@@ -111,8 +112,9 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry, void *probe)
 	old = entry->funcs;
 	if (old) {
 		/* (N -> N+1), (N != 0, 1) probes */
-		for (nr_probes = 0; old[nr_probes]; nr_probes++)
-			if (old[nr_probes] == probe)
+		for (nr_probes = 0; old[nr_probes].func; nr_probes++)
+			if (old[nr_probes].func == probe &&
+			    old[nr_probes].data == data)
 				return ERR_PTR(-EEXIST);
 	}
 	/* + 2 : one for new probe, one for NULL func */
@@ -120,9 +122,10 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry, void *probe)
 	if (new == NULL)
 		return ERR_PTR(-ENOMEM);
 	if (old)
-		memcpy(new, old, nr_probes * sizeof(void *));
-	new[nr_probes] = probe;
-	new[nr_probes + 1] = NULL;
+		memcpy(new, old, nr_probes * sizeof(struct tracepoint_func));
+	new[nr_probes].func = probe;
+	new[nr_probes].data = data;
+	new[nr_probes + 1].func = NULL;
 	entry->refcount = nr_probes + 1;
 	entry->funcs = new;
 	debug_print_probes(entry);
@@ -130,10 +133,11 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry, void *probe)
 }
 
 static void *
-tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
+tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
+			      void *probe, void *data)
 {
 	int nr_probes = 0, nr_del = 0, i;
-	void **old, **new;
+	struct tracepoint_func *old, *new;
 
 	old = entry->funcs;
 
@@ -142,8 +146,10 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
 
 	debug_print_probes(entry);
 	/* (N -> M), (N > 1, M >= 0) probes */
-	for (nr_probes = 0; old[nr_probes]; nr_probes++) {
-		if ((!probe || old[nr_probes] == probe))
+	for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
+		if (!probe ||
+		    (old[nr_probes].func == probe &&
+		     old[nr_probes].data == data))
 			nr_del++;
 	}
 
@@ -160,10 +166,11 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
 		new = allocate_probes(nr_probes - nr_del + 1);
 		if (new == NULL)
 			return ERR_PTR(-ENOMEM);
-		for (i = 0; old[i]; i++)
-			if ((probe && old[i] != probe))
+		for (i = 0; old[i].func; i++)
+			if (probe &&
+			    (old[i].func != probe || old[i].data != data))
 				new[j++] = old[i];
-		new[nr_probes - nr_del] = NULL;
+		new[nr_probes - nr_del].func = NULL;
 		entry->refcount = nr_probes - nr_del;
 		entry->funcs = new;
 	}
@@ -315,18 +322,19 @@ static void tracepoint_update_probes(void)
 	module_update_tracepoints();
 }
 
-static void *tracepoint_add_probe(const char *name, void *probe)
+static struct tracepoint_func *
+tracepoint_add_probe(const char *name, void *probe, void *data)
 {
 	struct tracepoint_entry *entry;
-	void *old;
+	struct tracepoint_func *old;
 
 	entry = get_tracepoint(name);
 	if (!entry) {
 		entry = add_tracepoint(name);
 		if (IS_ERR(entry))
-			return entry;
+			return (struct tracepoint_func *)entry;
 	}
-	old = tracepoint_entry_add_probe(entry, probe);
+	old = tracepoint_entry_add_probe(entry, probe, data);
 	if (IS_ERR(old) && !entry->refcount)
 		remove_tracepoint(entry);
 	return old;
@@ -340,12 +348,12 @@ static void *tracepoint_add_probe(const char *name, void *probe)
  * Returns 0 if ok, error value on error.
  * The probe address must at least be aligned on the architecture pointer size.
  */
-int tracepoint_probe_register(const char *name, void *probe)
+int tracepoint_probe_register(const char *name, void *probe, void *data)
 {
-	void *old;
+	struct tracepoint_func *old;
 
 	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_add_probe(name, probe);
+	old = tracepoint_add_probe(name, probe, data);
 	mutex_unlock(&tracepoints_mutex);
 	if (IS_ERR(old))
 		return PTR_ERR(old);
@@ -356,15 +364,16 @@ int tracepoint_probe_register(const char *name, void *probe)
 }
 EXPORT_SYMBOL_GPL(tracepoint_probe_register);
 
-static void *tracepoint_remove_probe(const char *name, void *probe)
+static struct tracepoint_func *
+tracepoint_remove_probe(const char *name, void *probe, void *data)
 {
 	struct tracepoint_entry *entry;
-	void *old;
+	struct tracepoint_func *old;
 
 	entry = get_tracepoint(name);
 	if (!entry)
 		return ERR_PTR(-ENOENT);
-	old = tracepoint_entry_remove_probe(entry, probe);
+	old = tracepoint_entry_remove_probe(entry, probe, data);
 	if (IS_ERR(old))
 		return old;
 	if (!entry->refcount)
@@ -382,12 +391,12 @@ static void *tracepoint_remove_probe(const char *name, void *probe)
  * itself uses stop_machine(), which insures that every preempt disabled section
  * have finished.
  */
-int tracepoint_probe_unregister(const char *name, void *probe)
+int tracepoint_probe_unregister(const char *name, void *probe, void *data)
 {
-	void *old;
+	struct tracepoint_func *old;
 
 	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_remove_probe(name, probe);
+	old = tracepoint_remove_probe(name, probe, data);
 	mutex_unlock(&tracepoints_mutex);
 	if (IS_ERR(old))
 		return PTR_ERR(old);
@@ -418,12 +427,13 @@ static void tracepoint_add_old_probes(void *old)
  *
  * caller must call tracepoint_probe_update_all()
  */
-int tracepoint_probe_register_noupdate(const char *name, void *probe)
+int tracepoint_probe_register_noupdate(const char *name, void *probe,
+				       void *data)
 {
-	void *old;
+	struct tracepoint_func *old;
 
 	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_add_probe(name, probe);
+	old = tracepoint_add_probe(name, probe, data);
 	if (IS_ERR(old)) {
 		mutex_unlock(&tracepoints_mutex);
 		return PTR_ERR(old);
@@ -441,12 +451,13 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_register_noupdate);
  *
  * caller must call tracepoint_probe_update_all()
  */
-int tracepoint_probe_unregister_noupdate(const char *name, void *probe)
+int tracepoint_probe_unregister_noupdate(const char *name, void *probe,
+					 void *data)
 {
-	void *old;
+	struct tracepoint_func *old;
 
 	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_remove_probe(name, probe);
+	old = tracepoint_remove_probe(name, probe, data);
 	if (IS_ERR(old)) {
 		mutex_unlock(&tracepoints_mutex);
 		return PTR_ERR(old);
diff --git a/samples/tracepoints/tp-samples-trace.h b/samples/tracepoints/tp-samples-trace.h
index dffdc49..4d46be9 100644
--- a/samples/tracepoints/tp-samples-trace.h
+++ b/samples/tracepoints/tp-samples-trace.h
@@ -7,7 +7,5 @@
 DECLARE_TRACE(subsys_event,
 	TP_PROTO(struct inode *inode, struct file *file),
 	TP_ARGS(inode, file));
-DECLARE_TRACE(subsys_eventb,
-	TP_PROTO(void),
-	TP_ARGS());
+DECLARE_TRACE_NOARGS(subsys_eventb);
 #endif
-- 
1.7.0


