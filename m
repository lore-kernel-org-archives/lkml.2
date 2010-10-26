Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab0JZAkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:40:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55397 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab0JZAia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:38:30 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <Hiroshi.DOYU@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 8/8] staging: tidspbridge - make sync_wait_on_event interruptible
Date: Mon, 25 Oct 2010 19:51:46 -0500
Message-Id: <1288054306-4361-9-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1288054306-4361-8-git-send-email-x0095840@ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
 <1288054306-4361-2-git-send-email-x0095840@ti.com>
 <1288054306-4361-3-git-send-email-x0095840@ti.com>
 <1288054306-4361-4-git-send-email-x0095840@ti.com>
 <1288054306-4361-5-git-send-email-x0095840@ti.com>
 <1288054306-4361-6-git-send-email-x0095840@ti.com>
 <1288054306-4361-7-git-send-email-x0095840@ti.com>
 <1288054306-4361-8-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that avoid non-killable process.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/sync.h   |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/sync.h b/drivers/staging/tidspbridge/include/dspbridge/sync.h
index e2651e7..df05b8f 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/sync.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/sync.h
@@ -80,13 +80,22 @@ void sync_set_event(struct sync_object *event);
  * This functios will wait until @event is set or until timeout. In case of
  * success the function will return 0 and
  * in case of timeout the function will return -ETIME
+ * in case of signal the function will return -ERESTARTSYS
  */
 
 static inline int sync_wait_on_event(struct sync_object *event,
 							unsigned timeout)
 {
-	return wait_for_completion_timeout(&event->comp,
-		msecs_to_jiffies(timeout)) ? 0 : -ETIME;
+	int res;
+
+	res = wait_for_completion_interruptible_timeout(&event->comp,
+						msecs_to_jiffies(timeout));
+	if (!res)
+		res = -ETIME;
+	else if (res > 0)
+		res = 0;
+
+	return res;
 }
 
 /**
-- 
1.6.3.3

