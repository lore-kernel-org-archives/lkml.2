Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1G0VsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:9080 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab1G0VsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="32274413"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: ostr@amd64.org, ak@linux.intel.com, borislav.petkov@amd.com,
        Hans.Rosenfeld@amd.com, Andreas.Herrmann3@amd.com, cebbert@redhat.com,
        hpa@linux.intel.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [1/99] x86, amd: Do not enable ARAT feature on AMD processors below
Message-Id: <20110727214759.581CD2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:47:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Boris Ostrovsky <ostr@amd64.org>

commit e9cdd343a5e42c43bcda01e609fa23089e026470 upstream.

Commit b87cf80af3ba4b4c008b4face3c68d604e1715c6 added support for
ARAT (Always Running APIC timer) on AMD processors that are not
affected by erratum 400. This erratum is present on certain processor
families and prevents APIC timer from waking up the CPU when it
is in a deep C state, including C1E state.

Determining whether a processor is affected by this erratum may
have some corner cases and handling these cases is somewhat
complicated. In the interest of simplicity we won't claim ARAT
support on processor families below 0x12 and will go back to
broadcasting timer when going idle.

Signed-off-by: Boris Ostrovsky <ostr@amd64.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1306423192-19774-1-git-send-email-ostr@amd64.org
Tested-by: Boris Petkov <borislav.petkov@amd.com>
Cc: Hans Rosenfeld <Hans.Rosenfeld@amd.com>
Cc: Andreas Herrmann <Andreas.Herrmann3@amd.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
@@ -565,8 +565,11 @@ static void __cpuinit init_amd(struct cp
 	}
 #endif
 
-	/* As a rule processors have APIC timer running in deep C states */
-	if (c->x86 > 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+	/*
+	 * Family 0x12 and above processors have APIC timer
+	 * running in deep C states.
+	 */
+	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
 	/*
