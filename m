Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab1IUV4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1IUV4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:31 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 18/26] dynamic_debug: describe_flags with '=[pmflta_]*'
Date: Wed, 21 Sep 2011 15:55:07 -0600
Message-Id: <1316642115-20029-19-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Change describe_flags() to emit '=[pmflta_]+' for current callsite
flags, or just '=_' when they're disabled.  Having '=' in output
allows a more selective grep expression, in contrast '-' may appear
in filenames, line-ranges, and format-strings.  '=' also has better
mnemonics, saying; "the current setting is equal to <flags>".

The default allows grep "=_" <dbgfs>/dynamic_debug/control
to see disabled callsites while avoiding the many occurrences of " = "
seen in format strings.

Enlarge flagsbufs to handle additional flag chars, "=a_"

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 0c9e53a..29dbf69 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -99,6 +99,7 @@ static struct { unsigned flag:8; char opt_char; } opt_array[] = {
 	{ _DPRINTK_FLAGS_INCL_LINENO, 'l' },
 	{ _DPRINTK_FLAGS_INCL_TID, 't' },
 	{ _DPRINTK_FLAGS_APPEND, 'a' },
+	{ _DPRINTK_FLAGS_DEFAULT, '_' },
 };
 
 /* format a string into buf[] which describes the _ddebug's flags */
@@ -108,12 +109,13 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	char *p = buf;
 	int i;
 
-	BUG_ON(maxlen < 4);
+	BUG_ON(maxlen < 10);
+	*p++ = '=';
 	for (i = 0; i < ARRAY_SIZE(opt_array); ++i)
 		if (dp->flags & opt_array[i].flag)
 			*p++ = opt_array[i].opt_char;
-	if (p == buf)
-		*p++ = '-';
+	if (*(p-1) == '=')
+		*p++ = '_';
 	*p = '\0';
 
 	return buf;
@@ -195,7 +197,7 @@ static int ddebug_change(const struct ddebug_query *query,
 	struct ddebug_table *dt;
 	unsigned int newflags;
 	unsigned int nfound = 0;
-	char flagbuf[8];
+	char flagbuf[10];
 
 	/* search for matching ddebugs */
 	list_for_each_entry(dt, &ddebug_tables, link) {
@@ -866,7 +868,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 {
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp = p;
-	char flagsbuf[8];
+	char flagsbuf[10];
 
 	if (verbose >= VERBOSE_PROC_SHOW)
 		pr_info("called m=%p p=%p\n", m, p);
-- 
1.7.4.4

