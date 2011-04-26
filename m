Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1DZV1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:27:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:60554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab1DZVOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327488"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: boris.ostrovsky@amd.com, borislav.petkov@amd.com,
        andreas.herrmann3@amd.com, mark.langsdorf@amd.com, tglx@linutronix.de,
        ak@linux.intel.com, mingo@elte.hu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [65/106] x86, AMD: Set ARAT feature on AMD processors
Message-Id: <20110426211346.276A03E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Boris Ostrovsky <boris.ostrovsky@amd.com>

commit b87cf80af3ba4b4c008b4face3c68d604e1715c6 upstream.

Support for Always Running APIC timer (ARAT) was introduced in
commit db954b5898dd3ef3ef93f4144158ea8f97deb058. This feature
allows us to avoid switching timers from LAPIC to something else
(e.g. HPET) and go into timer broadcasts when entering deep
C-states.

AMD processors don't provide a CPUID bit for that feature but
they also keep APIC timers running in deep C-states (except for
cases when the processor is affected by erratum 400). Therefore
we should set ARAT feature bit on AMD CPUs.

Tested-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1300205624-4813-1-git-send-email-ostr@amd64.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
@@ -564,6 +564,10 @@ static void __cpuinit init_amd(struct cp
 		}
 	}
 #endif
+
+	/* As a rule processors have APIC timer running in deep C states */
+	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+		set_cpu_cap(c, X86_FEATURE_ARAT);
 }
 
 #ifdef CONFIG_X86_32
