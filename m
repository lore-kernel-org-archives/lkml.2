Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2ENHML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:12:11 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47334 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab2ENHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:12:08 -0400
X-AuditID: 9c93016f-b7cecae000000e00-c7-4fb0b045ce3d
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] perf symbols: Introduce symbol__elf_init()
Date: Mon, 14 May 2012 16:10:20 +0900
Message-Id: <1336979424-17206-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol__elf_init() is for initializing internal libelf
data structure and getting rid of its dependency outside of
ELF/symboling handling code.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-buildid-list.c |    4 +---
 tools/perf/util/symbol.c          |    8 +++++++-
 tools/perf/util/symbol.h          |    1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 52480467e9ff..dfa01b8160a7 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -16,8 +16,6 @@
 #include "util/session.h"
 #include "util/symbol.h"
 
-#include <libelf.h>
-
 static const char *input_name;
 static bool force;
 static bool show_kernel;
@@ -71,7 +69,7 @@ static int perf_session__list_build_ids(void)
 {
 	struct perf_session *session;
 
-	elf_version(EV_CURRENT);
+	symbol__elf_init();
 
 	session = perf_session__new(input_name, O_RDONLY, force, false,
 				    &build_id__mark_dso_hit_ops);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c0a028c3ebaf..fe37d84e2107 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1395,6 +1395,11 @@ out_close:
 	return err;
 }
 
+void symbol__elf_init(void)
+{
+	elf_version(EV_CURRENT);
+}
+
 static bool dso__build_id_equal(const struct dso *dso, u8 *build_id)
 {
 	return memcmp(dso->build_id, build_id, sizeof(dso->build_id)) == 0;
@@ -2584,7 +2589,8 @@ int symbol__init(void)
 
 	symbol_conf.priv_size = ALIGN(symbol_conf.priv_size, sizeof(u64));
 
-	elf_version(EV_CURRENT);
+	symbol__elf_init();
+
 	if (symbol_conf.sort_by_name)
 		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
 					  sizeof(struct symbol));
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 1f003884f1ab..27e882f5ad8a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -265,6 +265,7 @@ void machines__destroy_guest_kernel_maps(struct rb_root *machines);
 
 int symbol__init(void);
 void symbol__exit(void);
+void symbol__elf_init(void);
 size_t symbol__fprintf_symname_offs(const struct symbol *sym,
 				    const struct addr_location *al, FILE *fp);
 size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp);
-- 
1.7.10.1

