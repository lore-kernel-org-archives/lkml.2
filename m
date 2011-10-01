Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab1JAAJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 20:09:06 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58507 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1JAAJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 20:09:01 -0400
Subject: [RFCv3][PATCH 1/4] replace string_get_size() arrays
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 30 Sep 2011 17:08:56 -0700
Message-Id: <20111001000856.DD623081@kernel>
x-cbid: 11100100-2398-0000-0000-0000009FA068
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of explicitly storing the entire string for each
possible units, just store the thing that varies: the
first character.

We have to special-case the 'B' unit (index==0).

This shaves about 100 bytes off of my .o file.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/lib/string_helpers.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff -puN lib/string_helpers.c~string_get_size-pow2 lib/string_helpers.c
--- linux-2.6.git/lib/string_helpers.c~string_get_size-pow2	2011-09-30 16:50:31.628981352 -0700
+++ linux-2.6.git-dave/lib/string_helpers.c	2011-09-30 17:04:02.211607364 -0700
@@ -8,6 +8,23 @@
 #include <linux/module.h>
 #include <linux/string_helpers.h>
 
+static const char byte_units[] = "_KMGTPEZY";
+
+static char *__units_str(enum string_size_units unit, char *buf, int index)
+{
+	int place = 0;
+
+	/* index=0 is plain 'B' with no other unit */
+	if (index) {
+		buf[place++] = byte_units[index];
+		if (unit == STRING_UNITS_2)
+			buf[place++] = 'i';
+	}
+	buf[place++] = 'B';
+	buf[place++] = '\0';
+	return buf;
+}
+
 /**
  * string_get_size - get the size in the specified units
  * @size:	The size to be converted
@@ -23,26 +40,19 @@
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
 	const unsigned int divisor[] = {
 		[STRING_UNITS_10] = 1000,
 		[STRING_UNITS_2] = 1024,
 	};
 	int i, j;
 	u64 remainder = 0, sf_cap;
+	char unit_buf[4];
 	char tmp[8];
 
 	tmp[0] = '\0';
 	i = 0;
 	if (size >= divisor[units]) {
-		while (size >= divisor[units] && units_str[units][i]) {
+		while (size >= divisor[units] && (i < strlen(byte_units))) {
 			remainder = do_div(size, divisor[units]);
 			i++;
 		}
@@ -61,7 +71,7 @@ int string_get_size(u64 size, const enum
 	}
 
 	snprintf(buf, len, "%lld%s %s", (unsigned long long)size,
-		 tmp, units_str[units][i]);
+		 tmp, __units_str(units, unit_buf, i));
 
 	return 0;
 }
diff -puN include/linux/string_helpers.h~string_get_size-pow2 include/linux/string_helpers.h
_

