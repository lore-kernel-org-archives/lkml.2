Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab2HUPmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:42:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60062 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2HUPmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:42:06 -0400
Date: Tue, 21 Aug 2012 08:41:44 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-166ccc9c244828da9214a0e7ba4d5dde6a26dcc1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1344228082-15569-2-git-send-email-namhyung@kernel.org>
References: <1344228082-15569-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Introduce symbol__elf_init()
Git-Commit-ID: 166ccc9c244828da9214a0e7ba4d5dde6a26dcc1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:41:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  166ccc9c244828da9214a0e7ba4d5dde6a26dcc1
Gitweb:     http://git.kernel.org/tip/166ccc9c244828da9214a0e7ba4d5dde6a26dcc1
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 6 Aug 2012 13:41:19 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Aug 2012 16:19:14 -0300

perf symbols: Introduce symbol__elf_init()

The symbol__elf_init() is for initializing internal libelf data
structure and getting rid of its dependency outside of ELF/symboling
handling code.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344228082-15569-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |    4 +---
 tools/perf/util/symbol.c          |    8 +++++++-
 tools/perf/util/symbol.h          |    1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 6b2bcfb..7d68428 100644
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
index 8b63b67..a61fec4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1453,6 +1453,11 @@ out_close:
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
@@ -2754,7 +2759,8 @@ int symbol__init(void)
 
 	symbol_conf.priv_size = ALIGN(symbol_conf.priv_size, sizeof(u64));
 
-	elf_version(EV_CURRENT);
+	symbol__elf_init();
+
 	if (symbol_conf.sort_by_name)
 		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
 					  sizeof(struct symbol));
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 1fe733a..355993d 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -309,6 +309,7 @@ void machines__destroy_guest_kernel_maps(struct rb_root *machines);
 
 int symbol__init(void);
 void symbol__exit(void);
+void symbol__elf_init(void);
 size_t symbol__fprintf_symname_offs(const struct symbol *sym,
 				    const struct addr_location *al, FILE *fp);
 size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp);
