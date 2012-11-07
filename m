Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2KGLnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:43:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab2KGLnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:43:00 -0500
From: Nikolay Aleksandrov <nikolay@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, JBottomley@parallels.com, nikolay@redhat.com
Subject: [PATCH] [SCSI] scsi_sysfs: fix a buffer overflow in sysfs handling
Date: Wed,  7 Nov 2012 11:57:46 +0100
Message-Id: <1352285866-16593-1-git-send-email-nikolay@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fix a stack buffer overflow in the SCSI layer sysfs handling code 
 (store_host_reset()). When a host reset type is read via sscanf in str
 there is no limit on the length and str is defined as char str[10].

How to reproduce:
 Given that the sysfs entry exists, execute
 echo "AAAAAAAAAAAAAAAA" > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/scsi_host/host0/host_reset

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ce5224c..51826e2 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -267,7 +267,7 @@ store_host_reset(struct device *dev, struct device_attribute *attr,
 	char str[10];
 	int type;
 
-	sscanf(buf, "%s", str);
+	sscanf(buf, "%9s", str);
 	type = check_reset_type(str);
 
 	if (!type)
-- 
1.7.11.4

