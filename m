Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab1F1HMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:12:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65277 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab1F1HKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JgnkYxk9LTuGua0ka5MVOUKZaqKjdALslZdkGhPeaDgd/0stdytbrksRddgcU4Mlkz
         xMXI+I2NcU3xcIvq3dsmU3itXRY6QEJlnj/NhOcmLjQJDX6/+U6JcDVjEYAwYZC1sl+a
         paOn4D7mvT4sL+QrxjWY9NEQas88eprRaTJ+E=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 07/11] dynamic_debug: dont kill entire facility on error parsing ddebug_query
Date: Tue, 28 Jun 2011 01:09:48 -0600
Message-Id: <1309244992-2305-8-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a parsing error on ddebug_query results in effective loss
of the facility; all tables are removed, and the init-call returns error.
This is way too severe, especially when an innocent quoting error can
be the cause:

Kernel command line: root=LABEL=ROOT_FS ... ddebug_query='file char_dev.c +p'
yields:

ddebug_exec_queries: query 0: "'file"
query before parse <'file>
ddebug_exec_queries: processed 1 queries, with 1 errs
Invalid ddebug boot param 'file

Fix this by zeroing return-code for parse error before returning.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 7cf5fa7..97f6a9b 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -844,10 +844,11 @@ static int __init dynamic_debug_init(void)
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
 		ret = ddebug_exec_queries(ddebug_setup_string);
-		if (ret)
+		if (ret) {
+			ret = 0; /* dont kill entire facility */
 			pr_warning("Invalid ddebug boot param %s",
 				   ddebug_setup_string);
-		else
+		} else
 			pr_info("ddebug initialized with string %s",
 				ddebug_setup_string);
 	}
-- 
1.7.4.1

