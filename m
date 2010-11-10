Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0KJTDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:50 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49308 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab0KJTDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:48 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 12/12] EDAC, MCE: Enable MCE decoding on F15h
Date: Wed, 10 Nov 2010 20:02:21 +0100
Message-Id: <1289415741-15000-13-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Now that everything is inplace, enable MCE decoding on F15h. Make
initcall routine a bit more readable.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 0a19d26..59ad34c 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -836,18 +836,21 @@ static struct notifier_block amd_mce_dec_nb = {
 
 static int __init mce_amd_init(void)
 {
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (c->x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	if ((boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x12) &&
-	    (boot_cpu_data.x86 != 0x14 || boot_cpu_data.x86_model > 0xf))
+	if ((c->x86 < 0xf || c->x86 > 0x12) &&
+	    (c->x86 != 0x14 || c->x86_model > 0xf) &&
+	    (c->x86 != 0x15 || c->x86_model > 0xf))
 		return 0;
 
 	fam_ops = kzalloc(sizeof(struct amd_decoder_ops), GFP_KERNEL);
 	if (!fam_ops)
 		return -ENOMEM;
 
-	switch (boot_cpu_data.x86) {
+	switch (c->x86) {
 	case 0xf:
 		fam_ops->dc_mce = k8_dc_mce;
 		fam_ops->ic_mce = k8_ic_mce;
@@ -887,8 +890,7 @@ static int __init mce_amd_init(void)
 		break;
 
 	default:
-		printk(KERN_WARNING "Huh? What family is that: %d?!\n",
-				    boot_cpu_data.x86);
+		printk(KERN_WARNING "Huh? What family is that: %d?!\n", c->x86);
 		kfree(fam_ops);
 		return -EINVAL;
 	}
-- 
1.7.3.1.50.g1e633

