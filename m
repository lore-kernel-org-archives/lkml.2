Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1LISJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:09:19 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36264 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1LISJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:09:08 -0500
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/5] x86, microcode, AMD: Exit early on success
Date: Fri,  9 Dec 2011 19:08:54 +0100
Message-Id: <1323454135-16777-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1323454135-16777-1-git-send-email-bp@amd64.org>
References: <1323454135-16777-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Once we've found and validated the ucode patch for the current CPU,
there's no need to iterate over the remaining patches in the binary
image. Exit then and save us a bunch of cycles.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 384990d..d80e943 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -282,11 +282,11 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 			mc_hdr  = patch;
 			new_mc  = patch;
 			new_rev = mc_hdr->patch_id;
-			leftover -= mc_size;
-		} else {
-			ucode_ptr += current_size;
-			leftover  -= current_size;
+			goto out_ok;
 		}
+
+		ucode_ptr += current_size;
+		leftover  -= current_size;
 	}
 
 	if (!new_mc) {
@@ -294,15 +294,11 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 		goto free_table;
 	}
 
-	if (!leftover) {
-		uci->mc = new_mc;
-		state = UCODE_OK;
-		pr_debug("CPU%d update ucode (0x%08x -> 0x%08x)\n",
-			 cpu, uci->cpu_sig.rev, new_rev);
-	} else {
-		new_mc = NULL;
-		state = UCODE_ERROR;
-	}
+out_ok:
+	uci->mc = new_mc;
+	state = UCODE_OK;
+	pr_debug("CPU%d update ucode (0x%08x -> 0x%08x)\n",
+		 cpu, uci->cpu_sig.rev, new_rev);
 
 free_table:
 	free_equiv_cpu_table();
-- 
1.7.8.rc0

