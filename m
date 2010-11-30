Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0K3Pkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:40:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:33871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab0K3Pko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:40:44 -0500
Date: Tue, 30 Nov 2010 15:40:07 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, tom.leiming@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, tom.leiming@gmail.com, mingo@elte.hu
In-Reply-To: <20101124144540.GB15875@ghostprotocols.net>
References: <20101124144540.GB15875@ghostprotocols.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Fix kallsyms kernel/module map splitting
Message-ID: <tip-8a9533123f43f2cdb3eb601c17ff2ad336882eff@git.kernel.org>
Git-Commit-ID: 8a9533123f43f2cdb3eb601c17ff2ad336882eff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Nov 2010 15:40:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a9533123f43f2cdb3eb601c17ff2ad336882eff
Gitweb:     http://git.kernel.org/tip/8a9533123f43f2cdb3eb601c17ff2ad336882eff
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 29 Nov 2010 12:44:15 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 14:47:51 -0200

perf symbols: Fix kallsyms kernel/module map splitting

On ARM, module addresss space is ahead of kernel space, so the module
symbols are handled before kernel symbol in dso__split_kallsyms, then
was causing one map to be created for each kernel symbol.

Reported-by: Ming Lei <tom.leiming@gmail.com>
Tested-by: Ming Lei <tom.leiming@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20101124144540.GB15875@ghostprotocols.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0500895..2af4d7d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -532,7 +532,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 	struct machine *machine = kmaps->machine;
 	struct map *curr_map = map;
 	struct symbol *pos;
-	int count = 0;
+	int count = 0, moved = 0;	
 	struct rb_root *root = &self->symbols[map->type];
 	struct rb_node *next = rb_first(root);
 	int kernel_range = 0;
@@ -590,6 +590,11 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			char dso_name[PATH_MAX];
 			struct dso *dso;
 
+			if (count == 0) {
+				curr_map = map;
+				goto filter_symbol;
+			}
+
 			if (self->kernel == DSO_TYPE_GUEST_KERNEL)
 				snprintf(dso_name, sizeof(dso_name),
 					"[guest.kernel].%d",
@@ -615,7 +620,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			map_groups__insert(kmaps, curr_map);
 			++kernel_range;
 		}
-
+filter_symbol:
 		if (filter && filter(curr_map, pos)) {
 discard_symbol:		rb_erase(&pos->rb_node, root);
 			symbol__delete(pos);
@@ -623,8 +628,9 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 			if (curr_map != map) {
 				rb_erase(&pos->rb_node, root);
 				symbols__insert(&curr_map->dso->symbols[curr_map->type], pos);
-			}
-			count++;
+				++moved;
+			} else
+				++count;
 		}
 	}
 
@@ -634,7 +640,7 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 		dso__set_loaded(curr_map->dso, curr_map->type);
 	}
 
-	return count;
+	return count + moved;
 }
 
 int dso__load_kallsyms(struct dso *self, const char *filename,
