Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab1CISbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:31:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1CISbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:31:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 01/10] perf session: Simplify evlist creation from perf.data header
Date: Wed,  9 Mar 2011 15:31:22 -0300
Message-Id: <1299695491-15786-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299695491-15786-1-git-send-email-acme@infradead.org>
References: <1299695491-15786-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We don't need to do that perf_header__add_attr +
perf_header_attr__add_id to then create the evsels and hash its ids.

Next csets will finish this perf_header and perf_header_attr stuff,
using the evsels for its purpose.

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
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-report.c |    4 +-
 tools/perf/util/header.c    |   66 +++++++++++++++++++++++++-----------------
 tools/perf/util/header.h    |    6 ++--
 tools/perf/util/session.c   |   53 ++--------------------------------
 5 files changed, 49 insertions(+), 82 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d40a81e..9d236e8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -524,7 +524,7 @@ static int __cmd_record(int argc, const char **argv)
 		perf_header__set_feat(&session->header, HEADER_BUILD_ID);
 
 	if (!file_new) {
-		err = perf_header__read(session, output);
+		err = perf_session__read_header(session, output);
 		if (err < 0)
 			goto out_delete_session;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e9b5d51..b1b8200 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -70,8 +70,8 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 		 * FIXME: Propagate this back, but at least we're in a builtin,
 		 * where exit() is allowed. ;-)
 		 */
-		ui__warning("Invalid %s file, contains samples with id not in "
-			    "its header!\n", input_name);
+		ui__warning("Invalid %s file, contains samples with id %" PRIu64 " not in "
+			    "its header!\n", input_name, sample->id);
 		exit_browser(0);
 		exit(1);
 	}
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 108b0db..3457ec6 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 
 #include "evlist.h"
+#include "evsel.h"
 #include "util.h"
 #include "header.h"
 #include "../perf.h"
@@ -861,7 +862,7 @@ static int perf_header__read_pipe(struct perf_session *session, int fd)
 	return 0;
 }
 
