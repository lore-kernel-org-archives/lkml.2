Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab1H0SM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:26 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39878
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751544Ab1H0SLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 32/46] Staging: hv: util: Adjust guest time in a process context
Date: Sat, 27 Aug 2011 11:31:31 -0700
Message-Id: <1314469905-7058-32-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code was adjusting guest time in interrupt context; do this
in process context since we may have to initiate cross-processor
interrupts as part of setting time.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_util.c |   33 ++++++++++++++++++++++++++++++---
 1 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index 876d44a..e29a2a2 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -107,6 +107,24 @@ static inline void do_adj_guesttime(u64 hosttime)
 }
 
 /*
+ * Set the host time in a process context.
+ */
+
+struct adj_time_work {
+	struct work_struct work;
+	u64	host_time;
+};
+
+static void hv_set_host_time(struct work_struct *work)
+{
+	struct adj_time_work	*wrk;
+
+	wrk = container_of(work, struct adj_time_work, work);
+	do_adj_guesttime(wrk->host_time);
+	kfree(wrk);
+}
+
+/*
  * Synchronize time with host after reboot, restore, etc.
  *
  * ICTIMESYNCFLAG_SYNC flag bit indicates reboot, restore events of the VM.
@@ -119,17 +137,26 @@ static inline void do_adj_guesttime(u64 hosttime)
  */
 static inline void adj_guesttime(u64 hosttime, u8 flags)
 {
+	struct adj_time_work    *wrk;
 	static s32 scnt = 50;
 
+	wrk = kmalloc(sizeof(struct adj_time_work), GFP_ATOMIC);
+	if (wrk == NULL)
+		return;
+
+	wrk->host_time = hosttime;
 	if ((flags & ICTIMESYNCFLAG_SYNC) != 0) {
-		do_adj_guesttime(hosttime);
+		INIT_WORK(&wrk->work, hv_set_host_time);
+		schedule_work(&wrk->work);
 		return;
 	}
 
 	if ((flags & ICTIMESYNCFLAG_SAMPLE) != 0 && scnt > 0) {
 		scnt--;
-		do_adj_guesttime(hosttime);
-	}
+		INIT_WORK(&wrk->work, hv_set_host_time);
+		schedule_work(&wrk->work);
+	} else
+		kfree(wrk);
 }
 
 /*
-- 
1.7.4.1

