Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0HZStw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:49:52 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:38628 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab0HZStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:49:47 -0400
Subject: [PATCH 05/13] cciss: factor out cciss_setnodename
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:55:54 -0500
Message-ID: <20100826185554.9067.1990.stgit@beardog.cce.hp.com>
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
 drivers/block/cciss.c |   65 ++++++++++++++++++++++---------------------------
 1 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 77db6ea..90c1906 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1307,6 +1307,34 @@ static int cciss_getnodename(ctlr_info_t *h, void __user *argp)
 	return 0;
 }
 
+static int cciss_setnodename(ctlr_info_t *h, void __user *argp)
+{
+	NodeName_type NodeName;
+	unsigned long flags;
+	int i;
+
+	if (!argp)
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (copy_from_user(NodeName, argp, sizeof(NodeName_type)))
+		return -EFAULT;
+	spin_lock_irqsave(&h->lock, flags);
+	/* Update the field, and then ring the doorbell */
+	for (i = 0; i < 16; i++)
+		writeb(NodeName[i], &h->cfgtable->ServerName[i]);
+	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
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
@@ -1327,42 +1355,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_GETNODENAME:
 		return cciss_getnodename(h, argp);
 	case CCISS_SETNODENAME:
-		{
-			NodeName_type NodeName;
-			unsigned long flags;
-			int i;
-
-			if (!arg)
-				return -EINVAL;
-			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
-
-			if (copy_from_user
-			    (NodeName, argp, sizeof(NodeName_type)))
-				return -EFAULT;
-
-			spin_lock_irqsave(&h->lock, flags);
-
-			/* Update the field, and then ring the doorbell */
-			for (i = 0; i < 16; i++)
-				writeb(NodeName[i],
-				       &h->cfgtable->ServerName[i]);
-
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
-
+		return cciss_setnodename(h, argp);
 	case CCISS_GETHEARTBEAT:
 		{
 			Heartbeat_type heartbeat;

