Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2FQM7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 08:59:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40923 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab2FQM7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 08:59:45 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.103.112]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 17 Jun 2012 15:59:24 +0300
Message-ID: <CAK=WgbZ20XZKauhn98ncMYupCrLv_mGo-bhPV7L93NLpWGrC=w@mail.gmail.com>
Subject: [GIT PULL] remoteproc fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:

  Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
tags/rproc-fixes-for-3.5

for you to fetch changes up to 6b03976288538a94e072bbfcd12d69a20daea8aa:

  remoteproc/omap: fix dev_err typo (2012-06-17 10:31:03 +0300)

----------------------------------------------------------------
A few relatively-small remoteproc fixes for 3.5: two error path fixes,
and one -Wformat warning fix.

----------------------------------------------------------------
Ohad Ben-Cohen (1):
      remoteproc/omap: fix dev_err typo

Sjur Brændeland (2):
      remoteproc: fix print format warnings
      remoteproc: fix missing fault indication in error-path

 drivers/remoteproc/omap_remoteproc.c |  2 +-
 drivers/remoteproc/remoteproc_core.c | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/remoteproc/omap_remoteproc.c
b/drivers/remoteproc/omap_remoteproc.c
index 69425c4..de138e30 100644
--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -182,7 +182,7 @@ static int __devinit omap_rproc_probe(struct
platform_device *pdev)

 	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret) {
-		dev_err(pdev->dev.parent, "dma_set_coherent_mask: %d\n", ret);
+		dev_err(&pdev->dev, "dma_set_coherent_mask: %d\n", ret);
 		return ret;
 	}

diff --git a/drivers/remoteproc/remoteproc_core.c
b/drivers/remoteproc/remoteproc_core.c
index 8ea7bcc..66324ee 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -247,7 +247,7 @@ rproc_load_segments(struct rproc *rproc, const u8
*elf_data, size_t len)
 		}

 		if (offset + filesz > len) {
-			dev_err(dev, "truncated fw: need 0x%x avail 0x%x\n",
+			dev_err(dev, "truncated fw: need 0x%x avail 0x%zx\n",
 					offset + filesz, len);
 			ret = -EINVAL;
 			break;
@@ -934,7 +934,7 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 		unmapped = iommu_unmap(rproc->domain, entry->da, entry->len);
 		if (unmapped != entry->len) {
 			/* nothing much to do besides complaining */
-			dev_err(dev, "failed to unmap %u/%u\n", entry->len,
+			dev_err(dev, "failed to unmap %u/%zu\n", entry->len,
 								unmapped);
 		}

@@ -1020,7 +1020,7 @@ static int rproc_fw_boot(struct rproc *rproc,
const struct firmware *fw)

 	ehdr = (struct elf32_hdr *)fw->data;

-	dev_info(dev, "Booting fw image %s, size %d\n", name, fw->size);
+	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);

 	/*
 	 * if enabling an IOMMU isn't relevant for this rproc, this is
@@ -1041,8 +1041,10 @@ static int rproc_fw_boot(struct rproc *rproc,
const struct firmware *fw)

 	/* look for the resource table */
 	table = rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
-	if (!table)
+	if (!table) {
+		ret = -EINVAL;
 		goto clean_up;
+	}

 	/* handle fw resources which are required to boot rproc */
 	ret = rproc_handle_boot_rsc(rproc, table, tablesz);
