Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0I1MRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:17:34 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:47172 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab0I1MRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:17:32 -0400
X-IronPort-AV: E=Sophos;i="4.57,247,1283745600"; 
   d="scan'208";a="115729359"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 04/12] xen: use vcpu_ops to setup cpu masks
Date: Tue, 28 Sep 2010 13:16:50 +0100
Message-Id: <1285676218-26218-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
X-OriginalArrivalTime: 28 Sep 2010 12:17:07.0995 (UTC) FILETIME=[11E6F6B0:01CB5F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/smp.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 25f232b..1386767 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -156,11 +156,16 @@ static void __init xen_fill_possible_map(void)
 {
 	int i, rc;
 
+	num_processors = 0;
+	disabled_cpus = 0;
 	for (i = 0; i < nr_cpu_ids; i++) {
 		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
 		if (rc >= 0) {
 			num_processors++;
 			set_cpu_possible(i, true);
+		} else {
+			set_cpu_possible(i, false);
+			set_cpu_present(i, false);
 		}
 	}
 }
@@ -190,6 +195,8 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	if (xen_smp_intr_init(0))
 		BUG();
 
+	xen_fill_possible_map();
+
 	if (!alloc_cpumask_var(&xen_cpu_initialized_map, GFP_KERNEL))
 		panic("could not allocate xen_cpu_initialized_map\n");
 
@@ -480,6 +487,5 @@ static const struct smp_ops xen_smp_ops __initdata = {
 void __init xen_smp_init(void)
 {
 	smp_ops = xen_smp_ops;
-	xen_fill_possible_map();
 	xen_init_spinlocks();
 }
-- 
1.5.6.5

