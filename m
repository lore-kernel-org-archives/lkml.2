Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936710Ab2C3XAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:00:15 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934863Ab2C3VFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:22 -0400
Message-Id: <201203302105.q2UL53Gm006281@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 14:02:52 -0400
Subject: [PATCH] arch/tile: avoid false corrupt frame warning in early boot
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:03.0741 (UTC) FILETIME=[C6E6FAD0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With lockstat we can end up trying to get a backtrace before
"high_memory" is initialized, so don't worry about range testing
if it is zero.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 4c1ac6e..3be7eb5 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -286,7 +286,7 @@ struct task_struct *validate_current(void)
 	static struct task_struct corrupt = { .comm = "<corrupt>" };
 	struct task_struct *tsk = current;
 	if (unlikely((unsigned long)tsk < PAGE_OFFSET ||
-		     (void *)tsk > high_memory ||
+		     (high_memory && (void *)tsk > high_memory) ||
 		     ((unsigned long)tsk & (__alignof__(*tsk) - 1)) != 0)) {
 		pr_err("Corrupt 'current' %p (sp %#lx)\n", tsk, stack_pointer);
 		tsk = &corrupt;
-- 
1.6.5.2

