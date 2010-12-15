Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab0LOWVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:21:06 -0500
Received: from claw.goop.org ([74.207.240.146]:47904 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab0LOWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:12 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 4/9] vmalloc: use plain pte_clear() for unmaps
Date: Wed, 15 Dec 2010 14:19:50 -0800
Message-Id: <6b78f2a4c559d86e940c8f6cd82b2a027caa0b09.1292450600.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

ptep_get_and_clear() is potentially moderately expensive (at least
an atomic operation, or potentially a trap-and-fault when virtualized)
so use a plain pte_clear().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 mm/vmalloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e95980a..67ce748 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -39,8 +39,9 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end)
 
 	pte = pte_offset_kernel(pmd, addr);
 	do {
-		pte_t ptent = ptep_get_and_clear(&init_mm, addr, pte);
+		pte_t ptent = *pte;
 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
+		pte_clear(&init_mm, addr, pte);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
-- 
1.7.3.3

