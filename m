Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0CVTSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:18:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:36474 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0CVTSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:08 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>,
       Sonic Zhang <sonic.zhang@analog.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 4/8] kgdb: have ebin2mem call probe_kernel_write once
Date: Mon, 22 Mar 2010 14:17:25 -0500
Message-Id: <1269285449-1424-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1269285449-1424-4-git-send-email-jason.wessel@windriver.com>
References: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-2-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-3-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Mar 2010 19:17:39.0268 (UTC) FILETIME=[566D3040:01CAC9F4]
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
 kernel/debug/gdbstub.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index ab29bce..ccdf092 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -293,27 +293,22 @@ int kgdb_hex2long(char **ptr, unsigned long *long_val)
 
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
 
 /* Write memory due to an 'M' or 'X' packet. */
-- 
1.6.4.rc1

