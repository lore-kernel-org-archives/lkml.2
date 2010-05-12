Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0ELPak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:30:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33303 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0ELP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:28:55 -0400
X-Authority-Analysis: v=1.1 cv=QBaIlYAip0cLYvdi/Wu3On4+kilSXYulM+a9j4asJ0c= c=1 sm=0 a=xJnypZoNGmcA:10 a=ygRHs6EKU7oA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=vmLDa1wCAAAA:8 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=kl_pvKir52qzfsXi2ZoA:9 a=pTsjDQxXoI1KnR0XY8EA:7 a=z96ihmnubhSCdBzxmM_JafnseRUA:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=gv_BBZfBKR8A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=tDGXR4jOi7u2f7vA:21 a=Vpz_8AbWt4Uk2VYO:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100512152852.960305992@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 12 May 2010 11:28:13 -0400
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
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 03/10 final] tracing: Let tracepoints have data passed to tracepoint callbacks
References: <20100512152810.819338250@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Let-tracepoints-have-data-passed-to-tracepoi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds data to be passed to tracepoint callbacks.

The created functions from DECLARE_TRACE() now need a mandatory data
parameter. For example:

DECLARE_TRACE(mytracepoint, int value, value)

Will create the register function:

int register_trace_mytracepoint((void(*)(void *data, int value))probe,
                                void *data);

As the first argument, all callbacks (probes) must take a (void *data)
parameter. So a callback for the above tracepoint will look like:

void myprobe(void *data, int value)
{
}

The callback may choose to ignore the data parameter.

This change allows callbacks to register a private data pointer along
with the function probe.

	void mycallback(void *data, int value);

	register_trace_mytracepoint(mycallback, mydata);

Then the mycallback() will receive the "mydata" as the first parameter
before the args.

A more detailed example:

  DECLARE_TRACE(mytracepoint, TP_PROTO(int status), TP_ARGS(status));

  /* In the C file */

  DEFINE_TRACE(mytracepoint, TP_PROTO(int status), TP_ARGS(status));

  [...]

       trace_mytracepoint(status);

  /* In a file registering this tracepoint */

  int my_callback(void *data, int status)
  {
	struct my_struct my_data = data;
	[...]
  }

  [...]
	my_data = kmalloc(sizeof(*my_data), GFP_KERNEL);
	init_my_data(my_data);
	register_trace_mytracepoint(my_callback, my_data);

The same callback can also be registered to the same tracepoint as long
as the data registered is different. Note, the data must also be used
to unregister the callback:

	unregister_trace_mytracepoint(my_callback, my_data);

Because of the data parameter, tracepoints declared this way can not have
no args. That is:

  DECLARE_TRACE(mytracepoint, TP_PROTO(void), TP_ARGS());

will cause an error.

If no arguments are needed, a new macro can be used instead:

  DECLARE_TRACE_NOARGS(mytracepoint);

Since there are no arguments, the proto and args fields are left out.

This is part of a series to make the tracepoint footprint smaller:

   text	   data	    bss	    dec	    hex	filename
4913961	1088356	 861512	6863829	 68bbd5	vmlinux.orig
4914025	1088868	 861512	6864405	 68be15	vmlinux.class
4918492	1084612	 861512	6864616	 68bee8	vmlinux.tracepoint

