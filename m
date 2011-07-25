Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1GYVr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:47:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63998 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab1GYVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:30 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 10/25] dynamic_debug: dont kill entire facility on error parsing ddebug_query
Date: Mon, 25 Jul 2011 15:42:35 -0600
Message-Id: <1311630170-26057-11-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
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
 lib/dynamic_debug.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c6d38b4..1ced79e 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -888,8 +888,10 @@ static int __init dynamic_debug_init(void)
 		pr_info("ddebug initializing with string \"%s\"",
 			ddebug_setup_string);
 		ret = ddebug_exec_queries(ddebug_setup_string);
-		if (ret)
+		if (ret) {
+			ret = 0; /* make this non-fatal */
 			pr_warn("invalid ddebug_query\n");
+		}
 	}
 
 out_free:
-- 
1.7.4.1

