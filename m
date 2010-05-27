Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab0E0XQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:16:21 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:43242 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0E0XQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=sSQxLFvEpQuTXkEHQi1XHDmwxydRt8CpsOxAAxPiGasOQw+VYXdzEK+/3wTW3hQ6Bl
         fFswiA2i3KfagQWJvalDvxVXChVlGsT78urbc5L/vqUv8122LQckF0zrsrKCAmWer+W3
         iw5SK76xV4Tll00Iz/MF2BsPtSkc6PWjUPJdI=
Date: Thu, 27 May 2010 20:16:13 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Arun Sharma <aruns@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com
Subject: Re: [PATCH] perf: implement recording/reporting per-cpu samples
Message-ID: <20100527231612.GO9874@ghostprotocols.net>
References: <20100503203813.GA17886@sharma-home.net>
 <1272919356.1642.154.camel@laptop>
 <w2u850c51c31005031353x9be8ca7h90c244d64675ce3e@mail.gmail.com>
 <1272964598.5605.133.camel@twins>
 <20100505181612.GA5091@sharma-home.net>
 <20100527184135.GL9874@ghostprotocols.net>
 <AANLkTim4UdMxxPkhHjVd_433Uk2QoVXBTy44KUlRBNSX@mail.gmail.com>
 <20100527215333.GM9874@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527215333.GM9874@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 27, 2010 at 06:53:33PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, May 27, 2010 at 01:54:46PM -0700, Arun Sharma escreveu:
> > Thanks for taking care of the second part.
> 
> Will try to get it done now and will send for review.

event__preprocess_sample should eventually digest event__parse_sample,
I guess, goal being to separate out what is common to evergrowing set of
perf commands.

Can you see any holes in this one?

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 96db524..9542295 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -65,7 +65,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	dump_printf("(IP, %d): %d: %#Lx\n", event->header.misc,
 		    event->ip.pid, event->ip.ip);
 
