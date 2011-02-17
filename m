Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1BQFWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 00:22:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52718 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1BQFWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 00:22:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fRb3IjW6lB7Z3dQohRcKukpqwhFSqXnqXCyInJD4lsy4Aq6wJEQFwrlpCAd+rdjvrl
         3Cau72JYyNwLrBUJlc1KFQbNfHmPJWcwtQHz77c4c/1q/ctHyxZ0dKOzUxo6A0WYlbQV
         B6b/ry5vALzwoNePUA8bQN8ADvQaDwEQbqfkc=
From: Johan Wessfeldt <johan.wessfeldt@gmail.com>
To: mhw@wittsend.com
Cc: linux-kernel@vger.kernel.org, Johan Wessfeldt <johan.wessfeldt@gmail.com>
Subject: [PATCH] ip2: Correction to unchecked calls copy_to_user/put_user in ip2 debug code
Date: Thu, 17 Feb 2011 06:22:15 +0100
Message-Id: <1297920135-11085-1-git-send-email-johan.wessfeldt@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes unchecked calls to copy_to_user() and put_user() in the
ip2 driver debug code, ie. when IP2DEBUG_TRACE and DEBUG_FIFO are set.
Minor coding style issues were corrected in corresponding code.

Signed-off-by: Johan Wessfeldt <johan.wessfeldt@gmail.com>
---
 drivers/char/ip2/ip2main.c |   55 ++++++++++++++++++++++++++++----------------
 1 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index fcd02ba..e1d2f47 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -2803,13 +2803,12 @@ ip2_ipl_read(struct file *pFile, char __user *pData, size_t count, loff_t *off )
 }
 
 static int
-DumpFifoBuffer ( char __user *pData, int count )
+DumpFifoBuffer(char __user *pData, int count)
 {
 #ifdef DEBUG_FIFO
-	int rc;
-	rc = copy_to_user(pData, DBGBuf, count);
-
-	printk(KERN_DEBUG "Last index %d\n", I );
+	if (copy_to_user(pData, DBGBuf, count))
+		return -EFAULT;
+	printk(KERN_DEBUG "Last index %d\n", I);
 
 	return count;
 #endif	/* DEBUG_FIFO */
@@ -2817,21 +2816,28 @@ DumpFifoBuffer ( char __user *pData, int count )
 }
 
 static int
-DumpTraceBuffer ( char __user *pData, int count )
+DumpTraceBuffer(char __user *pData, int count)
 {
 #ifdef IP2DEBUG_TRACE
-	int rc;
 	int dumpcount;
 	int chunk;
 	int *pIndex = (int __user *)pData;
 
-	if ( count < (sizeof(int) * 6) ) {
+	if (count < (sizeof(int) * 6))
 		return -EIO;
-	}
-	rc = put_user(tracewrap, pIndex );
-	rc = put_user(TRACEMAX, ++pIndex );
-	rc = put_user(tracestrip, ++pIndex );
-	rc = put_user(tracestuff, ++pIndex );
+
+	if (put_user(tracewrap, pIndex))
+		return -EFAULT;
+
+	if (put_user(TRACEMAX, ++pIndex))
+		return -EFAULT;
+
+	if (put_user(tracestrip, ++pIndex))
+		return -EFAULT;
+
+	if (put_user(tracestuff, ++pIndex))
+		return -EFAULT;
+
 	pData += sizeof(int) * 6;
 	count -= sizeof(int) * 6;
 
@@ -2843,22 +2849,31 @@ DumpTraceBuffer ( char __user *pData, int count )
 		dumpcount = count;
 	}
 	chunk = TRACEMAX - tracestrip;
-	if ( dumpcount > chunk ) {
-		rc = copy_to_user(pData, &tracebuf[tracestrip],
-			      chunk * sizeof(tracebuf[0]) );
+	if (dumpcount > chunk) {
+
+		if (copy_to_user(pData, &tracebuf[tracestrip],
+				 chunk * sizeof(tracebuf[0]) ))
+			return -EFAULT;
+
 		pData += chunk * sizeof(tracebuf[0]);
 		tracestrip = 0;
 		chunk = dumpcount - chunk;
 	} else {
 		chunk = dumpcount;
 	}
-	rc = copy_to_user(pData, &tracebuf[tracestrip],
-		      chunk * sizeof(tracebuf[0]) );
+
+	if (copy_to_user(pData, &tracebuf[tracestrip],
+			 chunk * sizeof(tracebuf[0]) ))
+		return -EFAULT;
+
 	tracestrip += chunk;
 	tracewrap = 0;
 
-	rc = put_user(tracestrip, ++pIndex );
-	rc = put_user(tracestuff, ++pIndex );
+	if (put_user(tracestrip, ++pIndex))
+		return -EFAULT;
+
+	if (put_user(tracestuff, ++pIndex))
+		return -EFAULT;
 
 	return dumpcount;
 #else
-- 
1.7.1

