Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2JSJCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:02:17 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:38950
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857Ab2JSJCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:02:15 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VPS8(zzzz1202h1d1ah1d2ahzz177df4h17326ah8275eh8275bh3284oa1495iz2dh668h839h93fhd25hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-WSS-ID: 0MC4UFL-01-37M-02
X-M-MSG: 
Date: Fri, 19 Oct 2012 11:02:09 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] x86, cacheinfo: Base cache sharing info on CPUID
 0x8000001d on AMD
Message-ID: <20121019090209.GG26718@alberich>
References: <20121019085519.GC26718@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20121019085519.GC26718@alberich>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patch is based on a patch submitted by Hans Rosenfeld.
See http://marc.info/?l=linux-kernel&m=133908777200931

Note that  CPUID Fn8000_001D_EAX slightly differs to Intel's CPUID function 4.

Bits 14-25 contain NumSharingCache. Actual number of cores sharing
           this cache. SW to add value of one to get result.

The corresponding bits on Intel are defined as "maximum number of threads
sharing this cache" (with a "plus 1" encoding).

Thus a different method to determine which cores are sharing a cache
level has to be used.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   41 +++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index cd2e1cc..fe9edec 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -750,37 +750,50 @@ static DEFINE_PER_CPU(struct _cpuid4_info *, ici_cpuid4_info);
 static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 {
 	struct _cpuid4_info *this_leaf;
-	int ret, i, sibling;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	int i, sibling;
 
-	ret = 0;
-	if (index == 3) {
-		ret = 1;
-		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
+	if (cpu_has_topoext) {
+		unsigned int apicid, nshared, first, last;
+
+		if (!per_cpu(ici_cpuid4_info, cpu))
+			return 0;
+
+		this_leaf = CPUID4_INFO_IDX(cpu, index);
+		nshared = this_leaf->base.eax.split.num_threads_sharing + 1;
+		apicid = cpu_data(cpu).apicid;
+		first = apicid - (apicid % nshared);
+		last = first + nshared - 1;
+
+		for_each_online_cpu(i) {
+			apicid = cpu_data(i).apicid;
+			if ((apicid < first) || (apicid > last))
+				continue;
 			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
-				if (!cpu_online(sibling))
+
+			for_each_online_cpu(sibling) {
+				apicid = cpu_data(sibling).apicid;
+				if ((apicid < first) || (apicid > last))
 					continue;
 				set_bit(sibling, this_leaf->shared_cpu_map);
 			}
 		}
-	} else if ((c->x86 == 0x15) && ((index == 1) || (index == 2))) {
-		ret = 1;
-		for_each_cpu(i, cpu_sibling_mask(cpu)) {
+	} else if (index == 3) {
+		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
 			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			for_each_cpu(sibling, cpu_sibling_mask(cpu)) {
+			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
 				if (!cpu_online(sibling))
 					continue;
 				set_bit(sibling, this_leaf->shared_cpu_map);
 			}
 		}
-	}
+	} else
+		return 0;
 
-	return ret;
+	return 1;
 }
 
 static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
-- 
1.7.8.6



