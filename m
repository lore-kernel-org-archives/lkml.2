Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab2LMOPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:15:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45142 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358Ab2LMOPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andre Przywara <osp@andrep.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 230/241] x86, amd: Disable way access filter on Piledriver CPUs
Date: Thu, 13 Dec 2012 11:59:55 -0200
Message-Id: <1355407206-17100-231-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@amd.com>

commit 2bbf0a1427c377350f001fbc6260995334739ad7 upstream.

The Way Access Filter in recent AMD CPUs may hurt the performance of
some workloads, caused by aliasing issues in the L1 cache.
This patch disables it on the affected CPUs.

The issue is similar to that one of last year:
http://lkml.indiana.edu/hypermail/linux/kernel/1107.3/00041.html
This new patch does not replace the old one, we just need another
quirk for newer CPUs.

The performance penalty without the patch depends on the
circumstances, but is a bit less than the last year's 3%.

The workloads affected would be those that access code from the same
physical page under different virtual addresses, so different
processes using the same libraries with ASLR or multiple instances of
PIE-binaries. The code needs to be accessed simultaneously from both
cores of the same compute unit.

More details can be found here:
http://developer.amd.com/Assets/SharedL1InstructionCacheonAMD15hCPU.pdf

CPUs affected are anything with the core known as Piledriver.
That includes the new parts of the AMD A-Series (aka Trinity) and the
just released new CPUs of the FX-Series (aka Vishera).
The model numbering is a bit odd here: FX CPUs have model 2,
A-Series has model 10h, with possible extensions to 1Fh. Hence the
range of model ids.

Signed-off-by: Andre Przywara <osp@andrep.de>
Link: http://lkml.kernel.org/r/1351700450-9277-1-git-send-email-osp@andrep.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
[ herton: use checking_wrmsrl instead of wrmsrl_safe on 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/cpu/amd.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 146bb62..6b4976b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -598,6 +598,20 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
+	/*
+	 * The way access filter has a performance penalty on some workloads.
+	 * Disable it on the affected CPUs.
+	 */
+	if ((c->x86 == 0x15) &&
+	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
+		u64 val;
+
+		if (!rdmsrl_safe(0xc0011021, &val) && !(val & 0x1E)) {
+			val |= 0x1E;
+			checking_wrmsrl(0xc0011021, val);
+		}
+	}
+
 	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
-- 
1.7.9.5

