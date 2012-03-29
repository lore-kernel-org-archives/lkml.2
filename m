Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936670Ab2C3Wxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:53:54 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934951Ab2C3VF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:58 -0400
Message-Id: <201203302105.q2UL57Gj006299@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:56:18 -0400
Subject: [PATCH] arch/tile: use memparse() for "maxmem" and "maxnodemem" options
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:07.0210 (UTC) FILETIME=[C8F84EA0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more standard and avoids having to remember what units
the options actually take.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 62b1903..90251dc 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -103,13 +103,11 @@ unsigned long __initdata pci_reserve_end_pfn = -1U;
 
 static int __init setup_maxmem(char *str)
 {
-	long maxmem_mb;
-	if (str == NULL || strict_strtol(str, 0, &maxmem_mb) != 0 ||
-	    maxmem_mb == 0)
+	unsigned long long maxmem;
+	if (str == NULL || (maxmem = memparse(str, NULL)) == 0)
 		return -EINVAL;
 
-	maxmem_pfn = (maxmem_mb >> (HPAGE_SHIFT - 20)) <<
-		(HPAGE_SHIFT - PAGE_SHIFT);
+	maxmem_pfn = (maxmem >> HPAGE_SHIFT) << (HPAGE_SHIFT - PAGE_SHIFT);
 	pr_info("Forcing RAM used to no more than %dMB\n",
 	       maxmem_pfn >> (20 - PAGE_SHIFT));
 	return 0;
@@ -119,14 +117,15 @@ early_param("maxmem", setup_maxmem);
 static int __init setup_maxnodemem(char *str)
 {
 	char *endp;
-	long maxnodemem_mb, node;
+	unsigned long long maxnodemem;
+	long node;
 
 	node = str ? simple_strtoul(str, &endp, 0) : INT_MAX;
-	if (node >= MAX_NUMNODES || *endp != ':' ||
-	    strict_strtol(endp+1, 0, &maxnodemem_mb) != 0)
+	if (node >= MAX_NUMNODES || *endp != ':')
 		return -EINVAL;
 
-	maxnodemem_pfn[node] = (maxnodemem_mb >> (HPAGE_SHIFT - 20)) <<
+	maxnodemem = memparse(endp+1, NULL);
+	maxnodemem_pfn[node] = (maxnodemem >> HPAGE_SHIFT) <<
 		(HPAGE_SHIFT - PAGE_SHIFT);
 	pr_info("Forcing RAM used on node %ld to no more than %dMB\n",
 	       node, maxnodemem_pfn[node] >> (20 - PAGE_SHIFT));
-- 
1.6.5.2

