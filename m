Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2EYOcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:32:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:50425 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab2EYOcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:32:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147799350"
From: andrei.emeltchenko.news@gmail.com
To: linux-kernel@vger.kernel.org, joe@perches.com,
        linux-bluetooth@vger.kernel.org
Cc: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Subject: [RFC] vsprintf: Add %pMR for Bluetooth MAC address
Date: Fri, 25 May 2012 17:32:48 +0300
Message-Id: <1337956368-30621-1-git-send-email-andrei.emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336778486.16292.0.camel@joe2Laptop>
References: <1336778486.16292.0.camel@joe2Laptop>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
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
 lib/vsprintf.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index abbabec..b767c3c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -557,17 +557,27 @@ char *mac_address_string(char *buf, char *end, u8 *addr,
 {
 	char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
 	char *p = mac_addr;
-	int i;
+	int i, index;
 	char separator;
+	bool bluetooth = false;
 
-	if (fmt[1] == 'F') {		/* FDDI canonical format */
+	switch (fmt[1]) {
+	case 'F':
 		separator = '-';
-	} else {
+		break;
+
+	case 'R':
+		bluetooth = true;
+		/* fall through */
+
+	default:
 		separator = ':';
+		break;
 	}
 
 	for (i = 0; i < 6; i++) {
-		p = hex_byte_pack(p, addr[i]);
+		index = !bluetooth ? i : 5 - i;
+		p = hex_byte_pack(p, addr[index]);
 		if (fmt[0] == 'M' && i != 5)
 			*p++ = separator;
 	}
@@ -830,6 +840,7 @@ int kptr_restrict __read_mostly;
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
  * - 'MF' For a 6-byte MAC FDDI address, it prints the address
  *       with a dash-separated hex notation
+ * - '[mM]R For a 6-byte MAC Bluetooth address, bits reversed
  * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
  *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
  *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
@@ -890,7 +901,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		return resource_string(buf, end, ptr, spec, fmt);
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */
-					/* [mM]F (FDDI, bit reversed) */
+					/* [mM]F (FDDI) */
+					/* [mM]R (Bluetooth, bits reversed) */
 		return mac_address_string(buf, end, ptr, spec, fmt);
 	case 'I':			/* Formatted IP supported
 					 * 4:	1.2.3.4
-- 
1.7.9.5

---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

