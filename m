Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab0GUVxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:53:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35978 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab0GUVxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:53:48 -0400
Message-ID: <4C476C5B.8020604@zytor.com>
Date: Wed, 21 Jul 2010 14:53:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86, xsave: introduce xstate enable functions
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>	 <1279731838-1522-3-git-send-email-robert.richter@amd.com>	 <4C476236.1020302@zytor.com> <1279747225.2812.37.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1279747225.2812.37.camel@sbs-t61.sc.intel.com>
Content-Type: multipart/mixed;
 boundary="------------050907010205050801030101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050907010205050801030101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 07/21/2010 02:20 PM, Suresh Siddha wrote:
> 
> Yes, it should be __init.
> 

OK, here is the proposed fix for that.  It's a bit uglier than I would
have liked.

It also fixes the assumption that "we are on the boot CPU so we are
early in the boot", which is true now but will not be true in the future
when we can offline (and later re-online) the boot CPU.

Comments appreciated...

	-hpa

--------------050907010205050801030101
Content-Type: text/x-patch;
 name="0001-x86-xsave-Make-xstate_enable_boot_cpu-__init-protect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-xsave-Make-xstate_enable_boot_cpu-__init-protect.pa";
 filename*1="tch"

>From 55b936c7a359a14d72bcba6c3fceba4cfbe3fedf Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@linux.intel.com>
Date: Wed, 21 Jul 2010 14:23:10 -0700
Subject: [PATCH] x86, xsave: Make xstate_enable_boot_cpu() __init, protect on CPU 0

xstate_enable_boot_cpu() is, as the name implies, only used on the
boot CPU; furthermore, it invokes alloc_bootmem(), which is __init;
hence it needs to be tagged __init rather than __cpuinit.

Furthermore, it is *not* safe in the long run to rely on CPU 0 only
coming online during the early boot -- at some point we're going to
support offlining (and re-onlining) the boot CPU, and at that point we
must not call xstate_enable_boot_cpu() again.

The code is a fair bit more obscure than one would like, because the
__ref overrides aren't quite powerful enough.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <4C476236.1020302@zytor.com>
---
 arch/x86/kernel/xsave.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index cfc7901..b2549c3 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -360,10 +360,10 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
 /*
  * Enable the extended processor state save/restore feature
  */
-static inline void xstate_enable(u64 mask)
+static inline void xstate_enable(void)
 {
 	set_in_cr4(X86_CR4_OSXSAVE);
-	xsetbv(XCR_XFEATURE_ENABLED_MASK, mask);
+	xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
 }
 
 /*
@@ -421,7 +421,7 @@ static void __init setup_xstate_init(void)
 /*
  * Enable and initialize the xsave feature.
  */
-static void __cpuinit xstate_enable_boot_cpu(void)
+static void __init xstate_enable_boot_cpu(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 
@@ -444,7 +444,7 @@ static void __cpuinit xstate_enable_boot_cpu(void)
 	 */
 	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
 
-	xstate_enable(pcntxt_mask);
+	xstate_enable();
 
 	/*
 	 * Recompute the context size for enabled features
@@ -462,16 +462,22 @@ static void __cpuinit xstate_enable_boot_cpu(void)
 	       pcntxt_mask, xstate_size);
 }
 
+/*
+ * For the very first instance, this calls xstate_enable_boot_cpu();
+ * for all subsequent instances, this calls xstate_enable().
+ *
+ * This is somewhat obfuscated due to the lack of powerful enough
+ * overrides for the section checks.
+ */
 void __cpuinit xsave_init(void)
 {
+	static __refdata void (*next_func)(void) = xstate_enable_boot_cpu;
+	void (*this_func)(void);
+
 	if (!cpu_has_xsave)
 		return;
 
-	/*
-	 * Boot processor to setup the FP and extended state context info.
-	 */
-	if (!smp_processor_id())
-		xstate_enable_boot_cpu();
-	else
-		xstate_enable(pcntxt_mask);
+	this_func = next_func;
+	next_func = xstate_enable;
+	this_func();
 }
-- 
1.7.0.1


--------------050907010205050801030101--
