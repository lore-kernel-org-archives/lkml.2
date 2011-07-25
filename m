Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1GYVnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1GYVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:43 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 18/25] dynamic_debug: describe_flags with '=[pmflta_]*'
Date: Mon, 25 Jul 2011 15:42:43 -0600
Message-Id: <1311630170-26057-19-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change describe_flags() to emit '=[pmflta_]+' for current callsite
flags, or just '=_' when they're disabled.  Having '=' in output
allows a more selective grep expression, in contrast '-' may appear
in filenames, line-ranges, and format-strings.  '=' also has better
mnemonics, saying; "the current setting are equal to <flags>".

The default allows grep "=_" <dbgfs>/dynamic_debug/control
to see disabled callsites while avoiding the many occurrences of " = "
seen in format strings.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 396ffb4..37f9748 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -92,6 +92,7 @@ static struct { unsigned flag:8; char opt_char; } opt_array[] = {
 	{ _DPRINTK_FLAGS_INCL_LINENO, 'l' },
 	{ _DPRINTK_FLAGS_INCL_TID, 't' },
 	{ _DPRINTK_FLAGS_APPEND, 'a' },
+	{ _DPRINTK_FLAGS_DEFAULT, '_' },
 };
 
 /* format a string into buf[] which describes the _ddebug's flags */
@@ -102,11 +103,12 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	int i;
 
 	BUG_ON(maxlen < 4);
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
-- 
1.7.4.1

