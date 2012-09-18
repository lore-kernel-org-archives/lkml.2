Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2IRXh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:37:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55124 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2IRXhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:37:16 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 4/6] dyndbg: increase verbosity for proc-show, proc-next
Date: Tue, 18 Sep 2012 17:36:45 -0600
Message-Id: <1348011407-24108-5-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
References: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dynamic_debug.verbose=1, catting /dbg/dynamic_debug/control
creates reams of log entries from ddebug_proc_(show|next|start|open).

Add vXpr_info() macro, and adjust verbosity required to enable those
callsites to 9 for show, next, and 8 for start, open.  This leaves
other verbosity levels available should that appear useful later.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 85258a8..11a8897 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -107,8 +107,12 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	return buf;
 }
 
-#define vpr_info(fmt, ...) \
-	if (verbose) do { pr_info(fmt, ##__VA_ARGS__); } while (0)
+#define vXpr_info(X, fmt, ...) \
+	if (verbose >= X) do { pr_info(fmt, ##__VA_ARGS__); } while (0)
+
+#define vpr_info(fmt, ...)	vXpr_info(1, fmt, ##__VA_ARGS__)
+#define v8pr_info(fmt, ...)	vXpr_info(8, fmt, ##__VA_ARGS__)
+#define v9pr_info(fmt, ...)	vXpr_info(9, fmt, ##__VA_ARGS__)
 
 #define vpr_info_dq(q, msg)					\
 do {								\
@@ -768,7 +772,7 @@ static void *ddebug_proc_start(struct seq_file *m, loff_t *pos)
 	struct _ddebug *dp;
 	int n = *pos;
 
-	vpr_info("called m=%p *pos=%lld\n", m, (unsigned long long)*pos);
+	v8pr_info("called m=%p *pos=%lld\n", m, (unsigned long long)*pos);
 
 	mutex_lock(&ddebug_lock);
 
@@ -792,7 +796,7 @@ static void *ddebug_proc_next(struct seq_file *m, void *p, loff_t *pos)
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp;
 
-	vpr_info("called m=%p p=%p *pos=%lld\n",
+	v9pr_info("called m=%p p=%p *pos=%lld\n",
 		m, p, (unsigned long long)*pos);
 
 	if (p == SEQ_START_TOKEN)
@@ -815,7 +819,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	struct _ddebug *dp = p;
 	char flagsbuf[10];
 
-	vpr_info("called m=%p p=%p\n", m, p);
+	v9pr_info("called m=%p p=%p\n", m, p);
 
 	if (p == SEQ_START_TOKEN) {
 		seq_puts(m,
@@ -839,7 +843,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
  */
 static void ddebug_proc_stop(struct seq_file *m, void *p)
 {
-	vpr_info("called m=%p p=%p\n", m, p);
+	v8pr_info("called m=%p p=%p\n", m, p);
 	mutex_unlock(&ddebug_lock);
 }
 
@@ -862,7 +866,7 @@ static int ddebug_proc_open(struct inode *inode, struct file *file)
 	struct ddebug_iter *iter;
 	int err;
 
-	vpr_info("called\n");
+	v8pr_info("called\n");
 
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (iter == NULL)
-- 
1.7.11.4

