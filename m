Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1FCQp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:45:59 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:19289
	"EHLO CH1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753400Ab1FCQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:45:58 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>, <akpm@linux-foundation.org>
Subject: [PATCH] lib: introduce strdup_from_user
Date: Fri, 3 Jun 2011 11:45:52 -0500
Message-ID: <1307119552-15573-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function strdup_from_user(), which kmallocs a block of memory and
copies a user-space NULL-terminated string into it.  NULL is returned if
the string is too large or cannot be accessed.

This function is added to lib/string_helpers.c, so this file is repurposed
to store generic "string helper" functions, and not just a function to
assist in sprintfs.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 include/linux/string_helpers.h |    2 +
 lib/string_helpers.c           |   43 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index a3eb2f6..6231838 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -13,4 +13,6 @@ enum string_size_units {
 int string_get_size(u64 size, enum string_size_units units,
 		    char *buf, int len);
 
+char *strdup_from_user(const char __user *ustr, size_t max);
+
 #endif
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index ab431d4..61323e6 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -1,13 +1,19 @@
 /*
- * Helpers for formatting and printing strings
+ * Additional arch-independent string helper functions
  *
  * Copyright 31 August 2008 James Bottomley
+ * Copyright (C) 2011 Freescale Semiconductor, Inc.
+ *
  */
 #include <linux/kernel.h>
 #include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/string_helpers.h>
 
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <asm/uaccess.h>
+
 /**
  * string_get_size - get the size in the specified units
  * @size:	The size to be converted
@@ -66,3 +72,38 @@ int string_get_size(u64 size, const enum string_size_units units,
 	return 0;
 }
 EXPORT_SYMBOL(string_get_size);
+
+/**
+ * strdup_from_user - copy a user-space string to a kmalloc'd buffer
+ * @ustr: user-space pointer to null-terminated string
+ * @max: maximum size the string is allowed to be, include NULL terminator
+ *
+ * This function allocates a block of memory (using kmalloc) and copies a
+ * user-space string into that buffer.  It returns a pointer to that string,
+ * or an error code.
+ */
+char *strdup_from_user(const char __user *ustr, size_t max)
+{
+	size_t len;
+	char *str;
+
+	len = strnlen_user(ustr, max);
+	if (len >= max)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	/* strnlen_user returns 0 on access error */
+	if (!len)
+		return ERR_PTR(-EFAULT);
+
+	str = kzalloc(len, GFP_KERNEL);
+	if (!str)
+		return ERR_PTR(-ENOMEM);
+
+	if (copy_from_user(str, ustr, len)) {
+		kfree(str);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return str;
+}
+EXPORT_SYMBOL(strdup_from_user);
-- 
1.7.3.4


