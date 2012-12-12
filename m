Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2LLBth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 20:49:37 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42030 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2LLBtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 20:49:36 -0500
X-Greylist: delayed 686 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 20:49:36 EST
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH] pstore/ram: Fix bounds checks for mem_size, record_size, console_size and ftrace_size
Date: Tue, 11 Dec 2012 17:49:24 -0800
Message-Id: <1355276964-2929-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bounds check in ramoops_init_prz was incorrect and ramoops_init_przs
had no check. Additionally, ramoops_init_przs allows record_size to be 0,
but ramoops_pstore_write_buf would always crash in this case.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 fs/pstore/ram.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1a4f6da..eb3dbff 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -189,7 +189,7 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 					    struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
-	struct persistent_ram_zone *prz = cxt->przs[cxt->dump_write_cnt];
+	struct persistent_ram_zone *prz;
 	size_t hlen;
 
 	if (type == PSTORE_TYPE_CONSOLE) {
@@ -226,6 +226,11 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 	if (part != 1)
 		return -ENOSPC;
 
+	if (!cxt->przs)
+		return -ENOSPC;
+
+	prz = cxt->przs[cxt->dump_write_cnt];
+
 	hlen = ramoops_write_kmsg_hdr(prz);
 	if (size + hlen > prz->buffer_size)
 		size = prz->buffer_size - hlen;
@@ -296,6 +301,11 @@ static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
 	if (!cxt->record_size)
 		return 0;
 
+	if (*paddr + dump_mem_sz - cxt->phys_addr > cxt->size) {
+		dev_err(dev, "no room for dumps\n");
+		return -ENOMEM;
+	}
+
 	cxt->max_dump_cnt = dump_mem_sz / cxt->record_size;
 	if (!cxt->max_dump_cnt)
 		return -ENOMEM;
@@ -333,8 +343,12 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 	if (!sz)
 		return 0;
 
-	if (*paddr + sz > *paddr + cxt->size)
+	if (*paddr + sz - cxt->phys_addr > cxt->size) {
+		dev_err(dev, "no room for mem region (0x%zx@0x%llx) in (0x%lx@0x%llx)\n",
+			sz, (unsigned long long)*paddr,
+			cxt->size, (unsigned long long)cxt->phys_addr);
 		return -ENOMEM;
+	}
 
 	*prz = persistent_ram_new(*paddr, sz, sig, cxt->ecc_size);
 	if (IS_ERR(*prz)) {
-- 
1.7.7.3

