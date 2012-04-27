Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab2D0Idk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:33:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2D0Idh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:33:37 -0400
Date: Fri, 27 Apr 2012 01:33:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-7dxjiwqb77wz6f5lc05e0i0x@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Align jump labels
Git-Commit-ID: 61e04b332e9417720c331eb39c96a4ccb1aa0460
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:33:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61e04b332e9417720c331eb39c96a4ccb1aa0460
Gitweb:     http://git.kernel.org/tip/61e04b332e9417720c331eb39c96a4ccb1aa0460
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Apr 2012 13:15:24 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Apr 2012 13:15:24 -0300

perf annotate browser: Align jump labels

Find out at browser startup the max width and use it when rendering jump
labels on the screen.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-7dxjiwqb77wz6f5lc05e0i0x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   17 +++++++++++++----
 tools/perf/util/util.c            |   10 ++++++++++
 tools/perf/util/util.h            |    2 ++
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index a1e942b..c5ab21c 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -31,6 +31,7 @@ struct annotate_browser {
 	bool		    hide_src_code;
 	bool		    use_offset;
 	bool		    searching_backwards;
+	u8		    offset_width;
 	char		    search_bf[128];
 };
 
@@ -92,10 +93,17 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		if (!ab->use_offset)
 			addr += ab->start;
 
-		if (bdl->jump_target || !ab->use_offset)
-			printed = scnprintf(bf, sizeof(bf), " %" PRIx64 ":", addr);
-		else
-			printed = scnprintf(bf, sizeof(bf), "    ");
+		if (!ab->use_offset) {
+			printed = scnprintf(bf, sizeof(bf), "%" PRIx64 ":", addr);
+		} else {
+			if (bdl->jump_target) {
+				printed = scnprintf(bf, sizeof(bf), "%*" PRIx64 ":",
+						    ab->offset_width, addr);
+			} else {
+				printed = scnprintf(bf, sizeof(bf), "%*s ",
+						    ab->offset_width, " ");
+			}
+		}
 
 		if (change_color)
 			color = ui_browser__set_color(self, HE_COLORSET_ADDR);
@@ -687,6 +695,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	annotate_browser__mark_jump_targets(&browser, size);
 
+	browser.offset_width = hex_width(size);
 	browser.b.nr_entries = browser.nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8109a90..d03599f 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -148,3 +148,13 @@ int readn(int fd, void *buf, size_t n)
 
 	return buf - buf_start;
 }
+
+size_t hex_width(u64 v)
+{
+	size_t n = 1;
+
+	while ((v >>= 4))
+		++n;
+
+	return n;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 0f99f39..6121e24 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -265,4 +265,6 @@ bool is_power_of_2(unsigned long n)
 	return (n != 0 && ((n & (n - 1)) == 0));
 }
 
+size_t hex_width(u64 v);
+
 #endif