-int perf_header__read(struct perf_session *session, int fd)
+int perf_session__read_header(struct perf_session *session, int fd)
 {
 	struct perf_header *self = &session->header;
 	struct perf_file_header	f_header;
@@ -869,6 +870,10 @@ int perf_header__read(struct perf_session *session, int fd)
 	u64			f_id;
 	int nr_attrs, nr_ids, i, j;
 
+	session->evlist = perf_evlist__new(NULL, NULL);
+	if (session->evlist == NULL)
+		return -ENOMEM;
+
 	if (session->fd_pipe)
 		return perf_header__read_pipe(session, fd);
 
@@ -881,33 +886,39 @@ int perf_header__read(struct perf_session *session, int fd)
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
 
 	for (i = 0; i < nr_attrs; i++) {
-		struct perf_header_attr *attr;
+		struct perf_evsel *evsel;
 		off_t tmp;
 
 		if (perf_header__getbuffer64(self, fd, &f_attr, sizeof(f_attr)))
 			goto out_errno;
 
 		tmp = lseek(fd, 0, SEEK_CUR);
+		evsel = perf_evsel__new(&f_attr.attr, i);
 
-		attr = perf_header_attr__new(&f_attr.attr);
-		if (attr == NULL)
-			 return -ENOMEM;
+		if (evsel == NULL)
+			goto out_delete_evlist;
+		/*
+		 * Do it before so that if perf_evsel__alloc_id fails, this
+		 * entry gets purged too at perf_evlist__delete().
+		 */
+		perf_evlist__add(session->evlist, evsel);
 
 		nr_ids = f_attr.ids.size / sizeof(u64);
+		/*
+		 * We don't have the cpu and thread maps on the header, so
+		 * for allocating the perf_sample_id table we fake 1 cpu and
+		 * hattr->ids threads.
+		 */
+		if (perf_evsel__alloc_id(evsel, 1, nr_ids))
+			goto out_delete_evlist;
+
 		lseek(fd, f_attr.ids.offset, SEEK_SET);
 
 		for (j = 0; j < nr_ids; j++) {
 			if (perf_header__getbuffer64(self, fd, &f_id, sizeof(f_id)))
 				goto out_errno;
 
-			if (perf_header_attr__add_id(attr, f_id) < 0) {
-				perf_header_attr__delete(attr);
-				return -ENOMEM;
-			}
-		}
-		if (perf_header__add_attr(self, attr) < 0) {
-			perf_header_attr__delete(attr);
-			return -ENOMEM;
+			perf_evlist__id_hash(session->evlist, evsel, 0, j, f_id);
 		}
 
 		lseek(fd, tmp, SEEK_SET);
@@ -932,37 +943,38 @@ int perf_header__read(struct perf_session *session, int fd)
 	return 0;
 out_errno:
 	return -errno;
+
+out_delete_evlist:
+	perf_evlist__delete(session->evlist);
+	session->evlist = NULL;
+	return -ENOMEM;
 }
 
-u64 perf_header__sample_type(struct perf_header *header)
+u64 perf_evlist__sample_type(struct perf_evlist *evlist)
 {
+	struct perf_evsel *pos;
 	u64 type = 0;
-	int i;
-
-	for (i = 0; i < header->attrs; i++) {
-		struct perf_header_attr *attr = header->attr[i];
 
+	list_for_each_entry(pos, &evlist->entries, node) {
 		if (!type)
-			type = attr->attr.sample_type;
-		else if (type != attr->attr.sample_type)
+			type = pos->attr.sample_type;
+		else if (type != pos->attr.sample_type)
 			die("non matching sample_type");
 	}
 
 	return type;
 }
 
-bool perf_header__sample_id_all(const struct perf_header *header)
+bool perf_evlist__sample_id_all(const struct perf_evlist *evlist)
 {
 	bool value = false, first = true;
-	int i;
-
-	for (i = 0; i < header->attrs; i++) {
-		struct perf_header_attr *attr = header->attr[i];
+	struct perf_evsel *pos;
 
+	list_for_each_entry(pos, &evlist->entries, node) {
 		if (first) {
-			value = attr->attr.sample_id_all;
+			value = pos->attr.sample_id_all;
 			first = false;
-		} else if (value != attr->attr.sample_id_all)
+		} else if (value != pos->attr.sample_id_all)
 			die("non matching sample_id_all");
 	}
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 2fab133..73b84eb 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -67,7 +67,7 @@ void perf_header__exit(struct perf_header *self);
 
 struct perf_evlist;
 
-int perf_header__read(struct perf_session *session, int fd);
+int perf_session__read_header(struct perf_session *session, int fd);
 int perf_header__write(struct perf_header *self, struct perf_evlist *evlist,
 		       int fd, bool at_exit);
 int perf_header__write_pipe(int fd);
@@ -83,8 +83,8 @@ void perf_header_attr__delete(struct perf_header_attr *self);
 
 int perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 
-u64 perf_header__sample_type(struct perf_header *header);
-bool perf_header__sample_id_all(const struct perf_header *header);
+u64 perf_evlist__sample_type(struct perf_evlist *evlist);
+bool perf_evlist__sample_id_all(const struct perf_evlist *evlist);
 void perf_header__set_feat(struct perf_header *self, int feat);
 void perf_header__clear_feat(struct perf_header *self, int feat);
 bool perf_header__has_feat(const struct perf_header *self, int feat);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0d41419..26b24c5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -13,46 +13,6 @@
 #include "sort.h"
 #include "util.h"
 
-static int perf_session__read_evlist(struct perf_session *session)
-{
-	int i, j;
-
-	session->evlist = perf_evlist__new(NULL, NULL);
-	if (session->evlist == NULL)
-		return -ENOMEM;
-
-	for (i = 0; i < session->header.attrs; ++i) {
-		struct perf_header_attr *hattr = session->header.attr[i];
-		struct perf_evsel *evsel = perf_evsel__new(&hattr->attr, i);
-
-		if (evsel == NULL)
-			goto out_delete_evlist;
-		/*
-		 * Do it before so that if perf_evsel__alloc_id fails, this
-		 * entry gets purged too at perf_evlist__delete().
-		 */
-		perf_evlist__add(session->evlist, evsel);
-		/*
-		 * We don't have the cpu and thread maps on the header, so
-		 * for allocating the perf_sample_id table we fake 1 cpu and
-		 * hattr->ids threads.
-		 */
-		if (perf_evsel__alloc_id(evsel, 1, hattr->ids))
-			goto out_delete_evlist;
-
-		for (j = 0; j < hattr->ids; ++j)
-			perf_evlist__id_hash(session->evlist, evsel, 0, j,
-					     hattr->id[j]);
-	}
-
-	return 0;
-
-out_delete_evlist:
-	perf_evlist__delete(session->evlist);
-	session->evlist = NULL;
-	return -ENOMEM;
-}
-
 static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
@@ -61,7 +21,7 @@ static int perf_session__open(struct perf_session *self, bool force)
 		self->fd_pipe = true;
 		self->fd = STDIN_FILENO;
 
-		if (perf_header__read(self, self->fd) < 0)
+		if (perf_session__read_header(self, self->fd) < 0)
 			pr_err("incompatible file format");
 
 		return 0;
@@ -93,16 +53,11 @@ static int perf_session__open(struct perf_session *self, bool force)
 		goto out_close;
 	}
 
-	if (perf_header__read(self, self->fd) < 0) {
+	if (perf_session__read_header(self, self->fd) < 0) {
 		pr_err("incompatible file format");
 		goto out_close;
 	}
 
-	if (perf_session__read_evlist(self) < 0) {
-		pr_err("Not enough memory to read the event selector list\n");
-		goto out_close;
-	}
-
 	self->size = input_stat.st_size;
 	return 0;
 
@@ -152,8 +107,8 @@ void perf_session__set_sample_type(struct perf_session *session, u64 type)
 
 void perf_session__update_sample_type(struct perf_session *self)
 {
-	self->sample_type = perf_header__sample_type(&self->header);
-	self->sample_id_all = perf_header__sample_id_all(&self->header);
+	self->sample_type = perf_evlist__sample_type(self->evlist);
+	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	perf_session__id_header_size(self);
 }
 
-- 
1.6.2.5

