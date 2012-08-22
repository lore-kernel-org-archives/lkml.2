Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab2HVXWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:22:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2HVXWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:22:17 -0400
Date: Wed, 22 Aug 2012 16:22:02 -0700
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-36bf50d7697be18c6bfd0401e037df10bff1e573@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com,
        borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode, AMD:
  Fix broken ucode patch size check
Git-Commit-ID: 36bf50d7697be18c6bfd0401e037df10bff1e573
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:22:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36bf50d7697be18c6bfd0401e037df10bff1e573
Gitweb:     http://git.kernel.org/tip/36bf50d7697be18c6bfd0401e037df10bff1e573
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 31 Jul 2012 15:41:45 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:10:41 -0700

x86, microcode, AMD: Fix broken ucode patch size check

This issue was recently observed on an AMD C-50 CPU where a patch of
maximum size was applied.

Commit be62adb49294 ("x86, microcode, AMD: Simplify ucode verification")
added current_size in get_matching_microcode(). This is calculated as
size of the ucode patch + 8 (ie. size of the header). Later this is
compared against the maximum possible ucode patch size for a CPU family.
And of course this fails if the patch has already maximum size.

Cc: <stable@vger.kernel.org> [3.3+]
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-1-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_amd.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 8a2ce8f..82746f9 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -143,11 +143,12 @@ static int get_matching_microcode(int cpu, const u8 *ucode_ptr,
 				  unsigned int *current_size)
 {
 	struct microcode_header_amd *mc_hdr;
-	unsigned int actual_size;
+	unsigned int actual_size, patch_size;
 	u16 equiv_cpu_id;
 
 	/* size of the current patch we're staring at */
-	*current_size = *(u32 *)(ucode_ptr + 4) + SECTION_HDR_SIZE;
+	patch_size = *(u32 *)(ucode_ptr + 4);
+	*current_size = patch_size + SECTION_HDR_SIZE;
 
 	equiv_cpu_id = find_equiv_id();
 	if (!equiv_cpu_id)
@@ -174,7 +175,7 @@ static int get_matching_microcode(int cpu, const u8 *ucode_ptr,
 	/*
 	 * now that the header looks sane, verify its size
 	 */
-	actual_size = verify_ucode_size(cpu, *current_size, leftover_size);
+	actual_size = verify_ucode_size(cpu, patch_size, leftover_size);
 	if (!actual_size)
 		return 0;
 
