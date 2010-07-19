Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200Ab0GSIG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 04:06:27 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:37389 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182Ab0GSIGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 04:06:25 -0400
Date: Mon, 19 Jul 2010 10:06:21 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.35-rc5
Message-ID: <20100719100621.48d2e8cd@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following bug fixes:

Peter Oberparleiter (1):
      [S390] dasd: use correct label location for diag fba disks

Sebastian Ott (1):
      [S390] cio: fix potential overflow in chpid descriptor

Stefan Haberland (1):
      [S390] add missing device put

 drivers/s390/block/dasd_devmap.c |    4 +++-
 drivers/s390/cio/chsc.c          |    2 +-
 fs/partitions/ibm.c              |   14 ++++++++++++--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index 34d51dd..bed7b46 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -948,8 +948,10 @@ static ssize_t dasd_alias_show(struct device *dev,
 	if (device->discipline && device->discipline->get_uid &&
 	    !device->discipline->get_uid(device, &uid)) {
 		if (uid.type == UA_BASE_PAV_ALIAS ||
-		    uid.type == UA_HYPER_PAV_ALIAS)
+		    uid.type == UA_HYPER_PAV_ALIAS) {
+			dasd_put_device(device);
 			return sprintf(buf, "1\n");
+		}
 	}
 	dasd_put_device(device);
 
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index ce7cb87..407d0e9 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -713,7 +713,7 @@ int chsc_determine_base_channel_path_desc(struct chp_id chpid,
 	ret = chsc_determine_channel_path_desc(chpid, 0, 0, 0, 0, chsc_resp);
 	if (ret)
 		goto out_free;
-	memcpy(desc, &chsc_resp->data, chsc_resp->length);
+	memcpy(desc, &chsc_resp->data, sizeof(*desc));
 out_free:
 	kfree(chsc_resp);
 	return ret;
diff --git a/fs/partitions/ibm.c b/fs/partitions/ibm.c
index 3e73de5..fc84976 100644
--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -74,6 +74,7 @@ int ibm_partition(struct parsed_partitions *state)
 	} *label;
 	unsigned char *data;
 	Sector sect;
+	sector_t labelsect;
 
 	res = 0;
 	blocksize = bdev_logical_block_size(bdev);
@@ -98,10 +99,19 @@ int ibm_partition(struct parsed_partitions *state)
 		goto out_freeall;
 
 	/*
+	 * Special case for FBA disks: label sector does not depend on
+	 * blocksize.
+	 */
+	if ((info->cu_type == 0x6310 && info->dev_type == 0x9336) ||
+	    (info->cu_type == 0x3880 && info->dev_type == 0x3370))
+		labelsect = info->label_block;
+	else
+		labelsect = info->label_block * (blocksize >> 9);
+
+	/*
 	 * Get volume label, extract name and type.
 	 */
-	data = read_part_sector(state, info->label_block*(blocksize/512),
-				&sect);
+	data = read_part_sector(state, labelsect, &sect);
 	if (data == NULL)
 		goto out_readerr;
 
