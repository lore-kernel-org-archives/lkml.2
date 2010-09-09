Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab0IIX5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:57:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:33361 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab0IIX5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 19:57:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jovi Zhang <bookjovi@gmail.com>,
        Davidlohr Bueso <dave@gnu.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf symbols: Fix multiple initialization of symbol system
Date: Thu,  9 Sep 2010 20:56:54 -0300
Message-Id: <1284076614-4154-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1284076614-4154-1-git-send-email-acme@infradead.org>
References: <1284076614-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

By returning immediately if it was already initialized, do it as well at
symbol__exit, refusing multiple deinitializations.

This fixes problems in the kmem, sched and timechart commands.

Reported-by: Davidlohr Bueso <dave@gnu.org>
Cc: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
LKML-Reference: AANLkTi=9Cn=R8SPMCRp5z+gEjXbaBHeb-AaOtRbuwwcn@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    7 +++++++
 tools/perf/util/symbol.h |    3 ++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1a36773..b2f5ae9 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2268,6 +2268,9 @@ static int setup_list(struct strlist **list, const char *list_str,
 
 int symbol__init(void)
 {
+	if (symbol_conf.initialized)
+		return 0;
+
 	elf_version(EV_CURRENT);
 	if (symbol_conf.sort_by_name)
 		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
@@ -2293,6 +2296,7 @@ int symbol__init(void)
 		       symbol_conf.sym_list_str, "symbol") < 0)
 		goto out_free_comm_list;
 
+	symbol_conf.initialized = true;
 	return 0;
 
 out_free_dso_list:
@@ -2304,11 +2308,14 @@ out_free_comm_list:
 
 void symbol__exit(void)
 {
+	if (!symbol_conf.initialized)
+		return;
 	strlist__delete(symbol_conf.sym_list);
 	strlist__delete(symbol_conf.dso_list);
 	strlist__delete(symbol_conf.comm_list);
 	vmlinux_path__exit();
 	symbol_conf.sym_list = symbol_conf.dso_list = symbol_conf.comm_list = NULL;
+	symbol_conf.initialized = false;
 }
 
 int machines__create_kernel_maps(struct rb_root *self, pid_t pid)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b7a8da4..ea95c27 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -69,7 +69,8 @@ struct symbol_conf {
 			show_nr_samples,
 			use_callchain,
 			exclude_other,
-			show_cpu_utilization;
+			show_cpu_utilization,
+			initialized;
 	const char	*vmlinux_name,
 			*source_prefix,
 			*field_sep;
-- 
1.6.2.5

