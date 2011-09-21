Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1IUV4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49731 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1IUV4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:05 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 08/26] dynamic_debug: define several levels of verbosity
Date: Wed, 21 Sep 2011 15:54:57 -0600
Message-Id: <1316642115-20029-9-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

define verbose levels 10, 11 to turn on noisy pr_info()s selectively
10: ddebug_proc_(start|stop) - once each per page of output
11: ddebug_proc_(show|next) - once each for every call-site
1-9: are unspecified, may be used for other pr_info()s

No MODULE_PARM_DESC added, as modinfo doesnt report it for built-ins.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 74b395b..b88f918 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -61,6 +61,8 @@ struct ddebug_iter {
 static DEFINE_MUTEX(ddebug_lock);
 static LIST_HEAD(ddebug_tables);
 static int verbose = 0;
+#define VERBOSE_PROC 10		/* enable per-page msgs on control file reads */
+#define VERBOSE_PROC_SHOW 11	/* enable per-line msgs on control file reads */
 module_param(verbose, int, 0644);
 
 /* Return the last part of a pathname */
@@ -636,7 +638,7 @@ static void *ddebug_proc_start(struct seq_file *m, loff_t *pos)
 	struct _ddebug *dp;
 	int n = *pos;
 
-	if (verbose)
+	if (verbose >= VERBOSE_PROC)
 		pr_info("called m=%p *pos=%lld\n", m, (unsigned long long)*pos);
 
 	mutex_lock(&ddebug_lock);
@@ -661,7 +663,7 @@ static void *ddebug_proc_next(struct seq_file *m, void *p, loff_t *pos)
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp;
 
-	if (verbose)
+	if (verbose >= VERBOSE_PROC_SHOW)
 		pr_info("called m=%p p=%p *pos=%lld\n",
 			m, p, (unsigned long long)*pos);
 
@@ -685,7 +687,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	struct _ddebug *dp = p;
 	char flagsbuf[8];
 
-	if (verbose)
+	if (verbose >= VERBOSE_PROC_SHOW)
 		pr_info("called m=%p p=%p\n", m, p);
 
 	if (p == SEQ_START_TOKEN) {
@@ -710,7 +712,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
  */
 static void ddebug_proc_stop(struct seq_file *m, void *p)
 {
-	if (verbose)
+	if (verbose >= VERBOSE_PROC)
 		pr_info("called m=%p p=%p\n", m, p);
 	mutex_unlock(&ddebug_lock);
 }
-- 
1.7.4.4

