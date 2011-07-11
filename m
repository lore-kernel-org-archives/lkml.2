Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab1GKHrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:47:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964837Ab1GKHrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:42 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 16/21] dynamic_debug: define several levels of verbosity
Date: Mon, 11 Jul 2011 01:46:51 -0600
Message-Id: <1310370416-6322-17-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

define verbose levels 10, 11 to turn on noisy pr_info()s selectively
10: ddebug_proc_(start|stop) - once each per page of output
11: ddebug_proc_(show|next) - once each for every call-site
1-9: are unspecified, may be used for other pr_info()s

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 31ee0fd..8dde999 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -70,7 +70,11 @@ struct ddebug_iter {
 
 static DEFINE_MUTEX(ddebug_lock);
 static LIST_HEAD(ddebug_tables);
-static int verbose = 0;
+
+#define VERB_BASIC 1
+#define VERB_PROC 10
+#define VERB_PROC_SHOW 11
+static int verbose;
 module_param(verbose, int, 0644);
 
 /* legal but inapplicable queries, save and test against new modules */
@@ -777,7 +781,7 @@ static void *ddebug_proc_start(struct seq_file *m, loff_t *pos)
 	struct _ddebug *dp;
 	int n = *pos;
 
-	if (verbose)
+	if (verbose >= VERB_PROC)
 		pr_info("called m=%p *pos=%lld\n", m, (unsigned long long)*pos);
 
 	mutex_lock(&ddebug_lock);
@@ -802,7 +806,7 @@ static void *ddebug_proc_next(struct seq_file *m, void *p, loff_t *pos)
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp;
 
-	if (verbose)
+	if (verbose >= VERB_PROC_SHOW)
 		pr_info("called m=%p p=%p *pos=%lld\n",
 			m, p, (unsigned long long)*pos);
 
@@ -826,7 +830,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	struct _ddebug *dp = p;
 	char flagsbuf[8];
 
-	if (verbose)
+	if (verbose >= VERB_PROC_SHOW)
 		pr_info("called m=%p p=%p\n", m, p);
 
 	if (p == SEQ_START_TOKEN) {
@@ -851,7 +855,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
  */
 static void ddebug_proc_stop(struct seq_file *m, void *p)
 {
-	if (verbose)
+	if (verbose >= VERB_PROC)
 		pr_info("called m=%p p=%p\n", m, p);
 	mutex_unlock(&ddebug_lock);
 }
-- 
1.7.4.1

