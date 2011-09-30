Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab1I3SCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:02:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47885 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716Ab1I3SCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:02:47 -0400
Subject: [RFC][PATCH 2/4] break out unit selection from string_get_size()
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 30 Sep 2011 11:02:42 -0700
References: <20110930180241.D69D5E9C@kernel>
In-Reply-To: <20110930180241.D69D5E9C@kernel>
Message-Id: <20110930180242.D89C1A59@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


string_get_size() can really only print things in a single
format.  You're always stuck with a space, and it will
always zero-pad the decimal places:

	4.00 KiB
	40.0 KiB
	400 KiB

Printing page sizes in decimal KiB does not make much sense
since they are always nice powers of two.  But,
string_get_size() does have some nice code for selecting
the right units and doing the division.

This breaks that nice code out so that we can reuse it.
find_size_units() is a bit of a funky function since it has
so many outputs.  I don't think it's _too_ crazy though.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/string_helpers.h |    3 
 linux-2.6.git-dave/lib/string_helpers.c           |   67 +++++++++++++++-------
 2 files changed, 50 insertions(+), 20 deletions(-)

diff -puN include/linux/string_helpers.h~break-up-string_get_size-1 include/linux/string_helpers.h
--- linux-2.6.git/include/linux/string_helpers.h~break-up-string_get_size-1	2011-09-30 10:47:14.794753824 -0700
+++ linux-2.6.git-dave/include/linux/string_helpers.h	2011-09-30 10:47:14.806753800 -0700
@@ -10,6 +10,9 @@ enum string_size_units {
 	STRING_UNITS_2,		/* use binary powers of 2^10 */
 };
 
+u64 find_size_units(u64 *size, const enum string_size_units units,
+		const char **unit_str);
+
 int string_get_size(u64 size, enum string_size_units units,
 		    char *buf, int len);
 
diff -puN lib/string_helpers.c~break-up-string_get_size-1 lib/string_helpers.c
--- linux-2.6.git/lib/string_helpers.c~break-up-string_get_size-1	2011-09-30 10:47:14.798753816 -0700
+++ linux-2.6.git-dave/lib/string_helpers.c	2011-09-30 10:47:14.806753800 -0700
@@ -20,6 +20,49 @@ static int calc_sf_digit_room(u64 size)
 	return digits;
 }
 
+static const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
+				   "EB", "ZB", "YB", NULL};
+static const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
+				"EiB", "ZiB", "YiB", NULL };
+
+static const char **units_str[] = {
+		[STRING_UNITS_10] =  units_10,
+		[STRING_UNITS_2] = units_2,
+};
+static const unsigned int divisor[] = {
+		[STRING_UNITS_10] = 1000,
+		[STRING_UNITS_2] = 1024,
+};
+
+/**
+ * string_get_size - helper function for printing numbers
+ * @size:	number to be printed (modified)
+ * @units:	units to use (powers of 1000 or 1024)
+ * @unit_str:	unit is returned in this string
+ * returns:	remainder from divisions
+ *
+ * The goal here is to return a number in @size which has
+ * only 3 significant figures, along with the unit pointed
+ * to by unit_str which is necessary to make that happen.
+ *
+ * We return the remainder so that the caller does not have
+ * to repeat the division operations themselves.
+ */
+u64 find_size_units(u64 *size, const enum string_size_units units,
+		const char **unit_str)
+{
+	u64 remainder = 0;
+	int i = 0;
+
+	while (*size >= divisor[units] && units_str[units][i]) {
+		remainder = do_div(*size, divisor[units]);
+		i++;
+	}
+	*unit_str = units_str[units][i];
+	return remainder;
+}
+EXPORT_SYMBOL(find_size_units);
+
 /**
  * string_get_size - get the size in the specified units
  * @size:	The size to be converted
@@ -35,30 +78,14 @@ static int calc_sf_digit_room(u64 size)
 int string_get_size(u64 size, const enum string_size_units units,
 		    char *buf, int len)
 {
-	const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
-				   "EB", "ZB", "YB", NULL};
-	const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
-				 "EiB", "ZiB", "YiB", NULL };
-	const char **units_str[] = {
-		[STRING_UNITS_10] =  units_10,
-		[STRING_UNITS_2] = units_2,
-	};
-	const unsigned int divisor[] = {
-		[STRING_UNITS_10] = 1000,
-		[STRING_UNITS_2] = 1024,
-	};
-	int i, j;
+	int j;
 	u64 remainder = 0;
 	char tmp[8];
+	const char *unit_str = "";
 
 	tmp[0] = '\0';
-	i = 0;
 	if (size >= divisor[units]) {
-		while (size >= divisor[units] && units_str[units][i]) {
-			remainder = do_div(size, divisor[units]);
-			i++;
-		}
-
+		remainder = find_size_units(&size, units, &unit_str);
 		j = calc_sf_digit_room(size);
 		if (j) {
 			remainder *= 1000;
@@ -70,7 +97,7 @@ int string_get_size(u64 size, const enum
 	}
 
 	snprintf(buf, len, "%lld%s %s", (unsigned long long)size,
-		 tmp, units_str[units][i]);
+		 tmp, unit_str);
 
 	return 0;
 }
_
