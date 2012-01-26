Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab2AZKDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:03:15 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57241 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2AZKDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:03:08 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>
Subject: [v7 3/8] tile: move tile to use generic on_each_cpu_mask
Date: Thu, 26 Jan 2012 12:01:56 +0200
Message-Id: <1327572121-13673-4-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API is the same as the tile private one, but the generic version
also calls the function on the with interrupts disabled in UP case

This is OK since the function is called on the other CPUs
with interrupts disabled.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-mm@kvack.org
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Pekka Enberg <penberg@kernel.org>
CC: Matt Mackall <mpm@selenic.com>
CC: Rik van Riel <riel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Sasha Levin <levinsasha928@gmail.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
CC: Avi Kivity <avi@redhat.com>
CC: Michal Nazarewicz <mina86@mina86.org>
CC: Kosaki Motohiro <kosaki.motohiro@gmail.com>
---
 arch/tile/include/asm/smp.h |    7 -------
 arch/tile/kernel/smp.c      |   19 -------------------
 2 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/arch/tile/include/asm/smp.h b/arch/tile/include/asm/smp.h
index 532124a..1aa759a 100644
--- a/arch/tile/include/asm/smp.h
+++ b/arch/tile/include/asm/smp.h
@@ -43,10 +43,6 @@ void evaluate_message(int tag);
 /* Boot a secondary cpu */
 void online_secondary(void);
 
-/* Call a function on a specified set of CPUs (may include this one). */
-extern void on_each_cpu_mask(const struct cpumask *mask,
-			     void (*func)(void *), void *info, bool wait);
-
 /* Topology of the supervisor tile grid, and coordinates of boot processor */
 extern HV_Topology smp_topology;
 
@@ -91,9 +87,6 @@ void print_disabled_cpus(void);
 
 #else /* !CONFIG_SMP */
 
-#define on_each_cpu_mask(mask, func, info, wait)		\
-  do { if (cpumask_test_cpu(0, (mask))) func(info); } while (0)
-
 #define smp_master_cpu		0
 #define smp_height		1
 #define smp_width		1
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index c52224d..a44e103 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -87,25 +87,6 @@ void send_IPI_allbutself(int tag)
 	send_IPI_many(&mask, tag);
 }
 
-
-/*
- * Provide smp_call_function_mask, but also run function locally
- * if specified in the mask.
- */
-void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
-		      void *info, bool wait)
-{
-	int cpu = get_cpu();
-	smp_call_function_many(mask, func, info, wait);
-	if (cpumask_test_cpu(cpu, mask)) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-	}
-	put_cpu();
-}
-
-
 /*
  * Functions related to starting/stopping cpus.
  */
-- 
1.7.0.4

