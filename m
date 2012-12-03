Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2LCOmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:42:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43905 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755485Ab2LCOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:55 -0500
Message-Id: <20121203143154.218941435@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:34 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andre Przywara <andre.przywara@amd.com>,
        Andre Przywara <osp@andrep.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 48/89] x86, amd: Disable way access filter on Piledriver CPUs
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: wrmsrl_safe() is called checking_wrmsrl()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/amd.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

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
+			checking_wrmsrl(0xc0011021, val);
+		}
+	}
+
 	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */


