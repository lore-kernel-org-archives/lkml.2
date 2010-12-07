Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0LGCJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:09:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47216 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab0LGCIl (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 21:08:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/7] radeon/nouveau/ttm/AGP: Use dma_addr if TTM has set it.
Date: Mon,  6 Dec 2010 21:07:25 -0500
Message-Id: <1291687646-31994-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
References: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the AGP case we are heavily relaying on the AGP API to
setup the GART, and insert the bus addresses of the pages in the
GART. Both radeon and nouveau use this for their AGP cards.

TTM, with the patch titled "ttm: Utilize the dma_addr_t array for
pages that are to in DMA32 pool", can create pages that have
already passed through the DMA API, and the DMA (bus) address
is saved. For this to work properly with the GART we need to
pass in the bus addresses to the AGP API, which we do
by setting the dma_addr field of 'struct agp_memory' with the
dma_address obtained from the TTM.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_agp_backend.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_agp_backend.c b/drivers/gpu/drm/ttm/ttm_agp_backend.c
index 1c4a72f..df4e1a9 100644
--- a/drivers/gpu/drm/ttm/ttm_agp_backend.c
+++ b/drivers/gpu/drm/ttm/ttm_agp_backend.c
@@ -64,7 +64,7 @@ static int ttm_agp_populate(struct ttm_backend *backend,
 		struct page *page = *cur_page;
 		if (!page)
 			page = dummy_read_page;
-
+		mem->dma_addr[mem->page_count] = dma_addrs[mem->page_count];
 		mem->pages[mem->page_count++] = page;
 	}
 	agp_be->mem = mem;
-- 
1.7.1

