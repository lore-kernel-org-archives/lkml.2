Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1ETCnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 22:43:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63042 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab1ETCnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 22:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=x3/884PM4RoWgWYGeZ6t4hsUthPQHIuofH7MJYniprALmoTHLCX2ZOeC3h9zqNxLnY
         f6qqjMadxGlUndrv4AJUfRHWLaG+kkabaph3cpYWnph+ETlk63QEkjf8hKmO2jwJtuTu
         /xxK2BodqUwr+1jQEmI7e7NDB1N7tdB11A1uo=
Subject: [PATCH] block: reduce spin_lock critical region
From: Eduardo Silva <edsiper@gmail.com>
To: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 22:43:09 -0400
Message-ID: <1305859389.1763.1.camel@monotop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the critical region is originally composed by a conditional plus
a memory copy, the memory copy routine don't need protection.
Moving the memcpy() outside the conditional also help to fix the
16 compiler warning messages generated in __u8 sn[16] def.

Signed-off-by: Eduardo Silva <edsiper@gmail.com>
---
 drivers/block/cciss.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9bf1398..199b35e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -621,20 +621,19 @@ static ssize_t dev_show_unique_id(struct device *dev,
 	spin_lock_irqsave(&h->lock, flags);
 	if (h->busy_configuring)
 		ret = -EBUSY;
-	else
-		memcpy(sn, drv->serial_no, sizeof(sn));
 	spin_unlock_irqrestore(&h->lock, flags);
 
 	if (ret)
 		return ret;
-	else
-		return snprintf(buf, 16 * 2 + 2,
-				"%02X%02X%02X%02X%02X%02X%02X%02X"
-				"%02X%02X%02X%02X%02X%02X%02X%02X\n",
-				sn[0], sn[1], sn[2], sn[3],
-				sn[4], sn[5], sn[6], sn[7],
-				sn[8], sn[9], sn[10], sn[11],
-				sn[12], sn[13], sn[14], sn[15]);
+
+	memcpy(sn, drv->serial_no, sizeof(sn));
+	return snprintf(buf, 16 * 2 + 2,
+			"%02X%02X%02X%02X%02X%02X%02X%02X"
+			"%02X%02X%02X%02X%02X%02X%02X%02X\n",
+			sn[0], sn[1], sn[2], sn[3],
+			sn[4], sn[5], sn[6], sn[7],
+			sn[8], sn[9], sn[10], sn[11],
+			sn[12], sn[13], sn[14], sn[15]);
 }
 static DEVICE_ATTR(unique_id, S_IRUGO, dev_show_unique_id, NULL);
 
-- 
1.7.4.1



