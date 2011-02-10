Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab1BJRSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:18:40 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44661 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1BJRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:58 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 21/30] amd64_edac: Fix channel interleave removal
Date: Thu, 10 Feb 2011 18:15:24 +0100
Message-Id: <1297358133-14320-22-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Remove the channel interleave select bit properly. See
F2x110[DctSelIntLvAddr] for details.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index f3f4ee9..1cbe9ca 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1373,7 +1373,7 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 {
 	int cs_found = -EINVAL;
 	u64 chan_addr;
-	u32 tmp, dct_sel_base;
+	u32 dct_sel_base;
 	u8 channel;
 	bool high_range = false;
 
@@ -1411,19 +1411,27 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 		chan_addr = ((chan_addr >> (12 + hweight8(intlv_en))) << 12) |
 			    (chan_addr & 0xfff);
 
-	/* remove channel interleave and hash */
+	/* remove channel interleave */
 	if (dct_interleave_enabled(pvt) &&
 	   !dct_high_range_enabled(pvt) &&
 	   !dct_ganging_enabled(pvt)) {
-		if (dct_sel_interleave_addr(pvt) != 1)
-			chan_addr = (chan_addr >> 1) & GENMASK(6, 63);
-		else {
-			tmp = chan_addr & 0xFC0;
-			chan_addr = ((chan_addr & GENMASK(14, 63)) >> 1) | tmp;
-		}
+
+		if (dct_sel_interleave_addr(pvt) != 1) {
+			if (dct_sel_interleave_addr(pvt) == 0x3)
+				/* hash 9 */
+				chan_addr = ((chan_addr >> 10) << 9) |
+					     (chan_addr & 0x1ff);
+			else
+				/* A[6] or hash 6 */
+				chan_addr = ((chan_addr >> 7) << 6) |
+					     (chan_addr & 0x3f);
+		} else
+			/* A[12] */
+			chan_addr = ((chan_addr >> 13) << 12) |
+				     (chan_addr & 0xfff);
 	}
 
-	debugf1("   (ChannelAddrLong=0x%llx)\n", chan_addr);
+	debugf1("   Normalized DCT addr: 0x%llx\n", chan_addr);
 
 	cs_found = f10_lookup_addr_in_dct(chan_addr, node_id, channel);
 
-- 
1.7.4.rc2

