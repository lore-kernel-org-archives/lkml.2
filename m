Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1BJRQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:16:04 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44666 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab1BJRQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:16:02 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 23/30] amd64_edac: Beef up early exit reporting
Date: Thu, 10 Feb 2011 18:15:26 +0100
Message-Id: <1297358133-14320-24-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add paranoid checks for the sys address before going off and decoding
it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4bba43e..e4ad091 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1380,9 +1380,20 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 	debugf1("(range %d) SystemAddr= 0x%llx Limit=0x%llx\n",
 		range, sys_addr, get_dram_limit(pvt, range));
 
+	if (dhar_valid(pvt) &&
+	    dhar_base(pvt) <= sys_addr &&
+	    sys_addr < BIT_64(32)) {
+		amd64_warn("Huh? Address is in the MMIO hole: 0x%016llx\n",
+			    sys_addr);
+		return -EINVAL;
+	}
+
 	if (intlv_en &&
-	    (intlv_sel != ((sys_addr >> 12) & intlv_en)))
+	    (intlv_sel != ((sys_addr >> 12) & intlv_en))) {
+		amd64_warn("Botched intlv bits, en: 0x%x, sel: 0x%x\n",
+			   intlv_en, intlv_sel);
 		return -EINVAL;
+	}
 
 	sys_addr = f10_swap_interleaved_region(pvt, sys_addr);
 
-- 
1.7.4.rc2

