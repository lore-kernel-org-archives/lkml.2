Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2F2OLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:11:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:64294 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab2F2OLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:11:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117376625"
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC] vsprintf: Add %pb[1-64] specifier to print hex memory dump
Date: Fri, 29 Jun 2012 17:11:44 +0300
Message-Id: <1340979104-19377-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Add new specifier which may be used to print 1-64 bytes of memory.
There is often a need to print small (up to 64 bytes) objects like
bluetooth keys in debug purposes. Currently we have to create special
function for that.

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 lib/vsprintf.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7369745..59835a7 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -655,6 +655,51 @@ char *resource_string(char *buf, char *end, struct resource *res,
 }
 
 static noinline_for_stack
+char *hex_memory_string(char *buf, char *end, const u8 *addr,
+			struct printf_spec spec, const char *fmt)
+{
+	const char *p_fmt = fmt + 1;
+	size_t len, bytes = 0;
+
+	p_fmt = &fmt[1];
+	if (isdigit(*p_fmt))
+		bytes = skip_atoi(&p_fmt);
+
+	/* Print up to 64 bytes */
+	if (!bytes || bytes > 64)
+		return string(buf, end, "(%pb[1-64])", spec);
+
+	/* for each byte 2 chars + separator; + terminator; + 1st newline */
+	len = bytes * (sizeof(char) * 3) + 2 * sizeof(char);
+	if (end - buf > len) {
+		char mem_str[len];
+		char *p = mem_str;
+		const char separator = ' ';
+		u16 columns = 15;
+		int i;
+
+		for (i = 0; i < bytes; i++, columns--) {
+			p = hex_byte_pack(p, addr[i]);
+
+			if (columns) {
+				*p++ = separator;
+			} else {
+				if (i < bytes - 1)
+					*p++ = '\n';
+
+				columns = 16;
+			}
+		}
+
+		*p = '\0';
+
+		return string(buf, end, mem_str, spec);
+	}
+
+	return string(buf, end, "(too big)", spec);
+}
+
+static noinline_for_stack
 char *mac_address_string(char *buf, char *end, u8 *addr,
 			 struct printf_spec spec, const char *fmt)
 {
@@ -934,6 +979,7 @@ int kptr_restrict __read_mostly;
  *
  * Right now we handle:
  *
+ * - 'b[1-64]' For printing memory dump 1-64 bytes long
  * - 'F' For symbolic function descriptor pointers with offset
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
@@ -996,6 +1042,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	}
 
 	switch (*fmt) {
+	case 'b':
+		return hex_memory_string(buf, end, ptr, spec, fmt);
 	case 'F':
 	case 'f':
 		ptr = dereference_function_descriptor(ptr);
-- 
1.7.9.5

