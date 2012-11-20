Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2KTDFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:05:03 -0500
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:43764 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092Ab2KTDFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:05:01 -0500
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2012 22:05:01 EST
From: Josh Hunt <johunt@akamai.com>
To: jaxboe@fusionio.com
Cc: kay.sievers@vrfy.org, tj@kernel.org, linux-kernel@vger.kernel.org,
        Josh Hunt <johunt@akamai.com>
Subject: [PATCH] block: Restore /proc/partitions to not display non-partitionable removable devices
Date: Mon, 19 Nov 2012 18:56:49 -0800
Message-Id: <1353380209-23799-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found with newer kernels we started seeing the cdrom device showing
up in /proc/partitions, but it was not there before. Looking into this I found
that commit d27769ec... block: add GENHD_FL_NO_PART_SCAN introduces this change
in behavior. It's not clear to me from the commit's changelog if this change was
intentional or not. This comment still remains:
/* Don't show non-partitionable removeable devices or empty devices */
so I've decided to send a patch to restore the behavior of not printing
unpartitionable removable devices.

Thanks
Josh
---

After commit d27769ec... block: add GENHD_FL_NO_PART_SCAN, /proc/partitions
started printing removable devices with only one partition. This is different
than prior to the commit. This restores /proc/partitions to behave as it did before.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 block/genhd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 6cace66..6bfeb2a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -851,7 +851,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	char buf[BDEVNAME_SIZE];
 
 	/* Don't show non-partitionable removeable devices or empty devices */
-	if (!get_capacity(sgp) || (!disk_max_parts(sgp) &&
+	if (!get_capacity(sgp) || (!(disk_max_parts(sgp) > 1) &&
 				   (sgp->flags & GENHD_FL_REMOVABLE)))
 		return 0;
 	if (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
-- 
1.7.0.4

