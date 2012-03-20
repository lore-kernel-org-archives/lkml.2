Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab2CTD1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:27:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53975 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab2CTD1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:27:24 -0400
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org,
        "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 4/4] compat: add some tracing backport work
Date: Mon, 19 Mar 2012 20:27:01 -0700
Message-Id: <1332214021-9716-5-git-send-email-mcgrof@frijolero.org>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
In-Reply-To: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

Its not really easy to backport the tracing stuff, but
lets give it a shot. We should simply review how many
subsystems we want tracing for and for what target kernels
we want that enabled for. It doesn't make sense to
backport tracing if we won't have much users.

For now add some code that at least does not break building.

Trying kernel                  3.3.0-030300rc2-generic  [OK]
Trying kernel                     3.2.2-030202-generic  [OK]
Trying kernel                    3.1.10-030110-generic  [OK]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                        2.6.38-13-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                        2.6.31-22-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [OK]
Trying kernel                    2.6.24-020624-generic  [OK]

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 include/linux/tracepoint.h |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 9f5add1..a5bd743 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -4,7 +4,47 @@
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+
 #include_next <linux/tracepoint.h>
+
+/* Backports f42c85e7 */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
+#undef TP_STRUCT__entry
+#define TP_STRUCT__entry(args...) args
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
+/* Backports 091ad365, a rename */
+#define DECLARE_EVENT_CLASS TRACE_EVENT_TEMPLATE
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
+#define TP_PROTO TPPROTO
+#define TP_ARGS TPARGS
+#define TP_FMT TPFMT
+#define TP_RAW_FMT TPRAWFMT
+#endif
+
+#endif
+
+#else /* just disable tracing */
+
+/* Disable all tracing */
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+
+#define TP_PROTO(args...)  args
+#define TP_ARGS(args...)   args
+#define TP_CONDITION(args...)      args
+
+struct tracepoint_iter {
+};
+
 #endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
 
 #endif	/* _COMPAT_LINUX_TRACEPOINT_H */
-- 
1.7.10.rc1.22.gf5241

