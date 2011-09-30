Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab1I3SDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:03:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43451 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707Ab1I3SCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:02:52 -0400
Subject: [RFC][PATCH 3/4] add seq_print_size() function
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 30 Sep 2011 11:02:43 -0700
References: <20110930180241.D69D5E9C@kernel>
In-Reply-To: <20110930180241.D69D5E9C@kernel>
Message-Id: <20110930180243.403953DC@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In order to get nice, human-readable output, we are going to
use MiB/KiB, etc... in numa_maps.  Introduce a helper to do
the conversion from a raw integer over to a string.

I thought about doing this as a new printk() format specifier.
That would be interesting, but it's hard to argue with this
since it's so short and sweet.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/seq_file.c            |   15 +++++++++++++++
 linux-2.6.git-dave/include/linux/seq_file.h |    3 +++
 2 files changed, 18 insertions(+)

diff -puN fs/seq_file.c~add-seq_print_size fs/seq_file.c
--- linux-2.6.git/fs/seq_file.c~add-seq_print_size	2011-09-30 10:52:22.302140723 -0700
+++ linux-2.6.git-dave/fs/seq_file.c	2011-09-30 10:52:22.322140685 -0700
@@ -386,6 +386,21 @@ int seq_printf(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_printf);
 
+/*
+ * Prints output with MiB/MB/KB/etc... suffixes
+ */
+int seq_print_size(struct seq_file *seq, u64 size,
+			const enum string_size_units units)
+{
+	int ret;
+	u64 remainder;
+	char *size_str;
+	remainder = find_size_units(&size, units, &size_str);
+	ret += seq_printf(seq, "%llu", size);
+	ret += seq_puts(seq, size_str);
+	return ret;
+}
+
 /**
  *	mangle_path -	mangle and copy path to buffer beginning
  *	@s: buffer start
diff -puN include/linux/seq_file.h~add-seq_print_size include/linux/seq_file.h
--- linux-2.6.git/include/linux/seq_file.h~add-seq_print_size	2011-09-30 10:52:22.314140700 -0700
+++ linux-2.6.git-dave/include/linux/seq_file.h	2011-09-30 10:52:22.322140685 -0700
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/mutex.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
@@ -83,6 +84,8 @@ int seq_escape(struct seq_file *, const 
 int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
 int seq_write(struct seq_file *seq, const void *data, size_t len);
+int seq_print_size(struct seq_file *seq, u64 size,
+			const enum string_size_units units);
 
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));
_
