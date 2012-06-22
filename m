Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249Ab2FVFl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:41:28 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43654 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761226Ab2FVFl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:41:26 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-76-4fe4058373f3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 4/8] perf symbols: Introduce symbol__elf_init()
Date: Fri, 22 Jun 2012 14:37:38 +0900
Message-Id: <1340343462-15556-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The symbol__elf_init() is for initializing internal libelf
data structure and getting rid of its dependency outside of
ELF/symboling handling code.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-buildid-list.c |    4 +---
 tools/perf/util/symbol.c          |    8 +++++++-
 tools/perf/util/symbol.h          |    1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 6b2bcfbde150..7d6842826a0c 100644
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
index 3e2e5ea0f03f..38447ad42ad1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1424,6 +1424,11 @@ out_close:
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
@@ -2614,7 +2619,8 @@ int symbol__init(void)
 
 	symbol_conf.priv_size = ALIGN(symbol_conf.priv_size, sizeof(u64));
 
-	elf_version(EV_CURRENT);
+	symbol__elf_init();
+
 	if (symbol_conf.sort_by_name)
 		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
 					  sizeof(struct symbol));
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index af0752b1aca1..295a9aa1cc78 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -296,6 +296,7 @@ void machines__destroy_guest_kernel_maps(struct rb_root *machines);
 
 int symbol__init(void);
 void symbol__exit(void);
+void symbol__elf_init(void);
 size_t symbol__fprintf_symname_offs(const struct symbol *sym,
 				    const struct addr_location *al, FILE *fp);
 size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp);
-- 
1.7.10.2