Again, this patch also increases the size of the kernel, but
lays the ground work for decreasing it.

 v5: Fixed net/core/drop_monitor.c to handle these updates.

 v4: Moved the DECLARE_TRACE() DECLARE_TRACE_NOARGS out of the
     #ifdef CONFIG_TRACE_POINTS, since the two are the same in both
     cases. The __DECLARE_TRACE() is what changes.
     Thanks to Frederic Weisbecker for pointing this out.

 v3: Made all register_* functions require data to be passed and
     all callbacks to take a void * parameter as its first argument.
     This makes the calling functions comply with C standards.

     Also added more comments to the modifications of DECLARE_TRACE().

 v2: Made the DECLARE_TRACE() have the ability to pass arguments
     and added a new DECLARE_TRACE_NOARGS() for tracepoints that
     do not need any arguments.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h                     |   95 ++++++++++++++-----
 include/trace/ftrace.h                         |   14 ++--
 kernel/trace/blktrace.c                        |  125 +++++++++++++-----------
 kernel/trace/ftrace.c                          |    7 +-
 kernel/trace/kmemtrace.c                       |   42 +++++----
 kernel/trace/trace_sched_switch.c              |   23 +++--
 kernel/trace/trace_sched_wakeup.c              |   27 +++---
 kernel/trace/trace_syscalls.c                  |   24 +++---
 kernel/trace/trace_workqueue.c                 |   26 +++--
 kernel/tracepoint.c                            |   91 ++++++++++--------
 net/core/drop_monitor.c                        |   12 +-
 samples/tracepoints/tp-samples-trace.h         |    4 +-
 samples/tracepoints/tracepoint-probe-sample.c  |   13 ++-
 samples/tracepoints/tracepoint-probe-sample2.c |    7 +-
 14 files changed, 299 insertions(+), 211 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 8d5e4f6..9a59d1f 100644
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
@@ -37,16 +42,19 @@ struct tracepoint {
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
@@ -102,17 +110,27 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 /*
  * it_func[0] is never NULL because there is at least one element in the array
  * when the array itself is non NULL.
+ *
+ * Note, the proto and args passed in includes "__data" as the first parameter.
+ * The reason for this is to handle the "void" prototype. If a tracepoint
+ * has a "void" prototype, then it is invalid to declare a function
+ * as "(void *, void)". The DECLARE_TRACE_NOARGS() will pass in just
+ * "void *data", where as the DECLARE_TRACE() will pass in "void *data, proto".
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
@@ -122,23 +140,29 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
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
-	static inline int register_trace_##name(void (*probe)(proto))	\
+	static inline int						\
+	register_trace_##name(void (*probe)(data_proto), void *data)	\
 	{								\
-		return tracepoint_probe_register(#name, (void *)probe);	\
+		return tracepoint_probe_register(#name, (void *)probe,	\
+						 data);			\
 	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
+	static inline int						\
+	unregister_trace_##name(void (*probe)(data_proto), void *data)	\
 	{								\
-		return tracepoint_probe_unregister(#name, (void *)probe);\
+		return tracepoint_probe_unregister(#name, (void *)probe, \
+						   data);		\
 	}								\
-	static inline void check_trace_callback_type_##name(void (*cb)(proto)) \
+	static inline void						\
+	check_trace_callback_type_##name(void (*cb)(data_proto))	\
 	{								\
 	}
 
@@ -158,20 +182,22 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	EXPORT_SYMBOL(__tracepoint_##name)
 
 #else /* !CONFIG_TRACEPOINTS */
-#define DECLARE_TRACE(name, proto, args)				\
-	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
-	{ }								\
+#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
 	static inline void trace_##name(proto)				\
 	{ }								\
-	static inline int register_trace_##name(void (*probe)(proto))	\
+	static inline int						\
+	register_trace_##name(void (*probe)(data_proto),		\
+			      void *data)				\
 	{								\
 		return -ENOSYS;						\
 	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
+	static inline int						\
+	unregister_trace_##name(void (*probe)(data_proto),		\
+				void *data)				\
 	{								\
 		return -ENOSYS;						\
 	}								\
-	static inline void check_trace_callback_type_##name(void (*cb)(proto)) \
+	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
 	{								\
 	}
 
@@ -181,6 +207,29 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 #define EXPORT_TRACEPOINT_SYMBOL(name)
 
 #endif /* CONFIG_TRACEPOINTS */
+
+/*
+ * The need for the DECLARE_TRACE_NOARGS() is to handle the prototype
+ * (void). "void" is a special value in a function prototype and can
+ * not be combined with other arguments. Since the DECLARE_TRACE()
+ * macro adds a data element at the beginning of the prototype,
+ * we need a way to differentiate "(void *data, proto)" from
+ * "(void *data, void)". The second prototype is invalid.
+ *
+ * DECLARE_TRACE_NOARGS() passes "void" as the tracepoint prototype
+ * and "void *__data" as the callback prototype.
+ *
+ * DECLARE_TRACE() passes "proto" as the tracepoint protoype and
+ * "void *__data, proto" as the callback prototype.
+ */
+#define DECLARE_TRACE_NOARGS(name)					\
+		__DECLARE_TRACE(name, void, , void *__data, __data)
+
+#define DECLARE_TRACE(name, proto, args)				\
+		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
+				PARAMS(void *__data, proto),		\
+				PARAMS(__data, args))
+
 #endif /* DECLARE_TRACE */
 
 #ifndef TRACE_EVENT
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7dcdfd8..ba28b64 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -406,18 +406,18 @@ static inline notrace int ftrace_get_offsets_##call(			\
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)			\
 									\
-static void perf_trace_##name(proto);					\
+static void perf_trace_##name(void *, proto);				\
 									\
 static notrace int							\
 perf_trace_enable_##name(struct ftrace_event_call *unused)		\
 {									\
-	return register_trace_##name(perf_trace_##name);		\
+	return register_trace_##name(perf_trace_##name, NULL);		\
 }									\
 									\
 static notrace void							\
 perf_trace_disable_##name(struct ftrace_event_call *unused)		\
 {									\
-	unregister_trace_##name(perf_trace_##name);			\
+	unregister_trace_##name(perf_trace_##name, NULL);		\
 }
 
 #undef DEFINE_EVENT_PRINT
@@ -578,7 +578,7 @@ ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
 									\
-static notrace void ftrace_raw_event_##call(proto)			\
+static notrace void ftrace_raw_event_##call(void *__ignore, proto)	\
 {									\
 	ftrace_raw_event_id_##template(&event_##call, args);		\
 }									\
@@ -586,13 +586,13 @@ static notrace void ftrace_raw_event_##call(proto)			\
 static notrace int							\
 ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)		\
 {									\
-	return register_trace_##call(ftrace_raw_event_##call);		\
+	return register_trace_##call(ftrace_raw_event_##call, NULL);	\
 }									\
 									\
 static notrace void							\
 ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)		\
 {									\
-	unregister_trace_##call(ftrace_raw_event_##call);		\
+	unregister_trace_##call(ftrace_raw_event_##call, NULL);		\
 }									\
 									\
 static struct trace_event ftrace_event_type_##call = {			\
