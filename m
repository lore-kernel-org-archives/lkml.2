Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0I3Mpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:45:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60490 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab0I3Mpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tE3g6r6N4a80mAQRzF6g4s1w0KS08IQlc+Z9F16J+eXLxRJQXKmzzvyq4S9uwCtfeY
         sT6YvjUgISWPZkjLnqbvsCBmxVR14nfRp7ahzqPGVPi/8hn0ld16fugw1wPhadOEk1RD
         v6uSUUdNaJ3jtzZKYe1g3EOFk3It7Q0WvYVXc=
Date: Thu, 30 Sep 2010 14:41:56 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] x86, amd: Use compute unit information to determine
 thread siblings
Message-ID: <20100930124156.GF20545@loge.amd.com>
References: <20100930121839.GA20545@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930121839.GA20545@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

This information is vital for different load balancing policies.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/smpboot.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d3484f1..2ced73b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -396,6 +396,19 @@ void __cpuinit smp_store_cpu_info(int id)
 		identify_secondary_cpu(c);
 }
 
+static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
+{
+	struct cpuinfo_x86 *c1 = &cpu_data(cpu1);
+	struct cpuinfo_x86 *c2 = &cpu_data(cpu2);
+
+	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
+	cpumask_set_cpu(cpu2, cpu_sibling_mask(cpu1));
+	cpumask_set_cpu(cpu1, cpu_core_mask(cpu2));
+	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
+	cpumask_set_cpu(cpu1, c2->llc_shared_map);
+	cpumask_set_cpu(cpu2, c1->llc_shared_map);
+}
+
 
 void __cpuinit set_cpu_sibling_map(int cpu)
 {
@@ -408,14 +421,13 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		for_each_cpu(i, cpu_sibling_setup_mask) {
 			struct cpuinfo_x86 *o = &cpu_data(i);
 
-			if (c->phys_proc_id == o->phys_proc_id &&
-			    c->cpu_core_id == o->cpu_core_id) {
-				cpumask_set_cpu(i, cpu_sibling_mask(cpu));
-				cpumask_set_cpu(cpu, cpu_sibling_mask(i));
-				cpumask_set_cpu(i, cpu_core_mask(cpu));
-				cpumask_set_cpu(cpu, cpu_core_mask(i));
-				cpumask_set_cpu(i, c->llc_shared_map);
-				cpumask_set_cpu(cpu, o->llc_shared_map);
+			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+				if (c->phys_proc_id == o->phys_proc_id &&
+				    c->compute_unit_id == o->compute_unit_id)
+					link_thread_siblings(cpu, i);
+			} else if (c->phys_proc_id == o->phys_proc_id &&
+				   c->cpu_core_id == o->cpu_core_id) {
+				link_thread_siblings(cpu, i);
 			}
 		}
 	} else {
-- 
1.6.4.4

