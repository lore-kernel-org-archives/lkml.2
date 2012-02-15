Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab2BOMfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 07:35:25 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34996 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601Ab2BOMfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 07:35:23 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] lib/cpumask.c: Optimize __any_online_cpu() calculation
To: akpm@linux-foundation.org
Cc: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org, venki@google.com,
        rusty@rustcorp.com.au
Date: Wed, 15 Feb 2012 18:05:14 +0530
Message-ID: <20120215123208.15623.73499.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12021502-7014-0000-0000-000000942244
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__any_online_cpu() uses a for loop at the moment.
Instead, use cpumask_* operations to speed it up.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---
Actually, the patch posted at https://lkml.org/lkml/2012/2/15/101 removed
the last user of any_online_cpu() (and hence __any_online_cpu()).
However, since this is an exported symbol, I refrained from removing this
function altogether.

 lib/cpumask.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index af3e5817..b25f53d 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -28,13 +28,7 @@ EXPORT_SYMBOL(__next_cpu_nr);
 
 int __any_online_cpu(const cpumask_t *mask)
 {
-	int cpu;
-
-	for_each_cpu(cpu, mask) {
-		if (cpu_online(cpu))
-			break;
-	}
-	return cpu;
+	return cpumask_any_and(mask, cpu_online_mask);
 }
 EXPORT_SYMBOL(__any_online_cpu);
 

