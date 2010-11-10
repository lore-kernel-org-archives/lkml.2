Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0KJTDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:24 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49253 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab0KJTDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:22 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 01/12] EDAC, MCE: Select extended error code mask
Date: Wed, 10 Nov 2010 20:02:10 +0100
Message-Id: <1289415741-15000-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F15h enlarges the extended error code of an MCE to a 5-bit field
(MCi_STATUS[20:16]). Add a mask variable which default 0xf is overridden
on F15h.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index c018109..01853ee 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -5,6 +5,7 @@
 
 static struct amd_decoder_ops *fam_ops;
 
+static u8 xec_mask	 = 0xf;
 static u8 nb_err_cpumask = 0xf;
 
 static bool report_gart_errors;
@@ -172,7 +173,7 @@ static bool f14h_dc_mce(u16 ec)
 static void amd_decode_dc_mce(struct mce *m)
 {
 	u16 ec = m->status & 0xffff;
-	u8 xec = (m->status >> 16) & 0xf;
+	u8 xec = (m->status >> 16) & xec_mask;
 
 	pr_emerg(HW_ERR "Data Cache Error: ");
 
@@ -257,7 +258,7 @@ static bool f14h_ic_mce(u16 ec)
 static void amd_decode_ic_mce(struct mce *m)
 {
 	u16 ec = m->status & 0xffff;
-	u8 xec = (m->status >> 16) & 0xf;
+	u8 xec = (m->status >> 16) & xec_mask;
 
 	pr_emerg(HW_ERR "Instruction Cache Error: ");
 
@@ -277,7 +278,7 @@ static void amd_decode_ic_mce(struct mce *m)
 static void amd_decode_bu_mce(struct mce *m)
 {
 	u32 ec = m->status & 0xffff;
-	u32 xec = (m->status >> 16) & 0xf;
+	u32 xec = (m->status >> 16) & xec_mask;
 
 	pr_emerg(HW_ERR "Bus Unit Error");
 
@@ -319,7 +320,7 @@ wrong_bu_mce:
 static void amd_decode_ls_mce(struct mce *m)
 {
 	u16 ec = m->status & 0xffff;
-	u8 xec = (m->status >> 16) & 0xf;
+	u8 xec = (m->status >> 16) & xec_mask;
 
 	if (boot_cpu_data.x86 == 0x14) {
 		pr_emerg("You shouldn't be seeing an LS MCE on this cpu family,"
@@ -651,6 +652,10 @@ static int __init mce_amd_init(void)
 		fam_ops->nb_mce = nb_noop_mce;
 		break;
 
+	case 0x15:
+		xec_mask = 0x1f;
+		break;
+
 	default:
 		printk(KERN_WARNING "Huh? What family is that: %d?!\n",
 				    boot_cpu_data.x86);
-- 
1.7.3.1.50.g1e633

