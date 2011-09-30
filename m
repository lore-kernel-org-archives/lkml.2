Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab1I3Ucb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:32:31 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50099 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1I3Uc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:32:27 -0400
Subject: [RFCv2][PATCH 2/4] add string_get_size_pow2()
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 30 Sep 2011 13:32:20 -0700
References: <20110930203219.60D507CB@kernel>
In-Reply-To: <20110930203219.60D507CB@kernel>
Message-Id: <20110930203220.522ECB96@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a specialized version of string_get_size().

It only works on powers-of-two, and only outputs in
KiB/MiB/etc...  Doing it this way means that we do
not have to do any division like string_get_size()
does.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/string_helpers.h |    1 
 linux-2.6.git-dave/lib/string_helpers.c           |   23 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff -puN lib/string_helpers.c~string_get_size-pow2-1 lib/string_helpers.c
--- linux-2.6.git/lib/string_helpers.c~string_get_size-pow2-1	2011-09-30 12:10:31.653729703 -0700
+++ linux-2.6.git-dave/lib/string_helpers.c	2011-09-30 12:40:13.090605408 -0700
@@ -21,6 +21,29 @@ static const unsigned int divisor[] = {
 	[STRING_UNITS_2] = 1024,
 };
 
+u64 string_get_size_pow2(u64 size, const char **unit_ret)
+{
+	int log2;
+	int unit_index;
+
+	if (!size)
+		log2 = 0;
+	else
+		log2 = ilog2(size);
+
+	/* KiB is log2=0->9, MiB is 10->19, etc... */
+	unit_index = log2 / 10;
+	/* Can not overflow since YiB=2^80 does
+	 * not fit in a u64. */
+	*unit_ret = units_2[unit_index];
+
+	/* 512 aka 2^9 is the largest integer without
+	 * overflowing to the next power-of-two, so
+	 * use %10 to make it max out there */
+	return (1 << (log2 % 10));
+}
+EXPORT_SYMBOL(string_get_size_pow2);
+
 /**
  * string_get_size - get the size in the specified units
  * @size:	The size to be converted
diff -puN include/linux/string_helpers.h~string_get_size-pow2-1 include/linux/string_helpers.h
--- linux-2.6.git/include/linux/string_helpers.h~string_get_size-pow2-1	2011-09-30 12:40:21.110592191 -0700
+++ linux-2.6.git-dave/include/linux/string_helpers.h	2011-09-30 12:40:31.186575591 -0700
@@ -10,6 +10,7 @@ enum string_size_units {
 	STRING_UNITS_2,		/* use binary powers of 2^10 */
 };
 
+u64 string_get_size_pow2(u64 size, const char **unit_ret);
 int string_get_size(u64 size, enum string_size_units units,
 		    char *buf, int len);
 
_
