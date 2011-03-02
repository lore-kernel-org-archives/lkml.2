Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1CBKnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:43:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48332 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab1CBKnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WrKK5A4NCHhf4lbH/CPN8bU0th9+oy0g87qTxNsbORSxoMBFNzRc7RzHeuKtCauYc1
         8isF2ZxiHRN4TB/IK9GEVdVog3GupkzizfcF+LBdDLOll5pTLfozr3LKUfbjc4gXqTO/
         B4AxE+3wBzwsnm19YlpWL7Ym2Akn3YdYpCR30=
Date: Wed, 2 Mar 2011 11:42:59 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED x86/mm] x86-64, NUMA: Better explain numa_distance
 handling
Message-ID: <20110302104259.GD3319@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org>
 <20110302103940.GC3319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302103940.GC3319@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 615e1632e55b6b8fb52da00c5e8540ef159f759b Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 2 Mar 2011 11:32:47 +0100

Handling of out-of-bounds distances and allocation failure can use
better documentation.  Add it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
Sorry, sent out the wrong version.  This one is a bit more detailed
and the version I put into the tree.

Thanks.

 arch/x86/mm/numa_64.c        |   11 ++++++++++-
 arch/x86/mm/numa_emulation.c |    6 +++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 541746f..74064e8 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -392,11 +392,12 @@ void __init numa_reset_distance(void)
 {
 	size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
 
+	/* numa_distance could be 1LU marking allocation failure, test cnt */
 	if (numa_distance_cnt)
 		memblock_x86_free_range(__pa(numa_distance),
 					__pa(numa_distance) + size);
 	numa_distance_cnt = 0;
-	numa_distance = NULL;
+	numa_distance = NULL;	/* enable table creation */
 }
 
 static int __init numa_alloc_distance(void)
@@ -447,6 +448,14 @@ static int __init numa_alloc_distance(void)
  * Set the distance from node @from to @to to @distance.  If distance table
  * doesn't exist, one which is large enough to accomodate all the currently
  * known nodes will be created.
+ *
+ * If such table cannot be allocated, a warning is printed and further
+ * calls are ignored until the distance table is reset with
+ * numa_reset_distance().
+ *
+ * If @from or @to is higher than the highest known node at the time of
+ * table creation or @distance doesn't make sense, the call is ignored.
+ * This is to allow simplification of specific NUMA config implementations.
  */
 void __init numa_set_distance(int from, int to, int distance)
 {
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 0afa25d..aeecea9 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -379,7 +379,11 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
 			emu_nid_to_phys[i] = 0;
 
-	/* transform distance table */
+	/*
+	 * Transform distance table.  numa_set_distance() ignores all
+	 * out-of-bound distances.  Just call it for every possible node
+	 * combination.
+	 */
 	numa_reset_distance();
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		for (j = 0; j < MAX_NUMNODES; j++) {
-- 
1.7.1

