Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0C2SJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:09:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51314 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0C2SJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:09:31 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: mingo@elte.hu, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, James.Bottomley@suse.de, matthew@wil.cx
Subject: [PATCH] dma-mapping: Remove WARN_ON in dma_free_coherent
Date: Mon, 29 Mar 2010 20:09:21 +0200
Message-Id: <1269886161-2616-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.6.3.3
To: mingo@elte.hu
To: hpa@zytor.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/ubuntu/bugs/458201

Triggered by the following backtrace I was looking at the sym53c8xx_2
driver and in there whether it would be possible to avoid the WARN_ON.

WARNING: at
/build/buildd/linux-2.6.32/arch/x86/include/asm/dma-mapping.h:154
___free_dma_mem_cluster+0x102/0x110()

 [<ffffffff81064f9b>] warn_slowpath_common+0x7b/0xc0
 [<ffffffff81064ff4>] warn_slowpath_null+0x14/0x20
 [<ffffffff8139a2a2>] ___free_dma_mem_cluster+0x102/0x110
 [<ffffffff8139a072>] __sym_mfree+0xd2/0x100
 [<ffffffff8139a109>] __sym_mfree_dma+0x69/0x100
 [<ffffffff8139245f>] sym_hcb_free+0x8f/0x1f0

But it seems modifying that driver would be a bigger effort and maybe
not really worthwile as it is a rather old driver. On the other side
I was told [1] that this WARN_ON applies only to ARM which could sleep
in the free path and it is just bogus for X86. As the code is in
arch/x86 it would never be used for anything else than X86 and if
its truely bogus on X86, couldn't it get removed?

[1] http://kerneltrap.org/mailarchive/linux-scsi/2010/3/25/6886023

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 arch/x86/include/asm/dma-mapping.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 6a25d5d..2d6097f 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -151,8 +151,6 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
-	WARN_ON(irqs_disabled());       /* for portability */
-
 	if (dma_release_from_coherent(dev, get_order(size), vaddr))
 		return;
 
-- 
1.6.3.3

