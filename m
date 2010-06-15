Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab0FOOE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:04:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55255 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab0FOOE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YlKfqMqvWLprv8lbFwUlAS45lDQSp8wlliZOpJ5fmSY+8cg1MhZqS3vMa+Oq4gJu6Y
         nbUbhAVp6h3aI1NqaeLNQjqJE6AFtKrC59ou8Gxfb2hDRVme5Hf3B/nl7VlpStnmjlxu
         uOuh1xmNlG9bWjGd1RrI4zv4brCNSI3ZL2y7Y=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb@vger.kernel.org
Subject: [PATCH] drivers: usb: throw away custom methods
Date: Tue, 15 Jun 2010 17:04:44 +0300
Message-Id: <1276610684-26335-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Recent kernel has common method to convert hex digit to its value.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/atm/ueagle-atm.c |    5 +++--
 drivers/usb/gadget/u_ether.c |   15 ++-------------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index e213d3f..7c46395 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -67,6 +67,7 @@
 #include <linux/mutex.h>
 #include <linux/freezer.h>
 #include <linux/slab.h>
+#include <linux/kernel.h>
 
 #include <asm/unaligned.h>
 
@@ -2429,7 +2430,6 @@ UEA_ATTR(firmid, 0);
 
 /* Retrieve the device End System Identifier (MAC) */
 
-#define htoi(x) (isdigit(x) ? x-'0' : toupper(x)-'A'+10)
 static int uea_getesi(struct uea_softc *sc, u_char * esi)
 {
 	unsigned char mac_str[2 * ETH_ALEN + 1];
@@ -2440,7 +2440,8 @@ static int uea_getesi(struct uea_softc *sc, u_char * esi)
 		return 1;
 
 	for (i = 0; i < ETH_ALEN; i++)
-		esi[i] = htoi(mac_str[2 * i]) * 16 + htoi(mac_str[2 * i + 1]);
+		esi[i] = hex_to_bin(mac_str[2 * i]) * 16 +
+			 hex_to_bin(mac_str[2 * i + 1]);
 
 	return 0;
 }
diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index 1da755a..6bb876d 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -704,17 +704,6 @@ static char *host_addr;
 module_param(host_addr, charp, S_IRUGO);
 MODULE_PARM_DESC(host_addr, "Host Ethernet Address");
 
-
-static u8 __init nibble(unsigned char c)
-{
-	if (isdigit(c))
-		return c - '0';
-	c = toupper(c);
-	if (isxdigit(c))
-		return 10 + c - 'A';
-	return 0;
-}
-
 static int get_ether_addr(const char *str, u8 *dev_addr)
 {
 	if (str) {
@@ -725,8 +714,8 @@ static int get_ether_addr(const char *str, u8 *dev_addr)
 
 			if ((*str == '.') || (*str == ':'))
 				str++;
-			num = nibble(*str++) << 4;
-			num |= (nibble(*str++));
+			num = hex_to_bin(*str++) << 4;
+			num |= hex_to_bin(*str++);
 			dev_addr [i] = num;
 		}
 		if (is_valid_ether_addr(dev_addr))
-- 
1.6.6.1

