Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab2EUXOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:14:40 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:59674 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759493Ab2EUXOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:14:38 -0400
Message-ID: <4FBACC57.6080503@suse.com>
Date: Mon, 21 May 2012 16:14:31 -0700
From: Lee Duncan <lduncan@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kai.makisara@kolumbus.fi, jeffm@suse.com
Subject: [PATCH v3 2/5] st: clean up dev cleanup in st_probe
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

st_probe leaves a cdev pointer hanging around that is compared
during the error path and freed later. There's no need for the pointer
to hang around at all. So we free it immediately and simplify the error
handling.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/st.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 662f9a0..f437b7f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4156,6 +4156,7 @@ static int st_probe(struct device *dev)
 				printk(KERN_ERR
 				       "st%d: out of memory. Device not attached.\n",
 				       dev_num);
+				cdev_del(cdev);
 				goto out_free_tape;
 			}
 			cdev->owner = THIS_MODULE;
@@ -4194,17 +4195,13 @@ out_free_tape:
 				  "tape");
 		for (j=0; j < 2; j++) {
 			if (STm->cdevs[j]) {
-				if (cdev == STm->cdevs[j])
-					cdev = NULL;
-					device_destroy(&st_sysfs_class,
-						       MKDEV(SCSI_TAPE_MAJOR,
-							     TAPE_MINOR(i, mode, j)));
+				device_destroy(&st_sysfs_class,
+					       MKDEV(SCSI_TAPE_MAJOR,
+						     TAPE_MINOR(i, mode, j)));
 				cdev_del(STm->cdevs[j]);
 			}
 		}
 	}
-	if (cdev)
-		cdev_del(cdev);
 	write_lock(&st_dev_arr_lock);
 	scsi_tapes[dev_num] = NULL;
 	st_nr_dev--;
-- 
1.7.9.2

