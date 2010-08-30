Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0H3Ifr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:35:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:54183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab0H3Ifp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:35:45 -0400
Date: Mon, 30 Aug 2010 08:35:18 GMT
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: acme@redhat.com, mingo@redhat.com, mathieu.desnoyers@efficios.com,
        naren.devaiah@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        jkenisto@linux.vnet.ibm.com, akpm@linux-foundation.org, mjw@redhat.com,
        oleg@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, fche@redhat.com, rdunlap@xenotime.net,
        hch@infradead.org, ananth@in.ibm.com, paulmck@linux.vnet.ibm.com,
        masami.hiramatsu.pt@hitachi.com, srikar@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, mathieu.desnoyers@efficios.com,
        naren.devaiah@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        jkenisto@linux.vnet.ibm.com, akpm@linux-foundation.org, mjw@redhat.com,
        tglx@linutronix.de, oleg@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, fche@redhat.com, rdunlap@xenotime.net,
        hch@infradead.org, ananth@in.ibm.com, paulmck@linux.vnet.ibm.com,
        masami.hiramatsu.pt@hitachi.com, srikar@linux.vnet.ibm.com
In-Reply-To: <20100825134329.5447.92261.sendpatchset@localhost6.localdomain6>
References: <20100825134329.5447.92261.sendpatchset@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: List symbols in a dso in ascending name order
Message-ID: <tip-90f18e63fbd005133624bf18a5e8b75c92e90f4d@git.kernel.org>
Git-Commit-ID: 90f18e63fbd005133624bf18a5e8b75c92e90f4d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 08:35:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90f18e63fbd005133624bf18a5e8b75c92e90f4d
Gitweb:     http://git.kernel.org/tip/90f18e63fbd005133624bf18a5e8b75c92e90f4d
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Wed, 25 Aug 2010 19:13:29 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Aug 2010 17:28:59 -0300

perf symbols: List symbols in a dso in ascending name order

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
