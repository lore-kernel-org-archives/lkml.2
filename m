Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2KMWB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:01:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37916 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2KMWB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:01:58 -0500
Date: Tue, 13 Nov 2012 14:01:44 -0800
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-27d3a8a26ada7660116fdd6830096008c063ee96@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20121019090209.GG26718@alberich>
References: <20121019090209.GG26718@alberich>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo:
  Base cache sharing info on CPUID 0x8000001d on AMD
Git-Commit-ID: 27d3a8a26ada7660116fdd6830096008c063ee96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 14:01:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27d3a8a26ada7660116fdd6830096008c063ee96
Gitweb:     http://git.kernel.org/tip/27d3a8a26ada7660116fdd6830096008c063ee96
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 19 Oct 2012 11:02:09 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 Nov 2012 11:22:31 -0800

x86, cacheinfo: Base cache sharing info on CPUID 0x8000001d on AMD

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
Link: http://lkml.kernel.org/r/20121019090209.GG26718@alberich
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
