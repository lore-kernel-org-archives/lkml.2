Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1J1Rwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:52:38 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:48061 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1J1Rwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:52:36 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 03/13] mtd/docg3: fix protection areas reading
Date: Fri, 28 Oct 2011 19:51:22 +0200
Message-Id: <1319824292-11085-4-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The protection areas boundaries were on 16bit registers, not
8bit. This is consistent with block numbers, which can
extend up to 4096 on bigger chips (and is 2048 on the
docg3).

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 8942a75..5834e6e 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -852,13 +852,15 @@ static int dbg_protection_show(struct seq_file *s, void *p)
 {
 	struct docg3 *docg3 = (struct docg3 *)s->private;
 	int pos = 0;
-	int protect = doc_register_readb(docg3, DOC_PROTECTION);
-	int dps0 = doc_register_readb(docg3, DOC_DPS0_STATUS);
-	int dps0_low = doc_register_readb(docg3, DOC_DPS0_ADDRLOW);
-	int dps0_high = doc_register_readb(docg3, DOC_DPS0_ADDRHIGH);
-	int dps1 = doc_register_readb(docg3, DOC_DPS1_STATUS);
-	int dps1_low = doc_register_readb(docg3, DOC_DPS1_ADDRLOW);
-	int dps1_high = doc_register_readb(docg3, DOC_DPS1_ADDRHIGH);
+	int protect, dps0, dps0_low, dps0_high, dps1, dps1_low, dps1_high;
+
+	protect = doc_register_readb(docg3, DOC_PROTECTION);
+	dps0 = doc_register_readb(docg3, DOC_DPS0_STATUS);
+	dps0_low = doc_register_readw(docg3, DOC_DPS0_ADDRLOW);
+	dps0_high = doc_register_readw(docg3, DOC_DPS0_ADDRHIGH);
+	dps1 = doc_register_readb(docg3, DOC_DPS1_STATUS);
+	dps1_low = doc_register_readw(docg3, DOC_DPS1_ADDRLOW);
+	dps1_high = doc_register_readw(docg3, DOC_DPS1_ADDRHIGH);
 
 	pos += seq_printf(s, "Protection = 0x%02x (",
 			 protect);
-- 
1.7.5.4

