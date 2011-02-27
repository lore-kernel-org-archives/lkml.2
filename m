Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1B0WUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 17:20:31 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47681 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1B0WUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 17:20:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DGuC5MKYGZYxQSYqbTheNStqMEFkFZdbHEHkw095hkMDAdLuVAhdoyZQ0tTreb8lT8
         Yylmb3iGPgtbfmPAyfd3snhJn8E/37ggIAQgkyWNYNAv6mUGq6vYwPqfKO6M/vXqAGgb
         FbkkguGXI/PHfJJBOLdF9Fq0llyxCvdjQhaJs=
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Roel Van Nyen <roel.vannyen@gmail.com>
Subject: [PATCH] keucr: Change the custom counting functions to hweight8 and hweight16
Date: Sun, 27 Feb 2011 23:20:24 +0100
Message-Id: <1298845224-22423-1-git-send-email-roel.vannyen@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the custom counting functions to hweight8 and hweight16

Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
---
 drivers/staging/keucr/smcommon.h |    2 --
 drivers/staging/keucr/smilsub.c  |   37 ++++++-------------------------------
 2 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/keucr/smcommon.h b/drivers/staging/keucr/smcommon.h
index 1694605..00064ca 100644
--- a/drivers/staging/keucr/smcommon.h
+++ b/drivers/staging/keucr/smcommon.h
@@ -25,8 +25,6 @@ Define Difinetion
 #define ERR_NoSmartMedia    0x003A /* Medium Not Present */
 
 /***************************************************************************/
-char Bit_D_Count(BYTE);
-char Bit_D_CountWord(WORD);
 void StringCopy(char *, char *, int);
 int  StringCmp(char *, char *, int);
 
diff --git a/drivers/staging/keucr/smilsub.c b/drivers/staging/keucr/smilsub.c
index 6dbc81d..80da61c 100644
--- a/drivers/staging/keucr/smilsub.c
+++ b/drivers/staging/keucr/smilsub.c
@@ -79,7 +79,7 @@ int Check_D_FailBlock(BYTE *redundant)
 		return(SUCCESS);
 	if (!*redundant)
 		return(ERROR);
-	if (Bit_D_Count(*redundant)<7)
+	if (hweight8(*redundant)<7)
 		return(ERROR);
 
 	return(SUCCESS);
@@ -100,7 +100,7 @@ int Check_D_DataStatus(BYTE *redundant)
 	else
 		ErrXDCode = NO_ERROR;
 
-	if (Bit_D_Count(*redundant)<5)
+	if (hweight8(*redundant)<5)
 		return(ERROR);
 
 	return(SUCCESS);
@@ -120,14 +120,14 @@ int Load_D_LogBlockAddr(BYTE *redundant)
 		if ((addr1 &0xF000)==0x1000)
 		{ Media.LogBlock=(addr1 &0x0FFF)/2; return(SUCCESS); }
 
-	if (Bit_D_CountWord((WORD)(addr1^addr2))!=0x01) return(ERROR);
+	if (hweight16((WORD)(addr1^addr2))!=0x01) return(ERROR);
 
 	if ((addr1 &0xF000)==0x1000)
-		if (!(Bit_D_CountWord(addr1) &0x01))
+		if (!(hweight16(addr1) &0x01))
 		{ Media.LogBlock=(addr1 &0x0FFF)/2; return(SUCCESS); }
 
 	if ((addr2 &0xF000)==0x1000)
-		if (!(Bit_D_CountWord(addr2) &0x01))
+		if (!(hweight16(addr2) &0x01))
 		{ Media.LogBlock=(addr2 &0x0FFF)/2; return(SUCCESS); }
 
 	return(ERROR);
@@ -151,7 +151,7 @@ void Set_D_LogBlockAddr(BYTE *redundant)
 	*(redundant+REDT_DATA) =0xFF;
 	addr=Media.LogBlock*2+0x1000;
 
-	if ((Bit_D_CountWord(addr)%2))
+	if ((hweight16(addr)%2))
 		addr++;
 
 	*(redundant+REDT_ADDR1H)=*(redundant+REDT_ADDR2H)=(BYTE)(addr/0x0100);
@@ -1549,31 +1549,6 @@ void Set_D_RightECC(BYTE *redundant)
 //    StringCopy((char *)(redundant+0x08),(char *)(EccBuf+0x03),3);
 //}
 */
-//Common Subroutine
-char Bit_D_Count(BYTE cdata)
-{
-    WORD bitcount=0;
-
-    while(cdata) {
-        bitcount+=(WORD)(cdata &0x01);
-        cdata /=2;
-    }
-
-    return((char)bitcount);
-}
-
-//-----
-char Bit_D_CountWord(WORD cdata)
-{
-    WORD bitcount=0;
-
-    while(cdata) {
-        bitcount+=(cdata &0x01);
-        cdata /=2;
-    }
-
-    return((char)bitcount);
-}
 
 /*
 //----- SM_ReadBlock() ---------------------------------------------
-- 
1.7.1

