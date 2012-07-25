Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2GYTUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:20:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58278 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2GYTUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:20:20 -0400
Date: Wed, 25 Jul 2012 12:20:04 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-c80c3c269011c67b8dabef5238af44a6d94e4d0e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1342826756-64663-7-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-7-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm:
  Limit repetitive guestmount message to once per directory
Git-Commit-ID: c80c3c269011c67b8dabef5238af44a6d94e4d0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:20:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c80c3c269011c67b8dabef5238af44a6d94e4d0e
Gitweb:     http://git.kernel.org/tip/c80c3c269011c67b8dabef5238af44a6d94e4d0e
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 20 Jul 2012 17:25:51 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 11:31:03 -0300

perf kvm: Limit repetitive guestmount message to once per directory

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
