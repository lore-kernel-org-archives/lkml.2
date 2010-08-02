Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0HBHxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:53:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:60419 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab0HBHxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:53:02 -0400
Date: Mon, 2 Aug 2010 07:52:20 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Precisely specify if dso->{long,short}_name should be freed
Message-ID: <tip-6e406257b3794009e3b7a6d48b54beb547719565@git.kernel.org>
Git-Commit-ID: 6e406257b3794009e3b7a6d48b54beb547719565
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:52:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e406257b3794009e3b7a6d48b54beb547719565
Gitweb:     http://git.kernel.org/tip/6e406257b3794009e3b7a6d48b54beb547719565
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 29 Jul 2010 15:11:30 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Jul 2010 15:11:30 -0300

perf symbols: Precisely specify if dso->{long,short}_name should be freed

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    1 +
 tools/perf/util/symbol.c |    5 ++++-
 tools/perf/util/symbol.h |    4 +++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 5b81bb2..8151d23 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -456,6 +456,7 @@ static int event__process_kernel_mmap(event_t *self,
 			goto out_problem;
 
 		map->dso->short_name = name;
+		map->dso->sname_alloc = 1;
 		map->end = map->start + self->mmap.len;
 	} else if (is_kernel_mmap) {
 		const char *symbol_name = (self->mmap.filename +
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index bc6e7e8..242d2b2 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -224,7 +224,9 @@ void dso__delete(struct dso *self)
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
 		symbols__delete(&self->symbols[i]);
-	if (self->long_name != self->name)
+	if (self->sname_alloc)
+		free((char *)self->short_name);
+	if (self->lname_alloc)
 		free(self->long_name);
 	free(self);
 }
@@ -1530,6 +1532,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 			if (long_name == NULL)
 				goto failure;
 			dso__set_long_name(map->dso, long_name);
+			map->dso->lname_alloc = 1;
 			dso__kernel_module_get_build_id(map->dso, "");
 		}
 	}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 6452a07..f29f73c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -126,12 +126,14 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
+	enum dso_kernel_type	kernel;
 	u8		 adjust_symbols:1;
 	u8		 slen_calculated:1;
 	u8		 has_build_id:1;
-	enum dso_kernel_type	kernel;
 	u8		 hit:1;
 	u8		 annotate_warned:1;
+	u8		 sname_alloc:1;
+	u8		 lname_alloc:1;
 	unsigned char	 origin;
 	u8		 sorted_by_name;
 	u8		 loaded;
