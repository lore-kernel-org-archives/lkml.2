Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0DBSdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:33:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:57252 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab0DBSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:33:01 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 1/5] kgdb: have ebin2mem call probe_kernel_write once
Date: Fri,  2 Apr 2010 13:32:21 -0500
Message-Id: <1270233145-29335-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 02 Apr 2010 18:32:42.0896 (UTC) FILETIME=[E1CEB900:01CAD292]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than call probe_kernel_write() one byte at a time, process the
whole buffer locally and pass the entire result in one go.  This way,
architectures that need to do special handling based on the length can
do so, or we only end up calling memcpy() once.

[sonic.zhang@analog.com: Reported original problem and preliminary patch]

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 kernel/kgdb.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 761fdd2..42fd128 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -391,27 +391,22 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
 
 /*
  * Copy the binary array pointed to by buf into mem.  Fix $, #, and
- * 0x7d escaped with 0x7d.  Return a pointer to the character after
- * the last byte written.
+ * 0x7d escaped with 0x7d. Return -EFAULT on failure or 0 on success.
+ * The input buf is overwitten with the result to write to mem.
  */
 static int kgdb_ebin2mem(char *buf, char *mem, int count)
 {
-	int err = 0;
-	char c;
+	int size = 0;
+	char *c = buf;
 
 	while (count-- > 0) {
-		c = *buf++;
-		if (c == 0x7d)
-			c = *buf++ ^ 0x20;
-
-		err = probe_kernel_write(mem, &c, 1);
-		if (err)
-			break;
-
-		mem++;
+		c[size] = *buf++;
+		if (c[size] == 0x7d)
+			c[size] = *buf++ ^ 0x20;
+		size++;
 	}
 
-	return err;
+	return probe_kernel_write(mem, c, size);
 }
 
 /*
-- 
1.6.3.1.9.g95405b

