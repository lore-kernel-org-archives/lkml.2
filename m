Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab0JPApb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:45:31 -0400
Received: from mx1.riseup.net ([204.13.164.18]:53704 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0JPApa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:45:30 -0400
From: Francisco Jerez <currojerez@riseup.net>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Grzesiek=20S=C3=B3jka?= <pld@pfu.pl>,
        dri-devel@lists.freedesktop.org
Subject: [PATCHv2] agp/amd-k7: Allow binding user memory to the AGP GART.
Date: Sat, 16 Oct 2010 02:45:15 +0200
Message-Id: <1287189915-13341-1-git-send-email-currojerez@riseup.net>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1285715225-21449-1-git-send-email-currojerez@riseup.net>
References: <1285715225-21449-1-git-send-email-currojerez@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TTM-based DRM drivers need to be able to bind user memory to the AGP
aperture. This patch fixes the "[TTM] AGP Bind memory failed." errors
and the subsequent fallout seen with the nouveau driver.

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
Tested-by: Grzesiek Sójka <pld@pfu.pl>
---
v2: "amd_remove_memory" bails out when it's given user memory, fix it too.

 drivers/char/agp/amd-k7-agp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index b6b1568..b1b4362 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -309,7 +309,8 @@ static int amd_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 
 	num_entries = A_SIZE_LVL2(agp_bridge->current_size)->num_entries;
 
-	if (type != 0 || mem->type != 0)
+	if (type != mem->type ||
+	    agp_bridge->driver->agp_type_to_mask_type(agp_bridge, type))
 		return -EINVAL;
 
 	if ((pg_start + mem->page_count) > num_entries)
@@ -348,7 +349,8 @@ static int amd_remove_memory(struct agp_memory *mem, off_t pg_start, int type)
 	unsigned long __iomem *cur_gatt;
 	unsigned long addr;
 
-	if (type != 0 || mem->type != 0)
+	if (type != mem->type ||
+	    agp_bridge->driver->agp_type_to_mask_type(agp_bridge, type))
 		return -EINVAL;
 
 	for (i = pg_start; i < (mem->page_count + pg_start); i++) {
-- 
1.6.4.4

