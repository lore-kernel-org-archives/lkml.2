Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab1BWT1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:27:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:43742 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab1BWT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:27:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/1] perf annotate: Show better message when no vmlinux is found
Date: Wed, 23 Feb 2011 16:27:29 -0300
Message-Id: <1298489249-7777-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298489249-7777-1-git-send-email-acme@infradead.org>
References: <1298489249-7777-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In both --tui and --stdio, in 'annotate', 'top', 'report' when trying to
annotate a kernel symbol having just access to a kallsyms file, that
doesn't have the DWARF info needed for annotation.

Suggested-by: Ingo Molnar <mingo@elte.hu>
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
 tools/perf/util/annotate.c          |   15 +++++++++++++--
 tools/perf/util/ui/browsers/hists.c |    8 --------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 70ec422..0d0830c 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -295,12 +295,23 @@ fallback:
 	}
 
 	if (dso->origin == DSO__ORIG_KERNEL) {
+		char bf[BUILD_ID_SIZE * 2 + 16] = " with build id ";
+		char *build_id_msg = NULL;
+
 		if (dso->annotate_warned)
 			goto out_free_filename;
+
+		if (dso->has_build_id) {
+			build_id__sprintf(dso->build_id,
+					  sizeof(dso->build_id), bf + 15);
+			build_id_msg = bf;
+		}
 		err = -ENOENT;
 		dso->annotate_warned = 1;
-		pr_err("Can't annotate %s: No vmlinux file was found in the "
-		       "path\n", sym->name);
+		pr_err("Can't annotate %s: No vmlinux file%s was found in the "
+		       "path.\nPlease use 'perf buildid-cache -av vmlinux' or "
+		       "--vmlinux vmlinux.\n",
+		       sym->name, build_id_msg ?: "");
 		goto out_free_filename;
 	}
 
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 294b495..497b3c4 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -924,14 +924,6 @@ int hists__browse(struct hists *self, const char *helpline,
 		if (choice == annotate) {
 			struct hist_entry *he;
 do_annotate:
-			if (browser->selection->map->dso->origin == DSO__ORIG_KERNEL) {
-				browser->selection->map->dso->annotate_warned = 1;
-				ui_helpline__puts("No vmlinux file found, can't "
-						 "annotate with just a "
-						 "kallsyms file");
-				continue;
-			}
-
 			he = hist_browser__selected_entry(browser);
 			if (he == NULL)
 				continue;
-- 
1.6.2.5

