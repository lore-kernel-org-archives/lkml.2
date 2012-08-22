Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab2HVXme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:42:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab2HVXma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:42:30 -0400
Date: Wed, 22 Aug 2012 16:42:17 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-685ca6d797af9d41164dd64dd60145d4946fc152@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-8-git-send-email-bp@amd64.org>
References: <1344361461-10076-8-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, AMD:
  Check before applying a patch
Git-Commit-ID: 685ca6d797af9d41164dd64dd60145d4946fc152
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:42:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  685ca6d797af9d41164dd64dd60145d4946fc152
Gitweb:     http://git.kernel.org/tip/685ca6d797af9d41164dd64dd60145d4946fc152
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 20 Jun 2012 16:17:51 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:15:41 -0700

x86, microcode, AMD: Check before applying a patch

Make sure we're actually applying a microcode patch to a core which
really needs it.

This brings only a very very very minor slowdown on F10:

0.032218828 sec vs 0.056010626 sec with this patch.

And small speedup on F15:

0.487089449 sec vs 0.180551162 sec (from perf output).

Also, fixup comments while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-8-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_amd.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 9421338..8fdf7d9 100644
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
