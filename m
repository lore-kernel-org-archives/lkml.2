Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0DZUCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:02:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0DZUCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:02:46 -0400
X-Authority-Analysis: v=1.1 cv=2/WNtoURsBD4grC4Rqfj62/w1mAETqRJkFX1sgq41IM= c=1 sm=0 a=QyR8828tPesA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=0fnDFiXj42L5JIxQfgcA:9 a=GmvOHe2cAWoExvdFJssA:7 a=eNMWATaJyFXb8nlHEAUiCbhm5X4A:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=-pXw0VrNwDBD7WVA:21 a=kGy8Aq7Nu2hZIv3t:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100426200241.631945432@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 26 Apr 2010 15:50:26 -0400
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
Subject: [PATCH 02/10][RFC] tracing: Let tracepoints have data passed to tracepoint callbacks
References: <20100426195024.256424113@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Let-tracepoints-have-data-passed-to-tracepoi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch allows data to be passed to the tracepoint callbacks
if the tracepoint was created to do so.

If a tracepoint is defined with:

DECLARE_TRACE_DATA(name, proto, args)

Then a registered function can also register data to be passed
to the tracepoint as such:

  DECLARE_TRACE_DATA(mytracepoint, TP_PROTO(int status), TP_ARGS(status));

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
as the data registered is the same. Note, the data must also be used
to unregister the callback:

	unregister_trace_mytracepoint_data(my_callback, my_data);

Because of the data parameter, tracepoints declared this way can not have
no args. That is:

  DECLARE_TRACE_DATA(mytracepoint, TP_PROTO(void), TP_ARGS());

will cause an error, but the original DECLARE_TRACE still allows for this.

The DECLARE_TRACE_DATA() will be used by TRACE_EVENT() so that it
can reuse code and bring the size of the tracepoint footprint down.
This means that TRACE_EVENT()s must have at least one argument defined.
This should not be a problem since we should never have a static
tracepoint in the kernel that simply says "Look I'm here!".

This is part of a series to make the tracepoint footprint smaller:

   text	   data	    bss	    dec	    hex	filename
5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
5792282	1333796	9351592	16477670	 fb6de6	vmlinux.class
5793448	1333780	9351592	16478820	 fb7264	vmlinux.tracepoint

Again, this patch also increases the size of the kernel, but
lays the ground work for decreasing it.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |  103 +++++++++++++++++++++++++++++++++++++------
 kernel/tracepoint.c        |   91 ++++++++++++++++++++++-----------------
 2 files changed, 139 insertions(+), 55 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 78b4bd3..4649bdb 100644
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
@@ -40,20 +45,31 @@ struct tracepoint {
 
 #ifdef CONFIG_TRACEPOINTS
 
+#define _CALL_TRACE(proto, args)					\
+	(void)(it_data);						\
+	((void(*)(proto))(it_func))(args)
+
+#define _CALL_TRACE_DATA(proto, args)					\
+	it_data = (it_func_ptr)->data;					\
+	((void(*)(proto, void *))(it_func))(args, (it_data))
+
 /*
  * it_func[0] is never NULL because there is at least one element in the array
  * when the array itself is non NULL.
  */
-#define __DO_TRACE(tp, proto, args)					\
+#define __DO_TRACE(tp, proto, args, call)				\
 	do {								\
-		void **it_func;						\
+		struct tracepoint_func *it_func_ptr;			\
+		void *it_func;						\
+		void *it_data;						\
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
+				call;					\
+			} while ((++it_func_ptr)->func);		\
 		}							\
 		rcu_read_unlock_sched_notrace();			\
 	} while (0)
@@ -69,17 +85,55 @@ struct tracepoint {
 	{								\
 		if (unlikely(__tracepoint_##name.state))		\
 			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(proto), TP_ARGS(args));	\
+				TP_PROTO(proto), TP_ARGS(args),		\
+				_CALL_TRACE(PARAMS(proto),		\
+					    PARAMS(args)));		\
 	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
-		return tracepoint_probe_register(#name, (void *)probe);	\
+		return tracepoint_probe_register(#name, (void *)probe,	\
+						 NULL);			\
 	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
+	static inline int unregister_trace_##name(void (*probe)(proto)) \
 	{								\
-		return tracepoint_probe_unregister(#name, (void *)probe);\
+		return tracepoint_probe_unregister(#name, (void *)probe,\
+						   NULL);		\
 	}
 
+#define DECLARE_TRACE_DATA(name, proto, args)				\
+	extern struct tracepoint __tracepoint_##name;			\
+	static inline void trace_##name(proto)				\
+	{								\
+		if (unlikely(__tracepoint_##name.state))		\
+			__DO_TRACE(&__tracepoint_##name,		\
+				TP_PROTO(proto), TP_ARGS(args),		\
+				_CALL_TRACE_DATA(PARAMS(proto),		\
+						 PARAMS(args)));	\
+	}								\
+	static inline int register_trace_##name(void (*probe)(proto))	\
+	{								\
+		return tracepoint_probe_register(#name, (void *)probe,	\
+						 NULL);			\
+	}								\
+	static inline int unregister_trace_##name(void (*probe)(proto)) \
+	{								\
+		return tracepoint_probe_unregister(#name, (void *)probe,\
+						   NULL);		\
+	}								\
+	static inline int						\
+	register_trace_##name##_data(void (*probe)(proto, void *data),	\
+				     void *data)			\
+	{								\
+		return tracepoint_probe_register(#name, (void *)probe,	\
+						 data);			\
+	}								\
+	static inline int						\
+	unregister_trace_##name##_data(void (*probe)(proto, void *data),\
+				       void *data)			\
+	{								\
+		return tracepoint_probe_unregister(#name, (void *)probe,\
+						   data);		\
+	}
 
 #define DEFINE_TRACE_FN(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
@@ -114,6 +168,22 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 		return -ENOSYS;						\
 	}
 
+#define DECLARE_TRACE_DATA(name, proto, args)				\
+	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
+	{ }								\
+	static inline void trace_##name(proto)				\
+	{ }								\
+	static inline int						\
+	register_trace_##name(void (*probe)(proto), void *data)		\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline int						\
+	unregister_trace_##name(void (*probe)(proto), void *data)	\
+	{								\
+		return -ENOSYS;						\
+	}
+
 #define DEFINE_TRACE_FN(name, reg, unreg)
 #define DEFINE_TRACE(name)
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
@@ -129,16 +199,19 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
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
-- 
1.7.0


