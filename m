Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab0GFPI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:08:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44506 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0GFPI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AvZbgieHcixBv+NMYUSk4F0qFeYOUlLjo+pvlF22jgAN+KI3pmyk8K2p3NhcZAY2wL
         uo0nb6fClkaD4BV7pNudpIVarFacUl8DJXYPnJJekJod1rw6KqWv+m+tcbsnUqS+win5
         iAfFUQ59NCfuIIqLJQLdl7geFZ/jlOkTxLbT0=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
       Ohad Ben-Cohen <ohad@wizery.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-omap@vger.kernel.org
Subject: [PATCH] staging: tidspbridge: gen: simplify and clean up
Date: Tue,  6 Jul 2010 18:08:52 +0300
Message-Id: <1278428932-9145-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <AANLkTimdDuce7ZCVGhmMpbY5vKO_2AB7Ew3gTAYW77QW@mail.gmail.com>
References: <AANLkTimdDuce7ZCVGhmMpbY5vKO_2AB7Ew3gTAYW77QW@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is recently added hex_to_bin() kernel's method which we could use
instead of custom long function.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-omap@vger.kernel.org
---
 drivers/staging/tidspbridge/gen/uuidutil.c |  167 +++++-----------------------
 1 files changed, 28 insertions(+), 139 deletions(-)

diff --git a/drivers/staging/tidspbridge/gen/uuidutil.c b/drivers/staging/tidspbridge/gen/uuidutil.c
index ce9319d..eb09bc3 100644
--- a/drivers/staging/tidspbridge/gen/uuidutil.c
+++ b/drivers/staging/tidspbridge/gen/uuidutil.c
@@ -54,61 +54,19 @@ void uuid_uuid_to_string(IN struct dsp_uuid *uuid_obj, OUT char *pszUuid,
 	DBC_ENSURE(i != -1);
 }
 
-/*
- *  ======== htoi ========
- *  Purpose:
- *      Converts a hex value to a decimal integer.
- */
-
-static int htoi(char c)
+static s32 uuid_hex_to_bin(char *buf, s32 len)
 {
-	switch (c) {
-	case '0':
-		return 0;
-	case '1':
-		return 1;
-	case '2':
-		return 2;
-	case '3':
-		return 3;
-	case '4':
-		return 4;
-	case '5':
-		return 5;
-	case '6':
-		return 6;
-	case '7':
-		return 7;
-	case '8':
-		return 8;
-	case '9':
-		return 9;
-	case 'A':
-		return 10;
-	case 'B':
-		return 11;
-	case 'C':
-		return 12;
-	case 'D':
-		return 13;
-	case 'E':
-		return 14;
-	case 'F':
-		return 15;
-	case 'a':
-		return 10;
-	case 'b':
-		return 11;
-	case 'c':
-		return 12;
-	case 'd':
-		return 13;
-	case 'e':
-		return 14;
-	case 'f':
-		return 15;
+	s32 i;
+	s32 result = 0;
+
+	for (i = 0; i < len; i++) {
+		value = hex_to_bin(*buf++);
+		result *= 16;
+		if (value > 0)
+			result += value;
 	}
-	return 0;
+
+	return result;
 }
 
 /*
@@ -118,106 +76,37 @@ static int htoi(char c)
  */
 void uuid_uuid_from_string(IN char *pszUuid, OUT struct dsp_uuid *uuid_obj)
 {
-	char c;
-	s32 i, j;
-	s32 result;
-	char *temp = pszUuid;
+	s32 j;
 
-	result = 0;
-	for (i = 0; i < 8; i++) {
-		/* Get first character in string */
-		c = *temp;
-
-		/* Increase the results by new value */
-		result *= 16;
-		result += htoi(c);
-
-		/* Go to next character in string */
-		temp++;
-	}
-	uuid_obj->ul_data1 = result;
+	uuid_obj->ul_data1 = uuid_hex_to_bin(pszUuid, 8);
+	pszUuid += 8;
 
 	/* Step over underscore */
-	temp++;
+	pszUuid++;
 
-	result = 0;
-	for (i = 0; i < 4; i++) {
-		/* Get first character in string */
-		c = *temp;
-
-		/* Increase the results by new value */
-		result *= 16;
-		result += htoi(c);
-
-		/* Go to next character in string */
-		temp++;
-	}
-	uuid_obj->us_data2 = (u16) result;
+	uuid_obj->us_data2 = (u16) uuid_hex_to_bin(pszUuid, 4);
+	pszUuid += 4;
 
 	/* Step over underscore */
-	temp++;
-
-	result = 0;
-	for (i = 0; i < 4; i++) {
-		/* Get first character in string */
-		c = *temp;
+	pszUuid++;
 
-		/* Increase the results by new value */
-		result *= 16;
-		result += htoi(c);
-
-		/* Go to next character in string */
-		temp++;
-	}
-	uuid_obj->us_data3 = (u16) result;
+	uuid_obj->us_data3 = (u16) uuid_hex_to_bin(pszUuid, 4);
+	pszUuid += 4;
 
 	/* Step over underscore */
-	temp++;
-
-	result = 0;
-	for (i = 0; i < 2; i++) {
-		/* Get first character in string */
-		c = *temp;
+	pszUuid++;
 
-		/* Increase the results by new value */
-		result *= 16;
-		result += htoi(c);
+	uuid_obj->uc_data4 = (u8) uuid_hex_to_bin(pszUuid, 2);
+	pszUuid += 2;
 
-		/* Go to next character in string */
-		temp++;
-	}
-	uuid_obj->uc_data4 = (u8) result;
-
-	result = 0;
-	for (i = 0; i < 2; i++) {
-		/* Get first character in string */
-		c = *temp;
-
-		/* Increase the results by new value */
-		result *= 16;
-		result += htoi(c);
-
-		/* Go to next character in string */
-		temp++;
-	}
-	uuid_obj->uc_data5 = (u8) result;
+	uuid_obj->uc_data5 = (u8) uuid_hex_to_bin(pszUuid, 2);
+	pszUuid += 2;
 
 	/* Step over underscore */
-	temp++;
+	pszUuid++;
 
 	for (j = 0; j < 6; j++) {
-		result = 0;
-		for (i = 0; i < 2; i++) {
-			/* Get first character in string */
-			c = *temp;
-
-			/* Increase the results by new value */
-			result *= 16;
-			result += htoi(c);
-
-			/* Go to next character in string */
-			temp++;
-		}
-		uuid_obj->uc_data6[j] = (u8) result;
+		uuid_obj->uc_data6[j] = (u8) uuid_hex_to_bin(pszUuid, 2);
+		pszUuid += 2;
 	}
 }
-- 
1.6.6.1

