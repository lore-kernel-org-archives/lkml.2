Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2GWGvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:51:02 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:21460
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616Ab2GWGu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:50:57 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7LPOS-01-5MN-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lin Ming <minggr@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH 2/5] scsi: sr: runtime pm when ODD is open/closed
Date: Mon, 23 Jul 2012 14:49:37 +0800
Message-ID: <1343026180-22236-3-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
References: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
X-OriginalArrivalTime: 23 Jul 2012 06:50:38.0295 (UTC) FILETIME=[77D1F670:01CD689F]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ODD can either be runtime resumed by the user or by a software
request. And for the latter part, we only support runtime resume the ODD
when the eject request is received. We did this in sr's block ioctl
function, this looks ugly.

Change this by runtime resuming the ODD in its open function and runtime
suspending it in its release function.

The downside of this approach is that in old distros with old udisk
daemon, the ODD will be polled by udisk daemon so open/close will
constantly be called, which will cause the ODD frequently resume from
suspend state, breaking the effect of power saving. User with such a
distro is advised to issue a udisk command to inhibit polling of the
disk like this:
$ udisks --inhibit-polling /dev/sr0
And since newer kernel has in kernel polling, there is no problem
regarding ODD's event report.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/sr.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5f4d19a..f7a7635 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -152,8 +152,15 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 	kref_get(&cd->kref);
 	if (scsi_device_get(cd->device))
 		goto out_put;
+	if (pm_runtime_get_sync(&cd->device->sdev_gendev) < 0) {
+		pm_runtime_put_noidle(&cd->device->sdev_gendev);
+		goto out_pm;
+	}
 	goto out;
 
+ out_pm:
+	scsi_device_put(cd->device);
+
  out_put:
 	kref_put(&cd->kref, sr_kref_release);
 	cd = NULL;
@@ -169,6 +176,8 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	scsi_device_put(sdev);
+	pm_runtime_mark_last_busy(&cd->device->sdev_gendev);
+	pm_runtime_put_autosuspend(&cd->device->sdev_gendev);
 	mutex_unlock(&sr_ref_mutex);
 }
 
@@ -654,13 +663,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	/* Make sure the ODD is not suspended */
-	ret = pm_runtime_get_sync(&sdev->sdev_gendev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(&sdev->sdev_gendev);
-		return -EACCES;
-	}
-
 	mutex_lock(&sr_mutex);
 
 	/*
@@ -692,8 +694,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 out:
 	mutex_unlock(&sr_mutex);
-	pm_runtime_mark_last_busy(&cd->device->sdev_gendev);
-	pm_runtime_put_autosuspend(&cd->device->sdev_gendev);
 	return ret;
 }
 
-- 
1.7.11.3


