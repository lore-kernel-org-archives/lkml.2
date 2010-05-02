Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab0EBW77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 18:59:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836Ab0EBW7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 18:59:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 5/5] perf inject: Refactor read_buildid function
Date: Sun,  2 May 2010 19:59:02 -0300
Message-Id: <1272841142-26029-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272841142-26029-1-git-send-email-acme@infradead.org>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Into two functions, one that actually reads the build_id for the dso if
it wasn't already read, and another taht will inject the event if the
build_id is available.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c |   76 +++++++++++++++++++++---------------------
 1 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index a5902a3..59e981a 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -67,46 +67,44 @@ static int event__repipe_tracing_data(event_t *self,
 	return err;
 }
 
-static int read_buildid(struct map *self, struct perf_session *session)
+static int dso__read_build_id(struct dso *self)
 {
-	const char *name = self->dso->long_name;
-	int err;
+	if (self->has_build_id)
+		return 0;
 
-	if (filename__read_build_id(self->dso->long_name, self->dso->build_id,
-				    sizeof(self->dso->build_id)) > 0) {
-		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+	if (filename__read_build_id(self->long_name, self->build_id,
+				    sizeof(self->build_id)) > 0) {
+		self->has_build_id = true;
+		return 0;
+	}
 
-		self->dso->has_build_id = true;
+	return -1;
+}
 
-		build_id__sprintf(self->dso->build_id,
-				  sizeof(self->dso->build_id),
-				  sbuild_id);
-		pr_debug("build id found for %s: %s\n", self->dso->long_name,
-			 sbuild_id);
-	}
+static int dso__inject_build_id(struct dso *self, struct perf_session *session)
+{
+	u16 misc = PERF_RECORD_MISC_USER;
+	struct machine *machine;
+	int err;
 
-	if (self->dso->has_build_id) {
-		u16 misc = PERF_RECORD_MISC_USER;
-		struct machine *machine;
+	if (dso__read_build_id(self) < 0) {
+		pr_debug("no build_id found for %s\n", self->long_name);
+		return -1;
+	}
 
-		misc = self->dso->kernel ? PERF_RECORD_MISC_KERNEL : misc;
+	machine = perf_session__find_host_machine(session);
+	if (machine == NULL) {
+		pr_err("Can't find machine for session\n");
+		return -1;
+	}
 
-		machine = perf_session__find_host_machine(session);
-		if (!machine) {
-			pr_err("Can't find machine for session\n");
-			return -1;
-		}
+	if (self->kernel)
+		misc = PERF_RECORD_MISC_KERNEL;
 
-		err = event__synthesize_build_id(self->dso, misc,
-						 event__repipe, machine,
-						 session);
-		if (err) {
-			pr_err("Can't synthesize build_id event for %s\n",
-			       name);
-			return -1;
-		}
-	} else {
-		pr_debug("no build_id found for %s\n", name);
+	err = event__synthesize_build_id(self, misc, event__repipe,
+					 machine, session);
+	if (err) {
+		pr_err("Can't synthesize build_id event for %s\n", self->long_name);
 		return -1;
 	}
 
@@ -118,7 +116,6 @@ static int event__inject_buildid(event_t *event, struct perf_session *session)
 	struct addr_location al;
 	struct thread *thread;
 	u8 cpumode;
-	int err = 0;
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
@@ -126,7 +123,6 @@ static int event__inject_buildid(event_t *event, struct perf_session *session)
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
-		err = -1;
 		goto repipe;
 	}
 
@@ -136,9 +132,13 @@ static int event__inject_buildid(event_t *event, struct perf_session *session)
 	if (al.map != NULL) {
 		if (!al.map->dso->hit) {
 			al.map->dso->hit = 1;
-			if (map__load(al.map, NULL) >= 0)
-				read_buildid(al.map, session);
-			else
+			if (map__load(al.map, NULL) >= 0) {
+				dso__inject_build_id(al.map->dso, session);
+				/*
+				 * If this fails, too bad, let the other side
+				 * account this as unresolved.
+				 */
+			} else
 				pr_warning("no symbols found in %s, maybe "
 					   "install a debug package?\n",
 					   al.map->dso->long_name);
@@ -147,7 +147,7 @@ static int event__inject_buildid(event_t *event, struct perf_session *session)
 
 repipe:
 	event__repipe(event, session);
-	return err;
+	return 0;
 }
 
 struct perf_event_ops inject_ops = {
-- 
1.6.2.5

