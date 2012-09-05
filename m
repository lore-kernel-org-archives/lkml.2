Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019Ab2IEXLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:11:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:34321 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759840Ab2IEXJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/17] perf tools: Remove the node from rblist in strlist__remove
Date: Wed,  5 Sep 2012 20:08:51 -0300
Message-Id: <1346886537-11621-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suzuki K. Poulose <suzuki@in.ibm.com>

The following commit:

author	David Ahern <dsahern@gmail.com>
	Tue, 31 Jul 2012 04:31:33 +0000 (22:31 -0600)
committer	Arnaldo Carvalho de Melo <acme@redhat.com>
	Fri, 3 Aug 2012 13:39:51 +0000 (10:39 -0300)
commit	ee8dd3ca43f151d9fbe1edeef68fb8a77eb9f047

causes a double free during a probe deletion as the node is never
removed from the list via strlist__remove(), even though it gets
'deleted' (read free()'d). This causes a double free when we do
strlist__delete() as the node is already deleted but present in the
rblist.

[suzukikp@suzukikp perf]$ sudo ./perf probe -a do_fork
Added new event:
  probe:do_fork        (on do_fork)

You can now use it in all perf tools, such as:

	perf record -e probe:do_fork -aR sleep 1

[suzukikp@suzukikp perf]$ sudo ./perf probe -d do_fork
Removed event: probe:do_fork
*** glibc detected *** ./perf: double free or corruption (fasttop): 0x000000000133d600 ***
======= Backtrace: =========
/lib64/libc.so.6[0x38eec7dda6]
./perf(rblist__delete+0x5c)[0x47d3dc]
./perf(del_perf_probe_events+0xb6)[0x47b826]
./perf(cmd_probe+0x471)[0x42c8d1]
./perf[0x4150b3]
./perf(main+0x501)[0x4148e1]
/lib64/libc.so.6(__libc_start_main+0xed)[0x38eec2169d]
./perf[0x414a61]

Make sure we remove the node from the rblist before we delete the node.
The rblist__remove_node() will invoke rblist->node_delete, which  will
take care of deleting the node with the suitable function provided by
the user.

Reported-by: Ananth N. Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120829055840.7802.1459.stgit@suzukikp.in.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/strlist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 95856ff..155d8b7 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -93,7 +93,7 @@ out:
 
 void strlist__remove(struct strlist *slist, struct str_node *snode)
 {
-	str_node__delete(snode, slist->dupstr);
+	rblist__remove_node(&slist->rblist, &snode->rb_node);
 }
 
 struct str_node *strlist__find(struct strlist *slist, const char *entry)
-- 
1.7.1

