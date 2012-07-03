Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2GCKHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:07:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:6308 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab2GCKHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187892581"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe@smile, Perches@smile, joe@perches.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC][PATCHv2 2/3] lib: printf: append support of '%*p[Mm][FR]'
Date: Tue,  3 Jul 2012 13:06:39 +0300
Message-Id: <1341310000-4082-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341310000-4082-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1341264199.10162.2.camel@joe2Laptop>
 <1341310000-4082-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many places in the kernel where the drivers print small buffers as a
hex string. This patch adds a support of the variable width buffer to print it
as a hex string with a delimiter. The idea came from Pavel Roskin here:
http://www.digipedia.pl/usenet/thread/18835/17449/

Sample output of
	pr_info("buf[%d:%d] %*pM\n", from, len, len, &buf[from]);
could be look like this:
	[ 0.726130] buf[51:8] e8:16:b6:ef:e3:74:45:6e
	[ 0.750736] buf[59:15] 31:81:b8:3f:35:49:06:ae:df:32:06:05:4a:af:55
	[ 0.757602] buf[17:5] ac:16:d5:2c:ef

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/printk-formats.txt |    5 ++++
 lib/vsprintf.c                   |   49 ++++++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 90ff4d7..3ae3d32 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -73,6 +73,11 @@ MAC/FDDI addresses:
 	specifier to use reversed byte order suitable for visual interpretation
 	of Bluetooth addresses which are in the little endian order.
 
+	Optional usage of all of the above is to specify variable length via
+	putting '*' into the specificator ('%*p[Mm][FR]'). In this case it will
+	print up to 64 bytes of the input as a hex string with certain
+	separator. For larger buffers consider to use print_hex_dump().
+
 IPv4 addresses:
 
 	%pI4	1.2.3.4
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c65f5d4..ef4bbd2 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -655,12 +655,13 @@ char *resource_string(char *buf, char *end, struct resource *res,
 }
 
 static noinline_for_stack
-char *mac_address_string(char *buf, char *end, u8 *addr,
-			 struct printf_spec spec, const char *fmt)
+char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
+		 const char *fmt)
 {
-	char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
-	char *p = mac_addr;
-	int i;
+	char hex_str[8*3+1];	/* support up to 8 bytes to print */
+	int len = 6;		/* default length is 6 bytes */
+	char *p;
+	int i = 0, j;
 	char separator;
 	bool reversed = false;
 
@@ -678,18 +679,31 @@ char *mac_address_string(char *buf, char *end, u8 *addr,
 		break;
 	}
 
-	for (i = 0; i < 6; i++) {
-		if (reversed)
-			p = hex_byte_pack(p, addr[5 - i]);
-		else
-			p = hex_byte_pack(p, addr[i]);
+	if (spec.field_width > 0)
+		len = min_t(int, spec.field_width, 64);
+
+	while (i < len) {
+		p = hex_str;
+		for (j = 0; j < 8 && i < len; j++) {
+			if (reversed)
+				p = hex_byte_pack(p, addr[len - 1 - i]);
+			else
+				p = hex_byte_pack(p, addr[i]);
+
+			if (fmt[0] == 'M' && i != len - 1)
+				*p++ = separator;
+			i++;
+		}
+		*p = '\0';
 
-		if (fmt[0] == 'M' && i != 5)
-			*p++ = separator;
+		for (p = hex_str; *p != '\0'; p++) {
+			if (buf < end)
+				*buf = *p;
+			++buf;
+		}
 	}
-	*p = '\0';
 
-	return string(buf, end, mac_addr, spec);
+	return buf;
 }
 
 static noinline_for_stack
@@ -947,6 +961,9 @@ int kptr_restrict __read_mostly;
  * - 'MF' For a 6-byte MAC FDDI address, it prints the address
  *       with a dash-separated hex notation
  * - '[mM]R For a 6-byte MAC address, Reverse order (Bluetooth)
+ *       Optional usage is %*p[Mn][FR] with variable length to print. It
+ *       supports up to 64 bytes of the input. Consider to use print_hex_dump()
+ *       for the larger input.
  * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
  *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
  *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
@@ -1011,7 +1028,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'm':			/* Contiguous: 000102030405 */
 					/* [mM]F (FDDI) */
 					/* [mM]R (Reverse order; Bluetooth) */
-		return mac_address_string(buf, end, ptr, spec, fmt);
+		return hex_string(buf, end, ptr, spec, fmt);
 	case 'I':			/* Formatted IP supported
 					 * 4:	1.2.3.4
 					 * 6:	0001:0203:...:0708
@@ -1291,6 +1308,8 @@ qualifier:
  * %pMF output a 6-byte MAC address with dashes
  * %pm output a 6-byte MAC address without colons
  * %pmR output a 6-byte MAC address without colons in reversed order
+ * %*p[Mm][FR] a variable-length hex string with a separator (supports up to 64
+ *             bytes of the input)
  * %pI4 print an IPv4 address without leading zeros
  * %pi4 print an IPv4 address with leading zeros
  * %pI6 print an IPv6 address with colons
-- 
1.7.10

