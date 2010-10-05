Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab0JEKw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:52:56 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37986 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab0JEKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:52:52 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 8/8] EDAC, MCE: Enable MCE decoding on F14h
Date: Tue,  5 Oct 2010 12:54:08 +0200
Message-Id: <1286276048-20556-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286276048-20556-1-git-send-email-bp@amd64.org>
References: <1286276048-20556-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Now that all decoders have been taught about F14h, models < 0x10
MCEs, enable decoding on this family of CPUs. Also, issue a short
informational message upon boot that MCE decoding gets enabled.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 82dc0de..f8dcd241 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -602,13 +602,12 @@ static struct notifier_block amd_mce_dec_nb = {
 
 static int __init mce_amd_init(void)
 {
-	/*
-	 * We can decode MCEs for K8, F10h and F11h CPUs:
-	 */
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+	if (boot_cpu_data.x86 != 0xf &&
+	    boot_cpu_data.x86 != 0x10 &&
+	    (boot_cpu_data.x86 != 0x14 || boot_cpu_data.x86_model > 0xf))
 		return 0;
 
 	fam_ops = kzalloc(sizeof(struct amd_decoder_ops), GFP_KERNEL);
@@ -642,6 +641,8 @@ static int __init mce_amd_init(void)
 		return -EINVAL;
 	}
 
+	pr_info("MCE: In-kernel MCE decoding enabled.\n");
+
 	atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
 
 	return 0;
-- 
1.7.3.1.50.g1e633

