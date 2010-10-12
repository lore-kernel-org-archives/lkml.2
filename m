Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab0JLQnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:43:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32802 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab0JLQnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:43:03 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283745600"; 
   d="scan'208";a="117745985"
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 05/10] xen: use vcpu_ops to setup cpu masks
Date: Tue, 12 Oct 2010 17:42:45 +0100
Message-Id: <1286901770-8612-5-git-send-email-Stefano.Stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop>
References: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop>
X-OriginalArrivalTime: 12 Oct 2010 16:43:03.0146 (UTC) FILETIME=[89B24CA0:01CB6A2C]
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