@@ -793,7 +793,7 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)		\
-static notrace void perf_trace_##call(proto)			\
+static notrace void perf_trace_##call(void *__ignore, proto)	\
 {								\
 	struct ftrace_event_call *event_call = &event_##call;	\
 								\
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b3bc91a..19d93f8 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -675,28 +675,33 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	}
 }
 
-static void blk_add_trace_rq_abort(struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_abort(void *ignore,
+				   struct request_queue *q, struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_ABORT);
 }
 
-static void blk_add_trace_rq_insert(struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_insert(void *ignore,
+				    struct request_queue *q, struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_INSERT);
 }
 
-static void blk_add_trace_rq_issue(struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_issue(void *ignore,
+				   struct request_queue *q, struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_ISSUE);
 }
 
-static void blk_add_trace_rq_requeue(struct request_queue *q,
+static void blk_add_trace_rq_requeue(void *ignore,
+				     struct request_queue *q,
 				     struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
 }
 
-static void blk_add_trace_rq_complete(struct request_queue *q,
+static void blk_add_trace_rq_complete(void *ignore,
+				      struct request_queue *q,
 				      struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_COMPLETE);
@@ -724,34 +729,40 @@ static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 			!bio_flagged(bio, BIO_UPTODATE), 0, NULL);
 }
 
-static void blk_add_trace_bio_bounce(struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_bounce(void *ignore,
+				     struct request_queue *q, struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_BOUNCE);
 }
 
-static void blk_add_trace_bio_complete(struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_complete(void *ignore,
+				       struct request_queue *q, struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE);
 }
 
