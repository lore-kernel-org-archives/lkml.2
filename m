Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1BJRP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:15:59 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44656 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab1BJRPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:55 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 20/30] amd64_edac: Correct node interleaving removal
Date: Thu, 10 Feb 2011 18:15:23 +0100
Message-Id: <1297358133-14320-21-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

When node interleaving is enabled, a subset of the addr[14:12] bits has
to be removed in order to get the normalized DCT address of the DRAM
channel. The actual number of bits to remove is determined by F1x[1,
0][7C:40][IntlvEn]. Do this correctly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9ea1bb4..f3f4ee9 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1406,10 +1406,10 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 	chan_addr = f10_get_norm_dct_addr(pvt, range, sys_addr,
 					  high_range, dct_sel_base);
 
-	/* remove Node ID (in case of node interleaving) */
-	tmp = chan_addr & 0xFC0;
-
-	chan_addr = ((chan_addr >> hweight8(intlv_en)) & GENMASK(12, 47)) | tmp;
+	/* Remove node interleaving, see F1x120 */
+	if (intlv_en)
+		chan_addr = ((chan_addr >> (12 + hweight8(intlv_en))) << 12) |
+			    (chan_addr & 0xfff);
 
 	/* remove channel interleave and hash */
 	if (dct_interleave_enabled(pvt) &&
-- 
1.7.4.rc2

