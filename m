Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1HHJBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:01:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1HHJBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:01:08 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Clements <Paul.Clements@steeleye.com>,
        WANG Cong <amwang@redhat.com>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] nbd: some trivial improvements
Date: Mon,  8 Aug 2011 17:00:04 +0800
Message-Id: <1312794004-22047-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch 1) uses task_pid_nr(current) to get the pid of current process,
 2) replaces sysfs_create_file() with device_create_file(), 3) lower
the loglevel of an error message.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index f533f33..07cad4b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -405,10 +405,10 @@ static int nbd_do_it(struct nbd_device *lo)
 
 	BUG_ON(lo->magic != LO_MAGIC);
 
-	lo->pid = current->pid;
-	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	lo->pid = task_pid_nr(current);
+	ret = device_create_file(disk_to_dev(lo->disk), &pid_attr);
 	if (ret) {
-		printk(KERN_ERR "nbd: sysfs_create_file failed!");
+		printk(KERN_ERR "nbd: device_create_file failed!");
 		lo->pid = 0;
 		return ret;
 	}
@@ -416,7 +416,7 @@ static int nbd_do_it(struct nbd_device *lo)
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
 
-	sysfs_remove_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	device_remove_file(disk_to_dev(lo->disk), &pid_attr);
 	lo->pid = 0;
 	return 0;
 }
@@ -745,7 +745,7 @@ static int __init nbd_init(void)
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
 	if (max_part < 0) {
-		printk(KERN_CRIT "nbd: max_part must be >= 0\n");
+		printk(KERN_ERR "nbd: max_part must be >= 0\n");
 		return -EINVAL;
 	}
 