-static void blk_add_trace_bio_backmerge(struct request_queue *q,
+static void blk_add_trace_bio_backmerge(void *ignore,
+					struct request_queue *q,
 					struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
 }
 
-static void blk_add_trace_bio_frontmerge(struct request_queue *q,
+static void blk_add_trace_bio_frontmerge(void *ignore,
+					 struct request_queue *q,
 					 struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE);
 }
 
-static void blk_add_trace_bio_queue(struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_queue(void *ignore,
+				    struct request_queue *q, struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_QUEUE);
 }
 
-static void blk_add_trace_getrq(struct request_queue *q,
+static void blk_add_trace_getrq(void *ignore,
+				struct request_queue *q,
 				struct bio *bio, int rw)
 {
 	if (bio)
@@ -765,7 +776,8 @@ static void blk_add_trace_getrq(struct request_queue *q,
 }
 
 
-static void blk_add_trace_sleeprq(struct request_queue *q,
+static void blk_add_trace_sleeprq(void *ignore,
+				  struct request_queue *q,
 				  struct bio *bio, int rw)
 {
 	if (bio)
@@ -779,7 +791,7 @@ static void blk_add_trace_sleeprq(struct request_queue *q,
 	}
 }
 
-static void blk_add_trace_plug(struct request_queue *q)
+static void blk_add_trace_plug(void *ignore, struct request_queue *q)
 {
 	struct blk_trace *bt = q->blk_trace;
 
@@ -787,7 +799,7 @@ static void blk_add_trace_plug(struct request_queue *q)
 		__blk_add_trace(bt, 0, 0, 0, BLK_TA_PLUG, 0, 0, NULL);
 }
 
-static void blk_add_trace_unplug_io(struct request_queue *q)
+static void blk_add_trace_unplug_io(void *ignore, struct request_queue *q)
 {
 	struct blk_trace *bt = q->blk_trace;
 
@@ -800,7 +812,7 @@ static void blk_add_trace_unplug_io(struct request_queue *q)
 	}
 }
 
-static void blk_add_trace_unplug_timer(struct request_queue *q)
+static void blk_add_trace_unplug_timer(void *ignore, struct request_queue *q)
 {
 	struct blk_trace *bt = q->blk_trace;
 
@@ -813,7 +825,8 @@ static void blk_add_trace_unplug_timer(struct request_queue *q)
 	}
 }
 
-static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
+static void blk_add_trace_split(void *ignore,
+				struct request_queue *q, struct bio *bio,
 				unsigned int pdu)
 {
 	struct blk_trace *bt = q->blk_trace;
@@ -839,8 +852,9 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
  *     it spans a stripe (or similar). Add a trace for that action.
  *
  **/
-static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
-				       dev_t dev, sector_t from)
+static void blk_add_trace_remap(void *ignore,
+				struct request_queue *q, struct bio *bio,
+				dev_t dev, sector_t from)
 {
 	struct blk_trace *bt = q->blk_trace;
 	struct blk_io_trace_remap r;
@@ -869,7 +883,8 @@ static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
  *     Add a trace for that action.
  *
  **/
-static void blk_add_trace_rq_remap(struct request_queue *q,
+static void blk_add_trace_rq_remap(void *ignore,
+				   struct request_queue *q,
 				   struct request *rq, dev_t dev,
 				   sector_t from)
 {
@@ -921,64 +936,64 @@ static void blk_register_tracepoints(void)
 {
 	int ret;
 
-	ret = register_trace_block_rq_abort(blk_add_trace_rq_abort);
+	ret = register_trace_block_rq_abort(blk_add_trace_rq_abort, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_rq_insert(blk_add_trace_rq_insert);
+	ret = register_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_rq_issue(blk_add_trace_rq_issue);
+	ret = register_trace_block_rq_issue(blk_add_trace_rq_issue, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_rq_requeue(blk_add_trace_rq_requeue);
+	ret = register_trace_block_rq_requeue(blk_add_trace_rq_requeue, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_rq_complete(blk_add_trace_rq_complete);
+	ret = register_trace_block_rq_complete(blk_add_trace_rq_complete, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_bounce(blk_add_trace_bio_bounce);
+	ret = register_trace_block_bio_bounce(blk_add_trace_bio_bounce, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_complete(blk_add_trace_bio_complete);
+	ret = register_trace_block_bio_complete(blk_add_trace_bio_complete, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_backmerge(blk_add_trace_bio_backmerge);
+	ret = register_trace_block_bio_backmerge(blk_add_trace_bio_backmerge, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge);
+	ret = register_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_queue(blk_add_trace_bio_queue);
+	ret = register_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_getrq(blk_add_trace_getrq);
+	ret = register_trace_block_getrq(blk_add_trace_getrq, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_sleeprq(blk_add_trace_sleeprq);
+	ret = register_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_plug(blk_add_trace_plug);
+	ret = register_trace_block_plug(blk_add_trace_plug, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_unplug_timer(blk_add_trace_unplug_timer);
+	ret = register_trace_block_unplug_timer(blk_add_trace_unplug_timer, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_unplug_io(blk_add_trace_unplug_io);
+	ret = register_trace_block_unplug_io(blk_add_trace_unplug_io, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_split(blk_add_trace_split);
+	ret = register_trace_block_split(blk_add_trace_split, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_remap(blk_add_trace_remap);
+	ret = register_trace_block_remap(blk_add_trace_remap, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_rq_remap(blk_add_trace_rq_remap);
+	ret = register_trace_block_rq_remap(blk_add_trace_rq_remap, NULL);
 	WARN_ON(ret);
 }
 
 static void blk_unregister_tracepoints(void)
 {
-	unregister_trace_block_rq_remap(blk_add_trace_rq_remap);
-	unregister_trace_block_remap(blk_add_trace_remap);
-	unregister_trace_block_split(blk_add_trace_split);
-	unregister_trace_block_unplug_io(blk_add_trace_unplug_io);
-	unregister_trace_block_unplug_timer(blk_add_trace_unplug_timer);
-	unregister_trace_block_plug(blk_add_trace_plug);
-	unregister_trace_block_sleeprq(blk_add_trace_sleeprq);
-	unregister_trace_block_getrq(blk_add_trace_getrq);
-	unregister_trace_block_bio_queue(blk_add_trace_bio_queue);
-	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge);
-	unregister_trace_block_bio_backmerge(blk_add_trace_bio_backmerge);
-	unregister_trace_block_bio_complete(blk_add_trace_bio_complete);
-	unregister_trace_block_bio_bounce(blk_add_trace_bio_bounce);
-	unregister_trace_block_rq_complete(blk_add_trace_rq_complete);
-	unregister_trace_block_rq_requeue(blk_add_trace_rq_requeue);
-	unregister_trace_block_rq_issue(blk_add_trace_rq_issue);
-	unregister_trace_block_rq_insert(blk_add_trace_rq_insert);
-	unregister_trace_block_rq_abort(blk_add_trace_rq_abort);
+	unregister_trace_block_rq_remap(blk_add_trace_rq_remap, NULL);
+	unregister_trace_block_remap(blk_add_trace_remap, NULL);
+	unregister_trace_block_split(blk_add_trace_split, NULL);
+	unregister_trace_block_unplug_io(blk_add_trace_unplug_io, NULL);
+	unregister_trace_block_unplug_timer(blk_add_trace_unplug_timer, NULL);
+	unregister_trace_block_plug(blk_add_trace_plug, NULL);
+	unregister_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);
+	unregister_trace_block_getrq(blk_add_trace_getrq, NULL);
+	unregister_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
+	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
+	unregister_trace_block_bio_backmerge(blk_add_trace_bio_backmerge, NULL);
+	unregister_trace_block_bio_complete(blk_add_trace_bio_complete, NULL);
+	unregister_trace_block_bio_bounce(blk_add_trace_bio_bounce, NULL);
+	unregister_trace_block_rq_complete(blk_add_trace_rq_complete, NULL);
+	unregister_trace_block_rq_requeue(blk_add_trace_rq_requeue, NULL);
+	unregister_trace_block_rq_issue(blk_add_trace_rq_issue, NULL);
+	unregister_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);
+	unregister_trace_block_rq_abort(blk_add_trace_rq_abort, NULL);
 
 	tracepoint_synchronize_unregister();
 }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8c9c293..ca04500 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3234,7 +3234,8 @@ free:
 }
 
 static void
-ftrace_graph_probe_sched_switch(struct rq *__rq, struct task_struct *prev,
+ftrace_graph_probe_sched_switch(void *ignore,
+				struct rq *__rq, struct task_struct *prev,
 				struct task_struct *next)
 {
 	unsigned long long timestamp;
@@ -3289,7 +3290,7 @@ static int start_graph_tracing(void)
 	} while (ret == -EAGAIN);
 
 	if (!ret) {
-		ret = register_trace_sched_switch(ftrace_graph_probe_sched_switch);
+		ret = register_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 		if (ret)
 			pr_info("ftrace_graph: Couldn't activate tracepoint"
 				" probe to kernel_sched_switch\n");
@@ -3365,7 +3366,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
-	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch);
+	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
  out:
 	mutex_unlock(&ftrace_lock);
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index a91da69..7253d0c 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -95,7 +95,8 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 	trace_wake_up();
 }
 
-static void kmemtrace_kmalloc(unsigned long call_site,
+static void kmemtrace_kmalloc(void *ignore,
+			      unsigned long call_site,
 			      const void *ptr,
 			      size_t bytes_req,
 			      size_t bytes_alloc,
@@ -105,7 +106,8 @@ static void kmemtrace_kmalloc(unsigned long call_site,
 			bytes_req, bytes_alloc, gfp_flags, -1);
 }
 
-static void kmemtrace_kmem_cache_alloc(unsigned long call_site,
+static void kmemtrace_kmem_cache_alloc(void *ignore,
+				       unsigned long call_site,
 				       const void *ptr,
 				       size_t bytes_req,
 				       size_t bytes_alloc,
@@ -115,7 +117,8 @@ static void kmemtrace_kmem_cache_alloc(unsigned long call_site,
 			bytes_req, bytes_alloc, gfp_flags, -1);
 }
 
-static void kmemtrace_kmalloc_node(unsigned long call_site,
+static void kmemtrace_kmalloc_node(void *ignore,
+				   unsigned long call_site,
 				   const void *ptr,
 				   size_t bytes_req,
 				   size_t bytes_alloc,
@@ -126,7 +129,8 @@ static void kmemtrace_kmalloc_node(unsigned long call_site,
 			bytes_req, bytes_alloc, gfp_flags, node);
 }
 
-static void kmemtrace_kmem_cache_alloc_node(unsigned long call_site,
+static void kmemtrace_kmem_cache_alloc_node(void *ignore,
+					    unsigned long call_site,
 					    const void *ptr,
 					    size_t bytes_req,
 					    size_t bytes_alloc,
@@ -137,12 +141,14 @@ static void kmemtrace_kmem_cache_alloc_node(unsigned long call_site,
 			bytes_req, bytes_alloc, gfp_flags, node);
 }
 
-static void kmemtrace_kfree(unsigned long call_site, const void *ptr)
+static void
+kmemtrace_kfree(void *ignore, unsigned long call_site, const void *ptr)
 {
 	kmemtrace_free(KMEMTRACE_TYPE_KMALLOC, call_site, ptr);
 }
 
-static void kmemtrace_kmem_cache_free(unsigned long call_site, const void *ptr)
+static void kmemtrace_kmem_cache_free(void *ignore,
+				      unsigned long call_site, const void *ptr)
 {
 	kmemtrace_free(KMEMTRACE_TYPE_CACHE, call_site, ptr);
 }
@@ -151,34 +157,34 @@ static int kmemtrace_start_probes(void)
 {
 	int err;
 
-	err = register_trace_kmalloc(kmemtrace_kmalloc);
+	err = register_trace_kmalloc(kmemtrace_kmalloc, NULL);
 	if (err)
 		return err;
-	err = register_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc);
+	err = register_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc, NULL);
 	if (err)
 		return err;
-	err = register_trace_kmalloc_node(kmemtrace_kmalloc_node);
+	err = register_trace_kmalloc_node(kmemtrace_kmalloc_node, NULL);
 	if (err)
 		return err;
-	err = register_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node);
+	err = register_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node, NULL);
 	if (err)
 		return err;
-	err = register_trace_kfree(kmemtrace_kfree);
+	err = register_trace_kfree(kmemtrace_kfree, NULL);
 	if (err)
 		return err;
-	err = register_trace_kmem_cache_free(kmemtrace_kmem_cache_free);
+	err = register_trace_kmem_cache_free(kmemtrace_kmem_cache_free, NULL);
 
 	return err;
 }
 
 static void kmemtrace_stop_probes(void)
 {
-	unregister_trace_kmalloc(kmemtrace_kmalloc);
-	unregister_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc);
-	unregister_trace_kmalloc_node(kmemtrace_kmalloc_node);
-	unregister_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node);
-	unregister_trace_kfree(kmemtrace_kfree);
-	unregister_trace_kmem_cache_free(kmemtrace_kmem_cache_free);
+	unregister_trace_kmalloc(kmemtrace_kmalloc, NULL);
+	unregister_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc, NULL);
+	unregister_trace_kmalloc_node(kmemtrace_kmalloc_node, NULL);
+	unregister_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node, NULL);
+	unregister_trace_kfree(kmemtrace_kfree, NULL);
+	unregister_trace_kmem_cache_free(kmemtrace_kmem_cache_free, NULL);
 }
 
 static int kmem_trace_init(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 5fca0f5..9ec020a 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -50,8 +50,8 @@ tracing_sched_switch_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_switch(struct rq *__rq, struct task_struct *prev,
-			struct task_struct *next)
+probe_sched_switch(void *ignore, struct rq *__rq, struct task_struct *prev,
+		   struct task_struct *next)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
@@ -109,7 +109,8 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
+probe_sched_wakeup(void *ignore,
+		   struct rq *__rq, struct task_struct *wakee, int success)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
@@ -139,21 +140,21 @@ static int tracing_sched_register(void)
 {
 	int ret;
 
-	ret = register_trace_sched_wakeup(probe_sched_wakeup);
+	ret = register_trace_sched_wakeup(probe_sched_wakeup, NULL);
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup\n");
 		return ret;
 	}
 
-	ret = register_trace_sched_wakeup_new(probe_sched_wakeup);
+	ret = register_trace_sched_wakeup_new(probe_sched_wakeup, NULL);
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup_new\n");
 		goto fail_deprobe;
 	}
 
-	ret = register_trace_sched_switch(probe_sched_switch);
+	ret = register_trace_sched_switch(probe_sched_switch, NULL);
 	if (ret) {
 		pr_info("sched trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_switch\n");
@@ -162,17 +163,17 @@ static int tracing_sched_register(void)
 
 	return ret;
 fail_deprobe_wake_new:
-	unregister_trace_sched_wakeup_new(probe_sched_wakeup);
+	unregister_trace_sched_wakeup_new(probe_sched_wakeup, NULL);
 fail_deprobe:
-	unregister_trace_sched_wakeup(probe_sched_wakeup);
+	unregister_trace_sched_wakeup(probe_sched_wakeup, NULL);
 	return ret;
 }
 
 static void tracing_sched_unregister(void)
 {
-	unregister_trace_sched_switch(probe_sched_switch);
-	unregister_trace_sched_wakeup_new(probe_sched_wakeup);
-	unregister_trace_sched_wakeup(probe_sched_wakeup);
+	unregister_trace_sched_switch(probe_sched_switch, NULL);
+	unregister_trace_sched_wakeup_new(probe_sched_wakeup, NULL);
+	unregister_trace_sched_wakeup(probe_sched_wakeup, NULL);
 }
 
 static void tracing_start_sched_switch(void)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 0271742..78a0af1 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -98,7 +98,8 @@ static int report_latency(cycle_t delta)
 	return 1;
 }
 
-static void probe_wakeup_migrate_task(struct task_struct *task, int cpu)
+static void
+probe_wakeup_migrate_task(void *ignore, struct task_struct *task, int cpu)
 {
 	if (task != wakeup_task)
 		return;
@@ -107,7 +108,7 @@ static void probe_wakeup_migrate_task(struct task_struct *task, int cpu)
 }
 
 static void notrace
-probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
+probe_wakeup_sched_switch(void *ignore, struct rq *rq, struct task_struct *prev,
 	struct task_struct *next)
 {
 	struct trace_array_cpu *data;
@@ -200,7 +201,7 @@ static void wakeup_reset(struct trace_array *tr)
 }
 
 static void
-probe_wakeup(struct rq *rq, struct task_struct *p, int success)
+probe_wakeup(void *ignore, struct rq *rq, struct task_struct *p, int success)
 {
 	struct trace_array_cpu *data;
 	int cpu = smp_processor_id();
@@ -264,28 +265,28 @@ static void start_wakeup_tracer(struct trace_array *tr)
 {
 	int ret;
 
-	ret = register_trace_sched_wakeup(probe_wakeup);
+	ret = register_trace_sched_wakeup(probe_wakeup, NULL);
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup\n");
 		return;
 	}
 
-	ret = register_trace_sched_wakeup_new(probe_wakeup);
+	ret = register_trace_sched_wakeup_new(probe_wakeup, NULL);
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup_new\n");
 		goto fail_deprobe;
 	}
 
-	ret = register_trace_sched_switch(probe_wakeup_sched_switch);
+	ret = register_trace_sched_switch(probe_wakeup_sched_switch, NULL);
 	if (ret) {
 		pr_info("sched trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_switch\n");
 		goto fail_deprobe_wake_new;
 	}
 
-	ret = register_trace_sched_migrate_task(probe_wakeup_migrate_task);
+	ret = register_trace_sched_migrate_task(probe_wakeup_migrate_task, NULL);
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_migrate_task\n");
@@ -312,19 +313,19 @@ static void start_wakeup_tracer(struct trace_array *tr)
 
 	return;
 fail_deprobe_wake_new:
-	unregister_trace_sched_wakeup_new(probe_wakeup);
+	unregister_trace_sched_wakeup_new(probe_wakeup, NULL);
 fail_deprobe:
-	unregister_trace_sched_wakeup(probe_wakeup);
+	unregister_trace_sched_wakeup(probe_wakeup, NULL);
 }
 
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
-	unregister_trace_sched_switch(probe_wakeup_sched_switch);
-	unregister_trace_sched_wakeup_new(probe_wakeup);
-	unregister_trace_sched_wakeup(probe_wakeup);
-	unregister_trace_sched_migrate_task(probe_wakeup_migrate_task);
+	unregister_trace_sched_switch(probe_wakeup_sched_switch, NULL);
+	unregister_trace_sched_wakeup_new(probe_wakeup, NULL);
+	unregister_trace_sched_wakeup(probe_wakeup, NULL);
+	unregister_trace_sched_migrate_task(probe_wakeup_migrate_task, NULL);
 }
 
 static int __wakeup_tracer_init(struct trace_array *tr)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index d036a74..b8d30e7 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -247,7 +247,7 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	return ret;
 }
 
-void ftrace_syscall_enter(struct pt_regs *regs, long id)
+void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 {
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
@@ -282,7 +282,7 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
-void ftrace_syscall_exit(struct pt_regs *regs, long ret)
+void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 {
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
@@ -324,7 +324,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
-		ret = register_trace_sys_enter(ftrace_syscall_enter);
+		ret = register_trace_sys_enter(ftrace_syscall_enter, NULL);
 	if (!ret) {
 		set_bit(num, enabled_enter_syscalls);
 		sys_refcount_enter++;
@@ -344,7 +344,7 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 	sys_refcount_enter--;
 	clear_bit(num, enabled_enter_syscalls);
 	if (!sys_refcount_enter)
-		unregister_trace_sys_enter(ftrace_syscall_enter);
+		unregister_trace_sys_enter(ftrace_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
 }
 
@@ -358,7 +358,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
-		ret = register_trace_sys_exit(ftrace_syscall_exit);
+		ret = register_trace_sys_exit(ftrace_syscall_exit, NULL);
 	if (!ret) {
 		set_bit(num, enabled_exit_syscalls);
 		sys_refcount_exit++;
@@ -378,7 +378,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	sys_refcount_exit--;
 	clear_bit(num, enabled_exit_syscalls);
 	if (!sys_refcount_exit)
-		unregister_trace_sys_exit(ftrace_syscall_exit);
+		unregister_trace_sys_exit(ftrace_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
 }
 
@@ -438,7 +438,7 @@ static DECLARE_BITMAP(enabled_perf_exit_syscalls, NR_syscalls);
 static int sys_perf_refcount_enter;
 static int sys_perf_refcount_exit;
 
-static void perf_syscall_enter(struct pt_regs *regs, long id)
+static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_enter *rec;
@@ -484,7 +484,7 @@ int perf_sysenter_enable(struct ftrace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_perf_refcount_enter)
-		ret = register_trace_sys_enter(perf_syscall_enter);
+		ret = register_trace_sys_enter(perf_syscall_enter, NULL);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
@@ -506,11 +506,11 @@ void perf_sysenter_disable(struct ftrace_event_call *call)
 	sys_perf_refcount_enter--;
 	clear_bit(num, enabled_perf_enter_syscalls);
 	if (!sys_perf_refcount_enter)
-		unregister_trace_sys_enter(perf_syscall_enter);
+		unregister_trace_sys_enter(perf_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
 }
 
-static void perf_syscall_exit(struct pt_regs *regs, long ret)
+static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
@@ -559,7 +559,7 @@ int perf_sysexit_enable(struct ftrace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_perf_refcount_exit)
-		ret = register_trace_sys_exit(perf_syscall_exit);
+		ret = register_trace_sys_exit(perf_syscall_exit, NULL);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall exit trace point");
@@ -581,7 +581,7 @@ void perf_sysexit_disable(struct ftrace_event_call *call)
 	sys_perf_refcount_exit--;
 	clear_bit(num, enabled_perf_exit_syscalls);
 	if (!sys_perf_refcount_exit)
-		unregister_trace_sys_exit(perf_syscall_exit);
+		unregister_trace_sys_exit(perf_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
 }
 
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index cc2d2fa..a7cc379 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -49,7 +49,8 @@ static void cpu_workqueue_stat_free(struct kref *kref)
 
 /* Insertion of a work */
 static void
-probe_workqueue_insertion(struct task_struct *wq_thread,
+probe_workqueue_insertion(void *ignore,
+			  struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
@@ -70,7 +71,8 @@ found:
 
 /* Execution of a work */
 static void
-probe_workqueue_execution(struct task_struct *wq_thread,
+probe_workqueue_execution(void *ignore,
+			  struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
@@ -90,7 +92,8 @@ found:
 }
 
 /* Creation of a cpu workqueue thread */
-static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
+static void probe_workqueue_creation(void *ignore,
+				     struct task_struct *wq_thread, int cpu)
 {
 	struct cpu_workqueue_stats *cws;
 	unsigned long flags;
@@ -114,7 +117,8 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 }
 
 /* Destruction of a cpu workqueue thread */
-static void probe_workqueue_destruction(struct task_struct *wq_thread)
+static void
+probe_workqueue_destruction(void *ignore, struct task_struct *wq_thread)
 {
 	/* Workqueue only execute on one cpu */
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
@@ -259,19 +263,19 @@ int __init trace_workqueue_early_init(void)
 {
 	int ret, cpu;
 
-	ret = register_trace_workqueue_insertion(probe_workqueue_insertion);
+	ret = register_trace_workqueue_insertion(probe_workqueue_insertion, NULL);
 	if (ret)
 		goto out;
 
-	ret = register_trace_workqueue_execution(probe_workqueue_execution);
+	ret = register_trace_workqueue_execution(probe_workqueue_execution, NULL);
 	if (ret)
 		goto no_insertion;
 
-	ret = register_trace_workqueue_creation(probe_workqueue_creation);
+	ret = register_trace_workqueue_creation(probe_workqueue_creation, NULL);
 	if (ret)
 		goto no_execution;
 
-	ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
+	ret = register_trace_workqueue_destruction(probe_workqueue_destruction, NULL);
 	if (ret)
 		goto no_creation;
 
@@ -283,11 +287,11 @@ int __init trace_workqueue_early_init(void)
 	return 0;
 
 no_creation:
-	unregister_trace_workqueue_creation(probe_workqueue_creation);
+	unregister_trace_workqueue_creation(probe_workqueue_creation, NULL);
 no_execution:
-	unregister_trace_workqueue_execution(probe_workqueue_execution);
+	unregister_trace_workqueue_execution(probe_workqueue_execution, NULL);
 no_insertion:
-	unregister_trace_workqueue_insertion(probe_workqueue_insertion);
+	unregister_trace_workqueue_insertion(probe_workqueue_insertion, NULL);
 out:
 	pr_warning("trace_workqueue: unable to trace workqueues\n");
 
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
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index cf208d8..ad41529 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -172,12 +172,12 @@ out:
 	return;
 }
 
-static void trace_kfree_skb_hit(struct sk_buff *skb, void *location)
+static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
 {
 	trace_drop_common(skb, location);
 }
 
-static void trace_napi_poll_hit(struct napi_struct *napi)
+static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi)
 {
 	struct dm_hw_stat_delta *new_stat;
 
@@ -225,12 +225,12 @@ static int set_all_monitor_traces(int state)
 
 	switch (state) {
 	case TRACE_ON:
-		rc |= register_trace_kfree_skb(trace_kfree_skb_hit);
-		rc |= register_trace_napi_poll(trace_napi_poll_hit);
+		rc |= register_trace_kfree_skb(trace_kfree_skb_hit, NULL);
+		rc |= register_trace_napi_poll(trace_napi_poll_hit, NULL);
 		break;
 	case TRACE_OFF:
-		rc |= unregister_trace_kfree_skb(trace_kfree_skb_hit);
-		rc |= unregister_trace_napi_poll(trace_napi_poll_hit);
+		rc |= unregister_trace_kfree_skb(trace_kfree_skb_hit, NULL);
+		rc |= unregister_trace_napi_poll(trace_napi_poll_hit, NULL);
 
 		tracepoint_synchronize_unregister();
 
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
diff --git a/samples/tracepoints/tracepoint-probe-sample.c b/samples/tracepoints/tracepoint-probe-sample.c
index 9e60eb6..744c0b9 100644
--- a/samples/tracepoints/tracepoint-probe-sample.c
+++ b/samples/tracepoints/tracepoint-probe-sample.c
@@ -13,7 +13,8 @@
  * Here the caller only guarantees locking for struct file and struct inode.
  * Locking must therefore be done in the probe to use the dentry.
  */
-static void probe_subsys_event(struct inode *inode, struct file *file)
+static void probe_subsys_event(void *ignore,
+			       struct inode *inode, struct file *file)
 {
 	path_get(&file->f_path);
 	dget(file->f_path.dentry);
@@ -23,7 +24,7 @@ static void probe_subsys_event(struct inode *inode, struct file *file)
 	path_put(&file->f_path);
 }
 
-static void probe_subsys_eventb(void)
+static void probe_subsys_eventb(void *ignore)
 {
 	printk(KERN_INFO "Event B is encountered\n");
 }
@@ -32,9 +33,9 @@ static int __init tp_sample_trace_init(void)
 {
 	int ret;
 
-	ret = register_trace_subsys_event(probe_subsys_event);
+	ret = register_trace_subsys_event(probe_subsys_event, NULL);
 	WARN_ON(ret);
-	ret = register_trace_subsys_eventb(probe_subsys_eventb);
+	ret = register_trace_subsys_eventb(probe_subsys_eventb, NULL);
 	WARN_ON(ret);
 
 	return 0;
@@ -44,8 +45,8 @@ module_init(tp_sample_trace_init);
 
 static void __exit tp_sample_trace_exit(void)
 {
-	unregister_trace_subsys_eventb(probe_subsys_eventb);
-	unregister_trace_subsys_event(probe_subsys_event);
+	unregister_trace_subsys_eventb(probe_subsys_eventb, NULL);
+	unregister_trace_subsys_event(probe_subsys_event, NULL);
 	tracepoint_synchronize_unregister();
 }
 
diff --git a/samples/tracepoints/tracepoint-probe-sample2.c b/samples/tracepoints/tracepoint-probe-sample2.c
index be2a960..9fcf990 100644
--- a/samples/tracepoints/tracepoint-probe-sample2.c
+++ b/samples/tracepoints/tracepoint-probe-sample2.c
@@ -12,7 +12,8 @@
  * Here the caller only guarantees locking for struct file and struct inode.
  * Locking must therefore be done in the probe to use the dentry.
  */
-static void probe_subsys_event(struct inode *inode, struct file *file)
+static void probe_subsys_event(void *ignore,
+			       struct inode *inode, struct file *file)
 {
 	printk(KERN_INFO "Event is encountered with inode number %lu\n",
 		inode->i_ino);
@@ -22,7 +23,7 @@ static int __init tp_sample_trace_init(void)
 {
 	int ret;
 
-	ret = register_trace_subsys_event(probe_subsys_event);
+	ret = register_trace_subsys_event(probe_subsys_event, NULL);
 	WARN_ON(ret);
 
 	return 0;
@@ -32,7 +33,7 @@ module_init(tp_sample_trace_init);
 
 static void __exit tp_sample_trace_exit(void)
 {
-	unregister_trace_subsys_event(probe_subsys_event);
+	unregister_trace_subsys_event(probe_subsys_event, NULL);
 	tracepoint_synchronize_unregister();
 }
 
-- 
1.7.0


