Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2JQGHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:07:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44349 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753397Ab2JQGHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:07:19 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 04/23] printk: Use pointer for console_cmdline indexing
Date: Tue, 16 Oct 2012 23:06:08 -0700
Message-Id: <1588ed725bf7ec688a3f334a5c601227b602438c.1350449851.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code a bit more compact by always using a pointer
for the active console_cmdline.

Move overly indented code to correct indent level.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c |   49 +++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index df5b80f..099c439 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1718,18 +1718,19 @@ static int __add_preferred_console(char *name, int idx, char *options,
 	 *	See if this tty is not yet registered, and
 	 *	if we have a slot free.
 	 */
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
-		if (strcmp(console_cmdline[i].name, name) == 0 &&
-			  console_cmdline[i].index == idx) {
-				if (!brl_options)
-					selected_console = i;
-				return 0;
+	for (i = 0, c = console_cmdline;
+	     i < MAX_CMDLINECONSOLES && c->name[0];
+	     i++, c++) {
+		if (strcmp(c->name, name) == 0 && c->index == idx) {
+			if (!brl_options)
+				selected_console = i;
+			return 0;
 		}
+	}
 	if (i == MAX_CMDLINECONSOLES)
 		return -E2BIG;
 	if (!brl_options)
 		selected_console = i;
-	c = &console_cmdline[i];
 	strlcpy(c->name, name, sizeof(c->name));
 	c->options = options;
 	braille_set_options(c, brl_options);
@@ -1802,15 +1803,15 @@ int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, cha
 	struct console_cmdline *c;
 	int i;
 
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
-		if (strcmp(console_cmdline[i].name, name) == 0 &&
-			  console_cmdline[i].index == idx) {
-				c = &console_cmdline[i];
-				strlcpy(c->name, name_new, sizeof(c->name));
-				c->name[sizeof(c->name) - 1] = 0;
-				c->options = options;
-				c->index = idx_new;
-				return i;
+	for (i = 0, c = console_cmdline;
+	     i < MAX_CMDLINECONSOLES && c->name[0];
+	     i++, c++)
+		if (strcmp(c->name, name) == 0 && c->index == idx) {
+			strlcpy(c->name, name_new, sizeof(c->name));
+			c->name[sizeof(c->name) - 1] = 0;
+			c->options = options;
+			c->index = idx_new;
+			return i;
 		}
 	/* not found */
 	return -1;
@@ -2218,6 +2219,7 @@ void register_console(struct console *newcon)
 	int i;
 	unsigned long flags;
 	struct console *bcon = NULL;
+	struct console_cmdline *c;
 
 	/*
 	 * before we register a new CON_BOOT console, make sure we don't
@@ -2265,24 +2267,25 @@ void register_console(struct console *newcon)
 	 *	See if this console matches one we selected on
 	 *	the command line.
 	 */
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0];
-			i++) {
-		if (strcmp(console_cmdline[i].name, newcon->name) != 0)
+	for (i = 0, c = console_cmdline;
+	     i < MAX_CMDLINECONSOLES && c->name[0];
+	     i++, c++) {
+		if (strcmp(c->name, newcon->name) != 0)
 			continue;
 		if (newcon->index >= 0 &&
-		    newcon->index != console_cmdline[i].index)
+		    newcon->index != c->index)
 			continue;
 		if (newcon->index < 0)
-			newcon->index = console_cmdline[i].index;
+			newcon->index = c->index;
 
-		if (_braille_register_console(newcon, &console_cmdline[i]))
+		if (_braille_register_console(newcon, c))
 			return;
 
 		if (newcon->setup &&
 		    newcon->setup(newcon, console_cmdline[i].options) != 0)
 			break;
 		newcon->flags |= CON_ENABLED;
-		newcon->index = console_cmdline[i].index;
+		newcon->index = c->index;
 		if (i == selected_console) {
 			newcon->flags |= CON_CONSDEV;
 			preferred_console = selected_console;
-- 
1.7.10.4

