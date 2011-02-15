Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1BOJyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:54:13 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8686 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab1BOJyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:54:10 -0500
X-IronPort-AV: E=Sophos;i="4.60,473,1291611600"; 
   d="scan'208";a="135917945"
From: Ian Campbell <ian.campbell@citrix.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH] xen: suspend and resume system devices when running PVHVM
Date: Tue, 15 Feb 2011 09:54:05 +0000
Message-Id: <1297763645-23274-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 15 Feb 2011 09:54:08.0554 (UTC) FILETIME=[49FD28A0:01CBCCF6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we fail to properly suspend/resume all of the emulated devices.

Something between 2.6.38-rc2 and rc3 appears to have exposed this
issue, but it's always been wrong not to do this.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/xen/manage.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index db8c4c4..2417727 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -37,11 +37,19 @@ static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
 #ifdef CONFIG_PM_SLEEP
 static int xen_hvm_suspend(void *data)
 {
+	int err;
 	struct sched_shutdown r = { .reason = SHUTDOWN_suspend };
 	int *cancelled = data;
 
 	BUG_ON(!irqs_disabled());
 
+	err = sysdev_suspend(PMSG_SUSPEND);
+	if (err) {
+		printk(KERN_ERR "xen_hvm_suspend: sysdev_suspend failed: %d\n",
+		       err);
+		return err;
+	}
+
 	*cancelled = HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
 
 	xen_hvm_post_suspend(*cancelled);
@@ -53,6 +61,8 @@ static int xen_hvm_suspend(void *data)
 		xen_timer_resume();
 	}
 
+	sysdev_resume();
+
 	return 0;
 }
 
-- 
1.5.6.5

