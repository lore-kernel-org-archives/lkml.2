Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641Ab2C3Unj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:43:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47263 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab2C3UmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:42:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/7] xen/setup: Make dom0_mem=XGB behavior be similar to classic Xen kernels.
Date: Fri, 30 Mar 2012 16:37:29 -0400
Message-Id: <1333139850-28456-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F761A9D.0029,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meaning that we will allocate up to XGB and not consider the
rest of the memory as a possible balloon goal.

This results in /proc/meminfo reporting:

-MemTotal:        2845024 kB
-MemFree:         2497716 kB
+MemTotal:        2927192 kB
+MemFree:         2458952 kB
 ...
-DirectMap4k:     8304640 kB
+DirectMap4k:     3063808 kB
 DirectMap2M:           0 kB

on a 8GB machine with 'dom0_mem=3GB' on the Xen hypervisor line.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 2a12143..4e4aa8e 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -261,11 +261,27 @@ static unsigned long __init xen_get_max_pages(void)
 	 * the current maximum rather than the static maximum. In this
 	 * case the e820 map provided to us will cover the static
 	 * maximum region.
+	 *
+	 * The dom0_mem=min:X,max:Y tweaks options differently depending
+	 * on the version, but in general this is what we get:
+	 *                | XENMEM_maximum_reser  | nr_pages
+	 * --------------++-----------------------+-------------------
+	 *  no dom0_mem   | INT_MAX               | the max_phys_pfn
+	 *  =3G           | INT_MAX               | 786432
+	 *  =max:3G       | 786432                | 786432
+	 *  =min:1G,max:3G| 262144                | 786432
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

