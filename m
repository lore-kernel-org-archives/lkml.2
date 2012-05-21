Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2EUVtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:49:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44906 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759319Ab2EUVtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:49:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, david.vrabel@citrix.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/setup: Work properly with 'dom0_mem=X' or with not dom0_mem.
Date: Mon, 21 May 2012 17:42:42 -0400
Message-Id: <1337636562-9579-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1337636562-9579-1-git-send-email-konrad.wilk@oracle.com>
References: <1337636562-9579-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We ignored the X value and ended up populating up to
max(MAX_DOMAIN_PAGES, last E820_RAM entry).

This fixes it by figuring out how many RAM nr_pages the
hypervisor wanted to provide to us and cap the populate
hypercalls up to that.

The end result is (on a 32GB box):

-Memory: 31779964k/34603008k available (5831k kernel code, 1351620k absent, 1471424k reserved, 2886k data, 692k init)
-(XEN) memory.c:133:d0 Could not allocate order=0 extent: id=0 memflags=0 (15 of 512)
+Memory: 31788256k/34032852k available (5831k kernel code, 1351620k absent, 892976k reserved, 2886k data, 692k init)

with dom0_mem=1G
-Memory: 550608k/12890412k available (5831k kernel code, 1351620k absent, 10988184k reserved, 2886k data, 692k init)
+Memory: 717272k/1049028k available (5831k kernel code, 516k absent, 331240k reserved, 2886k data, 692k init)

[v1: Details added]
[v2: Redid on 32GB box]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 1ba8dff..23d355c 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -182,11 +182,29 @@ static unsigned long __init xen_get_max_pages(void)
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

