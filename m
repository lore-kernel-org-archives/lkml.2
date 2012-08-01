Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2HAHXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:23:01 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58023 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab2HAHXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:23:00 -0400
Message-ID: <5018D926.6010709@linux.vnet.ibm.com>
Date: Wed, 01 Aug 2012 02:22:14 -0500
From: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] vphn: fix arch_update_cpu_topology() return value
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080107-5930-0000-0000-00000A699A4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5dfd547532fca61462dc17fd0bb8e533002c4bc5 Mon Sep 17 00:00:00 2001
From: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
Date: Thu, 7 Jun 2012 16:04:34 -0500

arch_update_cpu_topology() should only return 1 when the topology has
actually changed, and should return 0 otherwise.

This patch fixes a potential bug where rebuild_sched_domains() would
reinitialize the sched domains even when the topology hasn't changed.

Signed-off-by: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
---
 arch/powerpc/mm/numa.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 39b1597..59213cf 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1436,11 +1436,11 @@ static long vphn_get_associativity(unsigned long cpu,
 
 /*
  * Update the node maps and sysfs entries for each cpu whose home node
- * has changed.
+ * has changed. Returns 1 when the topology has changed, and 0 otherwise.
  */
 int arch_update_cpu_topology(void)
 {
-	int cpu, nid, old_nid;
+	int cpu, nid, old_nid, changed = 0;
 	unsigned int associativity[VPHN_ASSOC_BUFSIZE] = {0};
 	struct device *dev;
 
@@ -1466,9 +1466,10 @@ int arch_update_cpu_topology(void)
 		dev = get_cpu_device(cpu);
 		if (dev)
 			kobject_uevent(&dev->kobj, KOBJ_CHANGE);
+		changed = 1;
 	}
 
-	return 1;
+	return changed;
 }
 
 static void topology_work_fn(struct work_struct *work)
-- 
1.7.7.6


Jesse Larrew
Software Engineer, Linux on Power Kernel Team
IBM Linux Technology Center
Phone: (512) 973-2052 (T/L: 363-2052)
jlarrew@linux.vnet.ibm.com

