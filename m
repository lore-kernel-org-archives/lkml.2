Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321Ab2KAVdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:33:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47860 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759887Ab2KAVdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:33:42 -0400
Date: Thu, 1 Nov 2012 14:33:19 -0700
From: tip-bot for Andre Przywara <andre.przywara@amd.com>
Message-ID: <tip-2bbf0a1427c377350f001fbc6260995334739ad7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, osp@andrep.de, hpa@zytor.com,
        mingo@kernel.org, andre.przywara@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, osp@andrep.de,
        linux-kernel@vger.kernel.org, andre.przywara@amd.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1351700450-9277-1-git-send-email-osp@andrep.de>
References: <1351700450-9277-1-git-send-email-osp@andrep.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, amd:
  Disable way access filter on Piledriver CPUs
Git-Commit-ID: 2bbf0a1427c377350f001fbc6260995334739ad7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Nov 2012 14:33:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bbf0a1427c377350f001fbc6260995334739ad7
Gitweb:     http://git.kernel.org/tip/2bbf0a1427c377350f001fbc6260995334739ad7
Author:     Andre Przywara <andre.przywara@amd.com>
AuthorDate: Wed, 31 Oct 2012 17:20:50 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 31 Oct 2012 13:06:55 -0700

x86, amd: Disable way access filter on Piledriver CPUs

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
---
 arch/x86/kernel/cpu/amd.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f7e98a2..1b7d165 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -631,6 +631,20 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
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
+			wrmsrl_safe(0xc0011021, val);
+		}
+	}
+
 	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
