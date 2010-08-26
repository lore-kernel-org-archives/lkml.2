Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0HZSth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:49:37 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:16374 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0HZStb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:49:31 -0400
Subject: [PATCH 02/13] cciss: factor out cciss_getintinfo
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:55:39 -0500
Message-ID: <20100826185539.9067.78602.stgit@beardog.cce.hp.com>
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
index c1eca37..14380c4 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1248,6 +1248,20 @@ static int cciss_getpciinfo(ctlr_info_t *h, void __user *argp)
 	return 0;
 }
 
+static int cciss_getintinfo(ctlr_info_t *h, void __user *argp)
+{
+	cciss_coalint_struct intinfo;
+
+	if (!argp)
+		return -EINVAL;
+	intinfo.delay = readl(&h->cfgtable->HostWrite.CoalIntDelay);
+	intinfo.count = readl(&h->cfgtable->HostWrite.CoalIntCount);
+	if (copy_to_user
+	    (argp, &intinfo, sizeof(cciss_coalint_struct)))
+		return -EFAULT;
+	return 0;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg)
 {
@@ -1262,19 +1276,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_GETPCIINFO:
 		return cciss_getpciinfo(h, argp);
 	case CCISS_GETINTINFO:
-		{
-			cciss_coalint_struct intinfo;
-			if (!arg)
-				return -EINVAL;
-			intinfo.delay =
-			    readl(&h->cfgtable->HostWrite.CoalIntDelay);
-			intinfo.count =
-			    readl(&h->cfgtable->HostWrite.CoalIntCount);
-			if (copy_to_user
-			    (argp, &intinfo, sizeof(cciss_coalint_struct)))
-				return -EFAULT;
-			return 0;
-		}
+		return cciss_getintinfo(h, argp);
 	case CCISS_SETINTINFO:
 		{
 			cciss_coalint_struct intinfo;

