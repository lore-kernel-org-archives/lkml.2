Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab0G2P4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:56:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57522 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab0G2P4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GROXRyvwBAaV39EmPFLJfUOcB7FVMKHU5TghR0MBQxQWo5Kd2brI/Ea5/Zf2IIxlL/
         BXWKyQ9ZiBCpNnVHBpUd2RXSSHbktRZmPbDgVd6uXIIjvV6gnXZdQ2dtctqp3a447VRa
         EJrAgr9XF9qmSF9Gmb1NClHqf4aT3+ap0uCwk=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "Michael H. Warfield" <mhw@wittsend.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] char: ip2: check put_user() result
Date: Thu, 29 Jul 2010 19:55:38 +0400
Message-Id: <1280418938-5833-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_user()/copy_to_user() may fail, if so return -EFAULT.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/ip2/ip2main.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 07f3ea3..3f70a05 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -2813,9 +2813,9 @@ DumpTraceBuffer ( char __user *pData, int count )
 		return -EIO;
 	}
 	rc = put_user(tracewrap, pIndex );
-	rc = put_user(TRACEMAX, ++pIndex );
-	rc = put_user(tracestrip, ++pIndex );
-	rc = put_user(tracestuff, ++pIndex );
+	rc |= put_user(TRACEMAX, ++pIndex);
+	rc |= put_user(tracestrip, ++pIndex);
+	rc |= put_user(tracestuff, ++pIndex);
 	pData += sizeof(int) * 6;
 	count -= sizeof(int) * 6;
 
@@ -2828,7 +2828,7 @@ DumpTraceBuffer ( char __user *pData, int count )
 	}
 	chunk = TRACEMAX - tracestrip;
 	if ( dumpcount > chunk ) {
-		rc = copy_to_user(pData, &tracebuf[tracestrip],
+		rc |= copy_to_user(pData, &tracebuf[tracestrip],
 			      chunk * sizeof(tracebuf[0]) );
 		pData += chunk * sizeof(tracebuf[0]);
 		tracestrip = 0;
@@ -2836,15 +2836,15 @@ DumpTraceBuffer ( char __user *pData, int count )
 	} else {
 		chunk = dumpcount;
 	}
-	rc = copy_to_user(pData, &tracebuf[tracestrip],
+	rc |= copy_to_user(pData, &tracebuf[tracestrip],
 		      chunk * sizeof(tracebuf[0]) );
 	tracestrip += chunk;
 	tracewrap = 0;
 
-	rc = put_user(tracestrip, ++pIndex );
-	rc = put_user(tracestuff, ++pIndex );
+	rc |= put_user(tracestrip, ++pIndex);
+	rc |= put_user(tracestuff, ++pIndex);
 
-	return dumpcount;
+	return rc ? -EFAULT : dumpcount;
 #else
 	return 0;
 #endif
-- 
1.7.0.4

