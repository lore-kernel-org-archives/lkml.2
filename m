Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2CZM6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 08:58:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33586
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754666Ab2CZM63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 08:58:29 -0400
Date: Mon, 26 Mar 2012 08:58:22 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org
Subject: Re: [PATCH 4/4] compat: add some tracing backport work
Message-ID: <20120326125822.GA11929@bombadil.infradead.org>
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
 <1332214021-9716-5-git-send-email-mcgrof@frijolero.org>
 <1332245766.3329.14.camel@jlt3.sipsolutions.net>
 <CAB=NE6XyDDfzu71K-1ecMQ+F-0Z1iTN4OKCUjJ+E3yxvydks0Q@mail.gmail.com>
 <CAB=NE6XXd-T5B37Cc_eCwnWHRk-_UVn0JY0mQjzMQcK+ZcLuWQ@mail.gmail.com>
 <1332751768.3511.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1332751768.3511.3.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:49:28AM +0200, Johannes Berg wrote:
> On Wed, 2012-03-21 at 21:29 -0700, Luis R. Rodriguez wrote:
> 
> > But no dice. I then figured it may be my kernel with
> > CONFIG_TRACEPOINTS=y and indeed that is the case -- so we have to
> > consider the case where the target kernel may have tracing enabled and
> > we have to disable it somehow. Undef'ing CONFIG_TRACEPOINTS and
> > DECLARE_TRACE doesn't really do it.
> 
> Oh, ok, yuck. So I guess we can't easily disable tracing if it's enabled
> in the base kernel ...

Its a  bit tough.

> > We may need to redefine each macro to some COMPAT_TRACE_ macro, not sure yet.
> 
> That would require patches again though, no fun either.

Agreed.

I've gotten a bit farther:

This is not yet complete. At least for mac80211 we fail with:

  CC [M]  /home/mcgrof/devel/compat-wireless/net/mac80211/driver-trace.o
In file included from include/trace/ftrace.h:554:0,
                 from include/trace/define_trace.h:96,
                 from /home/mcgrof/devel/compat-wireless/include/trace/define_trace.h:4,
                 from /home/mcgrof/devel/compat-wireless/net/mac80211/driver-trace.h:1559,
                 from /home/mcgrof/devel/compat-wireless/net/mac80211/driver-trace.c:8:
/home/mcgrof/devel/compat-wireless/net/mac80211/./driver-trace.h: In function ‘ftrace_test_probe_drv_return_void’:
/home/mcgrof/devel/compat-wireless/net/mac80211/./driver-trace.h:111:2: error: implicit declaration of function ‘check_trace_callback_type_drv_return_void’

This is against v2.6.33

And ckmake log:

mcgrof@tux ~/compat (git::master)$ ckmake 
Trying kernel                  3.3.0-030300rc2-generic	[OK]
Trying kernel                     3.2.2-030202-generic	[OK]
Trying kernel                    3.1.10-030110-generic	[OK]
Trying kernel                    3.0.18-030018-generic	[OK]
Trying kernel                  2.6.39-02063904-generic	[OK]
Trying kernel                        2.6.38-13-generic	[OK]
Trying kernel                  2.6.38-02063808-generic	[OK]
Trying kernel                  2.6.37-02063706-generic	[FAILED]
Trying kernel                  2.6.36-02063604-generic	[FAILED]
Trying kernel                  2.6.35-02063512-generic	[FAILED]
Trying kernel                  2.6.34-02063410-generic	[OK]
Trying kernel                  2.6.33-02063305-generic	[OK]
Trying kernel                  2.6.32-02063255-generic	[OK]
Trying kernel                        2.6.31-22-generic	[OK]
Trying kernel                  2.6.31-02063113-generic	[OK]
Trying kernel                  2.6.30-02063010-generic	[OK]
Trying kernel                  2.6.29-02062906-generic	[OK]
Trying kernel                  2.6.28-02062810-generic	[OK]
Trying kernel                    2.6.27-020627-generic	[OK]
Trying kernel                    2.6.26-020626-generic	[OK]
Trying kernel                    2.6.25-020625-generic	[OK]
Trying kernel                    2.6.24-020624-generic	[OK]


---
 include/linux/tracepoint.h |   57 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index a5bd743..4930600 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -10,13 +10,16 @@
 /* Backports f42c85e7 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
 #undef TP_STRUCT__entry
+/* XXX: Is this right when CONFIG_TRACEPOINTS is enabled ? */
 #define TP_STRUCT__entry(args...) args
 #endif
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
 /* Backports 091ad365, a rename */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
 #define DECLARE_EVENT_CLASS TRACE_EVENT_TEMPLATE
+#endif
 
+/* Backpports 2939b0469 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
 #define TP_PROTO TPPROTO
 #define TP_ARGS TPARGS
@@ -24,7 +27,53 @@
 #define TP_RAW_FMT TPRAWFMT
 #endif
 
-#endif
+/* Force disabling tracing */
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+
+#undef __DECLARE_TRACE
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
+	static inline void trace_##name(proto)				\
+	{ }								\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{ }								\
+	static inline int						\
+	register_trace_##name(void (*probe)(data_proto),		\
+			      void *data)				\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline int						\
+	unregister_trace_##name(void (*probe)(data_proto),		\
+				void *data)				\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
+	{								\
+	}
+
+#undef DEFINE_TRACE_FN
+#define DEFINE_TRACE_FN(name, reg, unreg)
+
+#undef DEFINE_TRACE
+#define DEFINE_TRACE(name)
+
+#undef EXPORT_TRACEPOINT_SYMBOL_GPL
+#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
+
+#undef EXPORT_TRACEPOINT_SYMBOL
+#define EXPORT_TRACEPOINT_SYMBOL(name)
+
+#ifdef CONFIG_TRACEPOINTS
+#else /* CONFIG_TRACEPOINTS */
+#endif /* CONFIG_TRACEPOINTS */
 
 #else /* just disable tracing */
 
@@ -42,8 +91,8 @@ static inline void trace_ ## name(proto) {}
 #define TP_ARGS(args...)   args
 #define TP_CONDITION(args...)      args
 
-struct tracepoint_iter {
-};
+//struct tracepoint_iter {
+//};
 
 #endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
 
-- 
1.7.10.rc1.22.gf5241

