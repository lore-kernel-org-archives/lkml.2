Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab2EVN2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:28:06 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33999 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103Ab2EVN1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:27:09 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 3/6] remoteproc: Move fw sanity check to find_rsc_table.
Date: Tue, 22 May 2012 15:26:54 +0200
Message-Id: <1337693217-15466-4-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Prepare for pluggable firmware handling by calling firmware
sanity check from function find_rsc_table.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 3d980ea..785d66b 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -43,6 +43,7 @@
 
 #include "remoteproc_internal.h"
 
+static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw);
 static void klist_rproc_get(struct klist_node *n);
 static void klist_rproc_put(struct klist_node *n);
 
@@ -848,6 +849,9 @@ rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 	int i;
 	const u8 *elf_data = fw->data;
 
+	if (rproc_fw_sanity_check(rproc, fw) < 0)
+		return NULL;
+
 	ehdr = (struct elf32_hdr *)elf_data;
 	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
 	name_table = elf_data + shdr[ehdr->e_shstrndx].sh_offset;
@@ -1021,10 +1025,6 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	struct resource_table *table;
 	int ret, tablesz;
 
-	ret = rproc_fw_sanity_check(rproc, fw);
-	if (ret)
-		return ret;
-
 	ehdr = (struct elf32_hdr *)fw->data;
 
 	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
@@ -1041,8 +1041,10 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 
 	/* look for the resource table */
 	table = rproc_find_rsc_table(rproc, fw, &tablesz);
-	if (!table)
+	if (!table) {
+		ret = -EINVAL;
 		goto clean_up;
+	}
 
 	/* handle fw resources which are required to boot rproc */
 	ret = rproc_handle_boot_rsc(rproc, table, tablesz);
@@ -1091,9 +1093,6 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 	struct resource_table *table;
 	int ret, tablesz;
 
-	if (rproc_fw_sanity_check(rproc, fw) < 0)
-		goto out;
-
 	/* look for the resource table */
 	table = rproc_find_rsc_table(rproc, fw,  &tablesz);
 	if (!table)
-- 
1.7.9.5

