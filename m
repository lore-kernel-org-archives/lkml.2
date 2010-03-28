Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0C1Set (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 14:34:49 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43845 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754961Ab0C1Ses (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 14:34:48 -0400
Date: Sun, 28 Mar 2010 14:34:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Imre Deak <imre.deak@nokia.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Alexander Shishkin <virtuoso@slind.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] create generic alignment api (v3)
Message-ID: <20100328183445.GB13135@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:33:34 up 64 days, 21:10,  4 users,  load average: 0.15, 0.11,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than re-doing the "alignment on a type size" trick all over again at
different levels, import the "ltt_align" from LTTng into kernel.h and make this
available to everyone. Renaming to:

- offset_align
- offset_align_floor
- object_align
- object_align_floor

Changelog since v2:
- Fix object_align*(): should use object size alignment, not pointer alignment.

Changelog since v1:
- Align on the object natural alignment
    (rather than min(arch word alignment, natural alignment))

The advantage of separating the API in "object alignment" and "offset alignment"
is that it gives more freedom to play with offset alignment. Very useful to
implement a tracer ring-buffer alignment. (hint hint)

Typical users will use "object alignment", but infrastructures like tracers
which need to perform dynamic alignment will typically use "offset alignment",
because it allows to align with respect to a base rather than to pass an
absolute address.

We use "sizeof(object)" rather than "__alignof__()" object because alignof
returns "recommended" object alignment for the architecture, which can be
sub-optimal on some architectures. By ensuring alignment on the object size, we
are sure to make the right choice.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alexander Shishkin <virtuoso@slind.org>,
CC: linux-arm-kernel@lists.infradead.org
CC: Imre Deak <imre.deak@nokia.com>
CC: Jamie Lokier <jamie@shareable.org>
CC: rostedt@goodmis.org
CC: mingo@elte.hu
---
 include/linux/kernel.h |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: linux-2.6-lttng/include/linux/kernel.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/kernel.h	2010-03-27 20:46:07.000000000 -0400
+++ linux-2.6-lttng/include/linux/kernel.h	2010-03-28 14:33:12.000000000 -0400
@@ -42,6 +42,41 @@ extern const char linux_proc_banner[];
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
+/**
+ * offset_align - Calculate the offset needed to align an object on its natural
+ *                alignment towards higher addresses.
+ * @align_drift:  object offset from an "alignment"-aligned address.
+ * @alignment:    natural object alignment. Must be non-zero, power of 2.
+ *
+ * Returns the offset that must be added to align towards higher
+ * addresses.
+ */
+static inline size_t offset_align(size_t align_drift, size_t alignment)
+{
+	return (alignment - align_drift) & (alignment - 1);
+}
+
+/**
+ * offset_align_floor - Calculate the offset needed to align an object
+ *                      on its natural alignment towards lower addresses.
+ * @align_drift:  object offset from an "alignment"-aligned address.
+ * @alignment:    natural object alignment. Must be non-zero, power of 2.
+ *
+ * Returns the offset that must be substracted to align towards lower addresses.
+ */
+static inline size_t offset_align_floor(size_t align_drift, size_t alignment)
+{
+	return (align_drift - alignment) & (alignment - 1);
+}
+
+#define object_align(obj)						      \
+	((typeof(object))((size_t) (obj) + offset_align((size_t) (obj),	      \
+							sizeof(*(obj)))))
+
+#define object_align_floor(obj)						      \
+	((typeof(object))((size_t) (obj) - offset_align_floor((size_t) (obj), \
+							      sizeof(*(obj)))))
+
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
