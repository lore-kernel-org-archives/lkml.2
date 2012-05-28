Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2E1NEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:04:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:24949 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab2E1NEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:04:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105047689"
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, adobriyan@gmail.com,
        andriy.shevchenko@linux.intel.com
Subject: [PATCHv3] vsprintf: Add %pMR for Bluetooth MAC address
Date: Mon, 28 May 2012 16:05:16 +0300
Message-Id: <1338210316-12299-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CAHp75Vc3sut7R7FF=xHQ0-3HaydPBh86sNnzRjKP8+ow=SOfLg@mail.gmail.com>
References: <CAHp75Vc3sut7R7FF=xHQ0-3HaydPBh86sNnzRjKP8+ow=SOfLg@mail.gmail.com>
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
	v3: removed extra variable index
	v2: changed bluetooth to reversed, syntax fixes

 lib/vsprintf.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index abbabec..55052fa 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -559,15 +559,28 @@ char *mac_address_string(char *buf, char *end, u8 *addr,
 	char *p = mac_addr;
 	int i;
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
+		if (reversed)
+			p = hex_byte_pack(p, addr[5 - i]);
+		else
+			p = hex_byte_pack(p, addr[i]);
+
 		if (fmt[0] == 'M' && i != 5)
 			*p++ = separator;
 	}
@@ -830,6 +843,7 @@ int kptr_restrict __read_mostly;
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
  * - 'MF' For a 6-byte MAC FDDI address, it prints the address
  *       with a dash-separated hex notation
+ * - '[mM]R For a 6-byte MAC address, Reverse order (Bluetooth)
  * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
  *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
  *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
@@ -890,7 +904,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
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

