Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1CHJnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:43:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:46135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab1CHJnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:43:39 -0500
Date: Tue, 8 Mar 2011 09:43:09 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Remove needless global col lenght calcs
Message-ID: <tip-d7603d5122d9700fb8f36fa08b04f4e900fef059@git.kernel.org>
Git-Commit-ID: d7603d5122d9700fb8f36fa08b04f4e900fef059
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Mar 2011 09:43:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7603d5122d9700fb8f36fa08b04f4e900fef059
Gitweb:     http://git.kernel.org/tip/d7603d5122d9700fb8f36fa08b04f4e900fef059
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 4 Mar 2011 14:51:33 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 5 Mar 2011 22:31:04 -0300

perf hists: Remove needless global col lenght calcs

To support multiple events we need to do these calcs per 'struct hists'
instance, and it turns out we already do that at:

	__hists__add_entry
		hists__inc_nr_entries
			hists__calc_col_len

for all the unfiltered hist_entry instances we stash in the rb tree, so
trow away the dead code.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |   57 +---------------------------------------------
 tools/perf/util/hist.c   |    9 +++++++
 tools/perf/util/symbol.c |    1 -
 tools/perf/util/symbol.h |    1 -
 4 files changed, 10 insertions(+), 58 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index fbf5754..2b15c36 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -424,33 +424,6 @@ int perf_event__synthesize_kernel_mmap(perf_event__handler_t process,
 	return err;
 }
 
-static void thread__comm_adjust(struct thread *self, struct hists *hists)
-{
-	char *comm = self->comm;
-
-	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
-	    (!symbol_conf.comm_list ||
-	     strlist__has_entry(symbol_conf.comm_list, comm))) {
-		u16 slen = strlen(comm);
-
-		if (hists__new_col_len(hists, HISTC_COMM, slen))
-			hists__set_col_len(hists, HISTC_THREAD, slen + 6);
-	}
-}
-
-static int thread__set_comm_adjust(struct thread *self, const char *comm,
-				   struct hists *hists)
-{
-	int ret = thread__set_comm(self, comm);
-
-	if (ret)
-		return ret;
-
-	thread__comm_adjust(self, hists);
-
-	return 0;
-}
-
 int perf_event__process_comm(union perf_event *event,
 			     struct perf_sample *sample __used,
 			     struct perf_session *session)
@@ -459,8 +432,7 @@ int perf_event__process_comm(union perf_event *event,
 
 	dump_printf(": %s:%d\n", event->comm.comm, event->comm.tid);
 
-	if (thread == NULL || thread__set_comm_adjust(thread, event->comm.comm,
-						      &session->hists)) {
+	if (thread == NULL || thread__set_comm(thread, event->comm.comm)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
 		return -1;
 	}
@@ -760,18 +732,6 @@ void thread__find_addr_location(struct thread *self,
 		al->sym = NULL;
 }
 
-static void dso__calc_col_width(struct dso *self, struct hists *hists)
-{
-	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
-	    (!symbol_conf.dso_list ||
-	     strlist__has_entry(symbol_conf.dso_list, self->name))) {
-		u16 slen = dso__name_len(self);
-		hists__new_col_len(hists, HISTC_DSO, slen);
-	}
-
-	self->slen_calculated = 1;
-}
-
 int perf_event__preprocess_sample(const union perf_event *event,
 				  struct perf_session *session,
 				  struct addr_location *al,
@@ -817,23 +777,8 @@ int perf_event__preprocess_sample(const union perf_event *event,
 			strlist__has_entry(symbol_conf.dso_list,
 					   al->map->dso->long_name)))))
 			goto out_filtered;
-		/*
-		 * We have to do this here as we may have a dso with no symbol
-		 * hit that has a name longer than the ones with symbols
-		 * sampled.
-		 */
-		if (!sort_dso.elide && !al->map->dso->slen_calculated)
-			dso__calc_col_width(al->map->dso, &session->hists);
 
 		al->sym = map__find_symbol(al->map, al->addr, filter);
-	} else {
-		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
-
-		if (hists__col_len(&session->hists, HISTC_DSO) < unresolved_col_width &&
-		    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
-		    !symbol_conf.dso_list)
-			hists__set_col_len(&session->hists, HISTC_DSO,
-					   unresolved_col_width);
 	}
 
 	if (symbol_conf.sym_list && al->sym &&
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index da2899e..f7ad6bd 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -50,6 +50,15 @@ static void hists__calc_col_len(struct hists *self, struct hist_entry *h)
 
 	if (h->ms.sym)
 		hists__new_col_len(self, HISTC_SYMBOL, h->ms.sym->namelen);
+	else {
+		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
+
+		if (hists__col_len(self, HISTC_DSO) < unresolved_col_width &&
+		    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
+		    !symbol_conf.dso_list)
+			hists__set_col_len(self, HISTC_DSO,
+					   unresolved_col_width);
+	}
 
 	len = thread__comm_len(h->thread);
 	if (hists__new_col_len(self, HISTC_COMM, len))
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ba6d489..00014e3 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -207,7 +207,6 @@ struct dso *dso__new(const char *name)
 		dso__set_short_name(self, self->name);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
-		self->slen_calculated = 0;
 		self->origin = DSO__ORIG_NOT_FOUND;
 		self->loaded = 0;
 		self->sorted_by_name = 0;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 670cd1c..4d7ed09 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -132,7 +132,6 @@ struct dso {
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
 	enum dso_kernel_type	kernel;
 	u8		 adjust_symbols:1;
-	u8		 slen_calculated:1;
 	u8		 has_build_id:1;
 	u8		 hit:1;
 	u8		 annotate_warned:1;
