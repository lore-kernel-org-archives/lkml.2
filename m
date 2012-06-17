Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab2FQSWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50121 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757953Ab2FQSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:14 -0400
Message-Id: <20120617175943.202131124@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@kernel.org>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [ 13/69] x86/amd: Re-enable CPU topology extensions in case BIOS has
 disabled it
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

BIOS will switch off the corresponding feature flag on family
15h models 10h-1fh non-desktop CPUs.

The topology extension CPUID leafs are required to detect which
cores belong to the same compute unit. (thread siblings mask is
set accordingly and also correct information about L1i and L2
cache sharing depends on this).

W/o this patch we wouldn't see which cores belong to the same
compute unit and also cache sharing information for L1i and L2
would be incorrect on such systems.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
(cherry picked from commit f7f286a910221ae18b21c18d9d0f4cd88965829f)

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/amd.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0bab2b1..3524e1f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -571,6 +571,24 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
+	/* re-enable TopologyExtensions if switched off by BIOS */
+	if ((c->x86 == 0x15) &&
+	    (c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
+	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
+		u64 val;
+
+		if (!rdmsrl_amd_safe(0xc0011005, &val)) {
+			val |= 1ULL << 54;
+			wrmsrl_amd_safe(0xc0011005, val);
+			rdmsrl(0xc0011005, val);
+			if (val & (1ULL << 54)) {
+				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
+				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
+				  "disabled Topology Extensions Support\n");
+			}
+		}
+	}
+
 	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */


