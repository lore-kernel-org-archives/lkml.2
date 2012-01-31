Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab2AaQx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:53:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33372 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2AaQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:53:25 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Mark Grosen <mgrosen@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 1/2] remoteproc: bail out if firmware has different endianess
Date: Tue, 31 Jan 2012 18:52:41 +0200
Message-Id: <1328028762-28352-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point we don't support remote processors that have
a different endianess than the host.

Look out for these unsupported scenarios, and bail out if
encountered.

Reported-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Mark Grosen <mgrosen@ti.com>
---
 drivers/remoteproc/remoteproc_core.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 6212b82..567a3c5 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -39,6 +39,7 @@
 #include <linux/elf.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_ring.h>
+#include <asm/byteorder.h>
 
 #include "remoteproc_internal.h"
 
@@ -851,6 +852,16 @@ static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
 
 	ehdr = (struct elf32_hdr *)fw->data;
 
+	/* We assume the firmware has the same endianess as the host */
+# ifdef __LITTLE_ENDIAN
+	if (ehdr->e_ident[EI_DATA] != ELFDATA2LSB) {
+# else /* BIG ENDIAN */
+	if (ehdr->e_ident[EI_DATA] != ELFDATA2MSB) {
+# endif
+		dev_err(dev, "Unsupported firmware endianess\n");
+		return -EINVAL;
+	}
+
 	if (fw->size < ehdr->e_shoff + sizeof(struct elf32_shdr)) {
 		dev_err(dev, "Image is too small\n");
 		return -EINVAL;
-- 
1.7.5.4

