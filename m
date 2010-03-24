Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0CXFdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:33:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48374 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab0CXFc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:32:59 -0400
Date: Wed, 24 Mar 2010 06:32:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH] Allow Intel platforms to declare unsynchronized TSC to
	kernel
Message-ID: <20100324053257.GA4088@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow Intel platforms to declare unsynchronized TSC to kernel

[This came out of a private discussion with Linus last week]

Nehalem class processors support the CONSTANT_TSC bit in the 8000_0007 CPUID
leaf to declare CONSTANT_TSC. One of the ideas behind this bit was to allow the 
platform to clear it when it cannot guarantee a constant TSC.

Unfortunately this doesn't work right now because the Intel CPU
initialization also checks the model number and assumes that
all CPUs newer than Yonah have CONSTANT_TSC too.

Terminate the model number check before Nehalem and rely on the 8000_0007
bit only on newer CPUs. This way the platform can actually turn it off.

Atom CPUs might also have newer model numbers and do not necessarily
have that bit, but they are all single socket and expected to always
have synchronous TSCs.

Open: the two checks still differ in setting sched_clock_stable. 

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/intel.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.34-rc1-ak/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.34-rc1-ak.orig/arch/x86/kernel/cpu/intel.c	2010-03-03 02:01:27.000000000 +0100
+++ linux-2.6.34-rc1-ak/arch/x86/kernel/cpu/intel.c	2010-03-24 06:16:42.000000000 +0100
@@ -43,8 +43,16 @@
 		}
 	}
 
+	/*
+	 * On Nehalem+ class we trust the CONSTANT_TSC bit in 8000_0007 edx,
+	 * so that a platform that doesn't have synchronized TSCs can clear it.
+ 	 * Older CPUs didn't set that bit, so we keep hard coding the model
+	 * numbers for those.
+ 	 * Note this matches Atom class too, but there the TSCs are always
+	 * synchronized anyways.
+ 	 */
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
-		(c->x86 == 0x6 && c->x86_model >= 0x0e))
+		(c->x86 == 0x6 && c->x86_model >= 0x0e && c->x86_model < 0x1a))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
 #ifdef CONFIG_X86_64
