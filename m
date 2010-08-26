Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0HZSto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:49:44 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:38595 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab0HZStm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:49:42 -0400
Subject: [PATCH 04/13] cciss: factor out cciss_getnodename
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:55:49 -0500
Message-ID: <20100826185549.9067.9757.stgit@beardog.cce.hp.com>
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
 drivers/block/cciss.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5ff5a1d..77db6ea 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1293,6 +1293,20 @@ static int cciss_setintinfo(ctlr_info_t *h, void __user *argp)
 	return 0;
 }
 
+static int cciss_getnodename(ctlr_info_t *h, void __user *argp)
+{
+	NodeName_type NodeName;
+	int i;
+
+	if (!argp)
+		return -EINVAL;
+	for (i = 0; i < 16; i++)
+		NodeName[i] = readb(&h->cfgtable->ServerName[i]);
+	if (copy_to_user(argp, NodeName, sizeof(NodeName_type)))
+		return -EFAULT;
+	return 0;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg)
 {
@@ -1311,19 +1325,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_SETINTINFO:
 		return cciss_setintinfo(h, argp);
 	case CCISS_GETNODENAME:
-		{
-			NodeName_type NodeName;
-			int i;
-
-			if (!arg)
-				return -EINVAL;
-			for (i = 0; i < 16; i++)
-				NodeName[i] =
-				    readb(&h->cfgtable->ServerName[i]);
-			if (copy_to_user(argp, NodeName, sizeof(NodeName_type)))
-				return -EFAULT;
-			return 0;
-		}
+		return cciss_getnodename(h, argp);
 	case CCISS_SETNODENAME:
 		{
 			NodeName_type NodeName;

