Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1G0VsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:26091 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab1G0VsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="33043445"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: Joerg.Roedel@amd.com, joerg.roedel@amd.com, rjw@sisk.pl,
        maciej.rutecki@gmail.com, avi@redhat.com, akpm@linux-foundation.org,
        mingo@elte.hu, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [2/99] x86, amd: Use _safe() msr access for GartTlbWlk disable code
Message-Id: <20110727214800.5CA142403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>

commit d47cc0db8fd6011de2248df505fc34990b7451bf upstream.

The workaround for Bugzilla:

	https://bugzilla.kernel.org/show_bug.cgi?id=33012

introduced a read and a write to the MC4 mask msr.

Unfortunatly this MSR is not emulated by the KVM hypervisor
so that the kernel will get a #GP and crashes when applying
this workaround when running inside KVM.

This issue was reported as:

	https://bugzilla.kernel.org/show_bug.cgi?id=35132

and is fixed with this patch. The change just let the kernel
ignore any #GP it gets while accessing this MSR by using the
_safe msr access methods.

Reported-by: Török Edwin <edwintorok@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/amd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
@@ -585,10 +585,13 @@ static void __cpuinit init_amd(struct cp
 		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
 		 */
 		u64 mask;
+		int err;
 
-		rdmsrl(MSR_AMD64_MCx_MASK(4), mask);
-		mask |= (1 << 10);
-		wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		err = rdmsrl_safe(MSR_AMD64_MCx_MASK(4), &mask);
+		if (err == 0) {
+			mask |= (1 << 10);
+			checking_wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		}
 	}
 }
 
