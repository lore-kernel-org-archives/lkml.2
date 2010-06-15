Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0FOOZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:25:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42129 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0FOOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lIMvsgyVJYyBvfVCa1zViz7A8YPQ4NLvvz/fVCsgkV7PnpKrbZ0gVfh1WcqvJUjGqZ
         SULJeiTKCOEP6u7Z1vy2txVWL6NoI45CbdgdWLCgrFt/XxEJttBRAJly+OAIhEjXOaox
         qjF9QJg3kfgjM+N0jR3Fr1TBeiyV3misDVPqI=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH] staging: don't use custom hex_to_bin() implementation
Date: Tue, 15 Jun 2010 17:25:38 +0300
Message-Id: <1276611938-28464-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/comedi/drivers/jr3_pci.c |   17 +++++++++--------
 drivers/staging/rtl8192su/r8192S_Efuse.c |   19 +------------------
 2 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index d330b18..51f4c5c 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -48,6 +48,7 @@ Devices: [JR3] PCI force sensor board (jr3_pci)
 #include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
+#include <linux/kernel.h>
 #include "comedi_pci.h"
 #include "jr3_pci.h"
 
@@ -399,14 +400,14 @@ int read_idm_word(const u8 * data, size_t size, int *pos, unsigned int *val)
 		}
 		/*  Collect value */
 		*val = 0;
-		for (; *pos < size && isxdigit(data[*pos]); (*pos)++) {
-			char ch = tolower(data[*pos]);
-			result = 1;
-			if ('0' <= ch && ch <= '9') {
-				*val = (*val << 4) + (ch - '0');
-			} else if ('a' <= ch && ch <= 'f') {
-				*val = (*val << 4) + (ch - 'a' + 10);
-			}
+		for (; *pos < size; (*pos)++) {
+			int value;
+			value = hex_to_bin(data[*pos]);
+			if (value >= 0) {
+				result = 1;
+				*val = (*val << 4) + value;
+			} else
+				break;
 		}
 	}
 	return result;
diff --git a/drivers/staging/rtl8192su/r8192S_Efuse.c b/drivers/staging/rtl8192su/r8192S_Efuse.c
index f0ce656..1e1d55e 100644
--- a/drivers/staging/rtl8192su/r8192S_Efuse.c
+++ b/drivers/staging/rtl8192su/r8192S_Efuse.c
@@ -1848,22 +1848,6 @@ bool IsHexDigit(	char chTmp)
 	}
 }
 
-//
-//	Description:
-//		Translate a character to hex digit.
-//
-u32 MapCharToHexDigit(char chTmp)
-{
-	if(chTmp >= '0' && chTmp <= '9')
-		return (chTmp - '0');
-	else if(chTmp >= 'a' && chTmp <= 'f')
-		return (10 + (chTmp - 'a'));
-	else if(chTmp >= 'A' && chTmp <= 'F')
-		return (10 + (chTmp - 'A'));
-	else
-		return 0;
-}
-
 /*-----------------------------------------------------------------------------
  * Function:	efuse_ParsingMap
  *
@@ -1917,8 +1901,7 @@ efuse_ParsingMap(char* szStr,u32* pu4bVal,u32* pu4bMove)
 	// Parse each digit.
 	do
 	{
-		(*pu4bVal) <<= 4;
-		*pu4bVal += MapCharToHexDigit(*szScan);
+		*pu4bVal = (*pu4bVal << 4) + hex_to_bin(*szScan);
 
 		szScan++;
 		(*pu4bMove)++;
-- 
1.6.6.1

