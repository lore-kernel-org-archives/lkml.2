Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2FRPWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:22:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34930 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2FRPWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:22:06 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv3 2/4] remoteproc: Add function rproc_get_boot_addr
Date: Mon, 18 Jun 2012 17:21:53 +0200
Message-Id: <1340032915-10734-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340032915-10734-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1340032915-10734-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Prepare for introduction of custom firmware loaders by
moving the function operating on ELF data-structures into
separate functions. Move lookup of the boot_addr in the
ELF binary to the function rproc_get_boot_addr().

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index c8b428d..648ff88 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1003,6 +1003,20 @@ static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
 	return 0;
 }
 
+/**
+ * rproc_get_boot_addr() - Get rproc's boot address.
+ * @fw: the ELF firmware image
+ *
+ * This function reads the ELF entry point address.
+ * Note that the boot address is not a configurable property of all remote
+ * processors. Some will always boot at a specific hard-coded address.
+ */
+u32 rproc_get_boot_addr(struct rproc *rproc, const struct firmware *fw)
+{
+	struct elf32_hdr *ehdr  = (struct elf32_hdr *)fw->data;
+	return ehdr->e_entry;
+}
+
 /*
  * take a firmware and boot a remote processor with it.
  */
@@ -1010,7 +1024,6 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 {
 	struct device *dev = rproc->dev;
 	const char *name = rproc->firmware;
-	struct elf32_hdr *ehdr;
 	struct resource_table *table;
 	int ret, tablesz;
 
@@ -1018,8 +1031,6 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	if (ret)
 		return ret;
 
-	ehdr = (struct elf32_hdr *)fw->data;
-
 	dev_info(dev, "Booting fw image %s, size %d\n", name, fw->size);
 
 	/*
@@ -1032,12 +1043,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		return ret;
 	}
 
-	/*
-	 * The ELF entry point is the rproc's boot addr (though this is not
-	 * a configurable property of all remote processors: some will always
-	 * boot at a specific hardcoded address).
-	 */
-	rproc->bootaddr = ehdr->e_entry;
+	rproc->bootaddr = rproc_get_boot_addr(rproc, fw);
 
 	/* look for the resource table */
 	table = rproc_find_rsc_table(rproc, fw, &tablesz);
-- 
1.7.5.4

