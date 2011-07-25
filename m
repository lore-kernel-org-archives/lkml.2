Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1GYVnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63998 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1GYVnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:23 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 05/25] dynamic_debug: trim source-path prefix from dynamic_debug/control
Date: Mon, 25 Jul 2011 15:42:30 -0600
Message-Id: <1311630170-26057-6-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
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
index 887940d..76f80dc 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -646,6 +646,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp = p;
 	char flagsbuf[8];
+	int skip = strlen(__FILE__) - strlen("lib/dynamic_debug.c");
 
 	pr_debug("called m=%p p=%p\n", m, p);
 
@@ -655,8 +656,11 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
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

