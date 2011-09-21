Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1IUV7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:59:24 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37563 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab1IUV4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:16 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 12/26] dynamic_debug: dont kill entire facility on error parsing ddebug_query
Date: Wed, 21 Sep 2011 15:55:01 -0600
Message-Id: <1316642115-20029-13-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Currently, a parsing error on ddebug_query results in effective loss
of the facility; all tables are removed, and the init-call returns error.
This is way too severe, especially when an innocent quoting error can
be the cause:

Kernel command line: ... ddebug_query='file char_dev.c +p'
yields:

ddebug_exec_queries: query 0: "'file"
query before parse <'file>
ddebug_exec_queries: processed 1 queries, with 1 errs
Invalid ddebug boot param 'file

Fix this by zeroing return-code for query parse errors before
returning from dynamic_debug_init().

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 0676de0..3f37b5e 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -922,12 +922,10 @@ static int __init dynamic_debug_init(void)
 		pr_info("ddebug initializing with string \"%s\"",
 			ddebug_setup_string);
 		ret = ddebug_exec_queries(ddebug_setup_string);
-		if (ret)
-			pr_warn("Invalid ddebug boot param %s",
-				ddebug_setup_string);
-		else
-			pr_info("ddebug initialized with string %s",
-				ddebug_setup_string);
+		if (ret) {
+			ret = 0; /* make this non-fatal */
+			pr_warn("invalid ddebug_query\n");
+		}
 	}
 
 out_free:
-- 
1.7.4.4

