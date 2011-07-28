Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1G1Xx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:53:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:7788 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab1G1XoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32808947"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: mikey@neuling.org, anton@samba.org, benh@kernel.crashing.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [16/50] powerpc/kdump: Fix timeout in crash_kexec_wait_realmode
Message-Id: <20110728234420.942B52403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Michael Neuling <mikey@neuling.org>

[ upstream commit 63f21a56f1cc0b800a4c00349c59448f82473d19 ]

The existing code it pretty ugly.  How about we clean it up even more
like this?

From: Anton Blanchard <anton@samba.org>

We check for timeout expiry in the outer loop, but we also need to
check it in the inner loop or we can lock up forever waiting for a
CPU to hit real mode.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: <stable@kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/arch/powerpc/kernel/crash.c
===================================================================
--- linux-2.6.35.y.orig/arch/powerpc/kernel/crash.c
+++ linux-2.6.35.y/arch/powerpc/kernel/crash.c
@@ -176,12 +176,8 @@ static void crash_kexec_wait_realmode(in
 
 		while (paca[i].kexec_state < KEXEC_STATE_REAL_MODE) {
 			barrier();
-			if (!cpu_possible(i)) {
+			if (!cpu_possible(i) || !cpu_online(i) || (msecs <= 0))
 				break;
-			}
-			if (!cpu_online(i)) {
-				break;
-			}
 			msecs--;
 			mdelay(1);
 		}
