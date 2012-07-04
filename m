Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab2GDIqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:46:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:50323 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab2GDIqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:46:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118789195"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        joe@perches.com, Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 2/3] lib: printf: append support of '%*ph[CDN]'
Date: Wed,  4 Jul 2012 11:45:51 +0300
Message-Id: <1341391552-4842-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341391552-4842-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1341341280.2012.3.camel@joe2Laptop>
 <1341391552-4842-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many places in the kernel where the drivers print small buffers as a
hex string. This patch adds a support of the variable width buffer to print it
as a hex string with a delimiter. The idea came from Pavel Roskin here:
http://www.digipedia.pl/usenet/thread/18835/17449/

Sample output of
	pr_info("buf[%d:%d] %*phC\n", from, len, len, &buf[from]);
could be look like this:
	[ 0.726130] buf[51:8] e8:16:b6:ef:e3:74:45:6e
	[ 0.750736] buf[59:15] 31:81:b8:3f:35:49:06:ae:df:32:06:05:4a:af:55
	[ 0.757602] buf[17:5] ac:16:d5:2c:ef

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/printk-formats.txt |   10 ++++++
 lib/vsprintf.c                   |   62 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 90ff4d7..8ffb274 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -53,6 +53,16 @@ Struct Resources:
 	For printing struct resources. The 'R' and 'r' specifiers result in a
 	printed resource with ('R') or without ('r') a decoded flags member.
 
+Raw buffer as a hex string:
+	%*ph	00 01 02  ...  3f
+	%*phC	00:01:02: ... :3f
+	%*phD	00-01-02- ... -3f
+	%*phN	000102 ... 3f
+
+	For printing a small buffers (up to 64 bytes long) as a hex string with
+	certain separator. For the larger buffers consider to use
+	print_hex_dump().
+
 MAC/FDDI addresses:
 
 	%pM	00:01:02:03:04:05
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index e500158..86d6a12 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -655,6 +655,57 @@ char *resource_string(char *buf, char *end, struct resource *res,
 }
 
 static noinline_for_stack
+char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
+		 const char *fmt)
+{
+	char hex_str[8*3+1];	/* support up to 8 bytes to print */
+	int len;
+	char *p;
+	int i = 0, j;
+	char separator;
+
+	switch (fmt[1]) {
+	case 'C':
+		separator = ':';
+		break;
+	case 'D':
+		separator = '-';
+		break;
+	case 'N':
+		separator = 0;
+		break;
+	default:
+		separator = ' ';
+		break;
+	}
+
+	if (spec.field_width <= 0)
+		/* nothing to print */
+		return buf;
+
+	len = min_t(int, spec.field_width, 64);
+
+	while (i < len) {
+		p = hex_str;
+		for (j = 0; j < 8 && i < len; j++, i++) {
+			p = hex_byte_pack(p, addr[i]);
+
+			if (separator && i != len - 1)
+				*p++ = separator;
+		}
+		*p = '\0';
+
+		for (p = hex_str; *p != '\0'; p++) {
+			if (buf < end)
+				*buf = *p;
+			++buf;
+		}
+	}
+
+	return buf;
+}
+
+static noinline_for_stack
 char *mac_address_string(char *buf, char *end, u8 *addr,
 			 struct printf_spec spec, const char *fmt)
 {
@@ -974,6 +1025,13 @@ int kptr_restrict __read_mostly;
  *       correctness of the format string and va_list arguments.
  * - 'K' For a kernel pointer that should be hidden from unprivileged users
  * - 'NF' For a netdev_features_t
+ * - 'h[CDN]' For a variable-length buffer, it prints it as a hex string with
+ *            a certain separator (' ' by default):
+ *              C colon
+ *              D dash
+ *              N no separator
+ *            The maximum supported length is 64 bytes of the input. Consider
+ *            to use print_hex_dump() for the larger input.
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1007,6 +1065,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'R':
 	case 'r':
 		return resource_string(buf, end, ptr, spec, fmt);
+	case 'h':
+		return hex_string(buf, end, ptr, spec, fmt);
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */
 					/* [mM]F (FDDI) */
@@ -1298,6 +1358,8 @@ qualifier:
  * %pI6c print an IPv6 address as specified by RFC 5952
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
+ *           bytes of the input)
  * %n is ignored
  *
  * ** Please update Documentation/printk-formats.txt when making changes **
-- 
1.7.10

