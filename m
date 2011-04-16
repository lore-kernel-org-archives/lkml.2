Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1DPN1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 09:27:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49434 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1DPN02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 09:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        b=aD/mLsXSrxgMwpt+6qwfyiecv17KBIN2/x7X0X0Lsp5ZcEq04h5ob2fIssKl96Oicq
         4iIFpVC00LECxD8X/5pXyAgqNXXoIyOJJCtzfJv5P1OYsMWx7Iuk8LNmvzPEmF5DDhwJ
         MgJB1BFCu2esKhsuDyaLBkrqLFsSLYEMIAQxg=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH 3/4] lib: Add generic binary search function to the kernel.
Date: Sat, 16 Apr 2011 15:26:12 +0200
Message-Id: <1302960373-5309-4-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302960373-5309-1-git-send-email-abogani@kernel.org>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@ksplice.com>

There a large number hand-coded binary searches in the kernel (run
"git grep search | grep binary" to find many of them).  Since in my
experience, hand-coding binary searches can be error-prone, it seems
worth cleaning this up by providing a generic binary search function.

This generic binary search implementation comes from Ksplice.  It has
the same basic API as the C library bsearch() function.  Ksplice uses
it in half a dozen places with 4 different comparison functions, and I
think our code is substantially cleaner because of this.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Extra-bikeshedding-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Extra-bikeshedding-by: André Goddard Rosa <andre.goddard@gmail.com>
Extra-bikeshedding-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 include/linux/bsearch.h |    9 ++++++++
 lib/Makefile            |    3 +-
 lib/bsearch.c           |   53 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/bsearch.h
 create mode 100644 lib/bsearch.c

diff --git a/include/linux/bsearch.h b/include/linux/bsearch.h
new file mode 100644
index 0000000..90b1aa8
--- /dev/null
+++ b/include/linux/bsearch.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_BSEARCH_H
+#define _LINUX_BSEARCH_H
+
+#include <linux/types.h>
+
+void *bsearch(const void *key, const void *base, size_t num, size_t size,
+	      int (*cmp)(const void *key, const void *elt));
+
+#endif /* _LINUX_BSEARCH_H */
diff --git a/lib/Makefile b/lib/Makefile
index ef0f285..4b49a24 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -21,7 +21,8 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o
+	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
+	 bsearch.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
diff --git a/lib/bsearch.c b/lib/bsearch.c
new file mode 100644
index 0000000..5b54758
--- /dev/null
+++ b/lib/bsearch.c
@@ -0,0 +1,53 @@
+/*
+ * A generic implementation of binary search for the Linux kernel
+ *
+ * Copyright (C) 2008-2009 Ksplice, Inc.
+ * Author: Tim Abbott <tabbott@ksplice.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2.
+ */
+
+#include <linux/module.h>
+#include <linux/bsearch.h>
+
+/*
+ * bsearch - binary search an array of elements
+ * @key: pointer to item being searched for
+ * @base: pointer to first element to search
+ * @num: number of elements
+ * @size: size of each element
+ * @cmp: pointer to comparison function
+ *
+ * This function does a binary search on the given array.  The
+ * contents of the array should already be in ascending sorted order
+ * under the provided comparison function.
+ *
+ * Note that the key need not have the same type as the elements in
+ * the array, e.g. key could be a string and the comparison function
+ * could compare the string with the struct's name field.  However, if
+ * the key and elements in the array are of the same type, you can use
+ * the same comparison function for both sort() and bsearch().
+ */
+void *bsearch(const void *key, const void *base, size_t num, size_t size,
+	      int (*cmp)(const void *key, const void *elt))
+{
+	size_t start = 0, end = num;
+	int result;
+
+	while (start < end) {
+		size_t mid = start + (end - start) / 2;
+
+		result = cmp(key, base + mid * size);
+		if (result < 0)
+			end = mid;
+		else if (result > 0)
+			start = mid + 1;
+		else
+			return (void *)base + mid * size;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(bsearch);
-- 
1.7.4.1

