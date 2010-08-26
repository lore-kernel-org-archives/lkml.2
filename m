Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0HZOF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:05:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34060 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0HZOF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:05:56 -0400
From: Borislav Petkov <bp@amd64.org>
To: <torvalds@linux-foundation.org>
Cc: <norsk5@yahoo.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] MCE, AMD: Limit MCE decoding to current families for now
Date: Thu, 26 Aug 2010 16:06:28 +0200
Message-Id: <1282831589-4274-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282831589-4274-1-git-send-email-bp@amd64.org>
References: <1282831589-4274-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Limit MCE error decoding to current and older families only (K8-F11h).

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mce_amd.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index bae9351..352dcc6 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -426,11 +426,15 @@ static struct notifier_block amd_mce_dec_nb = {
 static int __init mce_amd_init(void)
 {
 	/*
-	 * We can decode MCEs for Opteron and later CPUs:
+	 * We can decode MCEs for K8, F10h and F11h CPUs:
 	 */
-	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
-	    (boot_cpu_data.x86 >= 0xf))
-		atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return 0;
+
+	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+		return 0;
+
+	atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
 
 	return 0;
 }
-- 
1.7.1

