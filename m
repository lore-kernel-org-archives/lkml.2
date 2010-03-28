Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab0C1BAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 21:00:49 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:50359 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428Ab0C1BAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 21:00:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAANCrktGGNpu/2dsb2JhbACbL3S8VYUBBIYf
Date: Sat, 27 Mar 2010 20:55:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alexander Shishkin <virtuoso@slind.org>,
       linux-arm-kernel@lists.infradead.org, Imre Deak <imre.deak@nokia.com>,
       Jamie Lokier <jamie@shareable.org>, rostedt@goodmis.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH] create generic alignment api
Message-ID: <20100328005545.GA12449@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:08:29 up 2 days, 10:10,  2 users,  load average: 0.01, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> On Thu, Mar 25, 2010 at 06:42:46PM +0200, Alexander Shishkin wrote:
> > +/*
> > + * emulate __xchg() using 32-bit __cmpxchg()
> > + */
> > +static inline unsigned long __xchg_generic(unsigned long x,
> > +						 volatile void *ptr, int size)
> > +{
> > +	unsigned long *ptrbig = (unsigned long *)((unsigned long)ptr & ~3UL);
> > +	int shift = ((unsigned)ptr - (unsigned)ptrbig) * 8;
> 
> I wonder if we should be using __alignof__ here.
> 
> 	unsigned long *ptrbig = (unsigned long *)((unsigned long)ptr &
> 		(__alignof__(unsigned long) - 1));
> 

Hrm, first, there is a missing "~" in the version you propose.

I'm not convinced __alignof__ is required to be as small as we think by
any standard. If, for some reason, a compiler see it convenient to align
everything on really large values, I think it could.

We could use sizeof() here without any problem here though:

	unsigned long *ptrbig = (unsigned long *)((unsigned long) ptr &
		~(sizeof(unsigned long) - 1));

And rather than doing this over and over again, we could create a
generic header for that (derived from LTTng ltt_align):

create generic alignment api

Rather than re-doing the "alignment on a type size" trick all over again at
different levels, import the "ltt_align" from LTTng into kernel.h and make this
available to everyone. Renaming to:

- offset_align
- offset_align_floor
- object_align
- object_align_floor

The advantage of separating the API in "object alignment" and "offset alignment"
is that it gives more freedom to play with offset alignment. Very useful to
implement a tracer ring-buffer alignment. (hint hint)

Typical users will use "object alignment", but infrastructures like tracers
which need to perform dynamic alignment will typically use "offset alignment",
because it allows to align with respect to a base rather than to pass an
absolute address.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alexander Shishkin <virtuoso@slind.org>,
CC: linux-arm-kernel@lists.infradead.org
CC: Imre Deak <imre.deak@nokia.com>
CC: Jamie Lokier <jamie@shareable.org>
CC: rostedt@goodmis.org
CC: mingo@elte.hu
---
 include/linux/kernel.h |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

Index: linux-2.6-lttng/include/linux/kernel.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/kernel.h	2010-03-27 20:46:07.000000000 -0400
+++ linux-2.6-lttng/include/linux/kernel.h	2010-03-27 20:50:39.000000000 -0400
@@ -613,6 +613,43 @@ static inline void ftrace_dump(void) { }
 	_max1 > _max2 ? _max1 : _max2; })
 
 /**
+ * offset_align - Calculate the offset needed to align an object on its natural
+ *                alignment towards higher addresses.
+ * @align_drift:  object offset from an architecture word-aligned address.
+ * @size_of_type: size of the type to align. Must be non-zero.
+ *
+ * Returns the offset that must be added to align towards higher
+ * addresses.
+ */
+static inline size_t offset_align(size_t align_drift, size_t size_of_type)
+{
+	size_t alignment = min(sizeof(void *), size_of_type);
+	return (alignment - align_drift) & (alignment - 1);
+}
+
+/**
+ * offset_align_floor - Calculate the offset needed to align an object
+ *                      on its natural alignment towards lower addresses.
+ * @align_drift:  object offset from an architecture word-aligned address.
+ * @size_of_type: size of the type to align. Must be non-zero.
+ *
+ * Returns the offset that must be substracted to align towards lower addresses.
+ */
+static inline size_t offset_align_floor(size_t align_drift, size_t size_of_type)
+{
+	size_t alignment = min(sizeof(void *), size_of_type);
+	return (align_drift - alignment) & (alignment - 1);
+}
+
+#define object_align(object)						       \
+	((typeof(object))((size_t) object + offset_align((size_t) object,      \
+			  sizeof(object))))
+
+#define object_align_floor(object)					       \
+	((typeof(object))((size_t) object - offset_align_floor((size_t) object,\
+			  sizeof(object))))
+
+/**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
  * @min: minimum allowable value


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
