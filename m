Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab2E1I7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 04:59:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:17785 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab2E1I7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 04:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171932536"
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, adobriyan@gmail.com,
        andriy.shevchenko@linux.intel.com
Subject: [PATCHv2] vsprintf: Add %pMR for Bluetooth MAC address
Date: Mon, 28 May 2012 12:00:05 +0300
Message-Id: <1338195605-22513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337956368-30621-1-git-send-email-andrei.emeltchenko.news@gmail.com>
References: <1337956368-30621-1-git-send-email-andrei.emeltchenko.news@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Bluetooth uses mostly LE byte order which is reversed for visual
interpretation. Currently in Bluetooth in use unsafe batostr function.

This is slightly modified version of Joe Perches <joe@perches.com>
patch (sent Sat, Dec 4, 2010).

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
	v2: changed bluetooth to reversed, syntax fixes

 lib/vsprintf.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index abbabec..d98b12d 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -557,17 +557,27 @@ char *mac_address_string(char *buf, char *end, u8 *addr,
 {
 	char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
 	char *p = mac_addr;
-	int i;
+	int i, index;
 	char separator;
+	bool reversed = false;
 
-	if (fmt[1] == 'F') {		/* FDDI canonical format */
+	switch (fmt[1]) {
+	case 'F':
 		separator = '-';
-	} else {
+		break;
+
+	case 'R':
+		reversed = true;
+		/* fall through */
+
+	default:
 		separator = ':';
+		break;
 	}
 
 	for (i = 0; i < 6; i++) {
-		p = hex_byte_pack(p, addr[i]);
+		index = !reversed ? i : 5 - i;
+		p = hex_byte_pack(p, addr[index]);
 		if (fmt[0] == 'M' && i != 5)
 			*p++ = separator;
 	}
@@ -830,6 +840,7 @@ int kptr_restrict __read_mostly;
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
  * - 'MF' For a 6-byte MAC FDDI address, it prints the address
  *       with a dash-separated hex notation
+ * - '[mM]R For a 6-byte MAC address, Reverse order (Bluetooth)
  * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
  *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
  *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
@@ -890,7 +901,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		return resource_string(buf, end, ptr, spec, fmt);
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */
-					/* [mM]F (FDDI, bit reversed) */
+					/* [mM]F (FDDI) */
+					/* [mM]R (Reverse order; Bluetooth) */
 		return mac_address_string(buf, end, ptr, spec, fmt);
 	case 'I':			/* Formatted IP supported
 					 * 4:	1.2.3.4
-- 
1.7.9.5

