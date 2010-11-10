Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab0KJTDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:41 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49291 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab0KJTDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:39 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 08/12] EDAC, MCE: Add F15h FP MCE decoder
Date: Wed, 10 Nov 2010 20:02:17 +0100
Message-Id: <1289415741-15000-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add decoder for FP MCEs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index afda6de5..c14abe3 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -692,6 +692,46 @@ wrong_fr_mce:
 	pr_emerg(HW_ERR "Corrupted FR MCE info?\n");
 }
 
+static void amd_decode_fp_mce(struct mce *m)
+{
+	u8 xec = (m->status >> 16) & xec_mask;
+
+	pr_emerg(HW_ERR "Floating Point Unit Error: ");
+
+	switch (xec) {
+	case 0x1:
+		pr_cont("Free List");
+		break;
+
+	case 0x2:
+		pr_cont("Physical Register File");
+		break;
+
+	case 0x3:
+		pr_cont("Retire Queue");
+		break;
+
+	case 0x4:
+		pr_cont("Scheduler table");
+		break;
+
+	case 0x5:
+		pr_cont("Status Register File");
+		break;
+
+	default:
+		goto wrong_fp_mce;
+		break;
+	}
+
+	pr_cont(" parity error.\n");
+
+	return;
+
+wrong_fp_mce:
+	pr_emerg(HW_ERR "Corrupted FP MCE info?\n");
+}
+
 static inline void amd_decode_err_code(u16 ec)
 {
 	if (TLB_ERROR(ec)) {
@@ -777,6 +817,10 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 		amd_decode_fr_mce(m);
 		break;
 
+	case 6:
+		amd_decode_fp_mce(m);
+		break;
+
 	default:
 		break;
 	}
-- 
1.7.3.1.50.g1e633

