Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1JJIJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:09:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36978 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752789Ab1JJIJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:09:08 -0400
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: NamJae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] udf: Neaten logging output, use vsprintf extension %pV
Date: Mon, 10 Oct 2011 01:08:06 -0700
Message-Id: <f6af3ca08d9e966de00d77cc9a8251d91666f33f.1318233879.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com> <cover.1318233879.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the warning and error prefixes that duplicate KERN_<level>.
Use %pV and remove a static buffer to save some text space.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/udf/super.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index ea1b44b..b72c5ab 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -75,8 +75,6 @@
 
 #define UDF_DEFAULT_BLOCKSIZE 2048
 
-static char error_buf[1024];
-
 /* These are the "meat" - everything else is stuffing */
 static int udf_fill_super(struct super_block *, void *, int);
 static void udf_put_super(struct super_block *);
@@ -2075,29 +2073,37 @@ error_out:
 void _udf_err(struct super_block *sb, const char *function,
 	      const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
-	if (!(sb->s_flags & MS_RDONLY)) {
-		/* mark sb error */
+	/* mark sb error */
+	if (!(sb->s_flags & MS_RDONLY))
 		sb->s_dirt = 1;
-	}
+
 	va_start(args, fmt);
-	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	pr_crit("device %s: %s: %pV", sb->s_id, function, &vaf);
+
 	va_end(args);
-	pr_crit("error (device %s): %s: %s",
-	       sb->s_id, function, error_buf);
 }
 
 void _udf_warn(struct super_block *sb, const char *function,
 	       const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	pr_warn("device %s: %s: %pV", sb->s_id, function, &vaf);
+
 	va_end(args);
-	pr_warn("warning (device %s): %s: %s",
-	       sb->s_id, function, error_buf);
 }
 
 static void udf_put_super(struct super_block *sb)
-- 
1.7.6.405.gc1be0

