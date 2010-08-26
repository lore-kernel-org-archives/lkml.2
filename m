Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0HZSvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:51:54 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:4744 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab0HZStg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:49:36 -0400
Subject: [PATCH 03/13] cciss: factor out cciss_setintinfo
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:55:44 -0500
Message-ID: <20100826185544.9067.28636.stgit@beardog.cce.hp.com>
In-Reply-To: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
References: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   66 ++++++++++++++++++++++++-------------------------
 1 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 14380c4..5ff5a1d 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1262,6 +1262,37 @@ static int cciss_getintinfo(ctlr_info_t *h, void __user *argp)
 	return 0;
 }
 
+static int cciss_setintinfo(ctlr_info_t *h, void __user *argp)
+{
+	cciss_coalint_struct intinfo;
+	unsigned long flags;
+	int i;
+
+	if (!argp)
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (copy_from_user(&intinfo, argp, sizeof(intinfo)))
+		return -EFAULT;
+	if ((intinfo.delay == 0) && (intinfo.count == 0))
+		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
+	/* Update the field, and then ring the doorbell */
+	writel(intinfo.delay, &(h->cfgtable->HostWrite.CoalIntDelay));
+	writel(intinfo.count, &(h->cfgtable->HostWrite.CoalIntCount));
+	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
+
+	for (i = 0; i < MAX_IOCTL_CONFIG_WAIT; i++) {
+		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
+			break;
+		udelay(1000); /* delay and try again */
+	}
+	spin_unlock_irqrestore(&h->lock, flags);
+	if (i >= MAX_IOCTL_CONFIG_WAIT)
+		return -EAGAIN;
+	return 0;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg)
 {
@@ -1278,40 +1309,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_GETINTINFO:
 		return cciss_getintinfo(h, argp);
 	case CCISS_SETINTINFO:
-		{
-			cciss_coalint_struct intinfo;
-			unsigned long flags;
-			int i;
-
-			if (!arg)
-				return -EINVAL;
-			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
-			if (copy_from_user
-			    (&intinfo, argp, sizeof(cciss_coalint_struct)))
-				return -EFAULT;
-			if ((intinfo.delay == 0) && (intinfo.count == 0))
-				return -EINVAL;
-			spin_lock_irqsave(&h->lock, flags);
-			/* Update the field, and then ring the doorbell */
-			writel(intinfo.delay,
-			       &(h->cfgtable->HostWrite.CoalIntDelay));
-			writel(intinfo.count,
-			       &(h->cfgtable->HostWrite.CoalIntCount));
-			writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
-
-			for (i = 0; i < MAX_IOCTL_CONFIG_WAIT; i++) {
-				if (!(readl(h->vaddr + SA5_DOORBELL)
-				      & CFGTBL_ChangeReq))
-					break;
-				/* delay and try again */
-				udelay(1000);
-			}
-			spin_unlock_irqrestore(&h->lock, flags);
-			if (i >= MAX_IOCTL_CONFIG_WAIT)
-				return -EAGAIN;
-			return 0;
-		}
+		return cciss_setintinfo(h, argp);
 	case CCISS_GETNODENAME:
 		{
 			NodeName_type NodeName;

