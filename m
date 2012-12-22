Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2LVCCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:02:17 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:40826 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab2LVB6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:25 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 14/25] rfkill: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:04 -0800
Message-Id: <1356141435-17340-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from rfkill.  Only compile
tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 net/rfkill/input.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/rfkill/input.c b/net/rfkill/input.c
index c9d931e..b85107b 100644
--- a/net/rfkill/input.c
+++ b/net/rfkill/input.c
@@ -148,11 +148,9 @@ static unsigned long rfkill_ratelimit(const unsigned long last)
 
 static void rfkill_schedule_ratelimited(void)
 {
-	if (delayed_work_pending(&rfkill_op_work))
-		return;
-	schedule_delayed_work(&rfkill_op_work,
-			      rfkill_ratelimit(rfkill_last_scheduled));
-	rfkill_last_scheduled = jiffies;
+	if (schedule_delayed_work(&rfkill_op_work,
+				  rfkill_ratelimit(rfkill_last_scheduled)))
+		rfkill_last_scheduled = jiffies;
 }
 
 static void rfkill_schedule_global_op(enum rfkill_sched_op op)
-- 
1.8.0.2

