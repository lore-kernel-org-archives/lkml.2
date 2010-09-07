Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0IGPUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:20:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39857 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab0IGPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uvEnfgvXye5XVUZ1tF+ngBR8yb3L4b8Ax0W/OF5i7ezLTRcLqqshfq5SrjwVhmAyQN
         hLccem4wjiP/XNs40Ely3XG1G6mqp276qPsfkyEebOZktnGHRvQCtOYw30EUnr0p+a8r
         NRb0cwpV0BFmU38YdghE31fwK1VT7pIaVJwsc=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 2/2] staging: ath6kl: use native methods from kernel library
Date: Tue,  7 Sep 2010 18:20:22 +0300
Message-Id: <8b251244717765e795b92a1f7335f8af98e5706f.1283872748.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <09b7da2e5462e0b855617ff5308ed6efb4fc9cab.1283872748.git.andy.shevchenko@gmail.com>
References: <09b7da2e5462e0b855617ff5308ed6efb4fc9cab.1283872748.git.andy.shevchenko@gmail.com>
In-Reply-To: <09b7da2e5462e0b855617ff5308ed6efb4fc9cab.1283872748.git.andy.shevchenko@gmail.com>
References: <09b7da2e5462e0b855617ff5308ed6efb4fc9cab.1283872748.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are already implemented methods such hex_to_bin() or isxdigit() in
the kernel. Let's use them.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |   31 ++++++-------------
 drivers/staging/ath6kl/os/linux/eeprom.c           |   32 +++++++++----------
 2 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
index 5eed8ac..8dce054 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
@@ -27,6 +27,9 @@
 
 #include "ar3kpsparser.h"
 
+#include <linux/ctype.h>
+#include <linux/kernel.h>
+
 #define BD_ADDR_SIZE            6
 #define WRITE_PATCH             8
 #define ENABLE_PATCH            11
@@ -61,20 +64,6 @@
 #define MAX_BYTE_LENGTH                   244
 
 #define SKIP_BLANKS(str) while (*str == ' ') str++
