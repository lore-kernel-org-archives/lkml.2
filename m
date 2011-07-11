Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1GKHru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:47:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab1GKHrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:46 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 18/21] dynamic_debug: trim source-path prefix from dynamic_debug/control
Date: Mon, 11 Jul 2011 01:46:53 -0600
Message-Id: <1310370416-6322-19-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for a common source-path prefix, and skip past it, to print a
path thats relative to kernel source's root-dir.  For in-tree modules,
this makes the control file easier to read without a wide screen.

For example:
  kernel/freezer.c:128 [freezer]cancel_freezing - "  clean up: %s\012"

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 1763cc2..44ccc02 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -829,6 +829,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp = p;
 	char flagsbuf[8];
+	int skip = strlen(__FILE__) - strlen("lib/dynamic_debug.c");
 
 	if (verbose >= VERB_PROC_SHOW)
 		pr_info("called m=%p p=%p\n", m, p);
@@ -839,8 +840,11 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 		return 0;
 	}
 
+	if (strncmp(dp->filename, __FILE__, skip))
+		skip = 0; /* prefix mismatch, don't skip */
+
 	seq_printf(m, "%s:%u [%s]%s %s \"",
-		   dp->filename, dp->lineno,
+		   dp->filename + skip, dp->lineno,
 		   iter->table->mod_name, dp->function,
 		   ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
 	seq_escape(m, dp->format, "\t\r\n\"");
-- 
1.7.4.1

