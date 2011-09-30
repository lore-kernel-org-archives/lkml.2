Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1I3Ucf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:32:35 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42189 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1I3Ucc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:32:32 -0400
Subject: [RFCv2][PATCH 3/4] add seq_print_pow2() function
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 30 Sep 2011 13:32:21 -0700
References: <20110930203219.60D507CB@kernel>
In-Reply-To: <20110930203219.60D507CB@kernel>
Message-Id: <20110930203221.DE0A3B4A@kernel>
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

 linux-2.6.git-dave/fs/seq_file.c            |   11 +++++++++++
 linux-2.6.git-dave/include/linux/seq_file.h |    2 ++
 2 files changed, 13 insertions(+)

diff -puN fs/seq_file.c~add-seq_print_size fs/seq_file.c
--- linux-2.6.git/fs/seq_file.c~add-seq_print_size	2011-09-30 13:00:29.160632197 -0700
+++ linux-2.6.git-dave/fs/seq_file.c	2011-09-30 13:22:57.229978028 -0700
@@ -386,6 +386,17 @@ int seq_printf(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_printf);
 
+/*
+ * Prints output with KiB/MiB/etc... suffixes
+ */
+int seq_print_pow2(struct seq_file *seq, u64 size)
+{
+	u64 shifted_size;
+	char *unit_str;
+	shifted_size = string_get_size_pow2(size, &unit_str);
+	return seq_printf(seq, "%llu%s", shifted_size, unit_str);
+}
+
 /**
  *	mangle_path -	mangle and copy path to buffer beginning
  *	@s: buffer start
diff -puN include/linux/seq_file.h~add-seq_print_size include/linux/seq_file.h
--- linux-2.6.git/include/linux/seq_file.h~add-seq_print_size	2011-09-30 13:00:29.164632191 -0700
+++ linux-2.6.git-dave/include/linux/seq_file.h	2011-09-30 13:22:43.910000779 -0700
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/mutex.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
@@ -83,6 +84,7 @@ int seq_escape(struct seq_file *, const 
 int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
 int seq_write(struct seq_file *seq, const void *data, size_t len);
+int seq_print_pow2(struct seq_file *seq, u64 size);
 
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));
_
