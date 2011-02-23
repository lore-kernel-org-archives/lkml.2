Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab1BWUZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:25:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:49591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab1BWUZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:25:38 -0500
Date: Wed, 23 Feb 2011 20:25:02 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Show better message when no vmlinux is found
Message-ID: <tip-170ae6bc24e1d7f9bd921a484ec9ea2825497970@git.kernel.org>
Git-Commit-ID: 170ae6bc24e1d7f9bd921a484ec9ea2825497970
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 20:25:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  170ae6bc24e1d7f9bd921a484ec9ea2825497970
Gitweb:     http://git.kernel.org/tip/170ae6bc24e1d7f9bd921a484ec9ea2825497970
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 23 Feb 2011 11:08:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Feb 2011 12:13:39 -0300

perf annotate: Show better message when no vmlinux is found

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
