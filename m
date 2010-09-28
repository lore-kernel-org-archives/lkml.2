Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0I1XHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 19:07:15 -0400
Received: from mx1.riseup.net ([204.13.164.18]:45442 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab0I1XHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 19:07:14 -0400
From: Francisco Jerez <currojerez@riseup.net>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
        =?UTF-8?q?Grzesiek=20S=C3=B3jka?= <pld@pfu.pl>
Subject: [PATCH] agp/amd-k7: Allow binding user memory to the AGP GART.
Date: Wed, 29 Sep 2010 01:07:05 +0200
Message-Id: <1285715225-21449-1-git-send-email-currojerez@riseup.net>
X-Mailer: git-send-email 1.6.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TTM-based DRM drivers need to be able to bind user memory to the AGP
aperture. This patch fixes the "[TTM] AGP Bind memory failed." errors
and the subsequent fallout seen with the nouveau driver.

Reported-by: Grzesiek Sójka <pld@pfu.pl>
Signed-off-by: Francisco Jerez <currojerez@riseup.net>
---
 drivers/char/agp/amd-k7-agp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index b6b1568..82e5189 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -303,13 +303,15 @@ static void amd_irongate_tlbflush(struct agp_memory *temp)
 
 static int amd_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 {
+	struct agp_bridge_data *bridge = mem->bridge;
 	int i, j, num_entries;
 	unsigned long __iomem *cur_gatt;
 	unsigned long addr;
 
 	num_entries = A_SIZE_LVL2(agp_bridge->current_size)->num_entries;
 
-	if (type != 0 || mem->type != 0)
+	if (!bridge || type != mem->type ||
+	    bridge->driver->agp_type_to_mask_type(bridge, type))
 		return -EINVAL;
 
 	if ((pg_start + mem->page_count) > num_entries)
-- 
1.6.4.4

