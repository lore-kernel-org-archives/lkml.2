Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab2KIAUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:20:04 -0500
Received: from dupo.coraid.com ([208.71.232.133]:46377 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753755Ab2KIAUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:20:02 -0500
Message-Id: <fe2ec651bfe9d006a81e75c6205a82a4d0e7dda7.1352410985.git.ecashin@coraid.com>
In-Reply-To: <cover.1352410985.git.ecashin@coraid.com>
References: <cover.1352410985.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 2/8] aoe: provide ATA identify device content to user on request
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 8 Nov 2012 19:19:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the aoe driver follow expected behavior when the
user uses ioctl to get the ATA device identify information,
allowing access to model, serial number, etc.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    1 +
 drivers/block/aoe/aoeblk.c |   30 ++++++++++++++++++++++++++++++
 drivers/block/aoe/aoecmd.c |   16 ++++++++++++++++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 536942b..f6e0c03 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -169,6 +169,7 @@ struct aoedev {
 	struct aoetgt *htgt;	/* target needing rexmit assistance */
 	ulong ntargets;
 	ulong kicked;
+	char ident[512];
 };
 
 /* kthread tracking */
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 56736cd..7ba0fcf 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -17,6 +17,7 @@
 #include <linux/mutex.h>
 #include <linux/export.h>
 #include <linux/moduleparam.h>
+#include <scsi/sg.h>
 #include "aoe.h"
 
 static DEFINE_MUTEX(aoeblk_mutex);
@@ -212,9 +213,38 @@ aoeblk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
+static int
+aoeblk_ioctl(struct block_device *bdev, fmode_t mode, uint cmd, ulong arg)
+{
+	struct aoedev *d;
+
+	if (!arg)
+		return -EINVAL;
+
+	d = bdev->bd_disk->private_data;
+	if ((d->flags & DEVFL_UP) == 0) {
+		pr_err("aoe: disk not up\n");
+		return -ENODEV;
+	}
+
+	if (cmd == HDIO_GET_IDENTITY) {
+		if (!copy_to_user((void __user *) arg, &d->ident,
+			sizeof(d->ident)))
+			return 0;
+		return -EFAULT;
+	}
+
+	/* udev calls scsi_id, which uses SG_IO, resulting in noise */
+	if (cmd != SG_IO)
+		pr_info("aoe: unknown ioctl 0x%x\n", cmd);
+
+	return -ENOTTY;
+}
+
 static const struct block_device_operations aoe_bdops = {
 	.open = aoeblk_open,
 	.release = aoeblk_release,
+	.ioctl = aoeblk_ioctl,
 	.getgeo = aoeblk_getgeo,
 	.owner = THIS_MODULE,
 };
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 3ce01f6..c4ff70b 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -799,6 +799,17 @@ aoecmd_sleepwork(struct work_struct *work)
 }
 
 static void
+ata_ident_fixstring(u16 *id, int ns)
+{
+	u16 s;
+
+	while (ns-- > 0) {
+		s = *id;
+		*id++ = s >> 8 | s << 8;
+	}
+}
+
+static void
 ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 {
 	u64 ssize;
@@ -833,6 +844,11 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 		d->geo.sectors = get_unaligned_le16(&id[56 << 1]);
 	}
 
+	ata_ident_fixstring((u16 *) &id[10<<1], 10);	/* serial */
+	ata_ident_fixstring((u16 *) &id[23<<1], 4);	/* firmware */
+	ata_ident_fixstring((u16 *) &id[27<<1], 20);	/* model */
+	memcpy(d->ident, id, sizeof(d->ident));
+
 	if (d->ssize != ssize)
 		printk(KERN_INFO
 			"aoe: %pm e%ld.%d v%04x has %llu sectors\n",
-- 
1.7.1

