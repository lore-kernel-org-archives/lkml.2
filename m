Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2DPRVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:21:01 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17764 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2DPRUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:20:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/8] xen/setup: Work properly with 'dom0_mem=X' or with not dom0_mem.
Date: Mon, 16 Apr 2012 13:15:37 -0400
Message-Id: <1334596539-18172-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F8C54EB.007B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We ignored the X value and ended up populating up to
max(MAX_DOMAIN_PAGES, last E820_RAM entry).

This fixes it by figuring out how many RAM nr_pages the
hypervisor wanted to provide to us and cap the populate
hypercalls up to that.

The end result is (on a 8GB box):

dom0_mem=1G
-Memory: 610884k/9435136k available (5817k kernel code, 1136060k absent, 7688192k reserved, 2899k data, 696k init)
+Memory: 724184k/1053064k available (5817k kernel code, 4552k absent, 324328k reserved, 2899k data, 696k init)

no dom0_mem
-Memory: 7619036k/9435136k available (5817k kernel code, 1136060k absent, 680040k reserved, 2899k data, 696k init)
+Memory: 7621460k/9208688k available (5817k kernel code, 1136060k absent, 451168k reserved, 2899k data, 696k init)

[v1: Details added]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 7b0ab77..0e82bf1 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -185,11 +185,29 @@ static unsigned long __init xen_get_max_pages(void)
 	 * the current maximum rather than the static maximum. In this
 	 * case the e820 map provided to us will cover the static
 	 * maximum region.
+	 *
+	 * The dom0_mem=min:X,max:Y tweaks options differently depending
+	 * on the version, but in general this is what we get:
+	 *                | XENMEM_maximum_reser  | nr_pages
+	 * --------------++-----------------------+-------------------
+	 *  no dom0_mem   | INT_MAX               | max_phys_pfn
+	 *  =3G           | INT_MAX               | 786432
+	 *  =max:3G       | 786432                | 786432
+	 *  =min:1G,max:3G| INT_MAX               | max_phys_fn
+	 *  =1G,max:3G    | INT_MAX               | 262144
+	 *  =min:1G,max:3G,2G | INT_MAX           | max_phys_fn
+	 *
+	 * The =3G is often used and it lead to us initially setting
+	 * 786432 and allowing dom0 to balloon up to the max_physical_pfn.
+	 * This is at odd with the classic XenOClassic so lets emulate
+	 * the classic behavior.
 	 */
 	if (xen_initial_domain()) {
 		ret = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
 		if (ret > 0)
 			max_pages = ret;
+		if (ret == -1UL)
+			max_pages = xen_start_info->nr_pages;
 	}
 
 	return min(max_pages, MAX_DOMAIN_PAGES);
-- 
1.7.7.5

