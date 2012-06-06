Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2FFNit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:38:49 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41400 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428Ab2FFNik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:38:40 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 4/7] remoteproc: Assign boot_addr in a separate function
Date: Wed,  6 Jun 2012 15:38:24 +0200
Message-Id: <1338989907-25360-5-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Prepare for introduction of custom firmware loaders by
moving the function operating on ELF data-structures into
separate functions. The assignment of boot_addr is moved
to the function rproc_set_boot_addr().

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 07036e2..1dd7f53 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1003,6 +1003,22 @@ static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
 	return 0;
 }
 
+/**
+ * rproc_set_boot_addr() - Set rproc's boot address.
+ * @rproc: remote processor which needs boot address set.
+ * @fw: the  the ELF firmware image
+ *
+ * This function reads the ELF entry point address and assign this
+ * to the rproc's boot address.
+ * Note that the boot address is not a configurable property of all remote
+ * processors. Some will always boot at a specific hard-coded address.
+ */
+void rproc_set_boot_addr(struct rproc *rproc, const struct firmware *fw)
+{
+	struct elf32_hdr *ehdr  = (struct elf32_hdr *)fw->data;
+	rproc->bootaddr = ehdr->e_entry;
+}
+
 /*
  * take a firmware and boot a remote processor with it.
  */
@@ -1010,7 +1026,6 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 {
 	struct device *dev = rproc->dev;
 	const char *name = rproc->firmware;
-	struct elf32_hdr *ehdr;
 	struct resource_table *table;
 	int ret, tablesz;
 
@@ -1018,8 +1033,6 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	if (ret)
 		return ret;
 
-	ehdr = (struct elf32_hdr *)fw->data;
-
 	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
 
 	/*
@@ -1032,12 +1045,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		return ret;
 	}
 
-	/*
-	 * The ELF entry point is the rproc's boot addr (though this is not
-	 * a configurable property of all remote processors: some will always
-	 * boot at a specific hardcoded address).
-	 */
-	rproc->bootaddr = ehdr->e_entry;
+	rproc_set_boot_addr(rproc, fw);
 
 	/* look for the resource table */
 	table = rproc_find_rsc_table(rproc, fw, &tablesz);
-- 
1.7.5.4

