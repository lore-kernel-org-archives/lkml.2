Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2GTX2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:28:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2GTX0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:26:20 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 06/11] perf kvm: limit repetitive guestmount message to once per directory
Date: Fri, 20 Jul 2012 17:25:51 -0600
Message-Id: <1342826756-64663-7-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 7ed97ad use of the guestmount option without a subdir for *each*
VM generates an error message for each sample related to that VM. Once
per VM is enough.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/map.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

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
1.7.10.1

