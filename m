Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0LFX1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:27:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27219 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab0LFXZZ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 06/23] agp/ali: Use the dma_addr instead of page_to_phys for m1541_[alloc|destroy]_page.
Date: Mon,  6 Dec 2010 18:24:18 -0500
Message-Id: <1291677875-30493-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_addr contains the same value as page_to_phys(page). That is
until the PCI API is enabled at which point the dma_addr will
contain the true DMA (bus) address - which on baremetal will in all
likehood be the same as page_to_phys(page). But under Xen, it might
be different.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/ali-agp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/ali-agp.c b/drivers/char/agp/ali-agp.c
index ede9d0a..92382d7 100644
--- a/drivers/char/agp/ali-agp.c
+++ b/drivers/char/agp/ali-agp.c
@@ -153,7 +153,7 @@ static struct page *m1541_alloc_page(struct agp_bridge_data *bridge,
 	pci_read_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL, &temp);
 	pci_write_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL,
 			(((temp & ALI_CACHE_FLUSH_ADDR_MASK) |
-			  page_to_phys(page)) | ALI_CACHE_FLUSH_EN ));
+			  *dma_addr) | ALI_CACHE_FLUSH_EN ));
 	return page;
 }
 
@@ -182,7 +182,7 @@ static void m1541_destroy_page(struct page *page, int flags,
 		pci_read_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL, &temp);
 		pci_write_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL,
 				       (((temp & ALI_CACHE_FLUSH_ADDR_MASK) |
-					 page_to_phys(page)) | ALI_CACHE_FLUSH_EN));
+					 *dma_addr) | ALI_CACHE_FLUSH_EN));
 	}
 	agp_generic_destroy_page(page, flags, dma_addr);
 }
-- 
1.7.1