-	if (event__preprocess_sample(event, session, &al, NULL) < 0) {
+	if (event__preprocess_sample(event, NULL, session, &al, NULL) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a6e2fdc..1608629 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -38,7 +38,9 @@ static int diff__process_sample_event(event_t *event, struct perf_session *sessi
 	dump_printf("(IP, %d): %d: %#Lx\n", event->header.misc,
 		    event->ip.pid, event->ip.ip);
 
-	if (event__preprocess_sample(event, session, &al, NULL) < 0) {
+	event__parse_sample(event, session->sample_type, &data);
+
+	if (event__preprocess_sample(event, &data, session, &al, NULL) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
@@ -47,8 +49,6 @@ static int diff__process_sample_event(event_t *event, struct perf_session *sessi
 	if (al.filtered || al.sym == NULL)
 		return 0;
 
-	event__parse_sample(event, session->sample_type, &data);
-
 	if (hists__add_entry(&session->hists, &al, data.period)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9bc8905..73f8122 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -274,6 +274,9 @@ static void create_counter(int counter, int cpu)
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
+	if (system_wide)
+		attr->sample_type	|= PERF_SAMPLE_CPU;
+
 	if (raw_samples) {
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 		attr->sample_type	|= PERF_SAMPLE_RAW;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3592057..bb0859f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -157,8 +157,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	event__parse_sample(event, session->sample_type, &data);
 
-	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
-		    data.pid, data.tid, data.ip, data.period);
+	dump_printf("(IP, %d): %d %d/%d: %#Lx period: %Ld\n", event->header.misc,
+		    data.cpu, data.pid, data.tid, data.ip, data.period);
 
 	if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
 		unsigned int i;
@@ -178,7 +178,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		}
 	}
 
-	if (event__preprocess_sample(event, session, &al, NULL) < 0) {
+	if (event__preprocess_sample(event, &data, session, &al, NULL) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a66f427..fc9849a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1024,7 +1024,7 @@ static void event__process_sample(const event_t *self,
 	if (self->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		exact_samples++;
 
-	if (event__preprocess_sample(self, session, &al, symbol_filter) < 0 ||
+	if (event__preprocess_sample(self, NULL, session, &al, symbol_filter) < 0 ||
 	    al.filtered)
 		return;
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 50771b5..cd8bf65 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -659,7 +659,8 @@ static void dso__calc_col_width(struct dso *self)
 	self->slen_calculated = 1;
 }
 
-int event__preprocess_sample(const event_t *self, struct perf_session *session,
+int event__preprocess_sample(const event_t *self, const struct sample_data *data,
+			     struct perf_session *session,
 			     struct addr_location *al, symbol_filter_t filter)
 {
 	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -672,6 +673,9 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 	    !strlist__has_entry(symbol_conf.comm_list, thread->comm))
 		goto out_filtered;
 
+	if (data != NULL)
+		al->cpu = data->cpu;
+
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 	/*
 	 * Have we already created the kernel maps for the host machine?
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 8577085..baedf02 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -156,7 +156,8 @@ int event__process_mmap(event_t *self, struct perf_session *session);
 int event__process_task(event_t *self, struct perf_session *session);
 
 struct addr_location;
-int event__preprocess_sample(const event_t *self, struct perf_session *session,
+int event__preprocess_sample(const event_t *self, const struct sample_data *data,
+			     struct perf_session *session,
 			     struct addr_location *al, symbol_filter_t filter);
 int event__parse_sample(event_t *event, u64 type, struct sample_data *data);
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 2316cb5..4f8e0bf 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -13,6 +13,7 @@ enum sort_type	sort__first_dimension;
 unsigned int dsos__col_width;
 unsigned int comms__col_width;
 unsigned int threads__col_width;
+unsigned int cpu__col_width;
 static unsigned int parent_symbol__col_width;
 char * field_sep;
 
@@ -28,6 +29,8 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 				    size_t size, unsigned int width);
 static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width);
+static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width);
 
 struct sort_entry sort_thread = {
 	.se_header	= "Command:  Pid",
@@ -64,6 +67,13 @@ struct sort_entry sort_parent = {
 	.se_width	= &parent_symbol__col_width,
 };
 
+struct sort_entry sort_cpu = {
+	.se_header      = "CPU",
+	.se_cmp	        = sort__cpu_cmp,
+	.se_snprintf    = hist_entry__cpu_snprintf,
+	.se_width	= &cpu__col_width,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -76,6 +86,7 @@ static struct sort_dimension sort_dimensions[] = {
 	{ .name = "dso",	.entry = &sort_dso,	},
 	{ .name = "symbol",	.entry = &sort_sym,	},
 	{ .name = "parent",	.entry = &sort_parent,	},
+	{ .name = "cpu",	.entry = &sort_cpu,	},
 };
 
 int64_t cmp_null(void *l, void *r)
@@ -242,6 +253,20 @@ static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
 			      self->parent ? self->parent->name : "[other]");
 }
 
+/* --sort cpu */
+
+int64_t
+sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->cpu - left->cpu;
+}
+
+static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
+				       size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*d", width, self->cpu);
+}
+
 int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
@@ -281,6 +306,8 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_SYM;
 			else if (!strcmp(sd->name, "parent"))
 				sort__first_dimension = SORT_PARENT;
+			else if (!strcmp(sd->name, "cpu"))
+				sort__first_dimension = SORT_CPU;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 0d61c40..dcc6f42 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -55,6 +55,7 @@ struct hist_entry {
 	char			level;
 	u8			filtered;
 	struct symbol		*parent;
+	s32                     cpu;
 	union {
 		unsigned long	  position;
 		struct hist_entry *pair;
@@ -68,7 +69,8 @@ enum sort_type {
 	SORT_COMM,
 	SORT_DSO,
 	SORT_SYM,
-	SORT_PARENT
+	SORT_PARENT,
+	SORT_CPU
 };
 
 /*
@@ -97,6 +99,8 @@ extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__dso_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__sym_print(FILE *, struct hist_entry *, unsigned int __used);
+extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
+extern size_t sort__cpu_print(FILE *, struct hist_entry *, unsigned int);
 extern int64_t cmp_null(void *, void *);
 extern int64_t sort__thread_cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t sort__comm_cmp(struct hist_entry *, struct hist_entry *);
@@ -104,7 +108,7 @@ extern int64_t sort__comm_collapse(struct hist_entry *, struct hist_entry *);
 extern int64_t sort__dso_cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
-extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
+extern int64_t sort__cpu_cmp(struct hist_entry *, struct hist_entry *);
 extern int sort_dimension__add(const char *);
 void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
 			     const char *list_name, FILE *fp);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5e02d2c..e9a5848 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -113,6 +113,7 @@ struct addr_location {
 	char	      level;
 	bool	      filtered;
 	unsigned int  cpumode;
+	s32           cpu;
 };
 
 enum dso_kernel_type {
