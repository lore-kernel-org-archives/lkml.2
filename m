Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab2IGGE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:04:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55050 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2IGGEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:04:55 -0400
Date: Thu, 6 Sep 2012 23:04:33 -0700
From: "tip-bot for Suzuki K. Poulose" <suzuki@in.ibm.com>
Message-ID: <tip-4592281403e74dc4401d5803ec9948d43bbee7ae@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, ananth@in.ibm.com, fweisbec@gmail.com,
        suzuki@in.ibm.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, ananth@in.ibm.com, fweisbec@gmail.com,
        suzuki@in.ibm.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <20120829055840.7802.1459.stgit@suzukikp.in.ibm.com>
References: <20120829055840.7802.1459.stgit@suzukikp.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove the node from rblist in strlist__remove
Git-Commit-ID: 4592281403e74dc4401d5803ec9948d43bbee7ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:04:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4592281403e74dc4401d5803ec9948d43bbee7ae
Gitweb:     http://git.kernel.org/tip/4592281403e74dc4401d5803ec9948d43bbee7ae
Author:     Suzuki K. Poulose <suzuki@in.ibm.com>
AuthorDate: Wed, 29 Aug 2012 11:30:07 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:36:42 -0300

perf tools: Remove the node from rblist in strlist__remove

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
