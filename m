Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0HYXhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:37:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0HYXhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:37:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Mark Wielaard <mjw@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/6] perf symbols: List symbols in a dso in ascending name order
Date: Wed, 25 Aug 2010 20:36:54 -0300
Message-Id: <1282779415-8544-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1282779415-8544-1-git-send-email-acme@infradead.org>
References: <1282779415-8544-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Given a dso, list the symbols in ascending name order. Needed for
listing available symbols from perf probe.

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Mark Wielaard <mjw@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Naren A Devaiah <naren.devaiah@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100825134329.5447.92261.sendpatchset@localhost6.localdomain6>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   14 ++++++++++++++
 tools/perf/util/symbol.h |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1a36773..a08e1cb 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -388,6 +388,20 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
 	return fprintf(fp, "%s", sbuild_id);
 }
 
+size_t dso__fprintf_symbols_by_name(struct dso *self, enum map_type type, FILE *fp)
+{
+	size_t ret = 0;
+	struct rb_node *nd;
+	struct symbol_name_rb_node *pos;
+
+	for (nd = rb_first(&self->symbol_names[type]); nd; nd = rb_next(nd)) {
+		pos = rb_entry(nd, struct symbol_name_rb_node, rb_node);
+		fprintf(fp, "%s\n", pos->sym.name);
+	}
+
+	return ret;
+}
+
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
 {
 	struct rb_node *nd;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b7a8da4..0a2c460 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -181,6 +181,7 @@ size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
 size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
 
 size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
+size_t dso__fprintf_symbols_by_name(struct dso *self, enum map_type type, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
 
 enum dso_origin {
-- 
1.6.2.5

