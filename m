Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1BNRPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:15:08 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34520 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab1BNRPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:15:03 -0500
Date: Mon, 14 Feb 2011 18:14:51 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: [PATCH] x86, amd: Fix uninitialized variable warning
Message-ID: <20110214171451.GB10076@kryptos.osrc.amd.com>
References: <1295881543-572552-2-git-send-email-hans.rosenfeld@amd.com>
 <tip-d518573de63fb119e5e9a3137386544671387681@git.kernel.org>
 <20110214143006.GA28202@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214143006.GA28202@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 03:30:06PM +0100, Ingo Molnar wrote:
> 
> * tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Commit-ID:  d518573de63fb119e5e9a3137386544671387681
> > Gitweb:     http://git.kernel.org/tip/d518573de63fb119e5e9a3137386544671387681
> > Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
> > AuthorDate: Mon, 24 Jan 2011 16:05:40 +0100
> 
> Andreas,
> 
> the build is now producing this warning:
> 
>  arch/x86/kernel/cpu/amd.c: In function 'amd_detect_cmp':
>  arch/x86/kernel/cpu/amd.c:268: warning: 'cores_per_cu' may be used uninitialized in this function
>  arch/x86/kernel/cpu/amd.c:268: note: 'cores_per_cu' was declared here

Here's a quick fix against tip/amd-nb:

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 14 Feb 2011 16:25:47 +0100
Subject: [PATCH] x86, amd: Fix uninitialized variable warning

d518573de63fb119e5e9a3137386544671387681 introduced compute unit
normalization but causes a valid compiler warning:

arch/x86/kernel/cpu/amd.c: In function 'amd_detect_cmp':
arch/x86/kernel/cpu/amd.c:268: warning: 'cores_per_cu' may be used uninitialized in this function
arch/x86/kernel/cpu/amd.c:268: note: 'cores_per_cu' was declared here

Initialize it with a proper value. Also, fixup comment while at it.

Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 990cc48..589bdd7 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -261,7 +261,7 @@ static int __cpuinit nearby_node(int apicid)
 #ifdef CONFIG_X86_HT
 static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
-	u32 nodes, cores_per_cu;
+	u32 nodes, cores_per_cu = 1;
 	u8 node_id;
 	int cpu = smp_processor_id();
 
@@ -276,7 +276,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 		/* get compute unit information */
 		smp_num_siblings = ((ebx >> 8) & 3) + 1;
 		c->compute_unit_id = ebx & 0xff;
-		cores_per_cu = ((ebx >> 8) & 3) + 1;
+		cores_per_cu += ((ebx >> 8) & 3);
 	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
 		u64 value;
 
@@ -298,7 +298,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 		/* store NodeID, use llc_shared_map to store sibling info */
 		per_cpu(cpu_llc_id, cpu) = node_id;
 
-		/* core id to be in range from 0 to (cores_per_node - 1) */
+		/* core id has to be in the [0 .. cores_per_node - 1] range */
 		c->cpu_core_id %= cores_per_node;
 		c->compute_unit_id %= cus_per_node;
 	}
-- 
1.7.4.rc2


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
