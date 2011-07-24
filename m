Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1GXJq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 05:46:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:45982 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1GXJqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 05:46:10 -0400
Message-Id: <20110723212626.550539989@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 24 Jul 2011 09:46:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Mike Travis <travis@sgi.com>
Subject: [patch 1/3] x86: cache_info: Remove bogus free of amd_l3_cache data
References: <20110723212603.517924252@linutronix.de>
Content-Disposition: inline; filename=x86-amd-remove-bogus-free.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_cache_attributes() kfree's:

   per_cpu(ici_cpuid4_info, cpu)->l3

which is a pointer to memory which was allocated as a block in
amd_init_l3_cache(). l3 of a particular cpu points to a part of this
memory blob. The part and the rest of the blob are still referenced by
other cpus.

As far as I can tell from the git history this is a leftover from the
conversion from per cpu to node data with commit ba06edb63(x86,
cacheinfo: Make L3 cache info per node) and the following commit
f658bcfb2(x86, cacheinfo: Cleanup L3 cache index disable support)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -820,7 +820,6 @@ static void __cpuinit free_cache_attribu
 	for (i = 0; i < num_cache_leaves; i++)
 		cache_remove_shared_cpu_map(cpu, i);
 
-	kfree(per_cpu(ici_cpuid4_info, cpu)->l3);
 	kfree(per_cpu(ici_cpuid4_info, cpu));
 	per_cpu(ici_cpuid4_info, cpu) = NULL;
 }


