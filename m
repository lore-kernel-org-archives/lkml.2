Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2HGRsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:48:12 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35592 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab2HGRo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:27 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v0 07/12] x86, microcode, AMD: Check before applying a patch
Date: Tue,  7 Aug 2012 19:44:16 +0200
Message-Id: <1344361461-10076-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Make sure we're actually applying a microcode patch to a core which
really needs it.

This brings only a very very very minor slowdown on F10:

0.032218828 sec vs 0.056010626 sec with this patch.

And small speedup on F15:

0.487089449 sec vs 0.180551162 sec (from perf output).

Also, fixup comments while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 94213387a3d1..8fdf7d99b804 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -202,11 +202,18 @@ static int apply_microcode_amd(int cpu)
 	if (mc_amd == NULL)
 		return 0;
 
-	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
-	/* get patch id after patching */
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
-	/* check current patch id and patch's id for match */
+	/* need to apply patch? */
+	if (rev >= mc_amd->hdr.patch_id) {
+		c->microcode = rev;
+		return 0;
+	}
+
+	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
+
+	/* verify patch application was successful */
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 	if (rev != mc_amd->hdr.patch_id) {
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 		       cpu, mc_amd->hdr.patch_id);
-- 
1.7.11.rc1

