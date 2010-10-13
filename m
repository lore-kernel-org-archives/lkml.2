Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0JMJb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:31:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51769 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0JMJb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:31:57 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/4] EDAC, MCE: Add F12h DC MCE decoder
Date: Wed, 13 Oct 2010 11:31:37 +0200
Message-Id: <1286962300-23385-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286962300-23385-1-git-send-email-bp@amd64.org>
References: <1286962300-23385-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F12h DC MCE signatures are a subset of F10h's so reuse them.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 9fa61ee..1f895df 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -74,16 +74,10 @@ static const char *f10h_nb_mce_desc[] = {
 	"ECC Error in the Probe Filter directory"
 };
 
-static bool f10h_dc_mce(u16 ec)
+static bool f12h_dc_mce(u16 ec)
 {
-	u8 r4  = (ec >> 4) & 0xf;
 	bool ret = false;
 
-	if (r4 == R4_GEN) {
-		pr_cont("during data scrub.\n");
-		return true;
-	}
-
 	if (MEM_ERROR(ec)) {
 		u8 ll = ec & 0x3;
 		ret = true;
@@ -98,6 +92,18 @@ static bool f10h_dc_mce(u16 ec)
 	return ret;
 }
 
+static bool f10h_dc_mce(u16 ec)
+{
+	u8 r4  = (ec >> 4) & 0xf;
+	u8 ll  = ec & 0x3;
+
+	if (r4 == R4_GEN && ll == LL_L1) {
+		pr_cont("during data scrub.\n");
+		return true;
+	}
+	return f12h_dc_mce(ec);
+}
+
 static bool k8_dc_mce(u16 ec)
 {
 	if (BUS_ERROR(ec)) {
@@ -632,6 +638,10 @@ static int __init mce_amd_init(void)
 		fam_ops->nb_mce = f10h_nb_mce;
 		break;
 
+	case 0x12:
+		fam_ops->dc_mce = f12h_dc_mce;
+		break;
+
 	case 0x14:
 		nb_err_cpumask  = 0x3;
 		fam_ops->dc_mce = f14h_dc_mce;
-- 
1.7.3.1.50.g1e633