-#define MIN(x, y) (((x) <= (y))? (x):(y))
-#define MAX(x, y) (((x) >= (y))? (x):(y))
-
-#define UNUSED(x) (x=x)
-
-#define IS_BETWEEN(x, lower, upper) (((lower) <= (x)) && ((x) <= (upper)))
-#define IS_DIGIT(c) (IS_BETWEEN((c), '0', '9'))
-#define IS_HEX(c)   (IS_BETWEEN((c), '0', '9') || IS_BETWEEN((c), 'a', 'f') || IS_BETWEEN((c), 'A', 'F'))
-#define TO_LOWER(c) (IS_BETWEEN((c), 'A', 'Z') ? ((c) - 'A' + 'a') : (c))
-#define IS_BLANK(c) ((c) == ' ')
-#define CONV_DEC_DIGIT_TO_VALUE(c) ((c) - '0')
-#define CONV_HEX_DIGIT_TO_VALUE(c) (IS_DIGIT(c) ? ((c) - '0') : (IS_BETWEEN((c), 'A', 'Z') ? ((c) - 'A' + 10) : ((c) - 'a' + 10))) 
-#define CONV_VALUE_TO_HEX(v) ((A_UINT8)( ((v & 0x0F) <= 9) ? ((v & 0x0F) + '0') : ((v & 0x0F) - 10 + 'A') ) )
-
 
 enum MinBootFileFormatE
 {
@@ -483,12 +472,12 @@ A_STATUS AthParseFilesUnified(A_UCHAR *srcbuffer,A_UINT32 srclen, int FileFormat
                     if((stPS_DataFormat.eDataType == eHex) && stPS_DataFormat.bIsArray == true) {
                        while(uReadCount > 0) {
                            PsTagEntry[TagCount].TagData[stReadStatus.uByteCount] =
-                                                     (A_UINT8)(CONV_HEX_DIGIT_TO_VALUE(pCharLine[stReadStatus.uCharCount]) << 4)
-                                                     | (A_UINT8)(CONV_HEX_DIGIT_TO_VALUE(pCharLine[stReadStatus.uCharCount + 1]));
+                                                     (A_UINT8)(hex_to_bin(pCharLine[stReadStatus.uCharCount]) << 4)
+                                                     | (A_UINT8)(hex_to_bin(pCharLine[stReadStatus.uCharCount + 1]));
 
                            PsTagEntry[TagCount].TagData[stReadStatus.uByteCount+1] =
-                                                     (A_UINT8)(CONV_HEX_DIGIT_TO_VALUE(pCharLine[stReadStatus.uCharCount + 3]) << 4)
-                                                     | (A_UINT8)(CONV_HEX_DIGIT_TO_VALUE(pCharLine[stReadStatus.uCharCount + 4]));
+                                                     (A_UINT8)(hex_to_bin(pCharLine[stReadStatus.uCharCount + 3]) << 4)
+                                                     | (A_UINT8)(hex_to_bin(pCharLine[stReadStatus.uCharCount + 4]));
 
                            stReadStatus.uCharCount += 6; // read two bytes, plus a space;
                            stReadStatus.uByteCount += 2;
@@ -574,14 +563,14 @@ A_STATUS GetNextTwoChar(A_UCHAR *srcbuffer,A_UINT32 len, A_UINT32 *pos, char * b
     unsigned char ch;
 
     ch = AthReadChar(srcbuffer,len,pos);
-    if(ch != '\0' && IS_HEX(ch)) {
+    if(ch != '\0' && isxdigit(ch)) {
         buffer[0] =  ch;
     } else 
     {
         return A_ERROR;
     }
     ch = AthReadChar(srcbuffer,len,pos);
-    if(ch != '\0' && IS_HEX(ch)) {
+    if(ch != '\0' && isxdigit(ch)) {
         buffer[1] =  ch;
     } else 
     {
@@ -606,7 +595,7 @@ A_STATUS AthDoParsePatch(A_UCHAR *patchbuffer, A_UINT32 patchlen)
     Patch_Count = 0;
 
     while(NULL != AthGetLine(Line,MAX_BYTE_LENGTH,patchbuffer,patchlen,&filepos)) {
-        if(strlen(Line) <= 1 || !IS_HEX(Line[0])) {
+        if(strlen(Line) <= 1 || !isxdigit(Line[0])) {
             continue;
         } else {
             break;
diff --git a/drivers/staging/ath6kl/os/linux/eeprom.c b/drivers/staging/ath6kl/os/linux/eeprom.c
index 8dd130a..be77fb8 100644
--- a/drivers/staging/ath6kl/os/linux/eeprom.c
+++ b/drivers/staging/ath6kl/os/linux/eeprom.c
@@ -71,24 +71,22 @@ wmic_ether_aton(const char *orig, A_UINT8 *eth)
   i = 0;
   for(bufp = orig; *bufp != '\0'; ++bufp) {
     unsigned int val;
-    unsigned char c = *bufp++;
-    if (c >= '0' && c <= '9') val = c - '0';
-    else if (c >= 'a' && c <= 'f') val = c - 'a' + 10;
-    else if (c >= 'A' && c <= 'F') val = c - 'A' + 10;
-    else {
-        printk("%s: MAC value is invalid\n", __FUNCTION__);
-        break;
-    }
+	int h, l;
 
-    val <<= 4;
-    c = *bufp++;
-    if (c >= '0' && c <= '9') val |= c - '0';
-    else if (c >= 'a' && c <= 'f') val |= c - 'a' + 10;
-    else if (c >= 'A' && c <= 'F') val |= c - 'A' + 10;
-    else {
-        printk("%s: MAC value is invalid\n", __FUNCTION__);
-        break;
-    }
+	h = hex_to_bin(*bufp++);
+
+	if (h < 0) {
+		printk("%s: MAC value is invalid\n", __FUNCTION__);
+		break;
+	}
+
+	l = hex_to_bin(*bufp++);
+	if (l < 0) {
+		printk("%s: MAC value is invalid\n", __FUNCTION__);
+		break;
+	}
+
+	val = (h << 4) | l;
 
     eth[i] = (unsigned char) (val & 0377);
     if(++i == ATH_MAC_LEN) {
-- 
1.7.2.2

