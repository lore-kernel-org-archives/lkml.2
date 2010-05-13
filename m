Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab0EMXkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:40:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:33995 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab0EMXkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:40:12 -0400
Date: Thu, 13 May 2010 23:39:52 GMT
From: tip-bot for Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, herrmann.der.user@googlemail.com,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, herrmann.der.user@googlemail.com,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100427101348.GC4489@alberich.amd.com>
References: <20100427101348.GC4489@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, amd: Check X86_FEATURE_OSVW bit before accessing OSVW MSRs
Message-ID: <tip-f01487119dda3d9f58c9729c7361ecc50a61c188@git.kernel.org>
Git-Commit-ID: f01487119dda3d9f58c9729c7361ecc50a61c188
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 23:39:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f01487119dda3d9f58c9729c7361ecc50a61c188
Gitweb:     http://git.kernel.org/tip/f01487119dda3d9f58c9729c7361ecc50a61c188
Author:     Andreas Herrmann <herrmann.der.user@googlemail.com>
AuthorDate: Tue, 27 Apr 2010 12:13:48 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 May 2010 16:21:20 -0700

x86, amd: Check X86_FEATURE_OSVW bit before accessing OSVW MSRs

If host CPU is exposed to a guest the OSVW MSRs are not guaranteed
to be present and a GP fault occurs. Thus checking the feature flag is
essential.

Cc: <stable@kernel.org> # .32.x .33.x
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100427101348.GC4489@alberich.amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/process.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 28ad9f4..0415c3e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -546,11 +546,13 @@ static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 		 * check OSVW bit for CPUs that are not affected
 		 * by erratum #400
 		 */
-		rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
-		if (val >= 2) {
-			rdmsrl(MSR_AMD64_OSVW_STATUS, val);
-			if (!(val & BIT(1)))
-				goto no_c1e_idle;
+		if (cpu_has(c, X86_FEATURE_OSVW)) {
+			rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
+			if (val >= 2) {
+				rdmsrl(MSR_AMD64_OSVW_STATUS, val);
+				if (!(val & BIT(1)))
+					goto no_c1e_idle;
+			}
 		}
 		return 1;
 	}
