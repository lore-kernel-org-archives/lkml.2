Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0HYNst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:48:49 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52593 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0HYNsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:48:45 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 25 Aug 2010 19:13:57 +0530
Message-Id: <20100825134357.5447.71201.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv11 2.6.36-rc2-tip 13/15] 13: perf: Loop thro each of the maps in a map_group.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduces map_groups_for_each_map that iterates over a map_group.
This is useful while listing functions through perf-probe.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Suggested-by: Arnaldo Carvalho de Melo <acme@infradead.org>
---
 tools/perf/util/map.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 7857579..45b5f50 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -54,6 +54,33 @@ struct map_groups {
 	struct machine	 *machine;
 };
 
+/* For map_groups iteration */
+static inline struct map *map__first(struct map_groups *self,
+						enum map_type type)
+{
+	struct rb_node *rn = rb_first(&self->maps[type]);
+	return rn ? rb_entry(rn, struct map, rb_node) : NULL;
+}
+
+static inline struct map *map__next(struct map *map)
+{
+	struct rb_node *rn;
+	if (!map)
+		return NULL;
+	rn = rb_next(&map->rb_node);
+	return rn ? rb_entry(rn, struct map, rb_node) : NULL;
+}
+
+/**
+ * map_groups__for_each_map      - iterate over a map_group
+ * @pos:	the &struct map to use as a loop cursor.
+ * @type:	the map type.
+ * @self:	the &struct map_groups for loop.
+ */
+#define map_groups__for_each_map(pos, type, self)	\
+	for (pos = map__first(self, type); pos;		\
+				pos = map__next(pos))
+
 /* Native host kernel uses -1 as pid index in machine */
 #define	HOST_KERNEL_ID			(-1)
 #define	DEFAULT_GUEST_KERNEL_ID		(0)
