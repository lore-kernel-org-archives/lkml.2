Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965868Ab2B1RVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:21:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42852 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965832Ab2B1RVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:21:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.180.8.164 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, Mark Grosen <mgrosen@ti.com>,
        Suman Anna <s-anna@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>, Rob Clark <rob@ti.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: [PATCH 1/5] remoteproc: make sure we're parsing a 32bit firmware
Date: Tue, 28 Feb 2012 19:21:08 +0200
Message-Id: <1330449672-18191-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330449672-18191-1-git-send-email-ohad@wizery.com>
References: <1330449672-18191-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we're parsing a 32bit image, since we only support
the ELF32 binary format at this point.

This should prevent unexpected behavior with non 32bit binaries.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: Suman Anna <s-anna@ti.com>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: Rob Clark <rob@ti.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
---
 drivers/remoteproc/remoteproc_core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 729911b..8990c51 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -840,6 +840,7 @@ static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
 	const char *name = rproc->firmware;
 	struct device *dev = rproc->dev;
 	struct elf32_hdr *ehdr;
+	char class;
 
 	if (!fw) {
 		dev_err(dev, "failed to load %s\n", name);
@@ -853,6 +854,13 @@ static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
 
 	ehdr = (struct elf32_hdr *)fw->data;
 
+	/* We only support ELF32 at this point */
+	class = ehdr->e_ident[EI_CLASS];
+	if (class != ELFCLASS32) {
+		dev_err(dev, "Unsupported class: %d\n", class);
+		return -EINVAL;
+	}
+
 	/* We assume the firmware has the same endianess as the host */
 # ifdef __LITTLE_ENDIAN
 	if (ehdr->e_ident[EI_DATA] != ELFDATA2LSB) {
-- 
1.7.5.4

