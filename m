Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953Ab0JSLR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:17:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49801 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758425Ab0JSLR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:17:56 -0400
X-IronPort-AV: E=Sophos;i="4.57,350,1283745600"; 
   d="scan'208";a="118686936"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 05/10] xen: use vcpu_ops to setup cpu masks
Date: Tue, 19 Oct 2010 12:17:13 +0100
Message-Id: <1287487038-6643-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
X-OriginalArrivalTime: 19 Oct 2010 11:17:56.0062 (UTC) FILETIME=[4775BFE0:01CB6F7F]
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

