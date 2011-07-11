Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788Ab1GKHra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:47:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab1GKHrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:24 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 06/21] dynamic_debug: dont kill entire facility on error parsing ddebug_query
Date: Mon, 11 Jul 2011 01:46:41 -0600
Message-Id: <1310370416-6322-7-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 lib/dynamic_debug.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index fc31707..bbee0aa 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -900,10 +900,11 @@ static int __init dynamic_debug_init(void)
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
 		ret = ddebug_exec_queries(ddebug_setup_string);
-		if (ret)
+		if (ret) {
+			ret = 0; /* make this non-fatal */
 			pr_warn("Invalid ddebug boot param %s",
 				ddebug_setup_string);
-		else
+		} else
 			pr_info("ddebug initialized with string %s",
 				ddebug_setup_string);
 	}
-- 
1.7.4.1

