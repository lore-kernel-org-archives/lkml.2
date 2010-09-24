Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab0IXQf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:56 -0400
Received: from kroah.org ([198.145.64.141]:37411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab0IXQfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:48 2010
Message-Id: <20100924163348.831563275@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [54/68] [S390] dasd: use correct label location for diag fba disks
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

commit cffab6bc5511cd6f67a60bf16b62de4267b68c4c upstream.

Partition boundary calculation fails for DASD FBA disks under the
following conditions:
- disk is formatted with CMS FORMAT with a blocksize of more than
  512 bytes
- all of the disk is reserved to a single CMS file using CMS RESERVE
- the disk is accessed using the DIAG mode of the DASD driver

Under these circumstances, the partition detection code tries to
read the CMS label block containing partition-relevant information
from logical block offset 1, while it is in fact located at physical
block offset 1.

Fix this problem by using the correct CMS label block location
depending on the device type as determined by the DASD SENSE ID
information.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[bwh: Adjust for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/ibm.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -74,6 +74,7 @@ ibm_partition(struct parsed_partitions *
 	} *label;
 	unsigned char *data;
 	Sector sect;
+	sector_t labelsect;
 
 	res = 0;
 	blocksize = bdev_logical_block_size(bdev);
@@ -98,9 +99,19 @@ ibm_partition(struct parsed_partitions *
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
-	data = read_dev_sector(bdev, info->label_block*(blocksize/512), &sect);
+	data = read_dev_sector(bdev, labelsect, &sect);
 	if (data == NULL)
 		goto out_readerr;
 


