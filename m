Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab0F0NWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 09:22:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47857 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab0F0NWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 09:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z7l3+TjvqcU+T/kMPhwtiZnemLdmy0Lgoe5LFNRsELi67aRxZbcte44kSYL+aOMRdh
         qJYszJad5TS6ncTdP5RJtA85q7zTDJ7YBGlBbL29Dmmp+B+PPQ/ODaB7tBjX9bLuNp2+
         J8MHOH351JrgLT1McoePxMLZOGQKen9gAg2Yk=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lior Dotan <liodot@gmail.com>, <charrer@alacritech.com>,
       Denis Kirjanov <kirjanov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] staging: slicoss: error handling with goto
Date: Sun, 27 Jun 2010 17:20:46 +0400
Message-Id: <1277644847-16292-4-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277644847-16292-1-git-send-email-segooon@gmail.com>
References: <1277644847-16292-1-git-send-email-segooon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes error handling more readable due to 'goto err' pattern.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/slicoss/slicoss.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 86bc733..d8c952e 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2646,22 +2646,21 @@ static int slic_upr_request(struct adapter *adapter,
 		     u32 upr_data_h,
 		     u32 upr_buffer, u32 upr_buffer_h)
 {
-	int status;
+	int rc;
 
 	spin_lock_irqsave(&adapter->upr_lock.lock, adapter->upr_lock.flags);
-	status = slic_upr_queue_request(adapter,
+	rc = slic_upr_queue_request(adapter,
 					upr_request,
 					upr_data,
 					upr_data_h, upr_buffer, upr_buffer_h);
-	if (status != 0) {
-		spin_unlock_irqrestore(&adapter->upr_lock.lock,
-					adapter->upr_lock.flags);
-		return status;
-	}
+	if (rc)
+		goto err_unlock_irq;
+
 	slic_upr_start(adapter);
+err_unlock_irq:
 	spin_unlock_irqrestore(&adapter->upr_lock.lock,
 				adapter->upr_lock.flags);
-	return 0;
+	return rc;
 }
 
 static void slic_upr_request_complete(struct adapter *adapter, u32 isr)
-- 
1.7.0.4

