Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab2GYRqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:46:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55590 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2GYRlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/19] perf kvm: Limit repetitive guestmount message to once per directory
Date: Wed, 25 Jul 2012 14:41:20 -0300
Message-Id: <1343238094-12481-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

After 7ed97ad use of the guestmount option without a subdir for *each*
VM generates an error message for each sample related to that VM. Once
per VM is enough.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1342826756-64663-7-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 16d783d..cc33486 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -8,6 +8,7 @@
 #include <unistd.h>
 #include "map.h"
 #include "thread.h"
+#include "strlist.h"
 
 const char *map_type__name[MAP__NR_TYPES] = {
 	[MAP__FUNCTION] = "Functions",
@@ -695,7 +696,15 @@ struct machine *machines__findnew(struct rb_root *self, pid_t pid)
 	    (symbol_conf.guestmount)) {
 		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
 		if (access(path, R_OK)) {
-			pr_err("Can't access file %s\n", path);
+			static struct strlist *seen;
+
+			if (!seen)
+				seen = strlist__new(true, NULL);
+
+			if (!strlist__has_entry(seen, path)) {
+				pr_err("Can't access file %s\n", path);
+				strlist__add(seen, path);
+			}
 			machine = NULL;
 			goto out;
 		}
-- 
1.7.1

