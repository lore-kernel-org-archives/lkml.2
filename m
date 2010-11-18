Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab0KRMzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:55:42 -0500
Received: from mail.windriver.com ([147.11.1.11]:53132 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab0KRMzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:55:41 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 1/4] kdb: fix memory leak in kdb_main.c
Date: Thu, 18 Nov 2010 06:56:00 -0600
Message-Id: <1290084963-6376-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290084963-6376-1-git-send-email-jason.wessel@windriver.com>
References: <1290084963-6376-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 18 Nov 2010 12:55:24.0635 (UTC) FILETIME=[DDDFAAB0:01CB871F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

Call kfree in the error path as well as the success path in kdb_ll().

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 37755d6..3ab3fee 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2361,7 +2361,7 @@ static int kdb_pid(int argc, const char **argv)
  */
 static int kdb_ll(int argc, const char **argv)
 {
-	int diag;
+	int diag = 0;
 	unsigned long addr;
 	long offset = 0;
 	unsigned long va;
@@ -2400,20 +2400,21 @@ static int kdb_ll(int argc, const char **argv)
 		char buf[80];
 
 		if (KDB_FLAG(CMD_INTERRUPT))
-			return 0;
+			goto out;
 
 		sprintf(buf, "%s " kdb_machreg_fmt "\n", command, va);
 		diag = kdb_parse(buf);
 		if (diag)
-			return diag;
+			goto out;
 
 		addr = va + linkoffset;
 		if (kdb_getword(&va, addr, sizeof(va)))
-			return 0;
+			goto out;
 	}
-	kfree(command);
 
-	return 0;
+out:
+	kfree(command);
+	return diag;
 }
 
 static int kdb_kgdb(int argc, const char **argv)
-- 
1.7.0.4

