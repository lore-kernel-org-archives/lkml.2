Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0HZStc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:49:32 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:4663 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab0HZSt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:49:26 -0400
Subject: [PATCH 01/13] cciss: factor out cciss_getpciinfo
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:55:34 -0500
Message-ID: <20100826185534.9067.84694.stgit@beardog.cce.hp.com>
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
 drivers/block/cciss.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index eef94fa..c1eca37 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1232,9 +1232,22 @@ static void check_ioctl_unit_attention(ctlr_info_t *h, CommandList_struct *c)
 			c->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION)
 		(void)check_for_unit_attention(h, c);
 }
-/*
- * ioctl
- */
+
+static int cciss_getpciinfo(ctlr_info_t *h, void __user *argp)
+{
+	cciss_pci_info_struct pciinfo;
+
+	if (!argp)
+		return -EINVAL;
+	pciinfo.domain = pci_domain_nr(h->pdev->bus);
+	pciinfo.bus = h->pdev->bus->number;
+	pciinfo.dev_fn = h->pdev->devfn;
+	pciinfo.board_id = h->board_id;
+	if (copy_to_user(argp, &pciinfo, sizeof(cciss_pci_info_struct)))
+		return -EFAULT;
+	return 0;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg)
 {
@@ -1247,20 +1260,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		cmd, arg);
 	switch (cmd) {
 	case CCISS_GETPCIINFO:
-		{
-			cciss_pci_info_struct pciinfo;
-
-			if (!arg)
-				return -EINVAL;
-			pciinfo.domain = pci_domain_nr(h->pdev->bus);
-			pciinfo.bus = h->pdev->bus->number;
-			pciinfo.dev_fn = h->pdev->devfn;
-			pciinfo.board_id = h->board_id;
-			if (copy_to_user
-			    (argp, &pciinfo, sizeof(cciss_pci_info_struct)))
-				return -EFAULT;
-			return 0;
-		}
+		return cciss_getpciinfo(h, argp);
 	case CCISS_GETINTINFO:
 		{
 			cciss_coalint_struct intinfo;

