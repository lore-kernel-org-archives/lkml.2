Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab2DSSNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:13:09 -0400
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:54428 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754475Ab2DSSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:13:08 -0400
From: Roland Dreier <roland@kernel.org>
To: Joerg Roedel <joerg.roedel@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dma-debug: Fix deadlock with netconsole or other drivers that use the DMA API
Date: Thu, 19 Apr 2012 11:12:53 -0700
Message-Id: <1334859173-9446-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

If we exhaust the free_entries list, then we print the error message

    DMA-API: debugging out of memory - disabling

to the kernel log, while holding free_entries_lock.  Unfortunately, if
the console driver ends up calling back into the DMA API to map a
buffer, as eg a NIC driver is quite likely to for the packet netconsole
asks it to send, this will deadlock on free_entries_lock.

A fix is pretty simple: if we flip the order of setting global_disable
to be before we print the error message, then the nested call into the
DMA API will bail out before trying to get free_entries_lock.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 lib/dma-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 13ef233..f198b4e 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -436,8 +436,8 @@ static struct dma_debug_entry *dma_entry_alloc(void)
 	spin_lock_irqsave(&free_entries_lock, flags);
 
 	if (list_empty(&free_entries)) {
-		pr_err("DMA-API: debugging out of memory - disabling\n");
 		global_disable = true;
+		pr_err("DMA-API: debugging out of memory - disabling\n");
 		goto out;
 	}
 
-- 
1.7.9.5

