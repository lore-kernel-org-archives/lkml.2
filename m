Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1IWJlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 05:41:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1IWJlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 05:41:18 -0400
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: [PATCH] md: don't delay reboot by 1 second if no MD devices exist
Date: Fri, 23 Sep 2011 10:40:45 +0100
Message-Id: <1316770845-18171-1-git-send-email-berrange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Daniel P. Berrange" <berrange@redhat.com>

The md_notify_reboot() method includes a call to mdelay(1000),
to deal with "exotic SCSI devices" which are too volatile on
reboot. The delay is unconditional. Even if the machine does
not have any block devices, let alone MD devices, the kernel
shutdown sequence is slowed down.

1 second does not matter much with physical hardware, but with
certain virtualization use cases any wasted time in the bootup
& shutdown sequence counts for alot.

* drivers/md/md.c: md_notify_reboot() - only impose a delay if
  there was at least one MD device to be stopped during reboot

Signed-off-by: Daniel P. Berrange <berrange@redhat.com>
---
 drivers/md/md.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5404b22..ef7ad8d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8059,12 +8059,13 @@ static int md_notify_reboot(struct notifier_block *this,
 {
 	struct list_head *tmp;
 	mddev_t *mddev;
+	int need_delay = 0;
 
 	if ((code == SYS_DOWN) || (code == SYS_HALT) || (code == SYS_POWER_OFF)) {
 
 		printk(KERN_INFO "md: stopping all md devices.\n");
 
-		for_each_mddev(mddev, tmp)
+		for_each_mddev(mddev, tmp) {
 			if (mddev_trylock(mddev)) {
 				/* Force a switch to readonly even array
 				 * appears to still be in use.  Hence
@@ -8073,13 +8074,16 @@ static int md_notify_reboot(struct notifier_block *this,
 				md_set_readonly(mddev, 100);
 				mddev_unlock(mddev);
 			}
+			need_delay = 1;
+		}
 		/*
 		 * certain more exotic SCSI devices are known to be
 		 * volatile wrt too early system reboots. While the
 		 * right place to handle this issue is the given
 		 * driver, we do want to have a safe RAID driver ...
 		 */
-		mdelay(1000*1);
+		if (need_delay)
+			mdelay(1000*1);
 	}
 	return NOTIFY_DONE;
 }
-- 
1.7.6.2

