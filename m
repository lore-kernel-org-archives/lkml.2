Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1AZLtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:49:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1AZLso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:48:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qBo7hzTAu5VLj0dVDck5pXxAVkeSntZP7LXYejYNSRLKhZJf+095nO1ybkFYfzpvHo
         5ZuB+I8APlDZDmd2chXyG/T4gzx+PxGgBICARJH3lxHo8ErpLvD9JVe7MDkMcklduFgH
         Wc6z31HX0Gbc0wbo4pQ17rgGcd+NDdgF5iQAk=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 3/5] staging: ft1000: Create common function for buffers check.
Date: Wed, 26 Jan 2011 12:49:13 +0100
Message-Id: <1296042555-29145-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same check was done on three places which make code unreadable.
Put repeat routine to separate function.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   59 ++++++++++----------
 1 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index b99553b..2537a11 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -470,6 +470,17 @@ static u16 hdr_checksum(struct pseudo_hdr *pHdr)
 	return chksum;
 }
 
+static int check_buffers(u16 *buff_w, u16 *buff_r, int len, int offset)
+{
+	int i;
+
+	for (i = 0; i < len; i++) {
+		if (buff_w[i] != buff_r[i + offset])
+			return -1;
+	}
+
+	return 0;
+}
 
 //---------------------------------------------------------------------------
 // Function:    write_blk
@@ -560,43 +571,31 @@ static u32 write_blk (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFi
 	    	       Status = ft1000_read_dpram32 (ft1000dev, dpram, (u8 *)&resultbuffer[0], 64);
 		       if ( (tempbuffer[31] & 0xfe00) == 0xfe00)
 		       {
-		           for (i=0; i<28; i++)
-		           {
-			       if (resultbuffer[i] != tempbuffer[i])
-			       {
-			           //NdisMSleep (100);
-                                   DEBUG("FT1000:download:DPRAM write failed 1 during bootloading\n");
-				   msleep(10);
-     	  			   Status = STATUS_FAILURE;
-				   break;
+				if (check_buffers(tempbuffer, resultbuffer, 28, 0)) {
+					DEBUG("FT1000:download:DPRAM write failed 1 during bootloading\n");
+					msleep(10);
+					Status = STATUS_FAILURE;
+					break;
 				}
-			   }
    			   Status = ft1000_read_dpram32 (ft1000dev, dpram+12, (u8 *)&resultbuffer[0], 64);
-		           for (i=0; i<16; i++)
-		           {
-    			       if (resultbuffer[i] != tempbuffer[i+24])
-    			       {
-                                   //NdisMSleep (100);
-                                   DEBUG("FT1000:download:DPRAM write failed 2 during bootloading\n");
-				   msleep(10);
-				   Status = STATUS_FAILURE;
-				   break;
+
+				if (check_buffers(tempbuffer, resultbuffer, 16, 24)) {
+					DEBUG("FT1000:download:DPRAM write failed 2 during bootloading\n");
+					msleep(10);
+					Status = STATUS_FAILURE;
+					break;
 				}
-			   }
+			   
 			}
 			else
 			{
-			    for (i=0; i<32; i++)
-			    {
-    			        if (resultbuffer[i] != tempbuffer[i])
-    			        {
-                                    //NdisMSleep (100);
-                                    DEBUG("FT1000:download:DPRAM write failed 3 during bootloading\n");
-				    msleep(10);
-				    Status = STATUS_FAILURE;
-				    break;
+				if (check_buffers(tempbuffer, resultbuffer, 32, 0)) {
+					DEBUG("FT1000:download:DPRAM write failed 3 during bootloading\n");
+					msleep(10);
+					Status = STATUS_FAILURE;
+					break;
 				}
-			    }
+			    
 			}
 
 			if (Status == STATUS_SUCCESS)
-- 
1.7.1

