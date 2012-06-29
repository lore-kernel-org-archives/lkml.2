Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2F2P64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:58:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:3484 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab2F2P6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:58:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117407733"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: proski@gnu.org, Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC][PATCH 1/2] lib: printf: append support of '%*p[Mm][FR]'
Date: Fri, 29 Jun 2012 18:58:32 +0300
Message-Id: <1340985513-15655-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <20110930115306.3bc105cb@mj>
References: <20110930115306.3bc105cb@mj>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many places in the kernel where the drivers print small buffers as a
hex string. This patch adds a support of the variable width buffer to print it
as a hex string with a delimiter. The idea came from Pavel Roskin here:
http://www.digipedia.pl/usenet/thread/18835/17449/

Sample output of
	pr_info("buf[%d:%d] %*pM\n", from, len, len, &buf[from]);
could be like this:
	[ 0.726130] buf[51:8] e8:16:b6:ef:e3:74:45:6e
	[ 0.750736] buf[59:15] 31:81:b8:3f:35:49:06:ae:df:32:06:05:4a:af:55
	[ 0.757602] buf[17:5] ac:16:d5:2c:ef

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/vsprintf.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a0b5f15..1645d7e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -655,11 +655,12 @@ char *resource_string(char *buf, char *end, struct resource *res,
 }
 
 static noinline_for_stack
-char *mac_address_string(char *buf, char *end, u8 *addr,
-			 struct printf_spec spec, const char *fmt)
+char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
+		 const char *fmt)
 {
-	char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
-	char *p = mac_addr;
+	char hex_str[64*3];	/* support up to 64 bytes to print */
+	int len = 6;		/* default length is 6 bytes */
+	char *p = hex_str;
 	int i;
 	char separator;
 	bool reversed = false;
@@ -678,18 +679,21 @@ char *mac_address_string(char *buf, char *end, u8 *addr,
 		break;
 	}
 
-	for (i = 0; i < 6; i++) {
+	if (spec.field_width > 0)
+		len = min_t(int, spec.field_width, 64);
+
+	for (i = 0; i < len; i++) {
 		if (reversed)
-			p = hex_byte_pack(p, addr[5 - i]);
+			p = hex_byte_pack(p, addr[len - 1 - i]);
 		else
 			p = hex_byte_pack(p, addr[i]);
 
-		if (fmt[0] == 'M' && i != 5)
+		if (fmt[0] == 'M' && i != len - 1)
 			*p++ = separator;
 	}
 	*p = '\0';
 
-	return string(buf, end, mac_addr, spec);
+	return string(buf, end, hex_str, spec);
 }
 
 static noinline_for_stack
@@ -1011,7 +1015,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'm':			/* Contiguous: 000102030405 */
 					/* [mM]F (FDDI) */
 					/* [mM]R (Reverse order; Bluetooth) */
-		return mac_address_string(buf, end, ptr, spec, fmt);
+		return hex_string(buf, end, ptr, spec, fmt);
 	case 'I':			/* Formatted IP supported
 					 * 4:	1.2.3.4
 					 * 6:	0001:0203:...:0708
-- 
1.7.10

