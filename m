Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2HHIyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:54:18 -0400
Received: from mail.ispras.ru ([83.149.199.43]:42197 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab2HHIyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:54:16 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Clemens Ladisch <clemens@ladisch.de>,
        David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] USB: whci-hcd: Fix potential memory leak in qset_add_urb_sg()
Date: Wed,  8 Aug 2012 12:53:07 +0400
Message-Id: <1344415987-17558-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not leak memory by updating pointer with potentially
NULL realloc return value.

By the way remove unused local variable:
	struct whc_page_list_entry *entry;
More precisely, it was used to increment uninitialized value within one of cycles.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/host/whci/qset.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/whci/qset.c b/drivers/usb/host/whci/qset.c
index 76083ae..dc31c42 100644
--- a/drivers/usb/host/whci/qset.c
+++ b/drivers/usb/host/whci/qset.c
@@ -436,7 +436,7 @@ static int qset_add_urb_sg(struct whc *whc, struct whc_qset *qset, struct urb *u
 	int i;
 	int ntds = 0;
 	struct whc_std *std = NULL;
-	struct whc_page_list_entry *entry;
+	struct whc_page_list_entry *new_pl_virt;
 	dma_addr_t prev_end = 0;
 	size_t pl_len;
 	int p = 0;
@@ -508,12 +508,15 @@ static int qset_add_urb_sg(struct whc *whc, struct whc_qset *qset, struct urb *u
 
 			pl_len = std->num_pointers * sizeof(struct whc_page_list_entry);
 
-			std->pl_virt = krealloc(std->pl_virt, pl_len, mem_flags);
-			if (std->pl_virt == NULL) {
+			new_pl_virt = krealloc(std->pl_virt, pl_len, mem_flags);
+			if (new_pl_virt == NULL) {
+				kfree(std->pl_virt);
+				std->pl_virt = NULL;
 				return -ENOMEM;
 			}
+			std->pl_virt = new_pl_virt;
 
-			for (;p < std->num_pointers; p++, entry++) {
+			for (;p < std->num_pointers; p++) {
 				std->pl_virt[p].buf_ptr = cpu_to_le64(dma_addr);
 				dma_addr = (dma_addr + WHCI_PAGE_SIZE) & ~(WHCI_PAGE_SIZE-1);
 			}
-- 
1.7.9.5

